----------------------EVENT PRODUCT------Scenario#1----------------
-- SELECT * FROM Events_Retail LIMIT 100   Scenario#1

--Amperity-Millenniumco
SELECT DISTINCT
        COUNT(product_event_id) Product_Count
       ,ROUND(SUM(net_amount),2)As TotalNetAmount
       ,YEAR(closed_date_in_center) As Sales_year
FROM Events_Retail 
--WHERE closed_date_in_center >= cast('2020-01-01 00:00:00' as timestamp) AND closed_date_in_center<= Cast('2020-12-31 11:59:00' as timestamp)
WHERE source_id = 1
AND YEAR(sales_timestamp) = 2020
GROUP BY YEAR(closed_date_in_center)
order by YEAR(closed_date_in_center)

--Millenniumco
WITH Events as (
  SELECT
    th.iid as product_event_id,
    1 as source_id,
      cast(TDATETIME as date) as closed_date_in_center
    FROM
    millenniumco.dbo.transhead th
    INNER JOIN millenniumco.dbo.[transaction] t ON t.IHEADERID = th.IID
    AND th.ILOCATIONID = t.ILOCATIONID
    LEFT OUTER JOIN (
      select
        IHEADERID,
        ILOCATIONID,
        NLINENO,
        sum(NDISCAMOUNT) as discount
      from
       millenniumco.dbo.trandisc
      group by
        IHEADERID,
        ILOCATIONID,
        NLINENO
    ) td on td.IHEADERID = t.IHEADERID
    and td.ILOCATIONID = t.ILOCATIONID
    and td.NLINENO = t.NLINENO
  WHERE
    t.IpackageID = '0'
    AND t.CTRANSTYPE = 'P'
    AND (CDISCOUNT != '' OR CDISCOUNT IS NOT NULL)
)
SELECT
      COUNT(product_event_id) TOTALEvents
	  ,Year(closed_date_in_center) As  EventYear
FROM Events
WHERE Year(closed_date_in_center) = 2020
GROUP BY Year(closed_date_in_center) 

----------------------EVENT PRODUCT------Scenario#2----------------
--Amperity-Millennium
  SELECT DISTINCT
    th.iid as product_event_id,
    1 as source_id,
    --null as zenoti_invoiceitemid,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    ILOGINID as employee_id,
    IPRDSRVID as service_id,
    IPRDSRVID as product_id,
    IPRDSRVID as item_id,
    --NULL as item_type_id,
    th.iid as invoice_id,
    t.iid as invoice_item_id,
    th.CINVOICENO as invoice_num,
    th.IPKID as invoice_pk,
    NQUANTITY as quantity,
    --NULL as invoicesource,
    (NPRICE * NQUANTITY) +(NPSTCOLLECTED) as final_sale_price,
    discount as discount,
    NPSTCOLLECTED as taxes,
    (NPRICE * NQUANTITY) as saleprice,
    ILOGINID as closed_by_id,
    ILOGINID as created_by_id,
    ILOGINID as modified_by_id,
    th.TLASTUPDATE as updated_at,
    th.TLASTUPDATE as invoice_timestamp,
    cast(TDATETIME as date) as invoice_date,
    TDATETIME as sales_timestamp,
    cast(TDATETIME as date) as sales_date,
    ILOGINID as applied_by_id,
    cast(TDATETIME as date) as created_date_in_center,
    TDATETIME as created_timestamp_in_center,
    TDATETIME as campaign_usage_timestamp_in_center,
    cast(TDATETIME as date) as campaign_usage_date_in_center,
    TDATETIME as closed_timestamp_in_center,
    cast(TDATETIME as date) as closed_date_in_center,
    TDATETIME as last_updated_timestamp_in_center,
    cast(TDATETIME as date) as last_updated_date_in_center,
     LVOID as void,

    (NPRICE * NQUANTITY) as net_amount
  FROM
    Millennium_transactionheader th
    INNER JOIN Millennium_TRANSACTIONS t ON t.IHEADERID = th.IID
    AND th.ILOCATIONID = t.ILOCATIONID
    LEFT OUTER JOIN (
      select
        IHEADERID,
        ILOCATIONID,
        NLINENO,
        sum(NDISCAMOUNT) as discount
      from
        Millennium_transactiondiscounts
      group by
        IHEADERID,
        ILOCATIONID,
        NLINENO
    ) td on td.IHEADERID = t.IHEADERID
    and td.ILOCATIONID = t.ILOCATIONID
    and td.NLINENO = t.NLINENO
  WHERE
    t.IpackageID = '0'
    AND t.CTRANSTYPE = 'P'
    AND CDISCOUNT != ''
	AND th.iid = '193161'   --product_event_id for Testing invoices
    --LIMIT 100
      
--Millennium
SELECT DISTINCT
    th.iid as product_event_id,
    1 as source_id,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    ILOGINID as employee_id,
    IPRDSRVID as service_id,
    IPRDSRVID as product_id,
    IPRDSRVID as item_id,
    th.iid as invoice_id,
    t.iid as invoice_item_id,
    th.CINVOICENO as invoice_num,
    th.IPKID as invoice_pk,
    NQUANTITY as quantity,
    (NPRICE * NQUANTITY) +(NPSTCOLLECTED) as final_sale_price,
    discount as discount,
    NPSTCOLLECTED as taxes,
    (NPRICE * NQUANTITY) as saleprice,
    ILOGINID as closed_by_id,
    ILOGINID as created_by_id,
    ILOGINID as modified_by_id,
    th.TLASTUPDATE as updated_at,
    th.TLASTUPDATE as invoice_timestamp,
    cast(TDATETIME as date) as invoice_date,
    TDATETIME as sales_timestamp,
    cast(TDATETIME as date) as sales_date,
    ILOGINID as applied_by_id,
    cast(TDATETIME as date) as created_date_in_center,
    TDATETIME as created_timestamp_in_center,
    TDATETIME as campaign_usage_timestamp_in_center,
    cast(TDATETIME as date) as campaign_usage_date_in_center,
    TDATETIME as closed_timestamp_in_center,
    cast(TDATETIME as date) as closed_date_in_center,
    TDATETIME as last_updated_timestamp_in_center,
    cast(TDATETIME as date) as last_updated_date_in_center,
      LVOID as void,
      (NPRICE * NQUANTITY) as net_amount
  FROM
    millenniumco.dbo.transhead th
    INNER JOIN millenniumco.dbo.[transaction] t ON t.IHEADERID = th.IID
    AND th.ILOCATIONID = t.ILOCATIONID
    LEFT OUTER JOIN (
      select
        IHEADERID,
        ILOCATIONID,
        NLINENO,
        sum(NDISCAMOUNT) as discount
      from
       millenniumco.dbo.trandisc
      group by
        IHEADERID,
        ILOCATIONID,
        NLINENO
    ) td on td.IHEADERID = t.IHEADERID
    and td.ILOCATIONID = t.ILOCATIONID
    and td.NLINENO = t.NLINENO
  WHERE
    t.IpackageID = '0'
    AND t.CTRANSTYPE = 'P'
    AND (CDISCOUNT != '' OR CDISCOUNT IS NOT NULL)
