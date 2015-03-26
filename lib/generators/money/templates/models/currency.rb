class Currency < ActiveRecord::Base 
  has_many :exchange_rates
  before_save :check_is_base
  after_create :create_calculated_exchange_rate 
  validates :name, :code, :symbol, presence: true
  validates :name, :code, :symbol, uniqueness: true	

  def check_is_base 
    self.class.where(is_base: true).update_all(is_base: false) if is_base
  end

  #по умолчанию курс любой новой валюты равен базовой, 
  #о чём и делаем запись в CalculatedExchangeRates, 
  #только если новая валюта не является российским рублём. 
  def create_calculated_exchange_rate
    Money.set_currency(code, 1.0) unless code == 'RUB'
  end
end
