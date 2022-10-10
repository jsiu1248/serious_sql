
--What is the earliest and latest market_date values?

SELECT  market_date, open_price, high_price, low_price, close_price, adjusted_close_price, volume
FROM trading.daily_btc
--GROUP BY open_price, high_price, low_price, close_price, adjusted_close_price, volume
WHERE market_date = (SELECT MAX(market_date) FROM trading.daily_btc)
LIMIT 5;


SELECT  market_date, open_price, high_price, low_price, close_price, adjusted_close_price, volume
FROM trading.daily_btc
--GROUP BY open_price, high_price, low_price, close_price, adjusted_close_price, volume
WHERE market_date = (SELECT MIN(market_date) FROM trading.daily_btc)
LIMIT 5;


-- What was the historic all-time high and low values for the close_price and their dates?

SELECT market_date, close_price
FROM trading.daily_btc

WHERE close_price = (SELECT MAX(close_price) FROM trading.daily_btc)

SELECT market_date, close_price
FROM trading.daily_btc

WHERE close_price = (SELECT MIN(close_price) FROM trading.daily_btc)



-- Which date had the most volume traded and what was the close_price for that day?

SELECT market_date, volume
FROM trading.daily_btc

WHERE volume = (SELECT MAX(volume) FROM trading.daily_btc)


SELECT market_date, volume
FROM trading.daily_btc

WHERE volume = (SELECT MIN(volume) FROM trading.daily_btc)

-- How many days had a low_price price which was 10% less than the open_price?


/*
sum all of the days
calculate low price 10% lower than open price
*/



What percentage of days have a higher close_price than open_price?
What was the largest difference between high_price and low_price and which date did it occur?
If you invested $10,000 on the 1st January 2016 - how much is your investment worth in 1st of February 2021? Use the close_price for this calculation


