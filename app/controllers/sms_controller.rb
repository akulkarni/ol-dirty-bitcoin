class SmsController < ApplicationController

def index
  msg = current_prices
  send_sms('+16463735777', 'C.R.E.A.M. %s' % msg)
  send_sms('+19175731568', 'C.R.E.A.M. %s' % msg)
  render :text => 'OK!'
end

def test
  @mtgox = MtGox.ticker
  msg = 'C.R.E.A.M. Current price on Gox: %s' 
  send_sms('+16463735777', msg % @mtgox.price)
  send_sms('+19175731568', msg % @mtgox.price)
end  


private

def current_prices
  mtgox = MtGox.ticker
  bitstamp = Bitstamp.ticker
  btce = Btce::Ticker.new "btc_usd"
  coinbase = Coinbase::Client.new(ENV['COINBASE_SECRET'])

  msg = "MtGox $%.2f, Bitstamp $%.2f, Btc-e $%.2f, Coinbase %s" 

  return msg % [mtgox.price, bitstamp.last, btce.json["btc_usd"]["last"], coinbase.buy_price(1).format]
end

def send_sms(phone_number, text)
  client = get_twilio_client
  client.account.sms.messages.create(:from => '+13212826467',
                                     :to => phone_number,
                                     :body => text)
end

def get_twilio_client
  return Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
end

end
