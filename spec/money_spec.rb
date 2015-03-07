require 'spec_helper'
require 'rake'

describe Money do
	#@currency = FactoryGirl.create(:currency)
	currency_usd = Currency.create(name: "US Dollar", code: "USD", is_base: true, symbol: "$")
  	currency_eur = Currency.create(name: "Euro", code: "EUR", is_base: false, symbol: "E")
  	currency_rur = Currency.create(name: "Rus Ruble", code: "RUR", is_base: false, symbol: "R")
  
  it "get_base returns base valute" do
  	expect(Money.get_base).to eq('USD')
  end

  it "set_base sets base valute" do 
  	Money.set_base('EUR')
  	expect(Money.get_base).to eq(EUR)
  end

  it "rake task" do 
  	load File.expand_path("../../../lib/tasks/getcbrates.rake", __FILE__)
	# make sure you set correct relative path 
	Rake::Task.define_task(:environment)
	Rake::Task["getcbrates"].invoke

	expect(ExchangeRate.all.count).to eq(6)
  end
end