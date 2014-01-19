class RegisterController < ApplicationController
  
  def create
    phone_number = params['phone_number']
    user = User.new(:phone_number => "+" + phone_number)
    user.save!

    

    render :json => user
  end
end
