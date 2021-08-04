select DISTINCT
      invoice_id
      ,invoice_item_id
,payment_type_id
,source_id
,center_Id
,CASE
      WHEN payment_type_id IN ('64', '65', '66') THEN 'Monetary'
    END AS Tender_Type

from events_payments
--LIMIT 100
where 
 invoice_id in ('98260b7f-f343-424a-9e89-7c596190b00d',
'40342f64-f44c-41aa-aa2f-835d51596f39')                    
AND
LTRIM(RTRIM(Center_id)) IN('455','282')   
AND source_id = 2
AND (CASE
      WHEN payment_type_id IN ('64', '65', '66') THEN 'Monetary'
    END IS NOT NULL)
limit 10