--**********************Package Amount & Quantity********************************************************************
--Snowflake
select zc.center_id_str, cast(Sum(purchased_price) as decimal(15,2)) as PackagePurchasedPrice
, cast(sum(discount) as decimal(15,2)) as PackageDiscount, 
cast(sum(taxes) as decimal(15,2)) as PackageTaxes,
cast(sum(saleprice) as decimal(15,2)) as PackageSalePrice,
sum(quantity) as packageqty
from package_purchase_events pp
inner JOIN centers_link zc ON zc.center_id = pp.center_id 
AND zc.SOURCE_ID = 2 
AND pp.closed_date_in_center between zc.start_date and zc.end_date
where closed_date_in_center >= (date '2021-12-26') 
and closed_date_in_center < (date '2022-03-27')
group by zc.center_id_str
order by zc.center_id_str

--Zenoti
select bd.centercode, cast(sum("sale price") as decimal(15,2)) as "PurchasePrice", 
cast(sum("discount applied") as decimal(15,2)) as "Discount", 
cast(sum(tax) as decimal(15,2)) as "Taxes", 
cast(sum("list price") as decimal(15,2)) as "SalePrice", sum("quantity sold") as "qty" 
from sales_fact_consolidated_uat_q1 sfc 
inner join bi_dimcenter_uat_q1 bd 
on sfc."center wid" = bd.centerwid
where "invoice closed date"  >= '12/26/2021'
and "invoice closed date" < '03/27/2022'
and "item type code" = 'Package'
and "invoice no" not like '%ZSCP%'
and  UPPER("invoice no") NOT LIKE 'II%' 
AND UPPER("invoice no") NOT LIKE 'IR%'
group by bd.centercode
order by bd.centercode
