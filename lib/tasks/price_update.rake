task :price_update => :environment do
  require 'open-uri'
  open("http://www.odbtc.com/sms_update")
end