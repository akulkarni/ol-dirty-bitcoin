OlDailyBitcoin::Application.routes.draw do
  match '/' => 'register#index', :via => :get
  match 'register/welcome' => 'register#welcome', :via => :get
  
  resources :super_market, :sms, :register

end
