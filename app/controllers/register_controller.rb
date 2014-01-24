require 'open-uri'

class RegisterController < ApplicationController

WELCOME_MESSAGE = "Coin Rules Everything Around Me. Welcome to ODBTC! Reply with STOP to unsubscribe at any time."
def create
  response = "Something bad happened."
  phone_number = params['phone_number']
  unless phone_number.nil?
    unless phone_number.empty?
      u = User.new(:phone_number => "+" + phone_number)
      u.save

      unless u.nil?
        msg = WELCOME_MESSAGE
        send_sms(u.phone_number, msg)
        response = msg
      end
    end
  end
  
  render :text => response
end

private

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
