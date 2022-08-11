/*1. Which id value has the most number of duplicate records in the health.user_logs table?*/

WITH date_count AS (SELECT id, log_date, measure, measure_value, systolic, diastolic, COUNT(*) as frequency FROM HEALTH.user_logs
GROUP BY id, log_date, measure, measure_value, systolic, diastolic)

SELECT  id, SUM(frequency) as total_dup_rows
FROM date_count
-- this is needed because you need to filter out the ones that are duplicated
WHERE frequency > 1
GROUP BY id
ORDER BY total_dup_rows desc

/*2. Which log_date value had the most duplicate records after removing the max duplicate id value from question 1?*/

WITH date_count AS (SELECT id, log_date, measure, measure_value, systolic, diastolic, COUNT(*) as frequency FROM HEALTH.user_logs
GROUP BY id, log_date, measure, measure_value, systolic, diastolic)

SELECT  log_date, SUM(frequency) as total_dup_rows
FROM date_count
-- this is needed because you need to filter out the ones that are duplicated
WHERE frequency > 1
AND id <> '054250c692e07a9fa9e62e345231df4b54ff435d'
GROUP BY log_date
ORDER BY total_dup_rows desc


/*3. Which measure_value had the most occurences in the health.user_logs value when measure = 'weight'?*/
SELECT measure_value, COUNT(*) frequency
FROM health.user_logs
WHERE measure='weight'
GROUP BY measure_value
ORDER BY frequency desc


/*4. How many single duplicated rows exist when measure = 'blood_pressure' in the health.user_logs? How about the total number of duplicate records in the same table?*/
WITH table_count as (SELECT DISTINCT id, log_date, measure, measure_value, systolic, diastolic, COUNT(*) as frequency FROM health.user_logs
WHERE measure = 'blood_pressure'
GROUP BY id, log_date, measure, measure_value, systolic, diastolic)


SELECT
  COUNT(*) as single_duplicate_rows, -- single duplicated is all the distinct rows for blood_presure
  SUM(frequency) as total_duplicate_records -- total duplicated is combining all of the counts together
FROM table_count
WHERE frequency > 1;

/*5. What percentage of records measure_value = 0 when measure = 'blood_pressure' in the health.user_logs table? How many records are there also for this same condition?*/
WITH table_count as (SELECT measure_value, COUNT(*) as frequency, SUM(count(*)) OVER() total_overall FROM health.user_logs
WHERE measure = 'blood_pressure' 
GROUP BY measure_value)

SELECT  measure_value, frequency, total_overall, 
ROUND(100*frequency/total_overall,2) as percentage
FROM table_count
WHERE frequency>1 and measure_value=0

/*6. What percentage of records are duplicates in the health.user_logs table?*/