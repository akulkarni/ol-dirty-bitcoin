# -*- coding: utf-8 -*-
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
  everyone = params['everyone']

  everyone = "false" if everyone.nil?

  if everyone.downcase == "true"
    sms_all_users(msg) unless msg.nil?
  else
    sms_all_admins(msg) unless msg.nil?
  end

  render :text => 'OK'
end  

def reply
  body = params['Body']
  phone_number = params['From']

  unless body.nil? or phone_number.nil?
    unless body.empty? or phone_number.empty?
      if body.downcase == "start"
        register_user(phone_number[1..-1]) # to remove "+"
      elsif ['price', 'prices', 'p'].member?body.downcase
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

WELCOME_MESSAGE = "Coin Rules Everything\nAround Me.\n\nWelcome to ODBTC! If you ever want to unsubscribe, reply with STOP.\n\nhttp://odbtc.com"
HELP_MESSAGE = "Shimmy shimmy ya\n\n\"p\" or \"price\" for latest prices \n\"STOP\" to unsubscribe\n\nhttp://odbtc.com"

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

def sms_all_admins(msg)
  admins = User.where("admin is true")
  admins.each do |u|
    send_sms(u.phone_number, msg) unless u.phone_number.nil? or !u.is_active
  end
end

def current_prices
  mtgox = MtGox.ticker
  bitstamp = Bitstamp.ticker
  btce = Btce::Ticker.new "btc_usd"
  coinbase = Coinbase::Client.new(ENV['COINBASE_SECRET'])
  
  msg = RAP.sample 
  msg += "\n\n$%.2f Gox\n%s Coinbase\n$%.2f Bitstamp\n$%.2f BTC-e"
  
  return msg % [mtgox.price, coinbase.buy_price(1).format, bitstamp.last, btce.json["btc_usd"]["last"]]
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

RAP = [
# "Million bitcoin deals in my email, you mad as hell you ain't CC'ed",
# "We the money team / Fell asleep next to that cake and had a money dream",
# "Lay back with my mind on my money and my money on my mind.",
"I've got 99 problems, but fiat ain't one.",
"Noooooooow here's a little sumtin I got to sell/About some bitcoin you know so well.",
"Bass! How low can you go?!/Bitcoin, what a brother know.",
"It's funny how money change a situation/Miscommunications lead to complications." ,
"I had a dream I could buy my way to heaven/When I woke I spent that on a necklace.",
# "If I don’t get paid 2 or 3 million dollars on Monday, I’m a bring on the ARMAGEDDON!",
"You need to diversify yo bonds *****",
# "He got swung on, his lungs was torn, the kingpin just castled with his rook and lost a pawn",
"Super Nintendo, Sega Genesis; When I was dead broke man I couldn't picture this",
"Thinkin’ of a master plan, ‘Cause ain’t no more bitcoins inside my hand",
"One, two, three and-to-the fo’/ Snoop Doggy Dogg and BTC is at the door"
"Straight outta Compton, a crazy coin investor named Ice Cube",
"Once upon a time not long ago, Where people used wallets with no crypto",
"It was all a dream, I used to read bitcoin magazine",
"I got you stuck off the realness, we be the infamous you heard of us, Official Bitcoin harvesters",
"Shimmy Shimmy Ya Shimmy Yeah Shimmy Yeh!, Gimme the coin so I can take it awwayyy...",
"Don’t steal my ‘coin - I’m close to the edge / I’m tryin’ not to lose my bread",
"I like bitcoins and I cannot lie / You other brothers can’t deny",
]

end
