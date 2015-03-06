class Currency < ActiveRecord::Base 
	has_one :ExchangeRate
end