select *
from RevRec_Combined
where 
Source_ID = '2'
AND Event_Type = 'Service'
AND Sale_date >= cast('2021-03-01 00:00:00' as timestamp) 
AND sale_date <= Cast('2021-03-31 11:59:00' as timestamp)
AND Center_ID = '0547'
-- AND transaction_id = '016913ef-8fd7-4be7-87b2-62188b53c96f'
order by transaction_id
limit 10



/*
select *
from Millennium_Locations
where cstorename like '%Delray%'
547-EWC - Alexandria Commons (0547) -29-false
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



