OlDailyBitcoin::Application.routes.draw do
  match '/' => 'register#index', :via => :get

  resources :super_market, :sms

end
