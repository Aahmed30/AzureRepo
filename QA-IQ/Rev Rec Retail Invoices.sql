select *
from RevRec_Combined
where 
Source_ID = 1
AND Event_Type = 'Retail'
AND Sale_date >= cast('2019-10-01 00:00:00' as timestamp) 
AND sale_date <= Cast('2019-10-31 11:59:00' as timestamp)
AND Center_ID = '0547'
AND transaction_id = '70889'
order by transaction_id


/*
select cstorename,ilocationid
from millennium_locations
where cstorename like '%Alexandria%'
*/






