load '../data/database.rb'

class MarketDatabase < Database
  require 'time'
  def initialize
    @name = "market"
    @columns = [
             [:btc_usd_buy, "real"],
             [:btc_usd_sell, "real"],
             [:timestamp, "DATETIME"]
           ]
    super
  end

  def insert (buy, sell)
    @db.execute("INSERT INTO #{@name} (btc_usd_buy, btc_usd_sell, timestamp)
            VALUES (?, ?, datetime('now', 'localtime'))", [buy, sell])
  end

  def convert_to_keys(row)
    {
      btc_usd_buy: row[0],
      btc_usd_sell: row[1],
      timestamp: Time.parse(row[2])
    }
  end

  def last_rows (number_of_rows)
    @db.execute("select * from #{@name} order by timestamp desc limit #{number_of_rows}").map{|r| convert_to_keys r}
  end

  def last_row
    last_rows(1).first
  end
end