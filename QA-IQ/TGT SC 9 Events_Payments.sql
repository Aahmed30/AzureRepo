SELECT
    ep.Source_id,
  	ep.invoice_id,
    ep.invoice_item_id,
    ep.center_id,
    ep.payment_amount_type,
    ep.payment_type_id,
  YEAR(ep.payment_in_center_timestamp) AS SalesYear,
    CASE
      WHEN ep.payment_type_id IN ('64', '65', '66') THEN 'Monetary'
      WHEN ep.payment_type_id IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
    END AS Tender_Type
  FROM
    events_payments ep
  where
    ep.source_id = 2
--   AND ep.payment_in_center_timestamp >= cast('2021-06-01 00:00:00' as timestamp)
--   AND ep.payment_in_center_timestamp <= Cast('2021-06-30 23:59:00' as timestamp)
  AND ep.center_id = '305'
  AND ep.invoice_id = '3ee0faaf-892a-467f-b988-e95a5ae686ec'
-- and CASE
--       WHEN ep.payment_type_id IN ('64', '65', '66') THEN 'Monetary'
--       WHEN ep.payment_type_id IN ('129') THEN 'WP Redemption'
--       ELSE 'Non-Monetary'
--     END = 'Monetary'
 ORDER BY ep.invoice_id
 LIMIT 200
  
  
  /*
SELECT franconnect_center_id,franconnect_center_name,
zenoti_center_id,zenoti_center_name
FROM Lookups_CenterCrossReference
WHERE zenoti_center_name LIKE '%Bloomfield%'
LIMIT 10
*/

-- select count(distinct invoice_id) from events_payments

-- select count(distinct transaction_id) from tender_group_type