require "money/version"

module Money 

	def self.set_base(sym)	 
		@currency = Currency.find_by_code(sym)
		unless currency.nil?
		  Currency.where(is_base: true).update_all(is_base: false)
		  @currency.is_base = true
		  @currency.save
		end	
	end

	def self.get_base
		Currency.find_by_is_base(true).code
	end

	def self.set_exchange_rate(options = {}) 
		from = Currency.find_by_code(options[:from])
		to = Currency.find_by_is_base(true)
		#to = options[:to] ? Currency.find_by_symbol(options[:to]) : Currency.find_by_is_base(true)
		rate = options[:rate]
		unless from.id == to.id  
			CalculatedExchangeRate.create(from_currency_id: from.id, to_currency_id: to.id, rate: rate) 
		else 
			CalculatedExchangeRate.create(from_currency_id: from.id, to_currency_id: to.id, rate: 1.0) 
		end
	end


	def self.calculate
		@base = Currency.find_by_is_base(true)
		@curriencies = Currency.all.includes(:ExchangeRate)
		@curriencies.each do |cur|
			set_exchange_rate(from: cur.code, to: base.code, rate: (cur.ExchangeRate.rate/base.ExchangeRate.rate).to_f.round(4))
		end
	end

	def self.get_currency(options={})
		from = Currency.find_by_code(options[:from])
		to = options[:to] ? Currency.find_by_code(options[:to]) : Currency.find_by_is_base(true)
		datetime = options[:datetime] ?  options[:datetime] : DateTime.now

		@currencyfrom = CalculatedExchangeRate.where("from_currency_id = ? and created_at < ?", from.id, datetime).order('created_at DESC').first
		@currencyto = CalculatedExchangeRate.where("from_currency_id = ? and created_at < ?", to.id, datetime).order('created_at DESC').first

		(@currencyfrom.rate/@currencyto.rate).to_f.round(4) 

	end
end

