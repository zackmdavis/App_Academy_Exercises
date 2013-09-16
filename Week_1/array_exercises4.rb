def stock_picker(prices)
  maximum = 0
  days = [0,0]
  (0...prices.length).each do |buy_day|
    (buy_day...prices.length).each do |sell_day|
      if prices[sell_day] - prices[buy_day] > maximum
        maximum = prices[sell_day] - prices[buy_day]
        days = [buy_day, sell_day]
      end
    end
  end
  days
end

prices = [1,2,-30,4,5,60,7]
print stock_picker(prices)