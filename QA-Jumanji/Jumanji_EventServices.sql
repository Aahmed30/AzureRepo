/****Amperity - Saervice sale
---------------------------***/

SELECT
--sum(cast(es.refund_amount as decimal(15,2))),mcp.Ewc_CenterId
--sum(cast(es.refund_amount as decimal(15,2))),zc.centercode
SUM(es.quantity) AS QUANTIY,
sum(es.saleprice) as Saleprice,
SUM(es.net_amount) AS Net_amount,
SUM(discount) AS Total_Discount,
sum(taxes) as Taxes,
year(es.sales_date) as year,
month(es.sales_date) as month
--sum(es.ta)
--sum(es.saleprice) as SP,sum(es.taxes) as Tax,mcp.Ewc_CenterId
--sum(cast(es.saleprice as decimal(15,2))) as ServiceSale,
--zc.centercode
FROM Events_Services es
where CAST(es.sales_date AS DATE) BETWEEN CAST('2021-09-27' AS DATE) AND CAST('2021-12-25' AS DATE)
and source_id =2
GROUP by year(es.sales_date),month(es.sales_date)
order by month(es.sales_date)


/***------------------------------------------------
Zenoti - Service sale 
--------------------------------------------*****/

With Zenoti_Service_Item as (
SELECT ii.invoiceId,
ii.invoiceitemid,
c.centerwid,
c.centername,
it.itemtypecode,
ii.saledateincenter,
ii.closeddateincenter,
DATE_PART(month,saledateincenter) Sale_Month,
DATE_PART(year,saledateincenter) AS Sale_Year,
DATE_PART(day,saledateincenter) AS Sale_Day,
DATE_PART(month,closeddateincenter) Closed_Month,
DATE_PART(year,closeddateincenter) AS Closed_Year,
DATE_PART(day,closeddateincenter) AS Closed_Day,
s.code AS SKU_Code,
s.servicename AS SKU_Name,
ii.refundsourceinvoiceitemid,
ii.quantity,
ii.saleprice,
ii.taxes,
ii.discount,
ii.finalsaleprice,
u.gender,
u.firstname,
u.lastname,
ii.isinvalidinvoice,
ii.void,
case when ii.SalePrice < 0 then 'Refund' else 'Purchase' end as refund
FROM bi_factinvoiceitem ii
LEFT OUTER JOIN bi_dimservice s ON s.servicewid = ii.servicewid
LEFT OUTER JOIN bi_dimproduct p ON p.productwid = ii.productwid
LEFT OUTER JOIN bi_dimcenter c ON c.centerwid = ii.centerwid
LEFT OUTER JOIN bi_dimuser u on u.userwid = ii.userwid
LEFT OUTER JOIN bi_dimitemtype it ON it.itemtypewid = ii.itemtypewid
WHERE ii.invoice_no NOT LIKE '%IGN%'
AND ii.invoice_no NOT LIKE 'II%'
--AND saledateincenter > '2021-04-01'
AND (usagetype <> 'PackageUsage' OR usagetype IS NULL)
--AND ii.itemtypewid = 39
----AND packageversionwid = 79
--AND invoiceitempk is not null
--AND ((trim(lower(usagetype)) NOT LIKE '%packageusage%') OR usagetype is null)
ORDER BY InvoiceID
)





SELECT
--Closed_Year,
sale_year,
--Closed_Month,
sale_month,
--centercode,
--refund,
sum(quantity) as Quantity,
SUM(SalePrice) AS Total_Sale_Price,
SUM(discount) AS Total_Discount,
SUM(saleprice-Discount) AS Net_amount,
sum(Discount) as discount,
SUM(taxes) as tax
FROM Zenoti_Service_Item ii
inner join bi_dimcenter bd on ii.centerwid=bd.centerwid
WHERE ii.isinvalidinvoice = 0
AND ii.void = 0
AND ii.itemtypecode = 'Service'
AND saledateincenter::date between '2021-09-27' and '2021-12-25'
GROUP BY
sale_year,
sale_month
--refund
order by sale_year,
sale_month

/*************-------------------------------------------------------------

Refund - Amperity 

-----------------------------------------------------------------************/

select  zc.centercode,sum(amount_paid_net) as amount_net, sum(amount_paid_gross) as amount_gross									
from events_refunds ef									
INNER JOIN Zenoti_bidimcenter zc ON zc.centerwid = ef.center_id --clink.ID									
AND ef.SOURCE_ID = 2									
where sale_in_center_date between (date '2021-04-01') and (date '2021-06-27')									
and  zc.centercode in ('0004', '0019', '0070', '0077', '0137', '0157', '0184', '0204',
 '0333', '0335', '0370', '0442', '0457', '0469', '0505', '0506',
 '0554', '0581', '0660', '0678', '0783', '0794', '0823', '0831', '0832', '0847', '0909', '0955'
  ,'0685','0801','0866',
'0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181',
'0182','0257','0350','0447','0524','0526','0636','0639','0644','0645','0684','0707','0708')									
and refund_product_Type = 'Service'									
group by zc.centercode									
order by zc.centercode	


/***********------------------------------------------------------------------------------

                  Refund - Zenoti 
-----------------------------------------------------------------------------***************/

select  bd.centercode,sum(""sale price"") as ""SalePrice"", sum(""list price"") as ""ListPrice""								
from sales_fact_consolidated sfc 								
inner join bi_dimcenter bd 								
on sfc.""center wid"" = bd.centerwid								
where ""sale date""  >= '04/1/2021'								
and ""sale date"" < '06/27/2021'								
and ""item type code"" = 'Service Refund'								
and bd.centercode in('0004', '0019', '0070', '0077', '0137', '0157', '0184', '0204',
 '0333', '0335', '0370', '0442', '0457', '0469', '0505', '0506',
 '0554', '0581', '0660', '0678', '0783', '0794', '0823', '0831', '0832', '0847', '0909', '0955'
  ,'0685','0801','0866',
'0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181',
'0182','0257','0350','0447','0524','0526','0636','0639','0644','0645','0684','0707','0708')								
group by bd.centercode								
order by bd.centercode	
