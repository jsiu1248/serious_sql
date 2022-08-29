-- 1. How many unique users exist in the logs dataset?
-- error in count syntax and also id is the identifier instead
SELECT
  COUNT (DISTINCT id)
FROM health.user_logs;


-- for questions 2-8 we created a temporary table
-- the name of the temp table was spelled incorrectly
-- the query needs to be wrapped in () and also AS after the name
DROP TABLE IF EXISTS user_measure_count;
CREATE TEMP TABLE user_measure_count
SELECT
    id,
    COUNT(*) AS measure_count,
    COUNT(DISTINCT measure) as unique_measures
  FROM health.user_logs
  GROUP BY 1; 

-- 2. How many total measurements do we have per user on average?
-- instead of mean it should be avg
SELECT
  ROUND(AVG(measure_count))
FROM user_measure_count;

-- 3. What about the median number of measurements per user?
-- the wrong function was used for median and it needed to be a numeric measure
SELECT
  CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_count) AS NUMERIC) AS median_value
FROM user_measure_count;


-- 4. How many users have 3 or more measurements?
-- I will be using where instead because the data comes from a temp table and is not agg
SELECT
  COUNT(*)
FROM user_measure_count
WHERE measure >= 3;

-- 5. How many users have 1,000 or more measurements?
-- you can't sum variables with characters. You have to count
SELECT
  COUNT(id)
FROM user_measure_count
WHERE measure_count >= 1000;

-- 6. Have logged blood glucose measurements?
-- the is part should be an equal sign. Also, it isn't called blood sugar
SELECT
  COUNT(DISTINCT id)
FROM health.user_logs
WHERE measure = 'blood_glucose';

-- 7. Have at least 2 types of measurements?
SELECT
  COUNT(*)
FROM user_measure_count
WHERE COUNT(DISTINCT measures) >= 2;

-- 8. Have all 3 measures - blood glucose, weight and blood pressure?
SELECT
  COUNT(*)
FROM usr_measure_count
WHERE unique_measures = 3;

-- 9.  What is the median systolic/diastolic blood pressure values?
SELECT
  PERCENTILE_CONT(0.5) WITHIN (ORDER BY systolic) AS median_systolic
  PERCENTILE_CONT(0.5) WITHIN (ORDER BY diastolic) AS median_diastolic
FROM health.user_logs
WHERE measure is blood_pressure;