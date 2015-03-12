module Money 

  def self.get_base
    code = Currency.find_by_is_base(true).code
    unless code
      raise "Не установлена базовая валюта"
    end
    code
  end

  def self.set_base(sym)	 
    currency = Currency.find_by_code(sym)
    if currency.nil?
    	raise "Валюта с указанным кодом не найдена"
    end
    
    currency.is_base = true
    currency.save
    calculate
    	
  end

  def self.set_currency(fromcode, rate) 
    from = Currency.find_by_code(fromcode)
    to = Currency.find_by_is_base(true)
    unless to
      raise "Не установлена базовая валюта" 
    end

    unless from.id == to.id 
      CalculatedExchangeRate.create(from_currency_id: from.id, to_currency_id: to.id, rate: rate)
    end 
  end

  def self.calculate	 
    base = Currency.find_by_is_base(true)
    unless base
      raise "Курсы валют не могут быть рассчитаны: не установлена базовая валюта" 
    end
    
    cur_base = base.exchange_rates.last
    
    unless cur_base
      raise "Курсы валют не могут быть рассчитаны: нет данных о курсе базовой валюты относительно рубля" 
	end

    @curriencies = Currency.all.includes(:exchange_rates)
    @curriencies.each do |cur|
      cur_from = cur.exchange_rates.last
      unless cur_from  
        raise "Курсы валют не могут быть рассчитаны: нет данных о курсе валюты #{cur.code}: #{cur.name} относиельное рубля" 					
      end
      set_currency(cur.code, (cur_from.rate/cur_base.rate).to_f)
    end		
  end

  def self.get_currency(fromcode, options = {})
    from = Currency.find_by_code(fromcode)
    tocode = options[:to] || Money.get_base 
    datetime = options[:datetime] || DateTime.now

    to = Currency.find_by_code(tocode)
    unless from
      raise "В базе данных нет валюты из которой идёт конвертация"  
    end

    unless to 
      raise "В базе данных нет валюты в которую идёт конвертация"  
	end

    if from.id == to.id
      1.0
    else 
      ratefrom = CalculatedExchangeRate.where("from_currency_id = ? and created_at < ?", from.id, datetime).last
      if to.id == ratefrom.to_currency_id
        ratefrom.rate.to_f.round(4)
      elsif from.code == ratefrom.from_currency_id
        (1/ratefrom.rate).to_f.round(4)
      else
        rateto =  CalculatedExchangeRate.where("from_currency_id = ? and created_at < ?", to.id, datetime).last
        (ratefrom.rate/rateto.rate).to_f.round(4)
      end
    end 		
  end

end

