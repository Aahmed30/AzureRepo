WITH TLog AS (

SELECT Event_type,
Transaction_ID,
Unit_ID,
Center_ID,
RevRec_Date,
RevRec_Value
FROM RevRec_Combined
WHERE RevRec_Value > 0
AND Event_Type in ('Service', 'Retail', 'Fixed Pass','Refund')

 UNION ALL

 SELECT 'Unlimited Pass' as Event_type,
Invoice_iD as Transaction_ID,
COALESCE(epr.redemption_invoice_item_id, epr.Package_redemption_ID) as Unit_ID,
COALESCE(zcr.Franconnect_Center_ID, mcr.Franconnect_Center_ID) as Center_ID,
CAST(epr.redemption_timestamp AS DATE) as RevRec_Date,
0 as RevRec_Value
FROM events_package_redemptions epr
LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = epr.Center_ID AND epr.source_id = 2
LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = epr.Center_ID AND epr.source_id = 1
WHERE epr.Is_unlimited = 1
)

SELECT
Transaction_id
,Event_type
,Center_Id
,RevRec_date
,RevRec_Value
FROM TLog
WHERE Revrec_Date >= cast('2021-04-01 00:00:00' as timestamp) AND Revrec_Date<= Cast('2021-06-30 11:59:00' as timestamp)
AND Event_type = 'Service'
AND Transaction_id = 'f4277bce-5320-42cc-8b91-a8ff7f7269e4'