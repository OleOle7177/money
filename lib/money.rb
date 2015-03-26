module Money 

  #узнать текущую базовую валюту, возвращается экземпляр класса Currency 
  def self.get_base
    valute = Currency.find_by_is_base(true)    
    valute
  end

  #установить новую базовую валюту 
  def self.set_base(sym)   
    
    currency = Currency.find_by_code(sym)
    
    raise "Валюта с указанным кодом не найдена" if currency.nil?  
    #если валюта с кодом sym и так является базовой, 
    #то ничего делать не нужно
    unless currency.is_base    
      currency.is_base = true
      currency.save
      calculate
    end
  end

  #установить курс валюты относительно текущей базовой
  def self.set_currency(fromcode, rate) 
    from = Currency.find_by_code(fromcode)
    to = get_base
    raise "В базе данных нет информации о валюте #{fromcode}" unless from
    raise "Не установлена базовая валюта" unless to 
    CalculatedExchangeRate.create(from_currency_id: from.id, to_currency_id: to.id, rate: rate) unless from.id == to.id 
  end
  
  #пересчитать курсы валют относительно базовой и занести записи в CalculatedExchangeRates
  def self.calculate
    #получаем текущую базовую валюту  
    base = get_base    
      raise "Курсы валют не могут быть рассчитаны: не установлена базовая валюта" unless base
   
    #cur_base_rate - текущий курс базовой валюты относительно рубля     
    if base.code == 'RUB'
      cur_base_rate = 1   
    else
      #если в ExchangeRates нет данных о курсе базовой валюты относительно рубля       
      raise "Курсы валют не могут быть рассчитаны: 
           нет данных о курсе базовой валюты относительно рубля" unless base.exchange_rates.last

      cur_base_rate = base.exchange_rates.last.rate 
    end
      
      @curriencies = Currency.all.includes(:exchange_rates)
      #итерируемся по коллекции всех валют 
      @curriencies.each do |cur|
        #cur_from_rate - курс относительно рубля для валюты, 
        #для котороый в данный момент присходит расчёт         
        if cur.code == 'RUB' 
          cur_from_rate = 1
        else 
          raise "Курсы валют не могут быть рассчитаны: 
               нет данных о курсе валюты #{cur.code}: #{cur.name} относительно рубля" unless cur.exchange_rates.last 
          cur_from_rate = cur.exchange_rates.last.rate
        end                
      
        set_currency(cur.code, (cur_from_rate/cur_base_rate).to_f)
      end   
  end

  #узнать курс валюты относительно любой другой (по умолчанию - базовой) 
  #на любую дату и время (по умолчанию - на текущий момент)
  def self.get_currency(fromcode, options = {})
    from = Currency.find_by_code(fromcode)
    to = options[:to] ? Currency.find_by_code(options[:to]) : Money.get_base
    datetime = options[:datetime] || DateTime.now

    raise "В базе данных нет валюты из которой идёт конвертация" unless from    
    raise "В базе данных нет валюты в которую идёт конвертация" unless to 
  
    # если конвертируем валюту в саму себя
    if from.id == to.id
      1.0      
    else
      #данные по котировке валюты из которой конвертируем 
      ratefrom = CalculatedExchangeRate.where("from_currency_id = ? and created_at < ?", from.id, datetime).last
      
      #данные по котировке валюты в которую конвертируем 
      rateto =  CalculatedExchangeRate.where("from_currency_id = ? and created_at < ?", to.id, datetime).last
      
      #конвертируем в базовую валюту
      if (!ratefrom.nil? && ratefrom.to_currency_id == to.id) 
        ratefrom.rate.to_f.round(4)
      #конвертируем из базовой валюты
      elsif (!rateto.nil? && rateto.to_currency_id == from.id)
        (1/rateto.rate).to_f.round(4)
      #конвертируем не из базовой в небазовую 
      elsif (!ratefrom.nil? && !rateto.nil? && ratefrom.to_currency_id == rateto.to_currency_id)
        (ratefrom.rate/rateto.rate).to_f.round(4)
      #в CalculatedExchangeRates не найдены необходимые записи 
      else
        raise "В базе данных недостаточно данных"
      end
    
    end        
  end

end

