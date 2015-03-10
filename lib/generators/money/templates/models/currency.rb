class Currency < ActiveRecord::Base 
	has_many :exchange_rates
	before_save :check_is_base 

	validates :name, :code, :symbol, presence: true
	validates :code, :symbol, uniqueness: true	

	def check_is_base 
	  self.class.where('id != ? and is_base == ?', id, true).update_all(is_base: false) if is_base
	end
end