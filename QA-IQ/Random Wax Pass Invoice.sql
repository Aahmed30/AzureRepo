select *
from RevRec_Combined
where 
Source_ID = '2'
AND Event_Type = 'Unlimited Pass'
AND revrec_date >= cast('2021-03-01 00:00:00' as timestamp) 
AND revrec_date <= Cast('2021-03-31 11:59:00' as timestamp)
AND Center_ID = '0701'
AND transaction_id = '313b1b42-fd91-4155-8186-d425cf1b0423'
order by transaction_id,unit_id



select top 2 * from bi/