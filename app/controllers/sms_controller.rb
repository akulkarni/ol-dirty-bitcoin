class SmsController < ApplicationController
  
def index
  render :text => 'OK'
end

def sms_update
  sms_all_users(current_prices)
  render :text => 'OK'
end

def news_update
  msg = params['message']
  sms_all_users(msg) unless msg.nil?
  render :text => 'OK'
end  

def reply
  body = params['Body']
  phone_number = params['From']

  unless body.nil? or phone_number.nil?
    unless body.empty? or phone_number.empty?
      if body == "START"
        register_user(phone_number[1..-1]) # to remove "+"
      elsif ['price', 'p'].member?body.downcase
        send_sms(phone_number, current_prices)
      else
        send_sms(phone_number, HELP_MESSAGE)
      end
    end
  end
  render :text => 'OK'
end


def create
  phone_number = params['phone_number']
  render :text => register_user(phone_number)
end


private

WELCOME_MESSAGE = "Coin Rules Everything Around Me. Welcome to ODBTC! Reply with STOP to unsubscribe at any time."
HELP_MESSAGE = 'Coin Rules Everything Around Me. \\n\\nOptions: "p" or "price" for latest price'

def register_user(phone_number)
  response = "Something bad happened."
  unless phone_number.nil?
    unless phone_number.empty?
      phone_number = "1" + phone_number if phone_number[0] != "1"
      u = User.new(:phone_number => "+" + phone_number)
      u.save
      
      unless u.nil?
        msg = WELCOME_MESSAGE
        send_sms(u.phone_number, msg)
        response = msg
      end
    end
  end
  return response
end

def sms_all_users(msg)
  users = User.all
  users.each do |u|
    send_sms(u.phone_number, msg) unless u.phone_number.nil? or !u.is_active
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
  begin
    client.account.sms.messages.create(:from => '+13212826467',
                                       :to => phone_number,
                                       :body => text)
  rescue
    puts "Error sending SMS to %s" % phone_number
  end
end

def get_twilio_client
  return Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
end

end
