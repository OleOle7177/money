task :getcbrates => :environment do 
  require 'nokogiri'
  require 'open-uri'
  # get the XML data form CB URL
  file_handle = open("http://www.cbr.ru/scripts/XML_daily.asp")

  # get document xml string and create Nokogiri object
  doc = Nokogiri::XML(file_handle)

  curriencies = Currency.all
        
  doc.css("Valute").each do |valute|
    currency = curriencies.find{ |i| i.code == valute.css('CharCode').text }                 
    ExchangeRate.create(currency: currency, rate: valute.css('Value').text.gsub(',', '.').to_f/valute.css('Nominal').text.to_f) unless currency.nil? 
  end
  
  Currency.find_or_create_by(code: 'RUB', name: 'Российский рубль', symbol: 'R')
   
  if Money.get_base
    Money.calculate    
  else
    Money.set_base('RUB')       
  end
end