AND th.iid = '193161'   --product_event_id for Testing invoices
    --LIMIT 100
    
----------------------EVENT PRODUCT------Scenario#3---------------- 
--Amperity-millennium

SELECT 
      
      SUM(net_amount) TotalSales
     ,YEAR(closed_date_in_center) As Sales_year
FROM Events_Retail 
WHERE closed_date_in_center >= cast('2021-01-01 00:00:00' as timestamp) AND closed_date_in_center<= Cast('2021-03-31 11:59:00' as timestamp) 
AND Source_id = 1
GROUP BY YEAR(closed_date_in_center)   --Q1-2021 8658106.060999835

--Millennium
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
;WITH  Products as (
  SELECT
    t.iid as product_event_id,
    1 as source_id,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    ILOGINID as employee_id,
    IPRDSRVID as service_id,
    IPRDSRVID as product_id,
    IPRDSRVID as item_id,
    th.iid as invoice_id,
    t.iid as invoice_item_id,
    th.CINVOICENO as invoice_num,
    th.IPKID as invoice_pk,
    NQUANTITY as quantity,
    NULL as invoicesource,
    round(
      (NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as Decimal(10,2)),
      2
    ) as final_sale_price,
    discount as discount,
    (NPRICE * NQUANTITY) * cast(NRETTAX as Decimal(10,2)) as taxes,
    (NPRICE * NQUANTITY) as saleprice,
    ILOGINID as closed_by_id,
    ILOGINID as created_by_id,
    ILOGINID as modified_by_id,
    th.TLASTUPDATE as updated_at,
    th.TLASTUPDATE as invoice_timestamp,
    cast(TDATETIME as date) as invoice_date,
    TDATETIME as sales_timestamp,
    cast(TDATETIME as date) as sales_date,
    ILOGINID as applied_by_id,
    cast(TDATETIME as date) as created_date_in_center,
    TDATETIME as created_timestamp_in_center,
    TDATETIME as campaign_usage_timestamp_in_center,
    cast(TDATETIME as date) as campaign_usage_date_in_center,
    TDATETIME as closed_timestamp_in_center,
    cast(TDATETIME as date) as closed_date_in_center,
    TDATETIME as last_updated_timestamp_in_center,
    cast(TDATETIME as date) as last_updated_date_in_center,
    LVOID as void,

    (NPRICE * NQUANTITY) as net_amount
  FROM
    millenniumco.dbo.transhead th
    INNER JOIN millenniumco.dbo.[transaction] t ON t.IHEADERID = th.IID
    AND th.ILOCATIONID = t.ILOCATIONID
    LEFT OUTER JOIN (
      select
        IHEADERID,
        ILOCATIONID,
        NLINENO,
        sum(NDISCAMOUNT) as discount
      from
        millenniumco.dbo.trandisc
      group by
        IHEADERID,
        ILOCATIONID,
        NLINENO
    ) td on td.IHEADERID = t.IHEADERID
    and td.ILOCATIONID = t.ILOCATIONID
    and td.NLINENO = t.NLINENO
    LEFT OUTER JOIN millenniumco.dbo.taxrates tr on t.ilocationid = tr.ilocationid
    and th.TDATETIME >= tr.ttaxstart
    AND (
      th.TDATETIME <= tr.ttaxend
      OR tr.ttaxend is null
    )
  WHERE
    cast(t.IpackageID as int) = 0
    AND t.CTRANSTYPE = 'P'

)
SELECT DISTINCT
          Count(product_id) ProductCount
  ,SUM(saleprice) TotalSales
         ,DATEPART(YEAR,closed_date_in_center) As Year
         ,DATEPART(QUARTER,closed_date_in_center) As Quarter
  FROM Products
  WHERE DATEPART(YEAR,closed_date_in_center) = 2021
  AND DATEPART(QUARTER,closed_date_in_center) = 1
  GROUP BY DATEPART(YEAR,closed_date_in_center),DATEPART(QUARTER,closed_date_in_center)
  ORDER BY DATEPART(YEAR,closed_date_in_center) ,DATEPART(QUARTER,closed_date_in_center)


----------------------EVENT PRODUCT------Scenario#4---------------- 

--Amperity

with Products as (
  SELECT
    t.iid as product_event_id,
    1 as source_id,
    null as zenoti_invoiceitemid,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    ILOGINID as employee_id,
    IPRDSRVID as service_id,
    IPRDSRVID as product_id,
    IPRDSRVID as item_id,
    NULL as item_type_id,
    th.iid as invoice_id,
    t.iid as invoice_item_id,
    th.CINVOICENO as invoice_num,
    th.IPKID as invoice_pk,
    NQUANTITY as quantity,
    NULL as invoicesource,
    round(
      (NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as double),
      2
    ) as final_sale_price,
    discount as discount,
    (NPRICE * NQUANTITY) * cast(NRETTAX as double) as taxes,
    (NPRICE * NQUANTITY) as saleprice,
    NULL as campaign_id,
    NULL as discount_id,
    NULL as custom_discount_id,
    NULL as custom_discount_type,
    ILOGINID as closed_by_id,
    ILOGINID as created_by_id,
    ILOGINID as modified_by_id,
    th.TLASTUPDATE as updated_at,
    th.TLASTUPDATE as invoice_timestamp,
    cast(TDATETIME as date) as invoice_date,
    TDATETIME as sales_timestamp,
    cast(TDATETIME as date) as sales_date,
    ILOGINID as applied_by_id,
    cast(TDATETIME as date) as created_date_in_center,
    TDATETIME as created_timestamp_in_center,
    TDATETIME as campaign_usage_timestamp_in_center,
    cast(TDATETIME as date) as campaign_usage_date_in_center,
    TDATETIME as closed_timestamp_in_center,
    cast(TDATETIME as date) as closed_date_in_center,
    TDATETIME as last_updated_timestamp_in_center,
    cast(TDATETIME as date) as last_updated_date_in_center,

    LVOID as void,

    (NPRICE * NQUANTITY) as net_amount
  FROM
    Millennium_transactionheader th
    INNER JOIN Millennium_TRANSACTIONS t ON t.IHEADERID = th.IID
    AND th.ILOCATIONID = t.ILOCATIONID
    LEFT OUTER JOIN (
      select
        IHEADERID,
        ILOCATIONID,
        NLINENO,
        sum(NDISCAMOUNT) as discount
      from
        Millennium_transactiondiscounts
      group by
        IHEADERID,
        ILOCATIONID,
        NLINENO
    ) td on td.IHEADERID = t.IHEADERID
    and td.ILOCATIONID = t.ILOCATIONID
    and td.NLINENO = t.NLINENO
    LEFT OUTER JOIN Millennium_TaxRates tr on t.ilocationid = tr.ilocationid
    and th.TDATETIME >= tr.ttaxstart
    AND (
      th.TDATETIME <= tr.ttaxend
      OR tr.ttaxend is null
    )
  WHERE
    cast(t.IpackageID as int) = 0
    AND t.CTRANSTYPE = 'P'
)
  
  SELECT DISTINCT
