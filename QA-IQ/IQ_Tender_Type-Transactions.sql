------------------------------------------------------------------------------------
                   REDSHIFT - ZENOTI
------------------------------------------------------------------------------------
WITH Tender As (
SELECT
  FACTCOLLECTIONWID as payment_id,
  2 as source,
  FACTCOLLECTIONID as zenoti_payment_id,
  CENTERWID as center_id,
  SALECENTERWID as sale_center_id,
  USERWID as user_id,
  ITEMTYPEWID as item_type_id,
  ITEMWID as item_id,
  INVOICE_NO as invoice_num,
  INVOICEID as invoice_id,
  INVOICEITEMID as invoice_item_id,
  PRODUCTWID as product_id,
  SERVICEWID as service_id,
  PACKAGEVERSIONWID as package_version_id,
  GIFTCARDWID as giftcard_id,
  MEMBERSHIPVERSIONWID as membership_id,
  PAIDBYMEMBERSHIPUSERWID as paid_by_membership,
  PAIDBYPPCGCUSERWID as paid_by_pp_cg_user_id,
  PAIDBYAGENTWID as paid_by_agent_id,
  PAYMENTMODENUMBER as payment_mode_number,
  ORGPAYMENTOPTIONWID as org_payment_option_id,
  SALEBYWID as sale_by_id,
  INVOICESTATUS as invoice_status,
  CLOSEBYWID as closed_by_user_id,
  CREATEDBYWID as created_by_user_id,
  SALEDATETIMEINCENTER as sale_timestamp,
  SALEDATEINCENTER as sale_date,
  CREATEDDATETIMEINCENTER as created_in_center_timestamp,
  CREATEDDATEINCENTER as created_in_center_date,
  CLOSEDDATETIMEINCENTER as closed_in_center_timestamp,
  CLOSEDDATEINCENTER as closed_in_center_date,
  PAYMENTDATETIMEINCENTER as payment_in_center_timestamp,
  PAYMENTDATEINCENTER as payment_in_center_date,
  AMOUNT as payment_amount,
  ADJUSTEDAMOUNT as payment_amount_adj,
  AMOUNTTYPE as payment_amount_type,
  PAYMENTTYPE as payment_type_id,
  TRANSACTIONID as transaction_id,
  ETLCREATEDBY as etl_user_id,
  INVOICESOURCE as invoice_source_id,
  APPOINTMENTID as appointment_id,
  APPGROUPID as app_group_id,
  PODID as podid,
  cast(VOID as integer) as void,
  PAYMENT_NO as payment_num,
  RECEIPT_NO as receipt_num,
  PAYMENTMODEDATA as payment_mode_data,
  PAYMENTOPTIONTYPE as payment_option_type,
  CCTRANSACTIONFEE as cc_transaction_fee,
  AMOUNTBYPAYMENT as amount_by_payment,
  APPROVALNUMBER as approval_number,
  CREDITCARDLASTFOURDIGITS as credit_card_last_four,
  DISPUTEAMOUNT as dispute_amount,
  DISPUTESTATUS as dispute_status,
  DISPUTEREASON as dispute_reason,
  DISPUTEDATETIME as dispute_timestamp,
  DISPUTEDATE as dispute_date,
  CHARGEDBACKAMOUNT as charged_back_amount,
  DISPUTEFEE as dispute_fee,
  RESPONDBYDATETIME as respond_by_timestamp,
  RESPONDBYDATE as respond_by_date,
  ETLCREATEDDATE as etl_created_date,
  CCTRANSACTIONID as cc_transaction_id,
  NULL as revenue_rec,
  CASE WHEN PAYMENTTYPE IN ('64', '65', '66') THEN 'Monetary' 
       WHEN PAYMENTTYPE IN ('129') THEN 'WP Redemption' ELSE 'Non-Monetary' 
    END AS Tender_Type 
FROM
    public.bi_factcollections bi 
WHERE
  (
    bi.invoicesource != '3'
    or bi.INVOICE_NO like '%IIIGN%'
  )
  
)

