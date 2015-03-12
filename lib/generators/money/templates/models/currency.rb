class Currency < ActiveRecord::Base 
  has_many :exchange_rates
  before_save :check_is_base 
  validates :name, :code, :symbol, presence: true
  validates :name, :code, :symbol, uniqueness: true	

  def check_is_base 
    self.class.where("(code <> ? or name <> ? or symbol <> ?) and is_base == ?", code, name, symbol, true).update_all(is_base: false) if is_base
  end
end