Count(product_id) As ProductCount
-- ,closed_date_in_center
,round(SUM(net_amount),2) As TotalNetAmount
,year(sales_timestamp) as sales_year
FROM Products
--WHERE closed_date_in_center >= cast('2010-01-01 00:00:00' as timestamp) AND closed_date_in_center<= Cast('2020-12-31 11:59:00' as timestamp)
WHERE year(sales_timestamp) IN (
   2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020
)
group by year(sales_timestamp)
order by year(sales_timestamp)



--Millennium
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
;WITH  Products as (
  SELECT
    t.iid as product_event_id,
    1 as source_id,
    null as zenoti_invoiceitemid,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    ILOGINID as employee_id,
    IPRDSRVID as service_id,
    IPRDSRVID as product_id,
    IPRDSRVID as item_id,
    NULL as item_type_id,
    th.iid as invoice_id,
    t.iid as invoice_item_id,
    th.CINVOICENO as invoice_num,
    th.IPKID as invoice_pk,
    NQUANTITY as quantity,
    NULL as invoicesource,
    round(
      (NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as Decimal(10,2)),
      2
    ) as final_sale_price,
    discount as discount,
    (NPRICE * NQUANTITY) * cast(NRETTAX as Decimal(10,2)) as taxes,
    (NPRICE * NQUANTITY) as saleprice,
    NULL as custom_discount_id,
    NULL as custom_discount_type,
    ILOGINID as closed_by_id,
    ILOGINID as created_by_id,
    ILOGINID as modified_by_id,
    th.TLASTUPDATE as updated_at,
    th.TLASTUPDATE as invoice_timestamp,
    cast(TDATETIME as date) as invoice_date,
    TDATETIME as sales_timestamp,
    cast(TDATETIME as date) as sales_date,
    ILOGINID as applied_by_id,
    NULL as items_bought_previously,
    cast(TDATETIME as date) as created_date_in_center,
    TDATETIME as created_timestamp_in_center,
    TDATETIME as campaign_usage_timestamp_in_center,
    cast(TDATETIME as date) as campaign_usage_date_in_center,
    TDATETIME as closed_timestamp_in_center,
    cast(TDATETIME as date) as closed_date_in_center,
    TDATETIME as last_updated_timestamp_in_center,
    cast(TDATETIME as date) as last_updated_date_in_center,
     LVOID as void,
    (NPRICE * NQUANTITY) as net_amount
  FROM
    millenniumco.dbo.transhead th
    INNER JOIN millenniumco.dbo.[transaction] t ON t.IHEADERID = th.IID
    AND th.ILOCATIONID = t.ILOCATIONID
    LEFT OUTER JOIN (
      select
        IHEADERID,
        ILOCATIONID,
        NLINENO,
        sum(NDISCAMOUNT) as discount
      from
        millenniumco.dbo.trandisc
      group by
        IHEADERID,
        ILOCATIONID,
        NLINENO
    ) td on td.IHEADERID = t.IHEADERID
    and td.ILOCATIONID = t.ILOCATIONID
    and td.NLINENO = t.NLINENO
    LEFT OUTER JOIN millenniumco.dbo.taxrates tr on t.ilocationid = tr.ilocationid
    and th.TDATETIME >= tr.ttaxstart
    AND (
      th.TDATETIME <= tr.ttaxend
      OR tr.ttaxend is null
    )
  WHERE
    cast(t.IpackageID as int) = 0
    AND t.CTRANSTYPE = 'P'

)
SELECT DISTINCT
          Count(product_id) ProductCount
  ,SUM(saleprice) TotalSales
         ,DATEPART(YEAR,closed_date_in_center) As Year
         --,DATEPART(QUARTER,closed_date_in_center) As Quarter
  FROM Products
  WHERE DATEPART(YEAR,closed_date_in_center) IN(
 2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020)
  GROUP BY DATEPART(YEAR,closed_date_in_center)
  ORDER BY DATEPART(YEAR,closed_date_in_center) 

 ----------------------Final_Sale_Price------Scenario#6---------------- 
 --Amperity
 with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
null as zenoti_invoiceitemid,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
NULL as item_type_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
NULL as invoicesource,
round(
(NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as double),
2
) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as double) as taxes,
(NPRICE * NQUANTITY) as saleprice,

ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,

(NPRICE * NQUANTITY) as net_amount
FROM
Millennium_transactionheader th
INNER JOIN Millennium_TRANSACTIONS t ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from
Millennium_transactiondiscounts
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN Millennium_TaxRates tr on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P'
)
SELECT DISTINCT
--Count(product_id) As ProductCount
-- ,closed_date_in_center
SUM(final_sale_price) As Final_Sale_Price
,year(sales_timestamp) as sales_year
FROM Products
WHERE year(sales_timestamp) IN(2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020)
group by year(sales_timestamp)
order by year(sales_timestamp)
 
 
 --Millennium
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
null as zenoti_invoiceitemid,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
NULL as item_type_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
NULL as invoicesource,
round(
(NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as DECIMAL(10,2)),
2
) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as DECIMAL(10,2)) as taxes,
(NPRICE * NQUANTITY) as saleprice,
ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,
(NPRICE * NQUANTITY) as net_amount
FROM
millenniumco.dbo.transhead th
INNER JOIN millenniumco.dbo.[transaction] t ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from
millenniumco.dbo.trandisc
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN millenniumco.dbo.taxrates tr on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P'
)
SELECT DISTINCT
--Count(product_id) As ProductCount
-- ,closed_date_in_center
SUM(final_sale_price) As Final_Sale_Price
,year(sales_timestamp) as sales_year
FROM Products
--WHERE closed_date_in_center >= cast('2010-01-01 00:00:00' as timestamp) AND closed_date_in_center<= Cast('2020-12-31 11:59:00' as timestamp)
WHERE year(sales_timestamp) IN (2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020)
group by year(sales_timestamp)
order by year(sales_timestamp)

 
 
 ----------------------Validate total taxes------Scenario#7---------------- 
 
 --Amperity
 with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
