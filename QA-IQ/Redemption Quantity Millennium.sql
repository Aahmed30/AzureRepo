select YEAR(redemption_timestamp) AS FY,
REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')
, sum(service_quantity) as redemptionquantity, 
Round(sum(saleprice_custom),2) as redemptionamount
from events_package_redemptions ef
INNER JOIN millennium_locations zc ON zc.ilocationid = ef.center_id --clink.ID
AND ef.SOURCE_ID = 1
where redemption_timestamp >= (date '2011-01-01') and redemption_timestamp  < (date '2016-01-01')
--and TRIM(cstorename) != 'Guest Services Location'
and transaction_type in ('Redemption', 'Transfer-In')
group by REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', ''),YEAR(redemption_timestamp)
order by YEAR(redemption_timestamp),REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')		