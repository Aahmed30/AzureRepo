select *
from RevRec_Combined
where 
Source_ID = '2'
AND Event_Type = 'Refund'
AND Sale_date >= cast('2021-03-01 00:00:00' as timestamp) 
AND sale_date <= Cast('2021-03-31 11:59:00' as timestamp)
AND Center_ID = '0701'
-- AND Sku_Name = 'Retail'
-- AND transaction_id = '36ebbc5f-cfdc-4f2a-9f5a-7a56fd9f17ed'
order by transaction_id

/*
select cstorename,ilocationid
from millennium_locations
where cstorename like '%Delray%'
*/

/*
select *
from Lookups_CenterCrossReference
where franconnect_center_name like '%Bloomfield%'
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