null as zenoti_invoiceitemid,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
NULL as item_type_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
NULL as invoicesource,
round(
(NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as double),
2
) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as double) as taxes,
(NPRICE * NQUANTITY) as saleprice,

ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,

(NPRICE * NQUANTITY) as net_amount
FROM
Millennium_transactionheader th
INNER JOIN Millennium_TRANSACTIONS t ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from
Millennium_transactiondiscounts
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN Millennium_TaxRates tr on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P'
)
SELECT DISTINCT
--Count(product_id) As ProductCount
-- ,closed_date_in_center
SUM(taxes) As TotalTaxes
,year(closed_date_in_center) as sales_year
FROM Products
--WHERE closed_date_in_center >= cast('2010-01-01 00:00:00' as timestamp) AND closed_date_in_center<= Cast('2020-12-31 11:59:00' as timestamp)
WHERE year(sales_timestamp) IN(2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020)
group by year(sales_timestamp)
order by year(sales_timestamp)

 
 --Millennium
 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
null as zenoti_invoiceitemid,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
NULL as item_type_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
NULL as invoicesource,
round(
(NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as DECIMAL(10,2)),
2
) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as DECIMAL(10,2)) as taxes,
(NPRICE * NQUANTITY) as saleprice,
ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,
(NPRICE * NQUANTITY) as net_amount
FROM
millenniumco.dbo.transhead th
INNER JOIN millenniumco.dbo.[transaction] t ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from
millenniumco.dbo.trandisc
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN millenniumco.dbo.taxrates tr on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P'
)
SELECT DISTINCT
--Count(product_id) As ProductCount
-- ,closed_date_in_center
SUM(taxes) As TotalTaxes
,year(sales_timestamp) as sales_year
FROM Products
--WHERE closed_date_in_center >= cast('2010-01-01 00:00:00' as timestamp) AND closed_date_in_center<= Cast('2020-12-31 11:59:00' as timestamp)
WHERE year(sales_timestamp) IN (2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020)
group by year(sales_timestamp)
order by year(sales_timestamp)

--------------Validate Number of unique package purchasers ---Scenario#8----------------

--Amperity
with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
null as zenoti_invoiceitemid,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
NULL as item_type_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
NULL as invoicesource,
round(
(NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as double),
2
) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as double) as taxes,
(NPRICE * NQUANTITY) as saleprice,

ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,

(NPRICE * NQUANTITY) as net_amount
FROM
Millennium_transactionheader th
INNER JOIN Millennium_TRANSACTIONS t ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from
Millennium_transactiondiscounts
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN Millennium_TaxRates tr on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P'
)
select year(sales_timestamp) as sales_year,count(distinct concat(user_id, center_id)) as total_unique_product_purchasers
from Products
where closed_date_in_center >= cast('2010-01-01 00:00:00' as timestamp) AND closed_date_in_center<= Cast('2020-12-31 11:59:00' as timestamp)

group by year(sales_timestamp)

order by year(sales_timestamp)



--Millennium
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
null as zenoti_invoiceitemid,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
NULL as item_type_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
NULL as invoicesource,
round(
(NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as DECIMAL(10,2)),
2
) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as DECIMAL(10,2)) as taxes,
(NPRICE * NQUANTITY) as saleprice,
ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,
(NPRICE * NQUANTITY) as net_amount
FROM
millenniumco.dbo.transhead th
INNER JOIN millenniumco.dbo.[transaction] t ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from
millenniumco.dbo.trandisc
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN millenniumco.dbo.taxrates tr on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P'
)

select year(sales_timestamp) as sales_year,
count(distinct concat(user_id, center_id)) as total_unique_product_purchasers
from Products
WHERE Year(closed_date_in_center) >= 2010 AND Year(closed_date_in_center) <=2020
group by year(sales_timestamp)
order by year(sales_timestamp)
 
 
--------------Validate Product Sales for 39 Center IDs---Scenario#9---------------- 
                                   
--Amperity --GET TOTAL ROWS
WITH milCentersMap AS (
  SELECT DISTINCT
      ilocationId AS Mil_Id
      , cstorename
      , TRIM(REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')) AS Ewc_CenterId -- format is 0000
  FROM Millennium_Locations
  WHERE ilocationid NOT IN ('1' /*Central Office*/, '47' /*Gest Services*/, '239' /*Online Services*/, '312' /*TIER 1 Base Setup*/, '336' /*TIER 2 Base Setup*/, '493' /*Base Center Setup*/)
)
SELECT
ep.*
FROM Events_Retail ep
 JOIN milCentersMap mcp
    ON mcp.Mil_Id = ep.center_id
       AND ep.SOURCE_ID = 1
       WHERE mcp.Ewc_CenterId in ('0660','0678','0685','0801','0866','0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181','0182','0257','0350','0447','0524')
AND CAST(ep.sales_date AS DATE) BETWEEN cast('2019-01-01' as date) AND cast('2019-06-30' as date)
order by ep.SOURCE_ID asc

--Millennium   --GET TOTAL ROWS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
round((NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as DECIMAL(10,2)),2) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as DECIMAL(10,2)) as taxes,
(NPRICE * NQUANTITY) as saleprice,
ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,
(NPRICE * NQUANTITY) as net_amount,
ML.Ewc_CenterId
FROM
millenniumco.dbo.transhead th
INNER JOIN millenniumco.dbo.[transaction] t 
ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from millenniumco.dbo.trandisc
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN millenniumco.dbo.taxrates tr 
on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
  left outer join 
  (SELECT
      ilocationId AS Mil_Id
      , cstorename
      , REPLACE(RIGHT(LTRIM(RTRIM(cstorename)),5),')','') as Ewc_CenterId -- format is 0000
  FROM millenniumco.dbo.locations
  WHERE ilocationid NOT IN ('1' /*Central Office*/, '47' /*Gest Services*/, '239' /*Online Services*/, '312' /*TIER 1 Base Setup*/, '336' /*TIER 2 Base Setup*/, '493' /*Base Center Setup*/))ml
  on ml.Mil_Id = t.ILOCATIONID
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P' and ml.Ewc_CenterId in ('0660','0678','0685','0801','0866','0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181','0182','0257','0350','0447','0524')
)

