-------------Amperity:

  SELECT source_id
  	,YEAR(payment_in_center_date) AS Year
    ,month(payment_in_center_date) AS Month
  	, COUNT(*) AS PaymentsRowCount
  	, COUNT(DISTINCT payment_id) AS PaymentIdsCount
	, COUNT(DISTINCT center_id) AS DistinctLocations
    , COUNT(DISTINCT user_id) AS DistinctPayors
    ,COUNT(void) AS VoidedPayments
    ,sum(cast(payment_amount as decimal(10,2))) as Total_Payment_amount
  FROM Events_Payments
  WHERE source_id = 2
  	AND payment_in_center_date between CAST('2021-09-26' AS DATE) and CAST('2021-12-25' AS DATE)
  GROUP BY source_id, YEAR(payment_in_center_date),month(payment_in_center_date)
  order by month(payment_in_center_date)


-----------------Zenoti:
WITH Amperity_Payments AS (
	SELECT
		FACTCOLLECTIONWID as payment_id
		--,2 as source
		,FACTCOLLECTIONID as zenoti_payment_id
		,CENTERWID as center_id
		,SALECENTERWID as sale_center_id
		,USERWID as user_id
		,ITEMTYPEWID as item_type_id
		,ITEMWID as item_id
		,INVOICE_NO as invoice_num
		,INVOICEID as invoice_id
		,c.INVOICEITEMID as invoice_item_id
		,PRODUCTWID as product_id
		,SERVICEWID as service_id
		,PACKAGEVERSIONWID as package_version_id
		,GIFTCARDWID as giftcard_id
		,MEMBERSHIPVERSIONWID as membership_id
		,PAIDBYMEMBERSHIPUSERWID as paid_by_membership
		,PAIDBYPPCGCUSERWID as paid_by_pp_cg_user_id
		,PAIDBYAGENTWID as paid_by_agent_id
		,PAYMENTMODENUMBER as payment_mode_number
		,ORGPAYMENTOPTIONWID as org_payment_option_id
		,SALEBYWID as sale_by_id
		,INVOICESTATUS as invoice_status
		,CLOSEBYWID as closed_by_user_id
		,CREATEDBYWID as created_by_user_id
		,SALEDATETIMEINCENTER as sale_timestamp
		,SALEDATEINCENTER as sale_date
		,CREATEDDATETIMEINCENTER as created_in_center_timestamp
		,CREATEDDATEINCENTER as created_in_center_date
		,CLOSEDDATETIMEINCENTER as closed_in_center_timestamp
		,CLOSEDDATEINCENTER as closed_in_center_date
		,PAYMENTDATETIMEINCENTER as payment_in_center_timestamp
		,PAYMENTDATEINCENTER as payment_in_center_date
		,AMOUNT as payment_amount
		,ADJUSTEDAMOUNT as payment_amount_adj
		,AMOUNTTYPE as payment_amount_type
		,PAYMENTTYPE as payment_type_id
		,TRANSACTIONID as transaction_id
		,ETLCREATEDBY as etl_user_id
		,INVOICESOURCE as invoice_source_id
		,APPOINTMENTID as appointment_id
		,APPGROUPID as app_group_id
		,PODID as podid
		,cast(VOID as integer) as void
		,PAYMENT_NO as payment_num
		,RECEIPT_NO as receipt_num
		,PAYMENTMODEDATA as payment_mode_data
		,PAYMENTOPTIONTYPE as payment_option_type
		,CCTRANSACTIONFEE as cc_transaction_fee
		,AMOUNTBYPAYMENT as amount_by_payment
		,APPROVALNUMBER as approval_number
		,CREDITCARDLASTFOURDIGITS as credit_card_last_four
		,DISPUTEAMOUNT as dispute_amount
		,DISPUTESTATUS as dispute_status
		,DISPUTEREASON as dispute_reason
		,DISPUTEDATETIME as dispute_timestamp
		,DISPUTEDATE as dispute_date
		,CHARGEDBACKAMOUNT as charged_back_amount
		,DISPUTEFEE as dispute_fee
		,RESPONDBYDATETIME as respond_by_timestamp
		,RESPONDBYDATE as respond_by_date
		,ETLCREATEDDATE as etl_created_date
		,CCTRANSACTIONID as cc_transaction_id
		--,NULL as revenue_rec
	FROM bi_Factcollections c
    INNER JOIN (
    	SELECT ii.invoiceitemid
		FROM bi_Factinvoiceitem ii
		WHERE (( NOT (UPPER(ii.INVOICE_NO) LIKE ('II%') OR UPPER(ii.INVOICE_NO) LIKE ('IIR%'))
			   OR (UPPER(ii.INVOICE_NO) LIKE ('IIIGN%') OR UPPER(ii.INVOICE_NO) LIKE ('IRIGN%'))
			 ))
    ) i
		ON c.invoiceitemid = i.invoiceitemid
)
SELECT
	DATE_PART_YEAR(payment_in_center_date) AS year
	,extract(month from payment_in_center_date) as Month
	, COUNT(*) AS PaymentsRowCount
  	, COUNT(DISTINCT payment_id) AS PaymentIdsCount
	, COUNT(DISTINCT center_id) AS DistinctLocations
    , COUNT(DISTINCT user_id) AS DistinctPayors
    ,COUNT(void) AS VoidedPayments
    ,sum(cast(payment_amount as decimal(10,2))) as Total_Payment_amount
FROM Amperity_Payments
WHERE payment_in_center_date between CAST('2021-09-26' AS DATE) and CAST('2021-12-25' AS DATE)
GROUP BY year, Month
ORDER BY year, month 