select 
Event_Type
,SUM(sale_price)
from RevRec_Combined
where 
Source_ID = '2'
-- AND Event_Type = 'Service'
-- -- AND Sale_date >= cast('2021-03-01 00:00:00' as timestamp) 
-- -- AND sale_date <= Cast('2021-03-31 11:59:00' as timestamp)
-- AND Center_ID = '0547'
AND transaction_id = '00b56d21-c8e2-4e72-8d8b-919d7447fec8'
-- order by transaction_id
group by Event_Type





/*
select Cstorename,ilocationID
from Millennium_Locations
where cstorename like '%Wyckoff%'
547-EWC - Alexandria Commons (0547) -29-false
*/

/*
select centername,centercode
from Zenoti_BIDimCenter
where centername like '%Bloomfield%'
Hoboken - 0059
Wyckoff - 0084
West Bloomfield - 0701
*/