select
*
from Products

where CAST(closed_date_in_center AS DATE) BETWEEN cast('2019-01-01' as date) AND cast('2019-06-30' as date)

--------------Validate Product Sales for 3 Center IDs---Scenario#9---------------- 
--Run Query in Millenium for Period 01/01/2019 to 06/30/2019 Validate Service Sales  for the 3 center_id's 
--Amperity

WITH milCentersMap AS (
  SELECT
      ilocationId AS Mil_Id
      , cstorename
      , TRIM(REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')) AS Ewc_CenterId -- format is 0000
  FROM Millennium_Locations
  WHERE ilocationid NOT IN ('1' /*Central Office*/, '47' /*Gest Services*/, '239' /*Online Services*/, '312' /*TIER 1 Base Setup*/, '336' /*TIER 2 Base Setup*/, '493' /*Base Center Setup*/)
)
SELECT sum(ep.final_sale_price), mcp.Ewc_CenterId
--ep.*
FROM Events_retail ep
 JOIN milCentersMap mcp
    ON mcp.Mil_Id = ep.center_id
       AND ep.SOURCE_ID = 1
       WHERE mcp.Ewc_CenterId in ('0678', '0660','0685')
And CAST(ep.sales_date AS DATE) BETWEEN cast('2019-01-01' as date) AND cast('2019-06-30' as date)
group by ep.SOURCE_ID, mcp.Ewc_CenterId
--order by ep.SOURCE_ID asc



--Millenniumco
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
round((NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as DECIMAL(10,2)),2) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as DECIMAL(10,2)) as taxes,
(NPRICE * NQUANTITY) as saleprice,
ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,
(NPRICE * NQUANTITY) as net_amount,
ML.Ewc_CenterId
FROM
millenniumco.dbo.transhead th
INNER JOIN millenniumco.dbo.[transaction] t 
ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from millenniumco.dbo.trandisc
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN millenniumco.dbo.taxrates tr 
on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
  left outer join 
  (SELECT
      ilocationId AS Mil_Id
      , cstorename
      , REPLACE(RIGHT(LTRIM(RTRIM(cstorename)),5),')','') as Ewc_CenterId -- format is 0000
  FROM millenniumco.dbo.locations
  WHERE ilocationid NOT IN ('1' /*Central Office*/, '47' /*Gest Services*/, '239' /*Online Services*/, '312' /*TIER 1 Base Setup*/, '336' /*TIER 2 Base Setup*/, '493' /*Base Center Setup*/))ml
  on ml.Mil_Id = t.ILOCATIONID
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P' and ml.Ewc_CenterId in ('0678', '0660','0685')
)

select
sum(final_sale_price), Ewc_CenterId
from Products
where CAST(closed_date_in_center AS DATE) BETWEEN cast('2019-01-01' as date) AND cast('2019-06-30' as date)
GROUP BY Ewc_CenterId


--------------Validate Product Sales for 39 Center IDs -Zenoti to Amperity--Scenario#10---------------- 

--Amperity Get count
with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
round(
(NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as DECIMAL(10,2)),
2
) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as DECIMAL(10,2)) as taxes,
(NPRICE * NQUANTITY) as saleprice,
ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,
(NPRICE * NQUANTITY) as net_amount
FROM
Millennium_transactionheader th
INNER JOIN Millennium_TRANSACTIONS t ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from
Millennium_transactiondiscounts
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN Millennium_TaxRates tr on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
  left outer join 
  (SELECT
      ilocationId AS Mil_Id
      , cstorename
      , TRIM(REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')) AS Ewc_CenterId -- format is 0000
  FROM Millennium_Locations
  WHERE ilocationid NOT IN ('1' /*Central Office*/, '47' /*Gest Services*/, '239' /*Online Services*/, '312' /*TIER 1 Base Setup*/, '336' /*TIER 2 Base Setup*/, '493' /*Base Center Setup*/))ml
  on ml.Mil_Id = t.ILOCATIONID
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P' and ml.Ewc_CenterId in ('0660','0678','0685','0801','0866','0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181','0182','0257','0350','0447','0524')
)

select
 count(*) as Count
from Products

where CAST(closed_date_in_center AS DATE) BETWEEN cast('2020-08-01' as date) AND cast('2020-09-27' as date)





 --Amperity
 SELECT
--sum(cast(es.final_sale_price as decimal(10,2))) as FinalSalePrice
sum(cast(es.Saleprice as decimal(15,2))) as saleprice 
,sum(cast(es.refund_amount as decimal(15,2))) as refundAmount
,round(sum(es.taxes),2) as Taxes, zc.centercode
FROM Events_retail es
LEFT JOIN Zenoti_bidimcenter zc
    ON zc.centerwid = es.center_id
        AND es.SOURCE_ID = 1
    WHERE zc.centercode in ('0678','0660','0685')
    AND CAST(es.sales_date AS DATE) BETWEEN cast('2020-09-28' as date) AND cast('2020-10-31' as date)
group by zc.centercode


 --Zenoti
 with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
round(
(NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as DECIMAL(10,2)),
2
) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as DECIMAL(10,2)) as taxes,
(NPRICE * NQUANTITY) as saleprice,
ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,
(NPRICE * NQUANTITY) as net_amount
FROM
Millennium_transactionheader th
INNER JOIN Millennium_TRANSACTIONS t ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from
Millennium_transactiondiscounts
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN Millennium_TaxRates tr on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
  left outer join 
  (SELECT
      ilocationId AS Mil_Id
      , cstorename
      , TRIM(REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')) AS Ewc_CenterId -- format is 0000
  FROM Millennium_Locations
  WHERE ilocationid NOT IN ('1' /*Central Office*/, '47' /*Gest Services*/, '239' /*Online Services*/, '312' /*TIER 1 Base Setup*/, '336' /*TIER 2 Base Setup*/, '493' /*Base Center Setup*/))ml
  on ml.Mil_Id = t.ILOCATIONID
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P' and ml.Ewc_CenterId in ('0660','0678','0685','0801','0866','0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181','0182','0257','0350','0447','0524')
)

