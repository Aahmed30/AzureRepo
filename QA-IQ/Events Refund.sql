select * from events_refunds 
where 
source_id = 2
-- AND sale_in_center_timestamp >= cast('2021-03-01 00:00:00' as timestamp) 
-- AND sale_in_center_timestamp <= Cast('2021-03-31 11:59:00' as timestamp)
AND refund_product_type = 'Retail'
-- AND invoice_id = '7e962715-e28c-4eff-bd0a-69613a296eba'
AND center_id = '84'
order by invoice_id
limit 100

/*
select cstorename,ilocationid
from millennium_locations
where cstorename like '%Alexandria%'
*/


/*
select centername,centercode
from Zenoti_BIDimCenter
where centername like '%Wyckoff%'
Hoboken - 0059
Wyckoff - 0084
West Bloomfield - 0701
*/