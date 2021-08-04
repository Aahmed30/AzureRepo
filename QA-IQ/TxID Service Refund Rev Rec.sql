select *
from RevRec_Refund
where 
Source_ID = 1
-- AND sku_name = 'Service'
-- AND Sale_date >= cast('2019-04-01 00:00:00' as timestamp)
-- AND sale_date <= Cast('2019-04-30 11:59:00' as timestamp)
-- AND Center_ID = '0707'
AND transaction_id = '101828'
order by transaction_id
limit 10


/*
select distinct Event_Type
from RevRec_Refund
*/


/*
select *
from Lookups_CenterCrossReference
where franconnect_center_name like '%Dupont%'
547-EWC - Alexandria Commons (0547)
EWC - Delray Beach (0520)	483
*/

/*
select centername,centercode
from Zenoti_BIDimCenter
where centername like '%Bloomfield%'
Washington DC - Dupont - 0707	0707
Delray Beach - 0520	0520
Alexandria Commons - 0547	0547
Hoboken - 0059	0059
Wyckoff - 0084	0084
West Bloomfield - 0701	0701
*/



