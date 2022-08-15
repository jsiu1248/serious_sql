/*1. What is the average, median and mode values of blood glucose values to 2 decimal places?*/
SELECT ROUND(AVG(measure_value),2),  MODE() WITHIN GROUP (ORDER BY measure_value), 
ROUND(
    -- this function actually returns a float which is incompatible with ROUND!
    -- we use this cast function to convert the output type to NUMERIC
    CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_value) AS NUMERIC),
    2
  ) AS median_value FROM HEALTH.user_logs
WHERE measure = 'blood_glucose'

/*2. What is the most frequently occuring measure_value value for all blood glucose measurements?*/
SELECT   measure_value, COUNT(measure_value) FROM health.user_logs
-- mode just shows the measure that is the most frequent, however in order to get the frequency you need the count
WHERE measure = 'blood_glucose'
GROUP BY measure_value
ORDER BY 2 desc

/*3. Calculate the 2 Pearson Coefficient of Skewness for blood glucose measures given the following formulas:*/
WITH cte_blood_glucose_stats AS (
  SELECT
    AVG(measure_value) AS mean_value,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_value) AS median_value,
    MODE() WITHIN GROUP (ORDER BY measure_value) AS mode_value,
    STDDEV(measure_value) AS stddev_value
  FROM health.user_logs
  WHERE measure = 'blood_glucose'
)
SELECT
-- get the mean, mode, median, and standard dev and then create the computed columns
  ( mean_value - mode_value ) / stddev_value AS pearson_corr_1,
  3 * ( mean_value - median_value ) / stddev_value AS pearson_corr_2
FROM cte_blood_glucose_stats;