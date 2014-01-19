require 'open-uri'

class RegisterController < ApplicationController

def create
  phone_number = params['phone_number']
  u = User.new(:phone_number => phone_number)
  u.save!

  unless u.nil?
    msg = "Coin Rules Everything Around Me. (Welcome!)"
    send_sms(u.phone_number, msg)
  end

  render :json => u
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
