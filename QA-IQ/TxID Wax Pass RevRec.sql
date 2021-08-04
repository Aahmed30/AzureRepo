select distinct
event_type
,source_id
,transaction_id
,unit_id
,center_id
,sale_price
from RevRec_Combined
where 
Source_ID = '2'
AND Event_Type = 'Unlimited Pass'
AND revrec_date >= cast('2021-03-01 00:00:00' as timestamp) 
AND revrec_date <= Cast('2021-03-31 11:59:00' as timestamp)
AND Center_ID = '0701'
AND transaction_id = '29e9cf2a-4a54-4368-bc0d-41a4e6ee9075'
order by transaction_id


/*
select cstorename,ilocationid
from millennium_locations
where cstorename like '%Alexandria%'
EWC - Delray Beach (0520)	483
EWC - Alexandria Commons (0547)	547
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

