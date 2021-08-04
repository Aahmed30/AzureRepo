-----------------------------Monetary Retail Purchase-----------------------------------
KPI:
SELECT fiscal_year,fiscal_month, Tender_Group_Type, round(sum(Retail_Revenue),2) as RetailRevenue
FROM KPI_Retail_Sales_By_tender_Group
WHERE fiscal_year = 2021
AND fiscal_month in (4,5,6) 
AND Sku_type = 'Retail'
group by fiscal_year,fiscal_month, Tender_Group_Type
ORDER BY fiscal_month,Tender_Group_Type

Events_Retail:
SELECT fiscal_month, tgt.Tender_Group_Type, round(SUM(Net_Amount),2) as RetailRevenue
FROM Events_Retail e
LEFT OUTER JOIN full_Datedimension d ON d.date = e.closed_date_in_center
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = e.Center_ID AND e.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = e.Center_ID AND e.Source_ID = 1
  LEFT OUTER JOIN Metric_0_Payment_Items m0 ON     m0.Transaction_ID = e.Invoice_id
                                                  AND m0.Unit_ID = e.invoice_item_id
                                                AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
LEFT OUTER JOIN Tender_group_type tgt ON tgt.Transaction_ID = e.Invoice_ID AND e.Invoice_Item_ID = tgt.Unit_ID
AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = tgt.center_id
WHERE fiscal_year = 2021
AND fiscal_month in (4,5,6)
AND void = false
AND m0.Transaction_ID IS NULL
AND tender_group_type <> ''
GROUP BY tgt.tender_group_Type, fiscal_month
order by fiscal_month,tgt.tender_group_Type

-----------------------------Non-Monetary Retail Redemption Value-----------------------------------
KPI:
SELECT fiscal_year,fiscal_month, Tender_Group_Type, round(sum(Retail_Revenue),2) as RetailRevenue
FROM KPI_Retail_Sales_By_tender_Group
WHERE fiscal_year = 2021
AND fiscal_month in (4,5,6) 
AND Sku_type = 'Retail'
group by fiscal_year,fiscal_month, Tender_Group_Type
ORDER BY fiscal_month,Tender_Group_Type

Events_Retail:
SELECT fiscal_month, tgt.Tender_Group_Type, round(SUM(Net_Amount),2) as RetailRevenue
FROM Events_Retail e
LEFT OUTER JOIN full_Datedimension d ON d.date = e.closed_date_in_center
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = e.Center_ID AND e.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = e.Center_ID AND e.Source_ID = 1
  LEFT OUTER JOIN Metric_0_Payment_Items m0 ON     m0.Transaction_ID = e.Invoice_id
                                                  AND m0.Unit_ID = e.invoice_item_id
                                                AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
LEFT OUTER JOIN Tender_group_type tgt ON tgt.Transaction_ID = e.Invoice_ID AND e.Invoice_Item_ID = tgt.Unit_ID
AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = tgt.center_id
WHERE fiscal_year = 2021
AND fiscal_month in (4,5,6)
AND void = false
AND m0.Transaction_ID IS NULL
AND tender_group_type <> ''
GROUP BY tgt.tender_group_Type, fiscal_month
order by fiscal_month,tgt.tender_group_Type

-----------------------------Hybrid Redemption Value-----------------------------------

KPI:
SELECT fiscal_year,fiscal_month, Tender_Group_Type, round(sum(Retail_Revenue),2) as RetailRevenue
FROM KPI_Retail_Sales_By_tender_Group
WHERE fiscal_year = 2021
AND fiscal_month in (4,5,6) 
AND Sku_type = 'Retail'
group by fiscal_year,fiscal_month, Tender_Group_Type
ORDER BY fiscal_month,Tender_Group_Type

