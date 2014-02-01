require 'colorize'
require 'bitstamp'

load 'trader.rb'
load 'traderStats.rb'
load 'transactionsDatabase.rb'
load 'marketDatabase.rb'
load 'marketData.rb'
load '../general_library.rb'

seconds_between_trader_runs = 5

Bitstamp.setup do |config|
  config.key = ENV["BITSTAMP_KEY"]
  config.secret = ENV["BITSTAMP_SECRET"]
  config.client_id = ENV["BITSTAMP_CLIENT_ID"]
end

transactionsDb    = TransactionsDatabase.new
marketDb          = MarketDatabase.new
traderStats       = TraderStats.new transactionsDb, marketDb
marketDataFetcher = MarketData.new marketDb
marketDataAggregator = MarketDataAggregator.new
trader = Trader.new do |t|
  t.min_percent_gain = 0.012
  t.min_percent_drop = -0.01
  t.transactionsDb = transactionsDb
  t.marketDb = marketDb
  t.stats = traderStats
end

aggregator = MarketDataAggregator.new

sample_rows = marketDb.last_rows 15

sample_rows.each do |row|
  marketDataAggregator.place_data_point aggregator.assemble_data_point_from_row row 
end
puts marketDataAggregator.array_of_data_points
'''
while true do
  marketDataFetcher.fetch
  puts format_stars
  trader.trade
  puts "Profit this run: $#{trader.stats.profit.to_f.usd_round}"
  sleep seconds_between_trader_runs
end
'''