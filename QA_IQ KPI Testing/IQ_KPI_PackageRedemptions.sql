--**********************Package Redemption Quantity And Amount********************************************************************
--Jumanji
select zc.center_id_str, cast(sum(saleprice_custom) as decimal(15,2)) as redemptionamount,
sum(service_quantity) as redemptionquantity
from package_redemption_events ef
INNER JOIN centers_link zc ON zc.center_id = ef.redemption_center_id 
AND zc.SOURCE_ID = 2 
AND ef. redemption_timestamp between zc.start_date and zc.end_date
where  redemption_timestamp >= (date '2021-12-26') 
and  redemption_timestamp < (date '2022-03-27')
and transaction_type = 'Redemption'
group by zc.center_id_str
order by zc.center_id_str


--IQ
with redempvalue as 
(select center_id, sum(amount) as amount
 from wax_pass_redemption_value
where fiscal_year = 2022
and fiscal_month in (1,2,3)
group by center_id),
redempcount as 
(select center_id, count(id) as qty
 from wax_pass_redemption_count
where fiscal_year = 2022
and fiscal_month in (1,2,3)
group by center_id)

select rd.center_id, amount, qty
from redempcount rd
inner join redempvalue rv
on rd.center_id = rv.center_id
order by rd.center_id

