--**********************Package Amount & Quantity********************************************************************
--Jumanji
select zc.center_id_str, sum(quantity) as packageqty, 
cast(Sum(saleprice) as decimal(15,2)) as SalePrice
from dbt.Q1_2022.package_purchase_events pp
inner JOIN dbt.Q1_2022.centers_link zc ON zc.center_id = pp.center_id 
AND zc.SOURCE_ID = 2 
AND pp.sales_date between zc.start_date and zc.end_date
where sales_date >= (date '2021-12-26') 
and sales_date < (date '2022-03-27')
group by zc.center_id_str
order by zc.center_id_str

--IQ
select center_ID, count(Service_Package_ID) as Qty, 
sum(amount) as Amt
from wax_pass_sales 
where fiscal_year = 2022
and fiscal_month in (1,2,3)
group by center_id
order by center_id
