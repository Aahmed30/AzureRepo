select *
from RevRec_Combined
where 
Source_ID = 1
AND Event_Type = 'Service'
AND Sale_date >= cast('2019-10-01 00:00:00' as timestamp) 
AND sale_date <= Cast('2019-10-31 11:59:00' as timestamp)
AND Center_ID = '0547'
AND transaction_id = '70830'
order by transaction_id

/*
select distinct event_type
from RevRec_Combined
where 
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