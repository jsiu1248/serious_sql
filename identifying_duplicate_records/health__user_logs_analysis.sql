SELECT * FROM health.user_logs LIMIT 10

-- 43891 rows
SELECT COUNT(*) FROM health.user_logs

-- dates from 2015 to 2020
SELECT log_date, COUNT(*)
FROM health.user_logs 
GROUP BY log_date
ORDER BY log_date

-- the highest count was on 2019-12-10 and it was measured 376 times
SELECT log_date, measure, COUNT(measure_value)
FROM health.user_logs 
GROUP BY log_date, measure
ORDER BY count desc

-- the systolic column has the same number of nulls than diastolic
SELECT
  measure,
  COUNT(*)
FROM health.user_logs
WHERE systolic IS NULL
GROUP BY 1;

SELECT
  measure,
  COUNT(*)
FROM health.user_logs
WHERE diastolic IS NULL
GROUP BY 1;

-- this was mainly to check the nulls and row counts. So, we will do more summary statistics in a bit. 