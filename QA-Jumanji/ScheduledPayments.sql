----------------------------Product counts for a Period------------------------------
Amperity:
WITH Payments as (
SELECT
  pd.iid as scheduled_payment_id,
  1 as source_id,
  NULL as zenoti_scheduled_payment_id,
  NULL as scheduled_payment_pk,
  pd.ilocationid as center_id,
  th.iclientid as user_id,
  NEFTTYPE as scheduled_payment_type,
  case
    when NEFTTYPE = '1' then 'Credit Card'
    when NEFTTYPE = '2' then 'ACH'
    else 'Pending'
  end as scheduled_payment_option_type,
  YHITAMOUNT as collection_amount,
  DHITDATE as collection_date,
  case
    when pd.nstatus = '2' then YHITAMOUNT --collection_amount
    else '0'
  end as collected_amount,
  NULL as collected_timestamp,
  case
    when pd.nstatus = '2' then dhitdate
    else null
  end as collected_date,
  CINVOICENO as invoice_id,
  NULL as last_tried_on,
  NULL as next_try_on,
  th.TDATETIME as created_timestamp,
  th.TDATETIME as created_date,
  pd.nstatus as collection_status,
  case
    when NEFTTYPE = '1' then 'Credit Card'
    when NEFTTYPE = '2' then 'ACH'
    else 'Pending'
  end as collection_source,
  th.iloginid as updated_by,
  pd.TLASTMODIFIED as updated_at,
  cast(LVOID as boolean) as void,
  NULL as podid,
  NULL as customer_payment_name,
  NULL as consider_in_financials,
  1 as parent_source_id,
  pd.ilocationid as parent_source_center_id,
  CINVOICENO as parent_source_invoice_id,
  YHITAMOUNT as parent_source_collection_amount
FROM
  Millennium_TransactionHeader th
  INNER JOIN millennium_payplan pp on pp.iheaderid = th.iid
  and pp.ilocationid = th.ilocationid
  INNER JOIN millennium_payplandetail pd on pd.ipayPLANHEADERID = pp.iid
  and pp.ilocationid = pd.ilocationid
WHERE
  pd.iheaderid != '0'
 )
 
 SELECT 
 
      Center_id
      ,source_id
      ,collection_source
      ,SUM(CAST(collection_amount as Decimal(10,2))) As Total_Collecttion_Amount
 FROM Payments
 GROUP BY Center_id,source_id,collection_source
 ORDER bY Center_id, collection_source

MillenniumCo:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
;WITH Payments As (
SELECT DISTINCT
  pd.iid as scheduled_payment_id,
  1 as source_id,
  NULL as zenoti_scheduled_payment_id,
  NULL as scheduled_payment_pk,
  pd.ilocationid as center_id,
  th.iclientid as user_id,
  NEFTTYPE as scheduled_payment_type,
  case
    when NEFTTYPE = '1' then 'Credit Card'
    when NEFTTYPE = '2' then 'ACH'
    else 'Pending'
  end as scheduled_payment_option_type,
  YHITAMOUNT as collection_amount,
  DHITDATE as collection_date,
  case
    when pd.nstatus = '2' then YHITAMOUNT --collection_amount
    else '0'
  end as collected_amount,
  NULL as collected_timestamp,
  case
    when pd.nstatus = '2' then dhitdate
    else null
  end as collected_date,
  CINVOICENO as invoice_id,
  NULL as last_tried_on,
  NULL as next_try_on,
  th.TDATETIME as created_timestamp,
  th.TDATETIME as created_date,
  pd.nstatus as collection_status,
  case
    when NEFTTYPE = '1' then 'Credit Card'
    when NEFTTYPE = '2' then 'ACH'
    else 'Pending'
  end as collection_source,
  th.iloginid as updated_by,
  pd.TLASTMODIFIED as updated_at,
  LVOID  as void,
  NULL as podid,
  NULL as customer_payment_name,
  NULL as consider_in_financials,
  1 as parent_source_id,
  pd.ilocationid as parent_source_center_id,
  CINVOICENO as parent_source_invoice_id,
  YHITAMOUNT as parent_source_collection_amount
FROM [millenniumco].dbo.transhead th
  INNER JOIN [millenniumco].dbo.payplan pp
 ON pp.iheaderid = th.iid
  and pp.ilocationid = th.ilocationid
  INNER JOIN [millenniumco].dbo.payplandetail pd on pd.ipayPLANHEADERID = pp.iid
  and pp.ilocationid = pd.ilocationid
WHERE
  pd.iheaderid != '0'
  )
  SELECT 
                Center_id
,collection_source
,SUM(collection_amount) As collection_amount
FROM Payments
GROUP BY Center_id
        ,collection_source
ORDER BY Center_id

