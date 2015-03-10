require 'spec_helper'
require 'rake'

describe Money do
  
  before(:all) do 
    Currency.find_or_create_by(name: "US Dollar", code: "USD", is_base: true, symbol: "$")
    Currency.find_or_create_by(name: "Euro", code: "EUR", is_base: false, symbol: "E")
    Currency.find_or_create_by(name: "English", code: "GBP", is_base: false, symbol: "R")
  end

  after(:all) do
    Currency.destroy_all 
    CalculatedExchangeRate.destroy_all
    ExchangeRate.destroy_all  
  end

  it "get_base returns base valute" do
    expect(Money.get_base).to eq('USD')
  end

  it "set_base sets base valute" do 
    Money.set_base('EUR')
    expect(Money.get_base).to eq('EUR')
  end

  it "rake task gets rates for all curriencies" do 
    expect { load File.expand_path("../../../lib/tasks/getcbrates.rake", __FILE__)
    Rake::Task.define_task(:environment)
    Rake::Task["getcbrates"].invoke}.to change {ExchangeRate.count}.by(3)
  end

  it "calculate calculates curriences for all valutes" do 
    expect { Money.calculate }.to change {CalculatedExchangeRate.count}.by(2)
  end

  it "get_currency works correct" do   
    expect(Money.get_currency(from: 'EUR')).to eq(1.0)
  end

  it "set and get currency_works correct" do
    Money.set_base('EUR')
    Money.set_currency(from: 'USD', rate: 2.0)
    Money.set_currency(from: 'GBP', rate: 0.5)
    expect(Money.get_currency(from: 'USD', to: 'GBP')).to eq(4.0)
  end

  it "database doesn't have valute rate to itself" do
    expect(CalculatedExchangeRate.where("from_currency_id == to_currency_id").count).to eq(0)
  end

end