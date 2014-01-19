OlDailyBitcoin::Application.routes.draw do
  match '/' => 'register#index', :via => :get
  
  match '/sms_update' => 'sms#sms_update', :via => :get

  resources :super_market, :sms, :register


end
