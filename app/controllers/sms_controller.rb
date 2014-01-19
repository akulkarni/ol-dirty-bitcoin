class SmsController < ApplicationController
  
def index
  msg = current_prices
  send_sms('+16463735777', msg)
  send_sms('+19175731568', msg)
  render :text => 'OK'
end

def sms_update
  sms_all_users(current_prices)
  render :text => 'OK'
end

def news_update
  msg = params['msg']
  sms_all_users(msg) unless msg.nil?
  render :text => 'OK'
end  


private

def sms_all_users(msg)
  users = User.all
  users.each do |u|
#    send_sms(u.phone_number, msg) unless u.phone_number.nil?
    send_sms(u.phone_number, msg) if u.phone_number == '+19175731568'
  end
end

def current_prices
  mtgox = MtGox.ticker
  bitstamp = Bitstamp.ticker
  btce = Btce::Ticker.new "btc_usd"
  coinbase = Coinbase::Client.new(ENV['COINBASE_SECRET'])

  msg = "C.R.E.A.M. MtGox $%.2f, Bitstamp $%.2f, Btc-e $%.2f, Coinbase %s" 

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
