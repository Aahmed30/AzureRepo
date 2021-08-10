Amperity (Zenoti) validate saleprice, taxes, discount, netamount and Quanity for all the 55 center ids
-----------------------------------------------------------

SELECT
--sum(cast(es.refund_amount as decimal(15,2))),mcp.Ewc_CenterId
--sum(cast(es.refund_amount as decimal(15,2))),zc.centercode
SUM(es.quantity) AS QUANTITY,zc.centercode,es.taxes,
--sum(es.saleprice)
SUM(net_amount) AS Net_amount,
--sum(es.ta)
sum(es.saleprice) as SP,sum(es.taxes) as Tax,mcp.Ewc_CenterId
--sum(cast(es.saleprice as decimal(15,2))) as ServiceSale, zc.centercode
 -- sum(cast(es.discount as decimal(15, 2))),
  --zc.centercode
FROM
  Events_Services es
 JOIN Zenoti_bidimcenter zc
 ON zc.centerwid = es.center_id
AND es.SOURCE_ID = 2
where
  zc.centercode in('0004', '0019', '0070', '0077', '0137', '0157', '0184', '0204', 
'0333', '0335', '0370', '0442', '0457', '0469', '0505', '0506',
 '0554', '0581', '0660', '0678', '0783', '0794', '0823', '0831', '0832', '0847', '0909', '0955'
    ,'0685','0801','0866',
'0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181',
'0182','0257','0350','0447','0524','0526','0636','0639','0644','0645','0684','0707','0708')
  AND CAST(es.closed_date_in_center AS DATE) BETWEEN CAST('2020-10-01' AS DATE)
  AND CAST('2020-10-31' AS DATE)
--GROUP BY
--  zc.centercode 

==========================================================================================================
Redshift (Zenoti) validate saleprice, taxes, discount, netamount and Quanity for all the 55 center ids
----------------------------------------------------------------------


  with Zenoti_Service_Item as (
SELECT     ii.invoiceId,
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
AND saledateincenter < '2021-04-01'
AND (usagetype <> 'PackageUsage' OR usagetype IS NULL)
ORDER BY InvoiceID        
)
SELECT    
--Closed_Year,
--        Closed_Month,
        --centercode,
        --cntrstatedispname,
        --refund,
        --COUNT(DISTINCT invoiceID) AS Transaction_Count,
        --COUNT(InvoiceItemID) AS Unit_Count,
        SUM(Quantity) AS Quantity_Sum,
        --closeddateincenter
        SUM(SalePrice) AS Total_List_Price
        SUM(discount) AS Total_Discount,
        SUM(saleprice-Discount) AS Net_amount,
        --taxes
        sum(taxes)as Tax
FROM Zenoti_Service_Item ii
inner join bi_dimcenter bd
on ii.centerwid=bd.centerwid
WHERE ii.isinvalidinvoice = 0
AND ii.void = 0
AND ii.itemtypecode = 'Service'
--AND centergolivedate>=saledateincenter
--and bd.cntrstatedispname in('Hawaii','Connecticut','New Mexico','Texas','Ohio',
--'Colorado','Maryland','New York','Virginia','New Jersey')
AND closeddateincenter::date between '2020-09-28' and '2020-10-31'
and bd.centercode in('0004', '0019', '0070', '0077', '0137', '0157', '0184', '0204', 
'0333', '0335', '0370', '0442', '0457', '0469', '0505', '0506',
 '0554', '0581', '0660', '0678', '0783', '0794', '0823', '0831', '0832', '0847', '0909', '0955'
    ,'0685','0801','0866',
'0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181',
'0182','0257','0350','0447','0524','0526','0636','0639','0644','0645','0684','0707','0708')
 --AND cast(taxes as decimal(15,2))>0
--GROUP BY cntrstatedispname,
--centercode,taxes
--Closed_Year
--        Closed_Month,
        --refund,centercode
        --order by centercode  

====================================================================================================================================================================================================================================
Amperity (Millennium) validate saleprice, taxes, discount, netamount and Quanity for all the 55 center ids
----------------------------------------------------------------------

