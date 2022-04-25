select REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '') AS centercode, 
Sum(quantity) as PackageCount
from events_package_purchases pp
JOIN millennium_locations zc ON zc.ilocationid = pp.center_id --clink.ID
AND pp.SOURCE_ID = 1
where sales_date >= (date '2015-01-01') and sales_date < (date '2016-01-01')
and TRIM(cstorename) != 'Guest Services Location'
and void = false	
group by REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')
order by REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')						
						
						
						
						
						
						
						
						
						
						
						
						
						
