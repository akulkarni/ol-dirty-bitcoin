OlDailyBitcoin::Application.routes.draw do
  match '/' => 'register#index', :via => :get
  
  match '/sms_update' => 'sms#sms_update', :via => :get
  match '/news_update' => 'sms#news_update', :via => :post
  match '/reply' => 'sms#reply', :via => :post

  resources :super_market, :sms, :register, :cerebro


end
