------------------------------------Payment Counts by Year----------------------------------------------
Amperity:
WITH paymentCounts AS (
  SELECT source_id
  	,YEAR(created_in_center_date) AS Year
  	, COUNT(*) AS PaymentsRowCount
  	, COUNT(DISTINCT payment_id) AS PaymentIdsCount
	, COUNT(DISTINCT center_id) AS DistinctLocations
    , COUNT(DISTINCT user_id) AS DistinctPayors
  FROM Events_Payments
  WHERE source_id = 2
  	AND created_in_center_date <= CAST('2021-03-31' AS DATE)
  GROUP BY source_id, YEAR(created_in_center_date)
  UNION ALL
  SELECT source_id
  	,YEAR(created_in_center_date) AS Year
  	, COUNT(*) AS PaymentsRowCount
  	, COUNT(DISTINCT payment_id) AS PaymentIdsCount
	, COUNT(DISTINCT center_id) AS DistinctLocations
    , COUNT(DISTINCT user_id) AS DistinctPayors
  FROM Events_Payments
  WHERE source_id = 1
  	AND created_in_center_date <= CAST('2021-03-31' AS DATE)
  GROUP BY source_id, YEAR(created_in_center_date)
)
SELECT DISTINCT
	pc.Year
	,(SELECT PaymentsRowCount FROM paymentCounts WHERE source_id = 2 AND Year = pc.Year) AS ZRowCount
    , (SELECT PaymentsRowCount FROM paymentCounts WHERE source_id = 1 AND Year = pc.Year) AS MRowCount
    , (SELECT SUM(PaymentsRowCount) FROM paymentCounts WHERE Year = pc.Year) AS TotalRows
	, (SELECT PaymentIdsCount FROM paymentCounts WHERE source_id = 2 AND Year = pc.Year) AS ZIdsCount
    , (SELECT PaymentIdsCount FROM paymentCounts WHERE source_id = 1 AND Year = pc.Year) AS MIdsCount
    , (SELECT SUM(PaymentIdsCount) FROM paymentCounts WHERE Year = pc.Year) AS TotalDistinctIds
FROM paymentCounts pc
ORDER BY pc.Year

Zenoti:
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
	DATE_PART_YEAR(created_in_center_date) AS Year
	, COUNT(*) AS RowCount
	, COUNT(DISTINCT payment_id) AS DistinctPaymentIds
FROM Amperity_Payments
WHERE created_in_center_date <= CAST('2021-03-31' AS DATE)
GROUP BY Year
ORDER BY Year

MillenniumCo:
WITH Amperity_Payments AS (
	SELECT
		pt.iid as payment_id
		--,1 as source
		--,null as zenoti_payment_id
		,pt.ilocationid as center_id
		--,null as sale_center_id
		,th.iclientid as user_id
		--,null as item_type_id
		--,null as item_id
		,th.CINVOICENO as invoice_num
		,th.iid as invoice_id
		--,null as invoice_item_id
		--,null as product_id
		--,null as service_id
		--,null as package_version_id
		--,null as giftcard_id
		--,null as membership_id
		--,null as paid_by_membership
		--,null as paid_by_pp_cg_user_id
		--,null as paid_by_agent_id
		--,null as payment_mode_number
		--,null as org_payment_option_id
		,ILOGINID as sale_by_id
		--,null as invoice_status
		,ILOGINID as closed_by_user_id
		,ILOGINID as created_by_user_id
		,TDATETIME as sale_timestamp
		,cast(TDATETIME as date) as sale_date
		,TDATETIME as created_in_center_timestamp
		,cast(TDATETIME as date) as created_in_center_date
		,TDATETIME as closed_in_center_timestamp
		,cast(TDATETIME as date) as closed_in_center_date
		,TDATETIME as payment_in_center_timestamp
		,cast(TDATETIME as date) as payment_in_center_date
		,pt.namount as payment_amount
		,pt.namount as payment_amount_adj
		,IPAYTYPEID as payment_amount_type
		,IPAYTYPEID as payment_type_id
		,th.iid as transaction_id
		,ILOGINID as etl_user_id
		--,null as invoice_source_id
		--,null as appointment_id
		--,null as app_group_id
		--,null as podid
		,case
			when LVOID = 'FALSE' then 0
			else 1
		end as void
		--,null as payment_num
		--,null as receipt_num
		--,null as payment_mode_data
		--,null as payment_option_type
		,pt.nccfee as cc_transaction_fee
		,pt.namount as amount_by_payment
		,pt.ICREDITAUTHID as approval_number
		--,null as credit_card_last_four
		--,null as dispute_amount
		--,null as dispute_status
		--,null as dispute_reason
		--,null as dispute_timestamp
		--,null as dispute_date
		--,null as charged_back_amount
		--,null as dispute_fee
		--,null as respond_by_timestamp
		--,null as respond_by_date
		--,null as etl_created_date
		--,null as cc_transaction_id
		,LNONMONETARY as revenue_rec
	FROM (SELECT iid, ilocationid, ipaytypeid, iheaderid, namount, nccfee, ICREDITAUTHID FROM dbo.PayType) pt
	LEFT OUTER JOIN dbo.CreditCards cc
		ON pt.ipaytypeid = cc.iid
		AND cc.ilocationid = pt.ilocationid
	LEFT OUTER JOIN dbo.TransHead th
		ON th.iid = pt.iheaderid
		AND pt.ilocationid = th.ilocationid
)
, paymentYearlyCounts AS (
	SELECT
		YEAR(created_in_center_date) AS [Year]
		, COUNT(*) AS [RowCount]
		, COUNT(DISTINCT payment_id) AS DistinctPaymentIds
	FROM Amperity_Payments
	WHERE created_in_center_date <= CAST('2021-03-31' AS DATE)
	GROUP BY YEAR(created_in_center_date)
)
SELECT * FROM paymentYearlyCounts ORDER BY [Year]