WITH milCentersMap AS (
  SELECT
      ilocationId AS Mil_Id
      , cstorename
      , TRIM(REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')) AS Ewc_CenterId -- format is 0000
  FROM Millennium_Locations
  WHERE ilocationid NOT IN ('1' /*Central Office*/, '47' /*Gest Services*/, '239' /*Online Services*/, '312' /*TIER 1 Base Setup*/, '336' /*TIER 2 Base Setup*/, '493' /*Base Center Setup*/)
)
SELECT
--sum(cast(es.refund_amount as decimal(15,2))),mcp.Ewc_CenterId
--sum(cast(es.refund_amount as decimal(15,2))),zc.centercode
SUM(es.quantity) AS QUANTITY,zc.centercode,es.taxes,
sum(es.saleprice) as Saleprice,
SUM(salepriceDiscount) AS Net_amount,
SUM(discount) AS Total_Discount
--sum(es.ta)
--sum(es.saleprice) as SP,sum(es.taxes) as Tax,mcp.Ewc_CenterId
--sum(cast(es.saleprice as decimal(15,2))) as ServiceSale, zc.centercode
FROM Events_Services es

 

--JOIN Zenoti_bidimcenter zc
-- ON zc.centerwid = es.center_id
-- AND es.SOURCE_ID = 2
       
 --JOIN Events_Refunds er
 --on er.center_id= es.center_id
-- AND er.refund_product_Type = 'Service'
  --and es.SOURCE_ID = 2
  --AND es.SOURCE_ID = 1
   
   JOIN milCentersMap mcp
ON mcp.Mil_Id = es.center_id
AND es.SOURCE_ID = 1

 

--where mcp.Ewc_CenterId in('0660','0678','0685','0801','0866','0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181','0182','0257','0350','0447','0524','0526','0636','0639','0644','0645','0684','0707','0708')
       
where mcp.Ewc_CenterId in ('0004', '0019', '0070', '0077', '0137', '0157', '0184', '0204', 
'0333', '0335', '0370', '0442', '0457', '0469', '0505', '0506',
 '0554', '0581', '0660', '0678', '0783', '0794', '0823', '0831', '0832', '0847', '0909', '0955'
    ,'0685','0801','0866',
'0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181',
'0182','0257','0350','0447','0524','0526','0636','0639','0644','0645','0684','0707','0708')

 

--AND CAST(es.sales_date AS DATE) BETWEEN CAST('2020-10-01' AS DATE) AND CAST('2020-10-31' AS DATE)
--And CAST(es.closed_date_in_center AS DATE) BETWEEN CAST('2020-09-28' AS DATE) AND CAST('2020-10-31' AS DATE)
And CAST(es.closed_date_in_center AS DATE) BETWEEN CAST('2020-08-01' AS DATE) AND CAST('2020-09-27' AS DATE)
--AND CAST(es.closed_date_in_center AS DATE) BETWEEN CAST('2020-10-01' AS DATE) AND CAST('2020-10-31' AS DATE)
--And CAST(es.closed_date_in_center AS DATE) BETWEEN cast('2019-01-01' as date) AND cast('2019-06-30' as date)
--GROUP BY zc.centercode,es.invoice_status
--mcp.Ewc_CenterId
--order by zc.centercode
--mcp.Ewc_CenterId desc
--zc.centercode
--mcp.Ewc_CenterId  

==========================================================================================================================================================================================================================================================
MillenniumDB (Millennium) validate saleprice, taxes, discount, netamount and Quanity for all the 55 center ids
----------------------------------------------------------------------

With service_events as (
  SELECT
    t.iid as service_event_id,
    1 as source_id,
      NULL as zenoti_invoiceitemid,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    ILOGINID as employee_id,
    IPRDSRVID as service_id,
      NULL as product_id,
    IPRDSRVID as item_id,
      NULL as item_type_id,
    th.iid as invoice_id,
    t.iid as invoice_item_id,
    th.CINVOICENO as invoice_num,
    th.IPKID as invoice_pk,
    NQUANTITY as quantity,
      NULL as invoicesource,
    (NPRICE * NQUANTITY) + (
      NPRICE * NQUANTITY * (
        case
          when t.LTAXABLE = 'True' then cast(NSERVTAX as decimal(10,2))
          else 0.0
        end
      )
    ) as final_sale_price,
    case
      when discount is Null then 0
      else discount
    end as discount,
    -- the sale price already has the discount removed
    (NPRICE * NQUANTITY) * (
      case
        when t.LTAXABLE = 'True' then cast(NSERVTAX as decimal(10,2))
        else 0.0
      end
    ) as taxes,
    (NPRICE * NQUANTITY) as saleprice,
     
    ILOGINID as closed_by_id,
    ILOGINID as created_by_id,
    ILOGINID as modified_by_id,
      NULL as podid,
      NULL as updated_by,
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
     
    /* case
          when LVOID = False then 0
          else 1
        end as void,*/
    LVOID as void,
     
    (NPRICE * NQUANTITY) as net_amount,ml.Ewc_CenterId
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
    aND t.CTRANSTYPE = 'S'
    AND LVOID = 'False'
)
Select SUM(es.quantity) AS QUANTITY,--zc.centercode,es.taxes,
sum(es.saleprice) as Saleprice,
SUM(salepriceDiscount) AS Net_amount,
SUM(discount) AS Total_Discount
--sum(es.ta)
--sum(es.saleprice) as SP,sum(es.taxes) as Tax,mcp.Ewc_CenterId

from service_events
where Ewc_CenterId in('0004', '0019', '0070', '0077', '0137', '0157', '0184', '0204', 
'0333', '0335', '0370', '0442', '0457', '0469', '0505', '0506',
 '0554', '0581', '0660', '0678', '0783', '0794', '0823', '0831', '0832', '0847', '0909', '0955'
    ,'0685','0801','0866',
'0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181',
'0182','0257','0350','0447','0524','0526','0636','0639','0644','0645','0684','0707','0708')
AND CAST(closed_date_in_center AS DATE) BETWEEN CAST('2020-08-01' AS DATE) AND CAST('2020-09-27' AS DATE)
--AND CAST(sales_date AS DATE) BETWEEN CAST('2019-01-01' AS DATE) AND CAST('2019-06-30' AS DATE)
       --GROUP BY Ewc_CenterId
       --order BY Ewc_CenterId                                                                                                                     