--------------------------------------CreditCard Payments(Amp Vs MillenniumCo)------------------------------------
Amperity:
WITH milCentersMap AS (
  SELECT
      ilocationId AS Mil_Id
      , cstorename
      , TRIM(REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')) AS Ewc_CenterId -- format is 0000
  FROM Millennium_Locations
  WHERE ilocationid NOT IN ('1' /*Central Office*/, '47' /*Gest Services*/, '239' /*Online Services*/, '312' /*TIER 1 Base Setup*/, '336' /*TIER 2 Base Setup*/, '493' /*Base Center Setup*/)
)
SELECT year(created_date) as Year,  ep.collection_source,
sum(cast(ep.collection_amount as decimal(10,2))) as Total_Collection_Amount--, mcp.Ewc_CenterId
FROM Events_scheduled_payments ep
 JOIN milCentersMap mcp
    ON mcp.Mil_Id = ep.center_id
       AND ep.SOURCE_ID = 1
       WHERE ep.created_date <= CAST('2021-03-31' AS DATE) 
       --mcp.Ewc_CenterId in ('0678', '0660','0685') and
 --CAST(ep.closed_datetime AS date) BETWEEN --cast('2019-01-01' as date) AND cast('2019-06-30' as date)
--cast('2020-08-01' as date) AND  Cast('2020-09-27' as date)
--and --ep.collection_source = 'Credit Card' and
--and mcp.Ewc_CenterId in ('0660','0678','0685','0801','0866','0928','0946','0067','0085','0140','0155','0156','0169','0172','0180','0181','0182','0257','0350','0447','0524')
group by  year(created_date), ep.collection_source
order by year(created_date), ep.collection_source

MillenniumCo:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
with payments as (
  select distinct
    coalesce(pd.iid, iv.iid) as scheduled_payment_id,
    1 as source_id,
    --null as zenoti_scheduled_payment_id,
    --null as scheduled_payment_pk,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    NEFTTYPE as scheduled_payment_type,
    case
      when cast(NEFTTYPE as int) = 1 then 'Credit Card'
      when cast(NEFTTYPE as int) = 2 then 'ACH'
      when NEFTTYPE is null then null
      else 'Pending'
    end as scheduled_payment_option_type,
    cast(
      coalesce(
        cast(yhitamount as decimal(10,2)),
        cast(npayamount as decimal(10,2))
      ) as decimal(10,2)
    ) as collection_amount,
    th.TDATETIME as collection_date,
    case
      when cast(pd.nstatus as int) = 2 then cast(
        coalesce(
          cast(yhitamount as decimal(10,2)),
          cast(npayamount as decimal(10,2))
        ) as decimal
      ) --collection_amount
      when pd.nstatus is null then cast(iv.NPAYAMOUNT as decimal(10,2))
      else 0
    end as collected_amount,
    case
      when (
        cast(pd.nstatus as int) = 2
        or pd.nstatus is null
      ) then th.TDATETIME
      else null
    end as collected_timestamp,
    case
      when (
        cast(pd.nstatus as int) = 2
        or pd.nstatus is null
      ) then th.TDATETIME
      else null
    end as collected_date,
    th.TDATETIME as closed_datetime,
    th.iid as invoice_id,
    NULL as last_tried_on,
    NULL as next_try_on,
    th.TDATETIME as created_timestamp,
    th.TDATETIME as created_date,
    pd.nstatus as collection_status,
    case
      when cast(NEFTTYPE as int) = 1 then 'Credit Card'
      when cast(NEFTTYPE as int) = 2 then 'ACH'
      when NEFTTYPE is null then null
      else 'Pending'
    end as collection_source,
    th.iloginid as etl_created_by,
    coalesce(pd.TLASTMODIFIED, iv.TLASTMODIFIED) as etl_created_at,
    cast(th.lvoid as bit) as void,
    null as podid,
    null as customer_payment_name,
    null as consider_in_financials,
    1 as parent_source_id,
    th.ilocationid as parent_source_center_id,
    th.CINVOICENO as parent_source_invoice_id,
    YHITAMOUNT as parent_source_collection_amount,
    'EFT' as schedule_type
  from millenniumco.dbo.transhead th
    --Millennium_transactionheader th
    left outer join millenniumco.dbo.payplandetail pd --Millennium_payplandetail pd 
 on pd.iheaderid = th.iid
    and pd.ilocationid = th.ilocationid
    left outer join millenniumco.dbo.payplan pp -- Millennium_payplan pp 
 on pd.ipayplanheaderid = pp.iid
    and pd.ilocationid = pp.ilocationid
     left outer join (
      select *
      from
       millenniumco.dbo.invdetail -- Millennium_invdetail
      where
        lpayplan = 'True'
    ) iv on th.ilocationid = iv.ilocationid
    and th.iid = iv.iheaderid
    and (
      (
        pd.iheaderid != iv.iheaderid
        and pd.ilocationid != iv.ilocationid
      )
      or pd.iheaderid is null
    )
  where
    (
      pd.iheaderid is not null
      or iv.iheaderid is not null
    )
),
 ScheduledPaymentCounts as (
SELECT 
year(created_date) as Year, collection_source,
 sum(cast(collection_amount as decimal(10,2))) as Total_Collection_Amount
FROM Payments

WHERE created_date <= CAST('2021-03-31' AS DATE)  and collection_source = 'Credit Card'
group by year(created_date), collection_source
)
select 
*
from ScheduledPaymentCounts order by [year], collection_source

--------------------------------------CreditCard Payments(Amp Vs Zenoti)------------------------------------

Amperity:
select --source_id
 -- ,count(*) as paymentrowcount,
 -- count(distinct scheduled_payment_id) as paymentidcount
  year(collected_date) as Year
  ,collection_source
  ,sum(cast(collection_amount as decimal(10,2))) as Total_Collection_amount  
  from events_scheduled_payments
  where source_id = 2
  and year(collected_date) <= 2021 --cast('2021-03-31' as date)
  group by source_id, year(collected_date), collection_source 
  order by year(collected_date), collection_source

Zenoti:
with zenoti_sch_payments as (
select
scheduledcollectionwid as scheduled_payment_id,
2 as source_id,
factsegmentid as zenoti_scheduled_payment_id,
scheduledcollectionpk as scheduled_payment_pk,
centerwid as center_id,
userwid as user_id,
scheduledpaymenttype as scheduled_payment_type,
paymentoptiontype as scheduled_payment_option_type,
cast(collectionamount as decimal) as collection_amount,
collectiondateincenter as collection_date,
cast(collectedamount as decimal) as collected_amount,
collecteddatetimeincenter as collected_timestamp,
collecteddateincenter as collected_date,
collecteddatetimeincenter as closed_datetime,
bc.invoiceid as invoice_id,
lasttriedon as last_tried_on,
nexttryat as next_try_on,
createddatetimeincenter as created_timestamp,
createddateincenter as created_date,
collectionstatus as collection_status,
collectionsource as collection_source,
etlcreatedby as etl_created_by,
etlcreateddate as etl_created_at,
cast(void as boolean) as void,
podid as podid,
custompaymentname as customer_payment_name,
cast(considerinfinancials as boolean) as consider_in_financials,
2 as parent_source_id,
centerwid as parent_source_center_id,
bc.invoiceid as parent_source_invoice_id,
collectionamount as parent_source_collection_amount,
case
when saledateincenter != COLLECTEDDATEINCENTER then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factscheduledcollections bc
inner join (
select
invoiceid,
max(saledateincenter) as saledateincenter
from
public.bi_factinvoiceitem
where
cast(itemtypewid as int) = 42
group by
1
) bi on bi.invoiceid = bc.invoiceid
where
createddateincenter > timestamp '2000-01-02 00:00:00'
and saledateincenter != COLLECTEDDATEINCENTER
),
zenoti_collect_payments as (
select
factcollectionwid as scheduled_payment_id,
2 as source_id,
null as zenoti_scheduled_payment_id,
null as scheduled_payment_pk,
CENTERWID as center_id,
USERWID as user_id,
paymentmodedata as scheduled_payment_type,
paymentmodedata as scheduled_payment_option_type,
cast(amount as decimal) as collection_amount,
paymentdateincenter as collection_date,
cast(amount as decimal) as collected_amount,
paymentdateTIMEINCENTER as collected_timestamp,
paymentdateincenter as collected_date,
closeddatetimeincenter as closed_datetime,
INVOICEID as invoice_id,
null as last_tried_on,
null as next_try_on,
CREATEDDATETIMEINCENTER as created_timestamp,
CREATEDDATEINCENTER as created_date,
'Collected' as collection_status,
null as collection_source,
ETLCREATEDBY as etl_created_by,
ETLCREATEDDATE as etl_created_at,
cast(void as boolean) as void,
PODID as podid,
null as customer_payment_name,
cast(CONSIDERINFINANCIALS as boolean) as consider_in_financials,
2 as parent_source_id,
CENTERWID as parent_source_center_id,
INVOICEID as parent_source_invoice_id,
amount as parent_source_collection_amount,
case
when saledateincenter != paymentdateincenter then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factcollections bc
left outer join (
select
considerinfinancials,
agentwid
from
public.bi_dimagent bd 
) ba on bc.PAIDBYAGENTWID = ba.agentwid --filter out financials
where
cast(saledateincenter as date) = date '2000-01-01'
and paymentdateincenter > saledateincenter
and cast(itemtypewid as int) = 42
),

scheduled_payments as
(select * from zenoti_sch_payments union all select * from zenoti_collect_payments )

select 
date_part_year(collected_date) as year,
collection_source,
sum(collection_amount) as Total_Collection_amount
 from scheduled_payments
 where date_part_year(collected_date) <= 2021 --created_date <= cast('2021-03-31' as date)
 --and collection_source is not null
 group by Year, collection_source
 order by Year, collection_source


--------------------------------------------------Distinct Payment IDs------------------------------------------------
Amperity:
with payments as
(
select source_id
  ,count(*) as paymentrowcount,
  count(distinct scheduled_payment_id) as paymentidcount
  ,sum(cast(collected_amount as decimal(10,2))) as Total_Collected_Amount
  ,year(collected_date) as Year
  from events_scheduled_payments
  where source_id = 2
  and (collected_date) <= cast('2021-03-31' as date)
  group by source_id, year(collected_date)
  union all
  select source_id
  ,count(*) as paymentrowcount,
  count(distinct scheduled_payment_id) as paymentidcount
  ,sum(cast(collected_amount as decimal(10,2))) as Total_Collected_Amount
  ,year(collected_date) as Year
  from events_scheduled_payments
  where source_id = 1
  and (collected_date) <= cast('2021-03-31' as date)
  group by source_id, year(collected_date)
)
select
(select paymentrowcount from payments where source_id = 2 and Year = p.Year ) as ZenotiRowCount
,(select paymentrowcount from payments where source_id = 1 and Year = p.Year ) as MillenniumRowCount
,(select sum(paymentrowcount) from payments where Year = p.Year) as totalrows
,(select distinct paymentidcount from payments where source_id =2 and Year = p.Year) as zenotiidcount
,(select distinct paymentidcount from payments where source_id =1 and Year = p.Year) as Millenniumidcount
,(select sum(paymentidcount) from payments where Year = p.Year ) as totalidcount
,(select sum(Total_Collected_Amount) from payments where Year = p.Year ) as Total_amount
, p.Year
from payments p
order by p.Year

MillenniumCo:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
with payments as (
  select distinct
   pd.iid as scheduled_payment_id,
    1 as source_id,
   -- null as zenoti_scheduled_payment_id,
   -- null as scheduled_payment_pk,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    NEFTTYPE as scheduled_payment_type,
    case
      when NEFTTYPE = '1' then 'Credit Card'
      when NEFTTYPE = '2' then 'ACH'
      else 'Pending'
    end as scheduled_payment_option_type,
    yhitamount as collection_amount,
    th.TDATETIME as collection_date,
  case
      when pd.nstatus = '2' then yhitamount  
      else null
    end as collected_amount,
--    null as collected_timestamp,
    case
   	 when pd.nstatus = '2' then dhitdate
      else null
    end as collected_date,
    th.TDATETIME as closed_datetime,
    CINVOICENO as invoice_id,
  --  NULL as last_tried_on,
 --   NULL as next_try_on,
    th.TDATETIME as created_timestamp,
    th.TDATETIME as created_date,
    pd.nstatus as collection_status,
    case
      when NEFTTYPE = '1' then 'Credit Card'
      when NEFTTYPE = '2' then 'ACH'
      else 'Pending'
    end as collection_source,
    th.iloginid as updated_by,
    pd.TLASTMODIFIED as updated_at,
    th.lvoid  as void,
--    null as podid,
--    null as customer_payment_name,
--    null as consider_in_financials,
    1 as parent_source_id,
    pd.ilocationid as parent_source_center_id,
    th.CINVOICENO as parent_source_invoice_id,
    YHITAMOUNT as parent_source_collection_amount,
    'EFT' as schedule_type
  from millenniumco.dbo.transhead th
    --Millennium_transactionheader th
    left outer join millenniumco.dbo.payplandetail pd --Millennium_payplandetail pd 
	on pd.iheaderid = th.iid
    and pd.ilocationid = th.ilocationid
    left outer join millenniumco.dbo.payplan pp -- Millennium_payplan pp 
	on pd.ipayplanheaderid = pp.iid
    and pd.ilocationid = pp.ilocationid
    where
  pd.iheaderid != '0'
  ),
  ScheduledPaymentCounts as (
SELECT 
year(created_date) as Year,
	COUNT(*) AS [RowCount]
	, COUNT(DISTINCT scheduled_payment_id) AS DistinctPaymentIds
	,sum(collected_amount) as Total_Collected_amount
FROM Payments
WHERE collected_date <= CAST('2021-03-31' AS DATE)
group by year(created_date)
)
select 
*

from ScheduledPaymentCounts order by [year]

Zenoti:
with zenoti_sch_payments as (
select
scheduledcollectionwid as scheduled_payment_id,
2 as source_id,
factsegmentid as zenoti_scheduled_payment_id,
scheduledcollectionpk as scheduled_payment_pk,
centerwid as center_id,
userwid as user_id,
scheduledpaymenttype as scheduled_payment_type,
paymentoptiontype as scheduled_payment_option_type,
cast(collectionamount as decimal) as collection_amount,
collectiondateincenter as collection_date,
cast(collectedamount as decimal) as collected_amount,
collecteddatetimeincenter as collected_timestamp,
collecteddateincenter as collected_date,
collecteddatetimeincenter as closed_datetime,
bc.invoiceid as invoice_id,
lasttriedon as last_tried_on,
nexttryat as next_try_on,
createddatetimeincenter as created_timestamp,
createddateincenter as created_date,
collectionstatus as collection_status,
collectionsource as collection_source,
etlcreatedby as etl_created_by,
etlcreateddate as etl_created_at,
cast(void as boolean) as void,
podid as podid,
custompaymentname as customer_payment_name,
cast(considerinfinancials as boolean) as consider_in_financials,
2 as parent_source_id,
centerwid as parent_source_center_id,
bc.invoiceid as parent_source_invoice_id,
collectionamount as parent_source_collection_amount,
case
when saledateincenter != COLLECTEDDATEINCENTER then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factscheduledcollections bc
inner join (
select
invoiceid,
max(saledateincenter) as saledateincenter
from
public.bi_factinvoiceitem
where
cast(itemtypewid as int) = 42
group by
1
) bi on bi.invoiceid = bc.invoiceid
where
createddateincenter > timestamp '2000-01-02 00:00:00'
and saledateincenter != COLLECTEDDATEINCENTER
),
zenoti_collect_payments as (
select
factcollectionwid as scheduled_payment_id,
2 as source_id,
null as zenoti_scheduled_payment_id,
null as scheduled_payment_pk,
CENTERWID as center_id,
USERWID as user_id,
paymentmodedata as scheduled_payment_type,
paymentmodedata as scheduled_payment_option_type,
cast(amount as decimal) as collection_amount,
paymentdateincenter as collection_date,
cast(amount as decimal) as collected_amount,
paymentdateTIMEINCENTER as collected_timestamp,
paymentdateincenter as collected_date,
closeddatetimeincenter as closed_datetime,
INVOICEID as invoice_id,
null as last_tried_on,
null as next_try_on,
CREATEDDATETIMEINCENTER as created_timestamp,
CREATEDDATEINCENTER as created_date,
'Collected' as collection_status,
null as collection_source,
ETLCREATEDBY as etl_created_by,
ETLCREATEDDATE as etl_created_at,
cast(void as boolean) as void,
PODID as podid,
null as customer_payment_name,
cast(CONSIDERINFINANCIALS as boolean) as consider_in_financials,
2 as parent_source_id,
CENTERWID as parent_source_center_id,
INVOICEID as parent_source_invoice_id,
amount as parent_source_collection_amount,
case
when saledateincenter != paymentdateincenter then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factcollections bc
left outer join (
select
considerinfinancials,
agentwid
from
public.bi_dimagent bd 
) ba on bc.PAIDBYAGENTWID = ba.agentwid --filter out financials
where
cast(saledateincenter as date) = date '2000-01-01'
and paymentdateincenter > saledateincenter
and cast(itemtypewid as int) = 42
),
scheduled_payments as
(select * from zenoti_sch_payments union all select * from zenoti_collect_payments )

 select 
date_part_year(collected_date) as year
,count(*) as paymentrowcount,
  count(distinct scheduled_payment_id) as paymentidcount
  ,sum(cast(collected_amount as decimal(10,2))) as Total_Collected_amount
  
 from scheduled_payments 
 where collected_date <= cast('2021-03-31' as date) 
 group by Year
 order by Year

-----------------------------Row Count(Amp Vs Mill)------------------------------------------------

Amperity:
with payments as
(
select source_id
  ,count(*) as paymentrowcount,
  count(distinct scheduled_payment_id) as paymentidcount
  ,year(collected_date) as Year
  from events_scheduled_payments
  where source_id = 2
  and year(collected_date) <= 2021 --created_date <= cast('2021-03-31' as date)
  group by source_id, year(collected_date)
  union all
  select source_id
  ,count(*) as paymentrowcount,
  count(distinct scheduled_payment_id) as paymentidcount
  ,year(collected_date) as Year
  from events_scheduled_payments
  where source_id = 1
  and year(collected_date) <= 2021 --cast('2021-03-31' as date)
  group by source_id, year(collected_date)
)
select  p.Year,
(select paymentrowcount from payments where source_id = 2 and Year = p.Year ) as ZenotiRowCount
,(select paymentrowcount from payments where source_id = 1 and Year = p.Year ) as MillenniumRowCount
,(select sum(paymentrowcount) from payments where Year = p.Year) as totalrows
,(select distinct paymentidcount from payments where source_id =2 and Year = p.Year) as zenotiidcount
,(select distinct paymentidcount from payments where source_id =1 and Year = p.Year) as Millenniumidcount
,(select sum(paymentidcount) from payments where Year = p.Year ) as totalidcount

from payments p
order by p.Year

MillenniumCo:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
with payments as (
  select distinct
    coalesce(pd.iid, iv.iid) as scheduled_payment_id,
    1 as source_id,
    --null as zenoti_scheduled_payment_id,
    --null as scheduled_payment_pk,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    NEFTTYPE as scheduled_payment_type,
    case
      when cast(NEFTTYPE as int) = 1 then 'Credit Card'
      when cast(NEFTTYPE as int) = 2 then 'ACH'
      when NEFTTYPE is null then null
      else 'Pending'
    end as scheduled_payment_option_type,
    cast(
      coalesce(
        cast(yhitamount as varchar),
        cast(npayamount as varchar)
      ) as decimal
    ) as collection_amount,
    th.TDATETIME as collection_date,
    case
      when cast(pd.nstatus as int) = 2 then cast(
        coalesce(
          cast(yhitamount as varchar),
          cast(npayamount as varchar)
        ) as decimal
      ) --collection_amount
      when pd.nstatus is null then cast(iv.NPAYAMOUNT as decimal)
      else 0
    end as collected_amount,
    case
      when (
        cast(pd.nstatus as int) = 2
        or pd.nstatus is null
      ) then th.TDATETIME
      else null
    end as collected_timestamp,
    case
      when (
        cast(pd.nstatus as int) = 2
        or pd.nstatus is null
      ) then th.TDATETIME
      else null
    end as collected_date,
    th.TDATETIME as closed_datetime,
    th.iid as invoice_id,
    NULL as last_tried_on,
    NULL as next_try_on,
    th.TDATETIME as created_timestamp,
    th.TDATETIME as created_date,
    pd.nstatus as collection_status,
    case
      when cast(NEFTTYPE as int) = 1 then 'Credit Card'
      when cast(NEFTTYPE as int) = 2 then 'ACH'
      when NEFTTYPE is null then null
      else 'Pending'
    end as collection_source,
    th.iloginid as etl_created_by,
    coalesce(pd.TLASTMODIFIED, iv.TLASTMODIFIED) as etl_created_at,
    cast(th.lvoid as bit) as void,
    null as podid,
    null as customer_payment_name,
    null as consider_in_financials,
    1 as parent_source_id,
    th.ilocationid as parent_source_center_id,
    th.CINVOICENO as parent_source_invoice_id,
    YHITAMOUNT as parent_source_collection_amount,
    'EFT' as schedule_type
  from millenniumco.dbo.transhead th
    --Millennium_transactionheader th
    left outer join millenniumco.dbo.payplandetail pd --Millennium_payplandetail pd 
 on pd.iheaderid = th.iid
    and pd.ilocationid = th.ilocationid
    left outer join millenniumco.dbo.payplan pp -- Millennium_payplan pp 
 on pd.ipayplanheaderid = pp.iid
    and pd.ilocationid = pp.ilocationid
     left outer join (
      select *
      from
       millenniumco.dbo.invdetail -- Millennium_invdetail
      where
        lpayplan = 'True'
    ) iv on th.ilocationid = iv.ilocationid
    and th.iid = iv.iheaderid
    and (
      (
        pd.iheaderid != iv.iheaderid
        and pd.ilocationid != iv.ilocationid
      )
      or pd.iheaderid is null
    )
  where
    (
      pd.iheaderid is not null
      or iv.iheaderid is not null
    )
),
  ScheduledPaymentCounts as (
SELECT 
year(collected_date) as Year,
 COUNT(*) AS [RowCount]
 , COUNT(DISTINCT scheduled_payment_id) AS DistinctPaymentIds
FROM Payments
WHERE year(collected_date) <= '2021' --CAST('2021-03-31' AS DATE)
group by year(collected_date)
)
select 
*
from ScheduledPaymentCounts order by [year]


--------------------------------------------RowCount(Amp Vs Zenoti)------------------------------------------

Amperity:
select source_id
  ,count(*) as paymentrowcount,
  count(distinct scheduled_payment_id) as paymentidcount
  ,year(collected_date) as Year
  from events_scheduled_payments
  where source_id = 2
  and (collected_date)  <= cast('2021-03-31' as date)
  group by source_id, year(collected_date)

Zenoti:
with zenoti_sch_payments as (
select
scheduledcollectionwid as scheduled_payment_id,
2 as source_id,
factsegmentid as zenoti_scheduled_payment_id,
scheduledcollectionpk as scheduled_payment_pk,
centerwid as center_id,
userwid as user_id,
scheduledpaymenttype as scheduled_payment_type,
paymentoptiontype as scheduled_payment_option_type,
cast(collectionamount as decimal) as collection_amount,
collectiondateincenter as collection_date,
cast(collectedamount as decimal) as collected_amount,
collecteddatetimeincenter as collected_timestamp,
collecteddateincenter as collected_date,
collecteddatetimeincenter as closed_datetime,
bc.invoiceid as invoice_id,
lasttriedon as last_tried_on,
nexttryat as next_try_on,
createddatetimeincenter as created_timestamp,
createddateincenter as created_date,
collectionstatus as collection_status,
collectionsource as collection_source,
etlcreatedby as etl_created_by,
etlcreateddate as etl_created_at,
cast(void as boolean) as void,
podid as podid,
custompaymentname as customer_payment_name,
cast(considerinfinancials as boolean) as consider_in_financials,
2 as parent_source_id,
centerwid as parent_source_center_id,
bc.invoiceid as parent_source_invoice_id,
collectionamount as parent_source_collection_amount,
case
when saledateincenter != COLLECTEDDATEINCENTER then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factscheduledcollections bc
inner join (
select
invoiceid,
max(saledateincenter) as saledateincenter
from
public.bi_factinvoiceitem
where
cast(itemtypewid as int) = 42
group by
1
) bi on bi.invoiceid = bc.invoiceid
where
createddateincenter > timestamp '2000-01-02 00:00:00'
and saledateincenter != COLLECTEDDATEINCENTER
),
zenoti_collect_payments as (
select
factcollectionwid as scheduled_payment_id,
2 as source_id,
null as zenoti_scheduled_payment_id,
null as scheduled_payment_pk,
CENTERWID as center_id,
USERWID as user_id,
paymentmodedata as scheduled_payment_type,
paymentmodedata as scheduled_payment_option_type,
cast(amount as decimal) as collection_amount,
paymentdateincenter as collection_date,
cast(amount as decimal) as collected_amount,
paymentdateTIMEINCENTER as collected_timestamp,
paymentdateincenter as collected_date,
closeddatetimeincenter as closed_datetime,
INVOICEID as invoice_id,
null as last_tried_on,
null as next_try_on,
CREATEDDATETIMEINCENTER as created_timestamp,
CREATEDDATEINCENTER as created_date,
'Collected' as collection_status,
null as collection_source,
ETLCREATEDBY as etl_created_by,
ETLCREATEDDATE as etl_created_at,
cast(void as boolean) as void,
PODID as podid,
null as customer_payment_name,
cast(CONSIDERINFINANCIALS as boolean) as consider_in_financials,
2 as parent_source_id,
CENTERWID as parent_source_center_id,
INVOICEID as parent_source_invoice_id,
amount as parent_source_collection_amount,
case
when saledateincenter != paymentdateincenter then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factcollections bc
left outer join (
select
considerinfinancials,
agentwid
from
public.bi_dimagent bd 
) ba on bc.PAIDBYAGENTWID = ba.agentwid --filter out financials
where
cast(saledateincenter as date) = date '2000-01-01'
and paymentdateincenter > saledateincenter
and cast(itemtypewid as int) = 42
),
scheduled_payments as
(select * from zenoti_sch_payments union all select * from zenoti_collect_payments )

select 
date_part_year(collected_date) as year,
 COUNT(*) as rowcount
 ,count(distinct scheduled_payment_id) as distinctpaymentid
 from scheduled_payments
 where date_part_year(collected_date) <= 2021 --collected_date <= cast('2021-03-31' as date)
 group by Year
 order by Year

------------------------------Unique Centers with Scheduled Payments--------------------------------------

Amperity:
select year(collected_date) as Year, month(collected_date) as month,
    count(distinct center_id) as total_schedpayment_unique_centers      
 from events_scheduled_payments
  where source_id = 2
  and collected_date between cast('2021-04-01' as date) and
  cast('2021-06-30' as date) 
  group by source_id, year(collected_date),month(collected_date)
  order by year(collected_date),month(collected_date)

Zenoti:
with zenoti_sch_payments as (
select
scheduledcollectionwid as scheduled_payment_id,
2 as source_id,
factsegmentid as zenoti_scheduled_payment_id,
scheduledcollectionpk as scheduled_payment_pk,
centerwid as center_id,
userwid as user_id,
scheduledpaymenttype as scheduled_payment_type,
paymentoptiontype as scheduled_payment_option_type,
cast(collectionamount as decimal) as collection_amount,
collectiondateincenter as collection_date,
cast(collectedamount as decimal) as collected_amount,
collecteddatetimeincenter as collected_timestamp,
collecteddateincenter as collected_date,
collecteddatetimeincenter as closed_datetime,
bc.invoiceid as invoice_id,
lasttriedon as last_tried_on,
nexttryat as next_try_on,
createddatetimeincenter as created_timestamp,
createddateincenter as created_date,
collectionstatus as collection_status,
collectionsource as collection_source,
etlcreatedby as etl_created_by,
etlcreateddate as etl_created_at,
cast(void as boolean) as void,
podid as podid,
custompaymentname as customer_payment_name,
cast(considerinfinancials as boolean) as consider_in_financials,
2 as parent_source_id,
centerwid as parent_source_center_id,
bc.invoiceid as parent_source_invoice_id,
collectionamount as parent_source_collection_amount,
case
when saledateincenter != COLLECTEDDATEINCENTER then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factscheduledcollections bc
inner join (
select
invoiceid,
max(saledateincenter) as saledateincenter
from
public.bi_factinvoiceitem
where
cast(itemtypewid as int) = 42
group by
1
) bi on bi.invoiceid = bc.invoiceid
where
createddateincenter > timestamp '2000-01-02 00:00:00'
and saledateincenter != COLLECTEDDATEINCENTER
),
zenoti_collect_payments as (
select
factcollectionwid as scheduled_payment_id,
2 as source_id,
null as zenoti_scheduled_payment_id,
null as scheduled_payment_pk,
CENTERWID as center_id,
USERWID as user_id,
paymentmodedata as scheduled_payment_type,
paymentmodedata as scheduled_payment_option_type,
cast(amount as decimal) as collection_amount,
paymentdateincenter as collection_date,
cast(amount as decimal) as collected_amount,
paymentdateTIMEINCENTER as collected_timestamp,
paymentdateincenter as collected_date,
closeddatetimeincenter as closed_datetime,
INVOICEID as invoice_id,
null as last_tried_on,
null as next_try_on,
CREATEDDATETIMEINCENTER as created_timestamp,
CREATEDDATEINCENTER as created_date,
'Collected' as collection_status,
null as collection_source,
ETLCREATEDBY as etl_created_by,
ETLCREATEDDATE as etl_created_at,
cast(void as boolean) as void,
PODID as podid,
null as customer_payment_name,
cast(CONSIDERINFINANCIALS as boolean) as consider_in_financials,
2 as parent_source_id,
CENTERWID as parent_source_center_id,
INVOICEID as parent_source_invoice_id,
amount as parent_source_collection_amount,
case
when saledateincenter != paymentdateincenter then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factcollections bc
left outer join (
select
considerinfinancials,
agentwid
from
public.bi_dimagent bd 
) ba on bc.PAIDBYAGENTWID = ba.agentwid --filter out financials
where
cast(saledateincenter as date) = date '2000-01-01'
and paymentdateincenter > saledateincenter
and cast(itemtypewid as int) = 42
),
scheduled_payments as
(select * from zenoti_sch_payments union all select * from zenoti_collect_payments )

 select 
date_part_year(collected_date) as year,date_part('month', collected_date) as month,
 count(distinct center_id) as total_schedpayment_unique_centers
 from scheduled_payments
 where collected_date between cast('2021-04-01' as date) and cast('2021-06-30' as date)  
 group by Year,month
 order by Year,month

---------------------------------Unique Payors by UserID & CenterID-----------------------------------

Amperity:
select year(collected_date) as Year, month(collected_date) as month,
     count(distinct user_id) as total_payors_unique   ,
     count(concat(concat( user_id, '-'), center_id)) as payor_by_Center
 from events_scheduled_payments
  where source_id = 2
  and collected_date between cast('2021-04-01' as date) and
  cast('2021-06-30' as date) 
  group by source_id, year(collected_date),month(collected_date)
  order by year(collected_date),month(collected_date)

Zenoti:
with zenoti_sch_payments as (
select
scheduledcollectionwid as scheduled_payment_id,
2 as source_id,
factsegmentid as zenoti_scheduled_payment_id,
scheduledcollectionpk as scheduled_payment_pk,
centerwid as center_id,
userwid as user_id,
scheduledpaymenttype as scheduled_payment_type,
paymentoptiontype as scheduled_payment_option_type,
cast(collectionamount as decimal) as collection_amount,
collectiondateincenter as collection_date,
cast(collectedamount as decimal) as collected_amount,
collecteddatetimeincenter as collected_timestamp,
collecteddateincenter as collected_date,
collecteddatetimeincenter as closed_datetime,
bc.invoiceid as invoice_id,
lasttriedon as last_tried_on,
nexttryat as next_try_on,
createddatetimeincenter as created_timestamp,
createddateincenter as created_date,
collectionstatus as collection_status,
collectionsource as collection_source,
etlcreatedby as etl_created_by,
etlcreateddate as etl_created_at,
cast(void as boolean) as void,
podid as podid,
custompaymentname as customer_payment_name,
cast(considerinfinancials as boolean) as consider_in_financials,
2 as parent_source_id,
centerwid as parent_source_center_id,
bc.invoiceid as parent_source_invoice_id,
collectionamount as parent_source_collection_amount,
case
when saledateincenter != COLLECTEDDATEINCENTER then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factscheduledcollections bc
inner join (
select
invoiceid,
max(saledateincenter) as saledateincenter
from
public.bi_factinvoiceitem
where
cast(itemtypewid as int) = 42
group by
1
) bi on bi.invoiceid = bc.invoiceid
where
createddateincenter > timestamp '2000-01-02 00:00:00'
and saledateincenter != COLLECTEDDATEINCENTER
),
zenoti_collect_payments as (
select
factcollectionwid as scheduled_payment_id,
2 as source_id,
null as zenoti_scheduled_payment_id,
null as scheduled_payment_pk,
CENTERWID as center_id,
USERWID as user_id,
paymentmodedata as scheduled_payment_type,
paymentmodedata as scheduled_payment_option_type,
cast(amount as decimal) as collection_amount,
paymentdateincenter as collection_date,
cast(amount as decimal) as collected_amount,
paymentdateTIMEINCENTER as collected_timestamp,
paymentdateincenter as collected_date,
closeddatetimeincenter as closed_datetime,
INVOICEID as invoice_id,
null as last_tried_on,
null as next_try_on,
CREATEDDATETIMEINCENTER as created_timestamp,
CREATEDDATEINCENTER as created_date,
'Collected' as collection_status,
null as collection_source,
ETLCREATEDBY as etl_created_by,
ETLCREATEDDATE as etl_created_at,
cast(void as boolean) as void,
PODID as podid,
null as customer_payment_name,
cast(CONSIDERINFINANCIALS as boolean) as consider_in_financials,
2 as parent_source_id,
CENTERWID as parent_source_center_id,
INVOICEID as parent_source_invoice_id,
amount as parent_source_collection_amount,
case
when saledateincenter != paymentdateincenter then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factcollections bc
left outer join (
select
considerinfinancials,
agentwid
from
public.bi_dimagent bd 
) ba on bc.PAIDBYAGENTWID = ba.agentwid --filter out financials
where
cast(saledateincenter as date) = date '2000-01-01'
and paymentdateincenter > saledateincenter
and cast(itemtypewid as int) = 42
),
scheduled_payments as
(select * from zenoti_sch_payments union all select * from zenoti_collect_payments )

 select 
date_part_year(collected_date) as year,date_part('month', collected_date) as month,
 count(distinct user_id) as total_payors_unique
 ,count(concat(concat( user_id, '-'), center_id)) as payor_by_Center
 from scheduled_payments 
 where collected_date between cast('2021-04-01' as date) and cast('2021-06-30' as date)  
 group by Year,month
 order by Year,month

------------------------------------------Total Amount Collected-------------------------------------

Amperity:
  select  year(collected_date) as Year, month(collected_date) as month
  --,collection_source
  ,sum(cast(collection_amount as decimal(10,2))) as Total_Collection_amount
  from events_scheduled_payments
  where source_id = 2
  and collected_date >= cast('2021-04-01' as date) and
  collected_date <= cast('2021-06-30' as date) 
  group by source_id, year(collected_date), --collection_source ,
  month(collected_date)
  order by month(collected_date)--, collection_source

Zenoti:
with zenoti_sch_payments as (
select
scheduledcollectionwid as scheduled_payment_id,
2 as source_id,
factsegmentid as zenoti_scheduled_payment_id,
scheduledcollectionpk as scheduled_payment_pk,
centerwid as center_id,
userwid as user_id,
scheduledpaymenttype as scheduled_payment_type,
paymentoptiontype as scheduled_payment_option_type,
cast(collectionamount as decimal) as collection_amount,
collectiondateincenter as collection_date,
cast(collectedamount as decimal) as collected_amount,
collecteddatetimeincenter as collected_timestamp,
collecteddateincenter as collected_date,
collecteddatetimeincenter as closed_datetime,
bc.invoiceid as invoice_id,
lasttriedon as last_tried_on,
nexttryat as next_try_on,
createddatetimeincenter as created_timestamp,
createddateincenter as created_date,
collectionstatus as collection_status,
collectionsource as collection_source,
etlcreatedby as etl_created_by,
etlcreateddate as etl_created_at,
cast(void as boolean) as void,
podid as podid,
custompaymentname as customer_payment_name,
cast(considerinfinancials as boolean) as consider_in_financials,
2 as parent_source_id,
centerwid as parent_source_center_id,
bc.invoiceid as parent_source_invoice_id,
collectionamount as parent_source_collection_amount,
case
when saledateincenter != COLLECTEDDATEINCENTER then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factscheduledcollections bc
inner join (
select
invoiceid,
max(saledateincenter) as saledateincenter
from
public.bi_factinvoiceitem
where
cast(itemtypewid as int) = 42
group by
1
) bi on bi.invoiceid = bc.invoiceid
where
createddateincenter > timestamp '2000-01-02 00:00:00'
and saledateincenter != COLLECTEDDATEINCENTER
),
zenoti_collect_payments as (
select
factcollectionwid as scheduled_payment_id,
2 as source_id,
null as zenoti_scheduled_payment_id,
null as scheduled_payment_pk,
CENTERWID as center_id,
USERWID as user_id,
paymentmodedata as scheduled_payment_type,
paymentmodedata as scheduled_payment_option_type,
cast(amount as decimal) as collection_amount,
paymentdateincenter as collection_date,
cast(amount as decimal) as collected_amount,
paymentdateTIMEINCENTER as collected_timestamp,
paymentdateincenter as collected_date,
closeddatetimeincenter as closed_datetime,
INVOICEID as invoice_id,
null as last_tried_on,
null as next_try_on,
CREATEDDATETIMEINCENTER as created_timestamp,
CREATEDDATEINCENTER as created_date,
'Collected' as collection_status,
null as collection_source,
ETLCREATEDBY as etl_created_by,
ETLCREATEDDATE as etl_created_at,
cast(void as boolean) as void,
PODID as podid,
null as customer_payment_name,
cast(CONSIDERINFINANCIALS as boolean) as consider_in_financials,
2 as parent_source_id,
CENTERWID as parent_source_center_id,
INVOICEID as parent_source_invoice_id,
amount as parent_source_collection_amount,
case
when saledateincenter != paymentdateincenter then 'EFT'
else 'Downpayment'
end as schedule_type
from
public.bi_factcollections bc
left outer join (
select
considerinfinancials,
agentwid
from
public.bi_dimagent bd 
) ba on bc.PAIDBYAGENTWID = ba.agentwid --filter out financials
where
cast(saledateincenter as date) = date '2000-01-01'
and paymentdateincenter > saledateincenter
and cast(itemtypewid as int) = 42
),
scheduled_payments as
(select * from zenoti_sch_payments union all select * from zenoti_collect_payments )

 select 
date_part_year(collected_date) as year, date_part('month', collected_date) as month,
--collection_source ,
sum(collection_amount) as Total_Collection_amount
 from scheduled_payments
 where  collected_date >= cast('2021-04-01' as date) and
  collected_date <= cast('2021-06-30' as date)  
 --collected_date between cast('2021-04-01' as date) and cast('2021-06-30' as date)
 group by Year, MONTH --,collection_source
 order by Year, Month