--------------------------------------Unique Centers by Year------------------------------------------

Amperity:
WITH paymentCounts AS (
  SELECT source_id
  	,YEAR(created_in_center_date) AS Year
  	, COUNT(*) AS PaymentsRowCount
  	, COUNT(DISTINCT payment_id) AS PaymentIdsCount
	, COUNT(DISTINCT center_id) AS DistinctLocations
    , COUNT(DISTINCT user_id) AS DistinctPayors
  FROM Events_Payments
  WHERE source_id = 2
  	AND created_in_center_date <= CAST('2021-03-31' AS DATE)
  GROUP BY source_id, YEAR(created_in_center_date)
  UNION ALL
  SELECT source_id
  	,YEAR(created_in_center_date) AS Year
  	, COUNT(*) AS PaymentsRowCount
  	, COUNT(DISTINCT payment_id) AS PaymentIdsCount
	, COUNT(DISTINCT center_id) AS DistinctLocations
    , COUNT(DISTINCT user_id) AS DistinctPayors
  FROM Events_Payments
  WHERE source_id = 1
  	AND created_in_center_date <= CAST('2021-03-31' AS DATE)
  GROUP BY source_id, YEAR(created_in_center_date)
)
SELECT DISTINCT
	pc.Year
	,(SELECT DistinctLocations FROM paymentCounts WHERE source_id = 2 AND Year = pc.Year) AS ZDistinctLocations
    , (SELECT DistinctLocations FROM paymentCounts WHERE source_id = 1 AND Year = pc.Year) AS MDistinctLocations
FROM paymentCounts pc
ORDER BY pc.Year

Zenoti:
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
	DATE_PART_YEAR(created_in_center_date) AS Year
	, COUNT(DISTINCT center_id) AS DistinctLocations
FROM Amperity_Payments
WHERE created_in_center_date <= CAST('2021-03-31' AS DATE)
GROUP BY Year
ORDER BY Year

