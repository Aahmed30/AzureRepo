/**********************Snowflake******************/

 		/*****DBT.Q1_2022**********/
		
			
SELECT YEAR(collected_date) AS Year,
 month(collected_date) as Month
  	, COUNT(*) AS ScheduledPayments_RowCount
  	, COUNT(DISTINCT scheduled_payment_id) AS Scheduled_Payment_IdsCount
	, COUNT(DISTINCT center_id) AS Distinct_Locations
    , COUNT(DISTINCT user_id) AS Distinct_Payors
    ,COUNT(void) AS Voided_Payments
    ,sum(cast(parent_source_collection_amount as decimal(10,2))) as Total_Payment_amount 
  FROM DBT.Q1_2022.SCHEDULED_PAYMENT_EVENTS
  WHERE source_id = 2
  	AND collected_date between CAST('2021-12-26' AS DATE) and CAST('2022-03-26' AS DATE)
  GROUP BY source_id, YEAR(collected_date),month(collected_date) 
  order by YEAR(collected_date),month(collected_date)"			
			
			
			
			
			
	/*********ZENOTI.Q1_2022**********/
					
								
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
ZENOTI.Q1_2022.BI_FACTSCHEDULEDCOLLECTIONS bc
inner join (
select
invoiceid,
max(saledateincenter) as saledateincenter
from
ZENOTI.Q1_2022.BI_FACTINVOICEITEM
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
ZENOTI.Q1_2022.BI_FACTCOLLECTIONS bc
left outer join (
select
considerinfinancials,
agentwid
from
ZENOTI.Q1_2022.BI_DIMAGENT bd 
) ba on bc.PAIDBYAGENTWID = ba.agentwid --filter out financials
where
cast(saledateincenter as date) = date '2000-01-01'
and paymentdateincenter > saledateincenter
and cast(itemtypewid as int) = 42
),
scheduled_payments as
(select * from zenoti_sch_payments union all select * from zenoti_collect_payments )

 select 
year (collected_date) as year,
month(collected_date) as Month
,COUNT(*) AS ScheduledPaymentsRowCount
  	, COUNT(DISTINCT scheduled_payment_id) AS ScheduledPaymentIdsCount
	, COUNT(DISTINCT center_id) AS DistinctLocations
    , COUNT(DISTINCT user_id) AS DistinctPayors
    ,COUNT(void) AS VoidedPayments
    ,sum(cast(parent_source_collection_amount as decimal(10,2))) as Total_Payment_amount
 from scheduled_payments 
 where collected_date between CAST('2021-12-26' AS DATE) and CAST('2022-03-26' AS DATE)
 group by year , month
 order by year , month								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