select
 count(*) as Count
from Products

where CAST(closed_date_in_center AS DATE) BETWEEN cast('2020-08-01' as date) AND cast('2020-09-27' as date)

--Millennium Amperity
with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
round(
(NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as DECIMAL(10,2)),
2
) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as DECIMAL(10,2)) as taxes,
(NPRICE * NQUANTITY) as saleprice,
ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,
(NPRICE * NQUANTITY) as net_amount
FROM
Millennium_transactionheader th
INNER JOIN Millennium_TRANSACTIONS t ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from
Millennium_transactiondiscounts
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN Millennium_TaxRates tr on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P'
)
SELECT
SUM(final_sale_price) As SumFinalSalePrice
,Center_id
FROM Products
WHERE Center_Id IN (SELECT DISTINCT
ilocationid
FROM Millennium_Locations
WHERE ilocationid NOT IN ('1' /*Central Office*/, '47' /*Gest Services*/, '239' /*Online Services*/, '312' /*TIER 1 Base Setup*/, '336' /*TIER 2 Base Setup*/, '493' /*Base Center Setup*/)
AND TRIM(REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', ''))IN('0678', '0660','0685')
)

And CAST(closed_date_in_center AS DATE) --BETWEEN cast('2019-01-01' as date) AND cast('2019-06-30' as date)
between cast('2020-08-01' as date) AND Cast('2020-09-27' as date)
GROUP BY center_Id

--millennium
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
with Products as (
SELECT
t.iid as product_event_id,
1 as source_id,
th.ilocationid as center_id,
th.iclientid as user_id,
ILOGINID as employee_id,
IPRDSRVID as service_id,
IPRDSRVID as product_id,
IPRDSRVID as item_id,
th.iid as invoice_id,
t.iid as invoice_item_id,
th.CINVOICENO as invoice_num,
th.IPKID as invoice_pk,
NQUANTITY as quantity,
round((NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as DECIMAL(10,2)),2) as final_sale_price,
discount as discount,
(NPRICE * NQUANTITY) * cast(NRETTAX as DECIMAL(10,2)) as taxes,
(NPRICE * NQUANTITY) as saleprice,
ILOGINID as closed_by_id,
ILOGINID as created_by_id,
ILOGINID as modified_by_id,
th.TLASTUPDATE as updated_at,
th.TLASTUPDATE as invoice_timestamp,
cast(TDATETIME as date) as invoice_date,
TDATETIME as sales_timestamp,
cast(TDATETIME as date) as sales_date,
ILOGINID as applied_by_id,
cast(TDATETIME as date) as created_date_in_center,
TDATETIME as created_timestamp_in_center,
TDATETIME as campaign_usage_timestamp_in_center,
cast(TDATETIME as date) as campaign_usage_date_in_center,
TDATETIME as closed_timestamp_in_center,
cast(TDATETIME as date) as closed_date_in_center,
TDATETIME as last_updated_timestamp_in_center,
cast(TDATETIME as date) as last_updated_date_in_center,
LVOID as void,
(NPRICE * NQUANTITY) as net_amount,
ML.Ewc_CenterId
FROM
millenniumco.dbo.transhead th
INNER JOIN millenniumco.dbo.[transaction] t 
ON t.IHEADERID = th.IID
AND th.ILOCATIONID = t.ILOCATIONID
LEFT OUTER JOIN (
select
IHEADERID,
ILOCATIONID,
NLINENO,
sum(NDISCAMOUNT) as discount
from millenniumco.dbo.trandisc
group by
IHEADERID,
ILOCATIONID,
NLINENO
) td on td.IHEADERID = t.IHEADERID
and td.ILOCATIONID = t.ILOCATIONID
and td.NLINENO = t.NLINENO
LEFT OUTER JOIN millenniumco.dbo.taxrates tr 
on t.ilocationid = tr.ilocationid
and th.TDATETIME >= tr.ttaxstart
AND (
th.TDATETIME <= tr.ttaxend
OR tr.ttaxend is null
)
left outer join (
SELECT
      ilocationId AS Mil_Id
      , cstorename
	  ,REPLACE(RIGHT(LTRIM(RTRIM(cstorename)),5),')','') as Ewc_CenterId
  FROM millenniumco.dbo.locations
  WHERE ilocationid NOT IN ('1' /*Central Office*/, '47' /*Gest Services*/, '239' /*Online Services*/, 
  '312' /*TIER 1 Base Setup*/, '336' /*TIER 2 Base Setup*/, '493' /*Base Center Setup*/)
  ) ml on ml.Mil_Id = th.ILOCATIONID
WHERE
cast(t.IpackageID as int) = 0
AND t.CTRANSTYPE = 'P' and ml.Ewc_CenterId in ('0678', '0660','0685')
--('0660','0678','0685','0801','0866','0928','0946','0067','0085','0140','0155',
--'0156','0169','0172','0180','0181','0182','0257','0350','0447','0524')
)
select round(sum(final_sale_price),2) as FinalSalesPrice, 
round(sum(saleprice),2) as SalePrice,
Ewc_CenterId
from Products
where cast(closed_date_in_center  as date)
between cast('2020-08-01' as date) AND  Cast('2020-09-27' as date)
GROUP BY Ewc_CenterId
order by Ewc_CenterId

 
 
 
--------Re-Testing Event Product -Senerio#3--------
--WHERE closed_date_in_center >= cast('2021-01-01 00:00:00' as timestamp) AND closed_date_in_center<= Cast('2021-03-31 11:59:00' as timestamp)  Quarter

--Senerio #3  Amperity
SELECT 
      
      SUM(net_amount) TotalSales
     ,YEAR(closed_date_in_center) As Sales_year
FROM Events_Retail 
WHERE closed_date_in_center >= cast('2021-01-01 00:00:00' as timestamp) AND closed_date_in_center<= Cast('2021-03-31 11:59:00' as timestamp) 
AND Source_id = 1
GROUP BY YEAR(closed_date_in_center)   --Q1-2021 8658106.060999835


--Senerio #3  Zenoti
WITH Product As (
  select
    factinvoiceitemwid as product_event_id,
    2 as source_id,
    factinvoiceitemid as zenoti_invoiceitemid,
    centerwid as center_id,
    productwid as product_id,
    itemwid as item_id,
    itemtypewid as item_type_id,
    invoiceid as invoice_id,
    invoiceitemid as invoice_item_id,
    invoice_no as invoice_num,
    invoiceitempk as invoice_pk,
    invoicesource as invoicesource,
    cast(finalsaleprice as decimal(38, 5)) as final_sale_price,
    cast(discount as decimal(38, 5)) as discount,
    cast(taxes as decimal(38, 5)) as taxes,
    cast(saleprice as decimal(38, 5)) as saleprice,
    createdbywid as created_by_id,
    modifiedbywid as modified_by_id,
    podid as podid,
    etlcreatedby as updated_by,
    etlcreateddate as updated_at,
    invoicedatetimeincenter as invoice_timestamp,
    invoicedateincenter as invoice_date,
    saledatetimeincenter as sales_timestamp,
    saledateincenter as sales_date,
   
    (
      cast(finalsaleprice as decimal(38, 5)) - (
        case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(gcrevenue as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(PREPAIDCARDPAYMENT as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(LPPAYMENT as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(
            considerforfinancialzero_discount as decimal(38, 5)
          )
        end + cast(taxes as decimal(38, 5))
      )
    ) as net_amount
  from
     public.bi_factinvoiceitem bi
  where
    itemtypewid = '40'
    and packageversionwid = '79'
    and invoiceitempk is not null
    and (
      (
        NOT (
          UPPER(bi.INVOICE_NO) LIKE ('II%')
          OR UPPER(bi.INVOICE_NO) LIKE ('IIR%')
        )
        OR (
          UPPER(bi.INVOICE_NO) LIKE ('IIIGN%')
          OR UPPER(bi.INVOICE_NO) LIKE ('IRIGN%')
        )
      )
    )
    )
    
  SELECT DISTINCT
          Count(1)
         ,DATEPART(YEAR,sales_date) As Year
         ,DATEPART(QUARTER,sales_date) As Quarter
         ,SUM(CAST(net_amount as Decimal(10,2))) As TotalNetAmount
  FROM Product
  GROUP BY DATEPART(YEAR,sales_date),DATEPART(QUARTER,sales_date)
  ORDER BY 1,2,3
  
----------------Re-Testing Event Product-------------

--Senerio #11  Amperity
WITH Events_Products As 
(SELECT * FROM Events_Retail
)
SELECT
--sum(cast(es.final_sale_price as decimal(10,2))) as FinalSalePrice
sum(cast(es.Saleprice as decimal(15,2))) as saleprice 
,sum(cast(es.refund_amount as decimal(15,2))) as refundAmount
,round(sum(es.taxes),2) as Taxes, zc.centercode
FROM Events_Products es
LEFT JOIN Zenoti_bidimcenter zc
    ON zc.centerwid = es.center_id
        AND es.SOURCE_ID = 2
    WHERE zc.centercode in ('0678','0660','0685')
    AND CAST(es.sales_date AS DATE) BETWEEN cast('2020-09-28' as date) AND cast('2020-10-31' as date)
group by zc.centercode

--------------------------------------------------------
--Senerio #11  Zenoti
with products as (
  select
    factinvoiceitemwid as product_event_id,
    2 as source_id,
    factinvoiceitemid as zenoti_invoiceitemid,
    centerwid as center_id,
    userwid as user_id,
    salebywid as employee_id,
    servicewid as service_id,
    productwid as product_id,
    itemwid as item_id,
    itemtypewid as item_type_id,
    invoiceid as invoice_id,
    invoiceitemid as invoice_item_id,
    invoice_no as invoice_num,
    invoiceitempk as invoice_pk,
    cast(quantity as decimal(38, 5)) as quantity,
    invoicesource as invoicesource,
    cast(finalsaleprice as decimal(38, 5)) as final_sale_price,
    cast(discount as decimal(38, 5)) as discount,
    cast(taxes as decimal(38, 5)) as taxes,
    cast(saleprice as decimal(38, 5)) as saleprice,
    campaignwid as campaign_id,
    discountwid as discount_id,
    customdiscountid as custom_discount_id,
    customdiscounttype as custom_discount_type,
    closebywid as closed_by_id,
    createdbywid as created_by_id,
    modifiedbywid as modified_by_id,
    podid as podid,
    etlcreatedby as updated_by,
    etlcreateddate as updated_at,
    invoicedatetimeincenter as invoice_timestamp,
    invoicedateincenter as invoice_date,
    saledatetimeincenter as sales_timestamp,
    saledateincenter as sales_date,
    appliedbywid as applied_by_id,
    considerforfinancialzero_discount as consider_for_financial,
    groupinvoiceid as group_invoice_id,
    groupinvoiceorder as group_invoice_order,
    isrecurringinvoicewid as is_recurring_invoice_id,
    membershipsold as membership_sold,
    membergueststatuswid as member_guest_status_id,
    firstgueststatus as first_guest_status,
    cancelornoshowstatus as cancle_or_no_show_status,
    appointmentpk as appointment_pk,
    invoicestatus as invoice_status,
    ismembershipdiscountedtwid as is_membership_discounted_wid,
    isupgrademembershipwid as is_upgraded_membership_id,
    isdowngrademembershipwid as is_downgrade_membership_id,
    membershipuserid as membership_user_id,
    itemsboughtpreviously as items_bought_previously,
    createdateincenter as created_date_in_center,
    createdatetimeincenter as created_timestamp_in_center,
    campaignusagedatetimeincenter as campaign_usage_timestamp_in_center,
    campaignusagedateincenter as campaign_usage_date_in_center,
    closeddatetimeincenter as closed_timestamp_in_center,
    closeddateincenter as closed_date_in_center,
    lastupdateddatetimeincenter as last_updated_timestamp_in_center,
    lastupdateddateincenter as last_updated_date_in_center,
    ispaymentreceivedwid as is_payment_received_wid,
    gc_ppcsold as gc_ppcsold,
    cash as cash,
    custom as custom,
    cheque as cheque,
    card as card,
    lppayment as lppayment,
    membershippayment as membership_payment,
    membershiprevenue as membership_revenue,
    membershipredemptionrevenue as membership_recemption_revenue,
    membershipbenefitredemptionrevenue as membership_benefit_redemption_revenue,
    gcpayment as gc_payment,
    gcrevenue as gc_revenue,
    gcredemptionrevenue as gc_redemption_revenue,
    prepaidcardpayment as prepaid_card_payment,
    prepaidcardrevenue as prepaid_card_revenue,
    packageredemptionrevenue as package_redemption_revenue,
    custompaymentname as custom_payment_name,
    paidbycardsname as paid_by_cards_name,
    membershipirr as membership_iir,
    packageirr as package_iir,
    switchfromusermembershipid as switch_from_user_membership_id,
    isrefundedwid as is_refunded_wid,
    refunddateincenter as refunded_date_in_center,
    refunddatetimeincenter as refunded_timestamp_in_center,
    itemsboughttogether as items_bought_together,
    isrebookwid as is_rebooked_id,
    cast(void as boolean) as void,
    soldbys_csv as soldby_csv,
    resourcewid as resource_id,
    equipmentwid as equipment_id,
    therapistwid as therapist_id,
    therapistrequesttype_statuswid as therapist_request_type_status_id,
    previoussaledate as previous_sale_date,
    nextsaledate as next_sale_date,
    loyaltytierwid as loyalty_tier_id,
    appstatuswid as app_status_id,
    isinvalidinvoice as is_invalid_invoice,
    comments as comments,
    multiplesoldby as multiple_sold_by,
    isappointmentrescheduled as is_appointment_rescheduled,
    actualappointmenttime as actual_appointment_time,
    actionperformeddatetimeincenter as action_performed_timestamp_center,
    rebookedappointmentcount as rebooked_appointment_count,
    isredo as is_redo,
    isredone as is_redone,
    redotherapistwid as redo_therapist_id,
    usagetype as usage_type,
    refundsourceinvoiceitemid as refund_source_invoice_item_id,
    refundamount as refund_amount,
    refundquantity as refund_quantity,
    ispriceadjusted as is_price_adjusted,
    originalsaleprice as orginal_sale_price,
    nextservicedate as next_service_date,
    lastservicedate as last_service_date,
    followup as follow_up,
    isupsell as is_upsell,
    saletax as sale_tax,
    discountwithtax as discount_with_tax,
    customdiscount as custom_discount,
    drr as drr,
    istaxexempted as is_tax_excempt,
    drrwithdiscountorordersetting as drr_with_discount_or_order_setting,
    refundtax as refund_tax,
    roundingadjustment as rounding_adjustment,
    restockquantity as restock_qauntity,
    (
      cast(finalsaleprice as decimal(38, 5)) - (
        case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(gcrevenue as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(PREPAIDCARDPAYMENT as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(LPPAYMENT as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(
            considerforfinancialzero_discount as decimal(38, 5)
          )
        end + cast(taxes as decimal(38, 5))
      )
    ) as net_amount
  from
    bi_factinvoiceitem bi
  where
    itemtypewid = '40'
    and packageversionwid = '79'
    and invoiceitempk is not null
    and (
      (
        NOT (
          UPPER(bi.INVOICE_NO) LIKE ('II%')
          OR UPPER(bi.INVOICE_NO) LIKE ('IIR%')
        )
        OR (
          UPPER(bi.INVOICE_NO) LIKE ('IIIGN%')
          OR UPPER(bi.INVOICE_NO) LIKE ('IRIGN%')
        )
      )
    )
)
SELECT 
sum(cast(Saleprice as decimal(15,2))) as saleprice 
,sum(cast(refund_amount as decimal(15,2))) as refundAmount
,round(sum(taxes),2) as Taxes, 
centercode
from Products
join public.bi_dimcenter bd on center_id =bd.centerwid
where sales_date >='09/28/2020'
AND sales_date <='10/31/2020'
and bd.centercode in ('0678','0660','0685')
group BY bd.centercode --,saleprice
order by bd.centercode
----------------------7-6-21------------
    WITH Events as (
  SELECT DISTINCT
    th.iid as product_event_id,
    1 as source_id,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    ILOGINID as employee_id,
    IPRDSRVID as service_id,
    IPRDSRVID as product_id,
    IPRDSRVID as item_id,
    th.iid as invoice_id,
    t.iid as invoice_item_id,
    th.CINVOICENO as invoice_num,
    th.IPKID as invoice_pk,
    NQUANTITY as quantity,
    (NPRICE * NQUANTITY) +(NPSTCOLLECTED) as final_sale_price,
    discount as discount,
    NPSTCOLLECTED as taxes,
    (NPRICE * NQUANTITY) as saleprice,
    ILOGINID as closed_by_id,
    ILOGINID as created_by_id,
    ILOGINID as modified_by_id,
    th.TLASTUPDATE as updated_at,
    th.TLASTUPDATE as invoice_timestamp,
    cast(TDATETIME as date) as invoice_date,
    TDATETIME as sales_timestamp,
    cast(TDATETIME as date) as sales_date,
    ILOGINID as applied_by_id,
    cast(TDATETIME as date) as created_date_in_center,
    TDATETIME as created_timestamp_in_center,
    TDATETIME as campaign_usage_timestamp_in_center,
    cast(TDATETIME as date) as campaign_usage_date_in_center,
    TDATETIME as closed_timestamp_in_center,
    cast(TDATETIME as date) as closed_date_in_center,
    TDATETIME as last_updated_timestamp_in_center,
    cast(TDATETIME as date) as last_updated_date_in_center,
    LVOID as void,
    (NPRICE * NQUANTITY) as net_amount
    FROM
    millenniumco.dbo.transhead th
    INNER JOIN millenniumco.dbo.[transaction] t ON t.IHEADERID = th.IID
    AND th.ILOCATIONID = t.ILOCATIONID
    LEFT OUTER JOIN (
      select
        IHEADERID,
        ILOCATIONID,
        NLINENO,
        sum(NDISCAMOUNT) as discount
      from
       millenniumco.dbo.trandisc
      group by
        IHEADERID,
        ILOCATIONID,
        NLINENO
    ) td on td.IHEADERID = t.IHEADERID
    and td.ILOCATIONID = t.ILOCATIONID
    and td.NLINENO = t.NLINENO
  WHERE
    t.IpackageID = '0'
    AND t.CTRANSTYPE = 'P'
    AND (CDISCOUNT != '' OR CDISCOUNT IS NOT NULL)
)
SELECT
      COUNT(product_event_id) TOTALEvents
      ,Year(closed_date_in_center) As EventYear
FROM Events
GROUP BY Year(closed_date_in_center)


----------------------------------------
SELECT 
        Product_event_id
       ,ROUND(SUM(net_amount),2)As TotalNetAmount
      ,YEAR(closed_date_in_center) As EventYear
FROM Events_Retail 
WHERE closed_date_in_center >= cast('2020-01-01 00:00:00' as timestamp) AND closed_date_in_center<= Cast('2020-12-31 11:59:00' as timestamp)
AND Product_event_id ='193161'
GROUP BY Product_event_id,YEAR(closed_date_in_center) 

LIMIT 100