MillenniumCo:
WITH Amperity_Payments AS (
	SELECT
		pt.iid as payment_id
		--,1 as source
		--,null as zenoti_payment_id
		,pt.ilocationid as center_id
		--,null as sale_center_id
		,th.iclientid as user_id
		--,null as item_type_id
		--,null as item_id
		,th.CINVOICENO as invoice_num
		,th.iid as invoice_id
		--,null as invoice_item_id
		--,null as product_id
		--,null as service_id
		--,null as package_version_id
		--,null as giftcard_id
		--,null as membership_id
		--,null as paid_by_membership
		--,null as paid_by_pp_cg_user_id
		--,null as paid_by_agent_id
		--,null as payment_mode_number
		--,null as org_payment_option_id
		,ILOGINID as sale_by_id
		--,null as invoice_status
		,ILOGINID as closed_by_user_id
		,ILOGINID as created_by_user_id
		,TDATETIME as sale_timestamp
		,cast(TDATETIME as date) as sale_date
		,TDATETIME as created_in_center_timestamp
		,cast(TDATETIME as date) as created_in_center_date
		,TDATETIME as closed_in_center_timestamp
		,cast(TDATETIME as date) as closed_in_center_date
		,TDATETIME as payment_in_center_timestamp
		,cast(TDATETIME as date) as payment_in_center_date
		,pt.namount as payment_amount
		,pt.namount as payment_amount_adj
		,IPAYTYPEID as payment_amount_type
		,IPAYTYPEID as payment_type_id
		,th.iid as transaction_id
		,ILOGINID as etl_user_id
		--,null as invoice_source_id
		--,null as appointment_id
		--,null as app_group_id
		--,null as podid
		,case
			when LVOID = 'FALSE' then 0
			else 1
		end as void
		--,null as payment_num
		--,null as receipt_num
		--,null as payment_mode_data
		--,null as payment_option_type
		,pt.nccfee as cc_transaction_fee
		,pt.namount as amount_by_payment
		,pt.ICREDITAUTHID as approval_number
		--,null as credit_card_last_four
		--,null as dispute_amount
		--,null as dispute_status
		--,null as dispute_reason
		--,null as dispute_timestamp
		--,null as dispute_date
		--,null as charged_back_amount
		--,null as dispute_fee
		--,null as respond_by_timestamp
		--,null as respond_by_date
		--,null as etl_created_date
		--,null as cc_transaction_id
		,LNONMONETARY as revenue_rec
	FROM (SELECT iid, ilocationid, ipaytypeid, iheaderid, namount, nccfee, ICREDITAUTHID FROM dbo.PayType) pt
	LEFT OUTER JOIN dbo.CreditCards cc
		ON pt.ipaytypeid = cc.iid
		AND cc.ilocationid = pt.ilocationid
	LEFT OUTER JOIN dbo.TransHead th
		ON th.iid = pt.iheaderid
		AND pt.ilocationid = th.ilocationid
)
, paymentYearlyCounts AS (
	SELECT
		YEAR(created_in_center_date) AS [Year]
		, COUNT(DISTINCT center_id) AS DistinctLocations
	FROM Amperity_Payments
	WHERE created_in_center_date <= CAST('2021-03-31' AS DATE)
	GROUP BY YEAR(created_in_center_date)
)
SELECT * FROM paymentYearlyCounts ORDER BY [Year]

---------------------------------Payors By Center-----------------------------------------

Amperity:
WITH paymentCounts AS (
  SELECT source_id
  	,YEAR(created_in_center_date) AS Year
  	, COUNT(*) AS PaymentsRowCount
  	, COUNT(DISTINCT payment_id) AS PaymentIdsCount
	, COUNT(DISTINCT center_id) AS DistinctLocations
    , COUNT(DISTINCT user_id) AS DistinctPayors
  FROM Events_Payments
  WHERE source_id = 2
  	AND created_in_center_date <= CAST('2021-03-31' AS DATE)
  GROUP BY source_id, YEAR(created_in_center_date)
  UNION ALL
  SELECT source_id
  	,YEAR(created_in_center_date) AS Year
  	, COUNT(*) AS PaymentsRowCount
  	, COUNT(DISTINCT payment_id) AS PaymentIdsCount
	, COUNT(DISTINCT center_id) AS DistinctLocations
    , COUNT(DISTINCT user_id) AS DistinctPayors
  FROM Events_Payments
  WHERE source_id = 1
  	AND created_in_center_date <= CAST('2021-03-31' AS DATE)
  GROUP BY source_id, YEAR(created_in_center_date)
)
SELECT DISTINCT
	pc.Year
	,(SELECT DistinctPayors FROM paymentCounts WHERE source_id = 2 AND Year = pc.Year) AS ZDistinctPayors
    , (SELECT DistinctPayors FROM paymentCounts WHERE source_id = 1 AND Year = pc.Year) AS MDistinctPayors
FROM paymentCounts pc
ORDER BY pc.Year

Zenoti:
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
	DATE_PART_YEAR(created_in_center_date) AS Year
	, COUNT(DISTINCT user_id) AS DistinctPayors
FROM Amperity_Payments
WHERE created_in_center_date <= CAST('2021-03-31' AS DATE)
GROUP BY Year
ORDER BY Year

