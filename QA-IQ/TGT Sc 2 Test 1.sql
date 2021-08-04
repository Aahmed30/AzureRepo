select DISTINCT
      invoice_id
      ,revenue_rec
,payment_type_id
,source_id
,center_Id
,CASE
      WHEN revenue_rec THEN 'Monetary'
      WHEN payment_type_id IN ('4') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
 END AS Tender_Type

from events_payments
--LIMIT 100
where 
invoice_id in ('212032') 
AND source_id = 1
AND LTRIM(RTRIM(Center_id)) IN('185')  
AND (CASE
      WHEN revenue_rec THEN 'Monetary'
      WHEN payment_type_id IN ('4') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
 END IS NOT NULL)
--  AND invoice_item_id IS NOT NULL
limit 100



select * from Tender_Group_Type
where transaction_id = '212032'
and center_id = '0241'
limit 100
  
  /*
  select invoice_id,center_id,payment_type_id,revenue_rec
  from events_payments
  where Sale_date >= cast('2021-03-28 00:00:00' as timestamp)
    AND sale_date <= Cast('2021-06-26 23:59:00' as timestamp)
--     AND payment_type_id not in ('65','129')
AND revenue_rec = true
    AND source_id = 1
  limit 100
  */
  
  
  /*
  select *
  from Lookups_CenterCrossReference
  where millennium_center_id = '185'
  */
  
  /*
  select * from unit_detail 
  where invoice_id = '134205'
  and center_id = '274'
  limit 10
  */
  