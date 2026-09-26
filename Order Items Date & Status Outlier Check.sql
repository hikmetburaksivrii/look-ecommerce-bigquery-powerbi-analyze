-- Created At And Returned At Dates Are Planned To Be Used Within The Scope Of The Project!
-- Due To The Synthetic Nature Of The Dataset, Anomalies Were Observed In The Dates!
-- 619 Records Were Found Where The Created At Date Was Later Than The Returned At Date!
-- Cancellations Made Within A Short Period Were Expected To Have A Cancelled Status...
-- However, Records With A Returned Status Were Found!
-- Cancelled Status Occurs Only When The Created At Column Is Populated!
-- All Date Fields Are Populated For Returned Orders!
-- All Date Fields Except Returned At Are Populated For Completed Orders!
-- While Examining The Dataset, No Issues Were Observed In The Records With A Completed Status!

SELECT
  COUNTIF(created_at > CURRENT_TIMESTAMP()) AS future_created_date,
  COUNTIF(returned_at > CURRENT_TIMESTAMP()) AS future_returned_date,
  COUNTIF(returned_at < created_at) AS returned_before_created,
  COUNTIF(returned_at IS NOT NULL AND created_at IS NULL) AS returned_without_created,
  COUNTIF(TIMESTAMP_DIFF(returned_at, created_at, DAY) < 1) AS instant_returns_day,
  COUNTIF(TIMESTAMP_DIFF(returned_at, created_at, MINUTE) < 60) AS instant_returns_hour,
  COUNTIF(TIMESTAMP_DIFF(returned_at, created_at, DAY) > 90) AS late_returns_over_90_days
FROM `look0726-300726-p10.look_ecommerce.look_order_items`;

--Instant Returns Status Control!
SELECT status,COUNT(*) AS total_count
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE TIMESTAMP_DIFF(returned_at, created_at, MINUTE) < 60
GROUP BY status;

SELECT status,COUNT(*) AS total_count
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE TIMESTAMP_DIFF(returned_at, created_at, DAY) < 4
GROUP BY status;

-- Check Status Breakdown For Invalid Orders... 
-- Where Return Date Is Earlier Than Creation Date!
SELECT status,COUNT(*) AS total_count
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE returned_at < created_at
GROUP BY status
ORDER BY total_count DESC;

SELECT ID,status,created_at,returned_at
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE returned_at < created_at;

SELECT ID,status,
DATE(created_at) AS created_at,
DATE(returned_at) AS returned_at
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE DATE(returned_at) < DATE(created_at);

--Check If Completed Orders Have A Returned At Date!
SELECT COUNT(*) AS complete_but_returned_count
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE status = 'Complete' 
AND returned_at IS NOT NULL;

--Check If Completed Orders Have A Missing Created At Date!
SELECT COUNT(*) AS complete_but_returned_count
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE status = 'Complete' 
AND created_at IS NULL;

--Check If Returned Orders Have A Missing Returned At Date!
SELECT COUNT(*) AS complete_but_returned_count
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE status = 'Returned' 
AND returned_at IS NULL;

--Check If Created At Date Is In The Future!
SELECT COUNTIF(created_at > CURRENT_TIMESTAMP()) AS invalid_created_at_date
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE status = 'Complete';

--Check Date Fields For Cancelled Orders!
SELECT COUNT(*) AS total_cancelled,
  COUNT(created_at) AS created_at_filled,
  COUNT(shipped_at) AS shipped_at_filled,
  COUNT(delivered_at) AS delivered_at_filled,
  COUNT(returned_at) AS returned_at_filled
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE status = 'Cancelled';

--Check Date Fields For Returned Orders!
SELECT COUNT(*) AS total_returned,
  COUNT(created_at) AS created_at_filled,
  COUNT(shipped_at) AS shipped_at_filled,
  COUNT(delivered_at) AS delivered_at_filled,
  COUNT(returned_at) AS returned_at_filled
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE status = 'Returned';

--Check Date Fields For Complete Orders!
SELECT COUNT(*) AS total_complete,
  COUNT(created_at) AS created_at_filled,
  COUNT(shipped_at) AS shipped_at_filled,
  COUNT(delivered_at) AS delivered_at_filled,
  COUNT(returned_at) AS returned_at_filled
FROM `look0726-300726-p10.look_ecommerce.look_order_items`
WHERE status = 'Complete';