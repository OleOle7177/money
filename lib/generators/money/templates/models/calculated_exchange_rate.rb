class CalculatedExchangeRate < ActiveRecord::Base 
	validates :from_currency_id, :to_currency_id, :rate, presence: true
end