SELECT 
       payment_id
      ,SOURCE
      ,center_id
      ,payment_type_id
      ,Tender_Type
 FROM  Tender  
 WHERE payment_type_id = 129
 AND Center_id IN(466,508)
 LIMIT 100
 ---------------------------------------------------------------     
 
select
  invoice_id,
  invoice_item_id,
  source,
  payment_amount,
  payment_amount_type,
  payment_type_id,
  revenue_rec,
          CASE
      WHEN revenue_rec THEN 'Monetary'
      WHEN payment_type_id IN ('4') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
    END AS Tender_Type
from
  Events_Payments
where
  center_id in (
    '4',
    '19',
    '67',
    '70',
    '77',
    '85',
    '137',
    '140',
    '155',
    '156'
 ,	'157',	'169',	'172',	'180',	'181',	'182',	'184',	'204',	'257',	'333',	'335',	'350',	'370',	'442',	'447',	'457',	'469',	'505',	'506',	'524',	'526',	'554',	'581',	'636',	'639',	'644',	'645',	'660',	'678',	'684',	'685',	'707',	'708',	'783',	'794',	'801',	'823',	'831',	'832',	'847',	'866',	'909',	'928',	'946',	'955'
  )
  and source = 1
  and invoice_id is null
  and cast(revenue_rec as varchar) = 'true'
  -----------------------------------------------------------------------------
  select
  invoice_id,
  invoice_item_id,
  source,
  payment_amount,
  payment_amount_type,
  payment_type_id,
  revenue_rec,
       CASE
      WHEN payment_type_id IN ('64', '65', '66') THEN 'Monetary'
      WHEN payment_type_id IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
      END AS Tender_Type
from
  Events_Payments
where
  center_id in (
    '4',
    '19',
    '67',
    '70',
    '77',
    '85',
    '137',
    '140',
    '155',
    '156'
 ,	'157',	'169',	'172',	'180',	'181',	'182',	'184',	'204',	'257',	'333',	'335',	'350',	'370',	'442',	'447',	'457',	'469',	'505',	'506',	'524',	'526',	'554',	'581',	'636',	'639',	'644',	'645',	'660',	'678',	'684',	'685',	'707',	'708',	'783',	'794',	'801',	'823',	'831',	'832',	'847',	'866',	'909',	'928',	'946',	'955'
  )
  and source = 2
  and cast(payment_Amount as real) < 0
  -----------------------------------------------------------------------------
  select invoice_id
,invoice_Item_id
,payment_type_id
,source
,CASE
      WHEN payment_type_id IN ('64', '65', '66') THEN 'Monetary'
      WHEN payment_type_id IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
    END AS Tender_Type

from events_payments
where invoice_id in ('67cc4ff7-3921-406b-8961-12d20292d966'
                    ,'fdac4b90-3cdd-4ac6-b53e-868f99984f7e')
  -----------------------------------------------------------------------------
  USE master
go
SELECT sdest.DatabaseName 
    ,sdes.session_id
    ,sdes.[host_name]
    ,sdes.[program_name]
    ,sdes.client_interface_name
    ,sdes.login_name
    ,sdes.login_time
    ,sdes.nt_domain
    ,sdes.nt_user_name
    ,sdec.client_net_address
    ,sdec.local_net_address
    ,sdest.ObjName
    --,sdest.Query
FROM sys.dm_exec_sessions AS sdes
INNER JOIN sys.dm_exec_connections AS sdec ON sdec.session_id = sdes.session_id
CROSS APPLY (
    SELECT db_name(dbid) AS DatabaseName
        ,object_id(objectid) AS ObjName
        --,ISNULL((
        --        SELECT TEXT AS [processing-instruction(definition)]
        --        FROM sys.dm_exec_sql_text(sdec.most_recent_sql_handle)
        --        FOR XML PATH('')
        --            ,TYPE
        --        ), '') AS Query

    FROM sys.dm_exec_sql_text(sdec.most_recent_sql_handle)
    ) sdest
where sdes.session_id <> @@SPID 
--and sdes.nt_user_name = '' -- Put the username here !
ORDER BY sdec.session_id
