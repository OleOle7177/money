task :getcbrates => :environment do 
	require 'open-uri'
	 # get the XML data form CB URL
    file_handle = open('http://www.cbr.ru/scripts/XML_daily.asp')

    # get document xml string and create Nokogiri object
    doc = Nokogiri::XML(file_handle)

    @curriencies = Currency.all
    
    doc.css("Valute").each do |valute|

    	  @currency = @curriencies.find{|i| i.code == valute.css('CharCode').text}
          
        unless @currency.nil? 
    	  @exchangerate = ExchangeRate.find_or_create_by_currency_id(@currency.id)
          @exchangerate.rate = valute.css('Value').text.gsub(',', '.').to_f
    	  @exchangerate.save
          @currency.save
        end
    
    end  
  

end