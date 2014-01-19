class RegisterController < ApplicationController

def create
  phone_number = params['phone_number']
  u = User.new(:phone_number => phone_number)
  u.save!
  render :json => u
end

end
