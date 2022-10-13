WITH april_17_data AS (
  SELECT
    market_date,
    open_price,
    null::NUMERIC AS null_column,
    1 AS numeric_column,
    LAG(open_price) OVER (ORDER BY market_date) AS lag_open_price
  FROM trading.daily_btc
  WHERE market_date BETWEEN ('2020-04-17'::DATE - 1) AND ('2020-04-17'::DATE + 1)
)
SELECT
  market_date,
  -- good example!
  open_price,
  COALESCE(open_price, lag_open_price) as open_lag,
  -- 2 different types?!?
  --COALESCE(market_date, open_price), -- this line won't work because of different types
  -- does order matter?
  COALESCE(open_price, numeric_column) as open_numeric,
  COALESCE(numeric_column, open_price) as numeric_open,
  -- using a default
  COALESCE(open_price, null_column, 9001::NUMERIC) as open_null_numeric ,
  -- only one null column input?
  COALESCE(null_column) as null_column,
  -- multiple null inputs
  COALESCE(null, null) as null_null, 
  -- blended?
  COALESCE(null, null_column) as null_null_column
FROM april_17_data;