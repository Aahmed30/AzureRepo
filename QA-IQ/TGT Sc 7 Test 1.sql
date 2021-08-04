select *
from Tender_Group_Type
where source_id = 2
AND transaction_id = ''
limit 100


-- When Source = 2 --> so this is Zenoti check in Ameprity

SELECT invoice_id
,invoice_Item_id
,payment_type_id
,source_id
,CASE
      WHEN payment_type_id IN ('64', '65', '66') THEN 'Monetary'
      WHEN payment_type_id IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
    END AS Tender_Type
FROM events_payments
WHERE invoice_id IS NULL
AND source_id = 2

select *
from events_payments 
where invoice_item_id is null
and source_id = 2
limit 100