MillenniumCo:
WITH Amperity_Payments AS (
	SELECT
		pt.iid as payment_id
		--,1 as source
		--,null as zenoti_payment_id
		,pt.ilocationid as center_id
		--,null as sale_center_id
		,th.iclientid as user_id
		--,null as item_type_id
		--,null as item_id
		,th.CINVOICENO as invoice_num
		,th.iid as invoice_id
		--,null as invoice_item_id
		--,null as product_id
		--,null as service_id
		--,null as package_version_id
		--,null as giftcard_id
		--,null as membership_id
		--,null as paid_by_membership
		--,null as paid_by_pp_cg_user_id
		--,null as paid_by_agent_id
		--,null as payment_mode_number
		--,null as org_payment_option_id
		,ILOGINID as sale_by_id
		--,null as invoice_status
		,ILOGINID as closed_by_user_id
		,ILOGINID as created_by_user_id
		,TDATETIME as sale_timestamp
		,cast(TDATETIME as date) as sale_date
		,TDATETIME as created_in_center_timestamp
		,cast(TDATETIME as date) as created_in_center_date
		,TDATETIME as closed_in_center_timestamp
		,cast(TDATETIME as date) as closed_in_center_date
		,TDATETIME as payment_in_center_timestamp
		,cast(TDATETIME as date) as payment_in_center_date
		,pt.namount as payment_amount
		,pt.namount as payment_amount_adj
		,IPAYTYPEID as payment_amount_type
		,IPAYTYPEID as payment_type_id
		,th.iid as transaction_id
		,ILOGINID as etl_user_id
		--,null as invoice_source_id
		--,null as appointment_id
		--,null as app_group_id
		--,null as podid
		,case
			when LVOID = 'FALSE' then 0
			else 1
		end as void
		--,null as payment_num
		--,null as receipt_num
		--,null as payment_mode_data
		--,null as payment_option_type
		,pt.nccfee as cc_transaction_fee
		,pt.namount as amount_by_payment
		,pt.ICREDITAUTHID as approval_number
		--,null as credit_card_last_four
		--,null as dispute_amount
		--,null as dispute_status
		--,null as dispute_reason
		--,null as dispute_timestamp
		--,null as dispute_date
		--,null as charged_back_amount
		--,null as dispute_fee
		--,null as respond_by_timestamp
		--,null as respond_by_date
		--,null as etl_created_date
		--,null as cc_transaction_id
		,LNONMONETARY as revenue_rec
	FROM (SELECT iid, ilocationid, ipaytypeid, iheaderid, namount, nccfee, ICREDITAUTHID FROM dbo.PayType) pt
	LEFT OUTER JOIN dbo.CreditCards cc
		ON pt.ipaytypeid = cc.iid
		AND cc.ilocationid = pt.ilocationid
	LEFT OUTER JOIN dbo.TransHead th
		ON th.iid = pt.iheaderid
		AND pt.ilocationid = th.ilocationid
)
, paymentYearlyCounts AS (
	SELECT
		YEAR(created_in_center_date) AS [Year]
		, COUNT(DISTINCT user_id) AS DistinctPayors
	FROM Amperity_Payments
	WHERE created_in_center_date <= CAST('2021-03-31' AS DATE)
	GROUP BY YEAR(created_in_center_date)
)
SELECT * FROM paymentYearlyCounts ORDER BY [Year]

---------------------------------Voided BY Year-----------------------------------------

Amperity:
WITH paymentCounts AS (
  SELECT source_id
  	,YEAR(created_in_center_date) AS Year
  	, COUNT(*) AS PaymentsRowCount
  	, COUNT(DISTINCT payment_id) AS PaymentIdsCount
	, COUNT(DISTINCT center_id) AS DistinctLocations
    , COUNT(DISTINCT user_id) AS DistinctPayors
  	, COUNT(void) AS VoidedPayments
  FROM Events_Payments
  WHERE source_id = 2
  	AND created_in_center_date <= CAST('2021-03-31' AS DATE)
  GROUP BY source_id, YEAR(created_in_center_date)
  UNION ALL
  SELECT source_id
  	,YEAR(created_in_center_date) AS Year
  	, COUNT(*) AS PaymentsRowCount
  	, COUNT(DISTINCT payment_id) AS PaymentIdsCount
	, COUNT(DISTINCT center_id) AS DistinctLocations
    , COUNT(DISTINCT user_id) AS DistinctPayors
  	, COUNT(void) AS VoidedPayments
  FROM Events_Payments
  WHERE source_id = 1
  	AND created_in_center_date <= CAST('2021-03-31' AS DATE)
  GROUP BY source_id, YEAR(created_in_center_date)
)
SELECT DISTINCT
	pc.Year
	,(SELECT VoidedPayments FROM paymentCounts WHERE source_id = 2 AND Year = pc.Year) AS ZVoidedPayments
    , (SELECT VoidedPayments FROM paymentCounts WHERE source_id = 1 AND Year = pc.Year) AS MVoidedPayments
