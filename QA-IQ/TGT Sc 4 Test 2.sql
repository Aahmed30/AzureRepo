select DISTINCT
      invoice_id
      ,revenue_rec
,payment_type_id
,source_id
,center_Id
,CASE
      WHEN revenue_rec THEN 'Monetary'
      WHEN payment_type_id IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
 END AS Tender_Type

from events_payments
--LIMIT 100
where 
LTRIM(RTRIM(Center_id)) IN('466','508')   
AND source_id = 2
-- AND invoice_id in ('4f3f226a-91e9-4848-a6bb-1146a1ea6e0e','34280898-2782-4ac6-87c2-befd8e3b6a08') 
AND (CASE
      WHEN revenue_rec THEN 'Monetary'
      WHEN payment_type_id IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
 END IS NOT NULL)
AND payment_type_id not in ('64','65','66','129')
--  AND invoice_item_id IS NOT NULL
limit 100