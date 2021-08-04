/*Checking Tender Counts/Group Types to Invoices per Center/Date*/
WITH tenders AS (
  SELECT DISTINCT
  	source_id
  	, center_id
  	, transaction_id
  	, unit_id
  	, tender_type_count
  	, tender_group_type
  FROM Tender_Group_Type
)
, payments AS (
  SELECT DISTINCT
    ep.source_id
  	, ep.payment_in_center_date AS Date
  	, ep.payment_in_center_timestamp AS Datetime
  	--, ep.payment_id
 	, ep.invoice_Id AS Transaction_ID
  	, COALESCE(ud.Invoice_Item_ID, ep.invoice_item_id, '0') AS Transaction_Item_ID
    , COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
    --, ep.payment_amount_type
    --, ep.payment_type_id
    , CASE
  		WHEN ep.source_id = 2 AND ep.payment_type_id IN ('64', '65', '66') THEN 'Monetary'
  		WHEN ep.source_id = 2 AND ep.payment_type_id IN ('129') THEN 'WP Redemption'
  		WHEN ep.source_id = 2 THEN 'Non-Monetary'
  		WHEN ep.source_id = 1 AND ep.revenue_rec THEN 'Monetary'
  		WHEN ep.source_id = 1 AND payment_type_id IN ('4') THEN 'WP Redemption'
  		WHEN ep.source_id = 1 THEN 'Non-Monetary'
  		ELSE 'N/A'
  	  END AS Tender_Type
  FROM Events_Payments ep
  LEFT OUTER JOIN Lookups_CenterCrossreference zcr
  	ON zcr.Zenoti_Center_ID = ep.Center_ID
  		AND ep.source_id = 2
  LEFT OUTER JOIN Lookups_CenterCrossreference mcr
  	ON mcr.Millennium_Center_ID = ep.Center_ID
  		AND ep.source_id = 1
  LEFT OUTER JOIN Unit_Detail ud ON ud.Source_ID = ep.Source_ID 
								AND ud.Invoice_ID = ep.Invoice_ID
                                AND ud.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
  								AND ud.Invoice_Item_Id = COALESCE(ud.Invoice_Item_ID, ep.invoice_item_id, '0')
                   				AND ud.Source_ID = 1
  WHERE ep.invoice_Id IS NOT NULL
  	AND CAST(ep.payment_amount AS DOUBLE) <> 0
)
, resultsBase AS (
  SELECT DISTINCT
      p.*
      , t.tender_group_type
      , t.tender_type_count
  FROM tenders t
  LEFT JOIN payments p
      ON t.source_id = p.source_id
          AND t.center_id = p.center_id
          AND t.Transaction_ID = p.Transaction_ID
          AND t.Unit_ID = p.Transaction_Item_ID
)
--SELECT COUNT(*) FROM resultsBase WHERE Tender_Group_Type IS NULL--Transaction_ID IN ('163138', '207608') AND Center_Id = '0407'

, results AS (
  SELECT *
  FROM resultsBase
  WHERE YEAR(Date) = 2017
      AND Month(Date) = 09
  AND transaction_ID IN ('22804' /*Monetary*/, '23402' /*Non-Monetary*/, '23408' /*Hybrid*/) -- had no WP Redemp for period
      AND center_id = '0707' /*Washington DC - Dupont Circle*/
  
--   UNION
--   SELECT *
--   FROM resultsBase
-- --   WHERE YEAR(Date) = 2019
-- --       AND Month(Date) = 01
--   WHERE transaction_ID IN ('163777' /*Monetary*/, '163782' /*Non-Monetary*/, '163870' /*Hybrid*/) -- had no WP Redemp for period
--       AND center_id = '0407' /*Brooklyn - Montague*/
--   UNION
--   SELECT *
--   FROM resultsBase
-- --   WHERE YEAR(Date) = 2019
-- --       AND Month(Date) = 06
--   WHERE transaction_ID IN ('64507' /*Monetary*/, '64435' /*Non-Monetary*/, '64134' /*Hybrid*/) -- had no WP Redemp for period
--       AND center_id = '0547' /*Alexandria - Alexandria Commons*/
--   UNION
--   SELECT *
--   FROM resultsBase
-- --   WHERE YEAR(Date) = 2020
-- --       AND Month(Date) = 12
--   WHERE transaction_ID IN ('01b2971c-3ede-4f67-9200-a7e7ce86f323' /*Monetary*/, '422b6f26-54cb-4913-b27e-845d5b82e6a5' /*Non-Monetary*/, 'b1e837d4-fc07-460e-a1e3-5f52a8fa1aa7' /*WP Redemption*/, 'b48ed66e-b7b0-487c-a0b6-495090cdb120' /*Hybrid*/)
--       AND center_id = '0059' /*Hoboken*/
--   UNION
--   SELECT *
--   FROM resultsBase
-- --   WHERE YEAR(Date) = 2020
-- --       AND Month(Date) = 10
--   WHERE transaction_ID IN ('0065b905-9ed6-4117-a9a3-7fc8b524657e' /*Monetary*/, '4b77ff23-4aa3-4eeb-91de-b76d19bdcb5a' /*Non-Monetary*/, '0118df17-a102-4560-8c5a-9f0e168c303c' /*WP Redemption*/, 'f09a73d4-e2e6-40d6-8ea7-8c5d9010064c' /*Hybrid*/)
--       AND center_id = '0084' /*Wyckoff*/
--   UNION
--   SELECT *
--   FROM resultsBase
-- --   WHERE YEAR(Date) = 2021
-- --       AND Month(Date) = 03
--   WHERE transaction_ID IN ('6e7f62c8-6ecd-46de-8395-6761bad1d6ae' /*Monetary*/, '016913ef-8fd7-4be7-87b2-62188b53c96f' /*Non-Monetary*/, '71189c20-5562-4e87-a930-b3acebbad447' /*WP Redemption*/, '459969e3-d3dc-4272-b88a-f6497d465cdc' /*Hybrid*/)
--       AND center_id = '0701' /*West Bloomfield*/
  
 
)
, resultCounts AS (
  SELECT
  	center_id, transaction_id, transaction_item_id, source_id
  	, COUNT(DISTINCT tender_type) AS test_count
  FROM results
  GROUP BY center_id, transaction_id, transaction_item_id, source_id
)
SELECT r.*, rc.test_count
FROM results r
LEFT JOIN resultCounts rc
	ON r.center_id = rc.center_id
    	AND r.transaction_id = rc.transaction_id
        AND r.transaction_item_id = rc.transaction_item_id
        AND r.source_id = rc.source_id
ORDER BY center_id, transaction_id, transaction_item_id, tender_type, source_id