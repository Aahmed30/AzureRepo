select year(sale_in_center_date) as FY,
REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '') as centercode, 
round(sum(amount_paid_net),2) as amount_net
from events_refunds ef
INNER JOIN millennium_locations zc ON zc.ilocationid = ef.center_id --clink.ID
AND ef.SOURCE_ID = 1
where sale_in_center_date >= (date '2014-01-01') and 
sale_in_center_date < (date '2019-01-01')
and refund_product_Type = 'Service'
and void = false
and TRIM(cstorename) != 'Guest Services Location'
group by REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', ''),year(sale_in_center_date)
order by year(sale_in_center_date),REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')

						
						
						
						
						
						
						
						
						
						
						

						
						
						
						
						
						
						
						
						
						
						