Events_Retail:
SELECT fiscal_month, tgt.Tender_Group_Type, round(SUM(Net_Amount),2) as RetailRevenue
FROM Events_Retail e
LEFT OUTER JOIN full_Datedimension d ON d.date = e.closed_date_in_center
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = e.Center_ID AND e.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = e.Center_ID AND e.Source_ID = 1
  LEFT OUTER JOIN Metric_0_Payment_Items m0 ON     m0.Transaction_ID = e.Invoice_id
                                                  AND m0.Unit_ID = e.invoice_item_id
                                                AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
LEFT OUTER JOIN Tender_group_type tgt ON tgt.Transaction_ID = e.Invoice_ID AND e.Invoice_Item_ID = tgt.Unit_ID
AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = tgt.center_id
WHERE fiscal_year = 2021
AND fiscal_month in (4,5,6)
AND void = false
AND m0.Transaction_ID IS NULL
AND tender_group_type <> ''
GROUP BY tgt.tender_group_Type, fiscal_month
order by fiscal_month,tgt.tender_group_Type

-----------------------------Hybrid Retail Sale-----------------------------------

KPI:
SELECT fiscal_year,fiscal_month, Tender_Group_Type, round(sum(Retail_Revenue),2) as RetailRevenue
FROM KPI_Retail_Sales_By_tender_Group
WHERE fiscal_year = 2021
AND fiscal_month in (4,5,6) 
AND Sku_type = 'Retail'
group by fiscal_year,fiscal_month, Tender_Group_Type
ORDER BY fiscal_month,Tender_Group_Type

Events_Retail:
SELECT fiscal_month, tgt.Tender_Group_Type, round(SUM(Net_Amount),2) as RetailRevenue
FROM Events_Retail e
LEFT OUTER JOIN full_Datedimension d ON d.date = e.closed_date_in_center
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = e.Center_ID AND e.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = e.Center_ID AND e.Source_ID = 1
  LEFT OUTER JOIN Metric_0_Payment_Items m0 ON     m0.Transaction_ID = e.Invoice_id
                                                  AND m0.Unit_ID = e.invoice_item_id
                                                AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
LEFT OUTER JOIN Tender_group_type tgt ON tgt.Transaction_ID = e.Invoice_ID AND e.Invoice_Item_ID = tgt.Unit_ID
AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = tgt.center_id
WHERE fiscal_year = 2021
AND fiscal_month in (4,5,6)
AND void = false
AND m0.Transaction_ID IS NULL
AND tender_group_type <> ''
GROUP BY tgt.tender_group_Type, fiscal_month
order by fiscal_month,tgt.tender_group_Type

-----------------------------Total Systemwide Retail Sales-----------------------------------
KPI:
SELECT fiscal_year,fiscal_month, Tender_Group_Type, round(sum(Retail_Revenue),2) as RetailRevenue
FROM KPI_Retail_Sales_By_tender_Group
WHERE fiscal_year = 2021
AND fiscal_month in (4,5,6) 
AND Sku_type = 'Retail'
group by fiscal_year,fiscal_month, Tender_Group_Type
ORDER BY fiscal_month,Tender_Group_Type

Events_Retail:
SELECT fiscal_month, tgt.Tender_Group_Type, round(SUM(Net_Amount),2) as RetailRevenue
FROM Events_Retail e
LEFT OUTER JOIN full_Datedimension d ON d.date = e.closed_date_in_center
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = e.Center_ID AND e.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = e.Center_ID AND e.Source_ID = 1
  LEFT OUTER JOIN Metric_0_Payment_Items m0 ON     m0.Transaction_ID = e.Invoice_id
                                                  AND m0.Unit_ID = e.invoice_item_id
                                                AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
LEFT OUTER JOIN Tender_group_type tgt ON tgt.Transaction_ID = e.Invoice_ID AND e.Invoice_Item_ID = tgt.Unit_ID
AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = tgt.center_id
WHERE fiscal_year = 2021
AND fiscal_month in (4,5,6)
AND void = false
AND m0.Transaction_ID IS NULL
AND tender_group_type <> ''
GROUP BY tgt.tender_group_Type, fiscal_month
order by fiscal_month,tgt.tender_group_Type