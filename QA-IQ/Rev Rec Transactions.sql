select *
from RevRec_Combined
where 
Source_ID = 1
AND Event_Type = 'Refund'
AND Sale_date >= cast('2019-04-01 00:00:00' as timestamp) 
AND sale_date <= Cast('2019-04-30 11:59:00' as timestamp)
AND Center_ID = '0707'
AND transaction_id = '103277'
order by transaction_id
