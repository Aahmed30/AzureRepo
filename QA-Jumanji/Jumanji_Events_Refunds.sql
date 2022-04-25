--**********************Service Refunds********************************************************************
--Snowflake
select zc.center_id_str as centercode, 
Round(sum(amount_paid_net),2) as amount_net, 
Round(sum(amount_refunded),2) as amount_gross, 
Round(sum(taxes), 2) as taxes,
sum(refund_qty)  as refundqty
from refund_events ef
INNER JOIN centers_link zc ON zc.center_id = ef.center_id 
AND zc.SOURCE_ID = 2
AND ef.closed_in_center_timestamp between zc.start_date 
and (case when zc.center_id in (677, 573) and zc.Source_id = 2 then
     (date '2100-01-01') else zc.end_date end)
where closed_in_center_timestamp >= (date '2021-12-26') 
and closed_in_center_timestamp < (date '2022-03-27')
and refund_product_Type = 'Service'
group by zc.center_id_str
order by zc.center_id_str

--Zenoti
select bd.centercode, cast((sum("sale price") - sum(tax)) as decimal(15,2)) as "amount_net",
cast(sum("sale price") as decimal(15,2)) as "amount_gross", sum(tax) as tax,
sum("quantity sold") as "refundqty"
from sales_fact_consolidated_uat_q1 sfc 
inner join bi_dimcenter_uat_q1 bd 
on sfc."center wid" = bd.centerwid
where "invoice closed date"  >= '12/26/2021'
and "invoice closed date" < '03/27/2022'
and "item type code" = 'Service Refund'
group by bd.centercode
order by bd.centercode

--**********************Product Refunds********************************************************************
--Snowflake
select zc.center_id_str as centercode, 
Round(sum(amount_paid_net),2) as amount_net, 
Round(sum(amount_refunded),2) as amount_gross, 
Round(sum(taxes), 2) as taxes,
sum(refund_qty)  as refundqty
from refund_events ef
INNER JOIN centers_link zc ON zc.center_id = ef.center_id 
AND zc.SOURCE_ID = 2
AND ef.closed_in_center_timestamp between zc.start_date 
and (case when zc.center_id in (677, 573) and zc.Source_id = 2 then
     (date '2100-01-01') else zc.end_date end)
where closed_in_center_timestamp >= (date '2021-12-26') 
and closed_in_center_timestamp < (date '2022-03-27')
and refund_product_Type = 'Retail'
group by zc.center_id_str
order by zc.center_id_str


--Zenoti
select bd.centercode, cast((sum("sale price") - sum(tax)) as decimal(15,2)) as "amount_net",
cast(sum("sale price") as decimal(15,2)) as "amount_gross", sum(tax) as tax,
sum("quantity sold") as "refundqty"
from sales_fact_consolidated_uat_q1 sfc 
inner join bi_dimcenter_uat_q1 bd 
on sfc."center wid" = bd.centerwid
where "invoice closed date"  >= '12/26/2021'
and "invoice closed date" < '03/27/2022'
and "item type code" = 'Product Refund'
group by bd.centercode
order by bd.centercode

--**********************Package Refunds********************************************************************
--Snowflake
select zc.center_id_str as centercode, 
Round(sum(amount_paid_net),2) as amount_net, 
Round(sum(amount_refunded),2) as amount_gross, 
Round(sum(taxes), 2) as taxes,
sum(refund_qty)  as refundqty
from refund_events ef
INNER JOIN centers_link zc ON zc.center_id = ef.center_id 
AND zc.SOURCE_ID = 2
AND ef.closed_in_center_timestamp between zc.start_date 
and (case when zc.center_id in (677, 573) and zc.Source_id = 2 then
     (date '2100-01-01') else zc.end_date end)
where closed_in_center_timestamp >= (date '2021-12-26') 
and closed_in_center_timestamp < (date '2022-03-27')
and refund_product_Type in ('Package - Unlimited', 'Package - Fixed')
group by zc.center_id_str
order by zc.center_id_str

--Zenoti		
with RefundQty as
(
select bd.centercode, sum("quantity sold") as "refundqty"
from sales_fact_consolidated_uat_q1 sfc 
inner join bi_dimcenter_uat_q1 bd 
on sfc."center wid" = bd.centerwid
where "invoice closed date"  >= '12/26/2021'
and "invoice closed date" < '03/27/2022'
and "item type code" = 'Package Refund'
group by bd.centercode
order by bd.centercode),
RefundAmt as 
(
select bd.centercode, cast(sum(case when "amount type" = 'PaymentWithoutTax' then amount else 0 end) as decimal(15,2)) as "amount_net",
cast(sum(amount) as decimal(15,2)) as "amount_gross", cast(sum(case when "amount type" = 'TaxCollected' then amount else 0 end) as decimal(15,2)) as tax
from collections_fact_consolidated_uat_q1 sfc 
inner join bi_dimcenter_uat_q1 bd 
on sfc."center wid" = bd.centerwid
where "invoice closed date"  >= '12/26/2021'
and "invoice closed date" < '03/27/2022'
and "item type code" = 'Package Refund'
group by bd.centercode
order by bd.centercode)
select ra.centercode, ra."amount_net", ra."amount_gross", ra.tax, rq.refundqty
from refundamt ra inner join refundqty rq
on ra.centercode = rq.centercode
order by ra.centercode
			
			
			
			
			
			
			
			
			
			
