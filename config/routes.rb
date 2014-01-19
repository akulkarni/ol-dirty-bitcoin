OlDailyBitcoin::Application.routes.draw do
  match '/' => 'register#index', :via => :get
  match 'register/welcome' => 'register#welcome', :via => :get
  
  match '/sms_update' => 'sms#sms_update', :via => :get
  match '/news_update' => 'sms#news_update', :via => :post

  resources :super_market, :sms, :register, :news


end
