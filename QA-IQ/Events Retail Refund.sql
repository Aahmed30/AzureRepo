select 
invoice_id
,payment_mode_data
,payment_option_type
,payment_type
,refund_product_type
,amount_paid_gross
,center_id
,ewc_center_id
from events_refunds
where center_id = '547'
AND payment_mode_data = 'REFUND'
AND refund_product_type = 'Retail'
AND sale_in_center_timestamp >= cast('2019-10-01 00:00:00' as timestamp) 
AND sale_in_center_timestamp <= Cast('2019-10-31 11:59:00' as timestamp)
limit 100


/*
select cstorename,ilocationid
from millennium_locations
where cstorename like '%Alexandria%'
*/