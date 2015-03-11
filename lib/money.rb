module Money 

	def self.get_base
		Currency.find_by_is_base(true).code
	end

	def self.set_base(sym)	 
		currency = Currency.find_by_code(sym)
		unless (currency.nil? || get_base == sym)
		  currency.is_base = true
		  currency.save
		  calculate
		end	
	end

	def self.set_currency(options = {}) 
		from = Currency.find_by_code(options[:from])
		to = Currency.find_by_is_base(true)		
		rate = options[:rate]
		CalculatedExchangeRate.create(from_currency_id: from.id, to_currency_id: to.id, rate: rate) unless from.id == to.id 
	end

	def self.calculate
		base = Currency.find_by_is_base(true)
		cur_base = base.exchange_rates.last
		@curriencies = Currency.all.includes(:exchange_rates)
		@curriencies.each do |cur|
			cur_from = cur.exchange_rates.last			
			set_currency(from: cur.code, rate: (cur_from.rate/cur_base.rate).to_f.round(4))
		end
	end

	def self.get_currency(options={})
		from = Currency.find_by_code(options[:from])
		to = options[:to] ? Currency.find_by_code(options[:to]) : Currency.find_by_is_base(true)
		datetime = options[:datetime] ? options[:datetime] : DateTime.now

		if from.id == to.id
			1.0
		elsif to.code == get_base 
			CalculatedExchangeRate.where("from_currency_id = ? and created_at < ?", from.id, datetime).last.rate
		elsif from.code == get_base
			currencyto = CalculatedExchangeRate.where("from_currency_id = ? and created_at < ?", to.id, datetime).last
			(1/currencyto.rate).to_f.round(4) 						
		else
			currencyfrom = CalculatedExchangeRate.where("from_currency_id = ? and created_at < ?", from.id, datetime).last
			currencyto = CalculatedExchangeRate.where("from_currency_id = ? and created_at < ?", to.id, datetime).last
			(currencyfrom.rate/currencyto.rate).to_f.round(4) 
		end
	end
end

