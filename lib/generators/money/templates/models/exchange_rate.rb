class ExchangeRate < ActiveRecord::Base
	belongs_to :currency 

	validates :currency_id, :rate, presence: true	
end