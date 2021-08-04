select 'Unlimited Pass' AS Event_Type,
  s.source_id,
  ppe.service_package_id as wax_pass_id,
  s.invoice_id as Transaction_ID,
  s.invoice_item_id as Unit_ID,
  COALESCE(zcr.Franconnect_Center_ID, mcr.Franconnect_Center_ID) AS Center_ID,
  cast(ppe.net_amount as double) as Sale_Price,
  cast(s.purchase_date as timestamp) as Sale_Date,
  cast(s.recognized_revenue as double) as RevRec_Value,
  cast(recognized_date as timestamp) as RevRec_Date
from Lookups_UnlimitedSchedule s
  inner join events_package_purchases ppe on s.package_purchase_event_id = ppe.package_purchase_event_id
  and s.invoice_id = ppe.invoice_id and s.invoice_item_id = ppe.invoice_item_id and s.center_id = ppe.center_id and cast(s.source_id as int) = ppe.source_id
  LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ppe.Center_ID AND CAST(ppe.source_ID AS INT) = 2
  LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ppe.Center_ID AND CAST(ppe.source_ID AS INT) = 1
where cast(recognized as boolean) = true
AND s.source_id = '2'
AND recognized_date >= '2021-03-01 00:00:00'--cast('2019-04-01 00:00:00' as timestamp) 
AND recognized_date <= '2021-03-31 11:59:00'--Cast('2019-04-30 11:59:00' as timestamp) 
AND COALESCE(zcr.Franconnect_Center_ID, mcr.Franconnect_Center_ID) = '0701'
AND s.invoice_id = '313b1b42-fd91-4155-8186-d425cf1b0423'

