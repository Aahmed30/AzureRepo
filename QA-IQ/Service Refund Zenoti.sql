select zc.centercode, 
Round(sum(amount_paid_net),2) as amount_net, 
Round(sum(amount_paid_gross),2) as amount_gross
from events_refunds ef
INNER JOIN Zenoti_bidimcenter zc ON zc.centerwid = ef.center_id 
AND ef.SOURCE_ID = 2
where closed_in_center_timestamp >= (date '2020-01-01') 
and closed_in_center_timestamp < (date '2020-07-01')
and refund_product_Type = 'Service'
and centerwid = '83'
group by zc.centercode
order by zc.centercode	


select centerwid,centername--,REPLACE(SPLIT(REPLACE(centername, 'EWC - ', ''), '(')[2], ')', '') 
from Zenoti_bidimcenter
where 
--centerwid = '083'
centername like '%0266%'
						
						
						
						
						
						
						
						
						
						
						
