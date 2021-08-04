SELECT Transaction_ID
,unit_id
,center_id
,tender_type_count
,tender_group_type
FROM Tender_Group_Type
where source_id = 2
and center_id = '0701'
-- and transaction_id IN (
-- '0f067673-4ab2-43cf-afa4-760746e0c30a'
-- ) 
and tender_group_type = 'Hybrid'
LIMIT 100 



/*
SELECT franconnect_center_id,franconnect_center_name,
zenoti_center_id,zenoti_center_name
FROM Lookups_CenterCrossReference
WHERE zenoti_center_name LIKE '%Dupont%'
LIMIT 10
*/


/*
select *
from events_payments
where invoice_id = '0034702e-efbb-4c2a-b404-f5d3988efd0b'
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