FROM paymentCounts pc
ORDER BY pc.Year

Zenoti:
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
	DATE_PART_YEAR(created_in_center_date) AS Year
	, COUNT(void) AS VoidedPayments
FROM Amperity_Payments
WHERE created_in_center_date <= CAST('2021-03-31' AS DATE)
GROUP BY Year
ORDER BY Year

MillenniumCO:
WITH Amperity_Payments AS (
	SELECT
		pt.iid as payment_id
		--,1 as source
		--,null as zenoti_payment_id
		,pt.ilocationid as center_id
		--,null as sale_center_id
		,th.iclientid as user_id
		--,null as item_type_id
		--,null as item_id
		,th.CINVOICENO as invoice_num
		,th.iid as invoice_id
		--,null as invoice_item_id
		--,null as product_id
		--,null as service_id
		--,null as package_version_id
		--,null as giftcard_id
		--,null as membership_id
		--,null as paid_by_membership
		--,null as paid_by_pp_cg_user_id
		--,null as paid_by_agent_id
		--,null as payment_mode_number
		--,null as org_payment_option_id
		,ILOGINID as sale_by_id
		--,null as invoice_status
		,ILOGINID as closed_by_user_id
		,ILOGINID as created_by_user_id
		,TDATETIME as sale_timestamp
		,cast(TDATETIME as date) as sale_date
		,TDATETIME as created_in_center_timestamp
		,cast(TDATETIME as date) as created_in_center_date
		,TDATETIME as closed_in_center_timestamp
		,cast(TDATETIME as date) as closed_in_center_date
		,TDATETIME as payment_in_center_timestamp
		,cast(TDATETIME as date) as payment_in_center_date
		,pt.namount as payment_amount
		,pt.namount as payment_amount_adj
		,IPAYTYPEID as payment_amount_type
		,IPAYTYPEID as payment_type_id
		,th.iid as transaction_id
		,ILOGINID as etl_user_id
		--,null as invoice_source_id
		--,null as appointment_id
		--,null as app_group_id
		--,null as podid
		,case
			when LVOID = 'FALSE' then 0
			else 1
		end as void
		--,null as payment_num
		--,null as receipt_num
		--,null as payment_mode_data
		--,null as payment_option_type
		,pt.nccfee as cc_transaction_fee
		,pt.namount as amount_by_payment
		,pt.ICREDITAUTHID as approval_number
		--,null as credit_card_last_four
		--,null as dispute_amount
		--,null as dispute_status
		--,null as dispute_reason
		--,null as dispute_timestamp
		--,null as dispute_date
		--,null as charged_back_amount
		--,null as dispute_fee
		--,null as respond_by_timestamp
		--,null as respond_by_date
		--,null as etl_created_date
		--,null as cc_transaction_id
		,LNONMONETARY as revenue_rec
	FROM (SELECT iid, ilocationid, ipaytypeid, iheaderid, namount, nccfee, ICREDITAUTHID FROM dbo.PayType) pt
	LEFT OUTER JOIN dbo.CreditCards cc
		ON pt.ipaytypeid = cc.iid
		AND cc.ilocationid = pt.ilocationid
	LEFT OUTER JOIN dbo.TransHead th
		ON th.iid = pt.iheaderid
		AND pt.ilocationid = th.ilocationid
)
, paymentYearlyCounts AS (
	SELECT
		YEAR(created_in_center_date) AS [Year]
		, COUNT(void) AS VoidedPayments
	FROM Amperity_Payments
	WHERE created_in_center_date <= CAST('2021-03-31' AS DATE)
	GROUP BY YEAR(created_in_center_date)
)
SELECT * FROM paymentYearlyCounts ORDER BY [Year]
