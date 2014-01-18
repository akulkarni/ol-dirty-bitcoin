class SuperMarketController < ApplicationController

def index
  # @bitcoin_prices = BitcoinPrice.all
  
  @mtgox = MtGox.ticker
  
  @bitstamp = Bitstamp.ticker
  
  @btce = Btce::Ticker.new "btc_usd"
  
  coinbase = Coinbase::Client.new(ENV['COINBASE_SECRET'])
  
  @coinbase_buy = coinbase.buy_price(1).format
  @coinbase_sell = coinbase.sell_price(1).format
  
  render :text => @mtgox.price

  end

end
