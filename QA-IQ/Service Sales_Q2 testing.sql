Scenario #3
Expected

WITH Net AS (
SELECT fc.fiscal_month, fc.fiscal_Year, 'Net Service' AS SKU_Type, SKU_Name, Tender_Group_Type, Revenue_Type, SUM(RevRec_Value) AS Service_Revenue, mrp.Center_ID
FROM Metric_Service_Base mrp
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
  AND center_ID <> '9999'
GROUP BY fc.fiscal_month, fc.fiscal_Year, Tender_Group_Type,SKU_Name, Revenue_Type, mrp.Center_ID
ORDER BY fc.fiscal_Year, fc.Fiscal_Month
),
KPI_Service_Sales_By_Center as (
SELECT fc.fiscal_month, fc.fiscal_Year, SKU_Type, SKU_name, Tender_Group_Type, Revenue_Type, SUM(RevRec_Value)  AS Service_Revenue, mrp.Center_ID
FROM Metric_Service_Base mrp
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
 AND center_ID <> '9999'
GROUP BY fc.fiscal_month, fc.fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, Revenue_Type, mrp.Center_ID
UNION
SELECT fiscal_month, fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, Revenue_Type, Service_Revenue, Center_ID
FROM Net
ORDER BY fiscal_Year, Fiscal_Month
)
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as ServiceRevenue, Sku_name, Tender_group_type--, Revenue_type
from KPI_Service_Sales_By_Center
where sku_type= 'Service'
AND fiscal_year = 2021
AND fiscal_month in (4,5,6)
--and fiscal_month =4
--in(1,2,3)
and center_id = '0497'
and lower(sku_name) like lower('%Eyebrows%')
--('%Butt (Strip)%')
and tender_group_type = 'Non-Monetary'
--and revenue_type = 'Monetary'
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type--, Revenue_type
ORDER BY fiscal_month



fiscal_year
fiscal_month
Center_ID
Sku_type
ServiceRevenue
Sku_name
Tender_group_type
2021	5	0497	Service	63.0	Eyebrows	Non-Monetary
2021	6	0497	Service	21.0	Eyebrows	Non-Monetary


Columbia - The Metropolitan (Large Center) and Womens Bikini (Brazilian) (Service SKU)

Scenario #3
Actual

SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,
		round(SUM(Net_amount),2) as Service_Revenue, COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name) as CenterName,
		COALESCE(mp.CDescript,zp.Servicename) AS SKU_Name, bb.tender_group_type
FROM Events_Services ep
		LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
		LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
		LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id AND mp.ilocationid = ep.center_id AND ep.source_id= 1
		LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2
		LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
		LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 
		AND ep.invoice_item_id = bb.Unit_ID
		and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id 
		LEFT OUTER JOIN Metric_0_Payment_Items mpt ON mpt.Transaction_ID = ep.Invoice_id
		AND mpt.Unit_ID = ep.invoice_item_id
		AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
		AND mpt.Source_ID = ep.Source_ID
		AND mpt.Unit_ID is null
    WHERE dd.fiscal_year = 2021 
    AND dd.Fiscal_month in (4,5,6)
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0497'
    AND lower(COALESCE(mp.CDescript,zp.Servicename)) like lower('%Eyebrows%') 
    AND bb.tender_group_type = 'Non-Monetary'
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.Servicename), 
bb.tender_group_type, COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name)
ORDER BY Fiscal_Year, Fiscal_month

Fiscal_Year
Fiscal_Month
Center_ID
Sku_type
Service_Revenue
CenterName
SKU_Name
tender_group_type
2021	5	0497	Service	63.0	Columbia - The Metropolitan	Eyebrows	Non-Monetary
2021	6	0497	Service	21.0	Columbia - The Metropolitan	Eyebrows	Non-Monetary



Expected

WITH Net AS (
SELECT fc.fiscal_month, fc.fiscal_Year, 'Net Service' AS SKU_Type, SKU_Name, Tender_Group_Type, Revenue_Type, SUM(RevRec_Value) AS Service_Revenue, mrp.Center_ID
FROM Metric_Service_Base mrp
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
  AND center_ID <> '9999'
GROUP BY fc.fiscal_month, fc.fiscal_Year, Tender_Group_Type,SKU_Name, Revenue_Type, mrp.Center_ID
ORDER BY fc.fiscal_Year, fc.Fiscal_Month
),
KPI_Service_Sales_By_Center as (
SELECT fc.fiscal_month, fc.fiscal_Year, SKU_Type, SKU_name, Tender_Group_Type, Revenue_Type, SUM(RevRec_Value)  AS Service_Revenue, mrp.Center_ID
FROM Metric_Service_Base mrp
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
 AND center_ID <> '9999'
GROUP BY fc.fiscal_month, fc.fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, Revenue_Type, mrp.Center_ID
UNION
SELECT fiscal_month, fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, Revenue_Type, Service_Revenue, Center_ID
FROM Net
ORDER BY fiscal_Year, Fiscal_Month
)
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as ServiceRevenue, Sku_name, Tender_group_type--, Revenue_type
from KPI_Service_Sales_By_Center
where sku_type= 'Service'
AND fiscal_year = 2021
AND fiscal_month in (4,5,6)
--and fiscal_month =4
--in(1,2,3)
and center_id = '0130'
and lower(sku_name) like lower('%Eyebrows%')
--('%Butt (Strip)%')
and tender_group_type = 'Non-Monetary'
--and revenue_type = 'Monetary'
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type--, Revenue_type
ORDER BY fiscal_month

Scenario #3
Actual

SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,
		round(SUM(Net_amount),2) as Service_Revenue, COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name) as CenterName,
		COALESCE(mp.CDescript,zp.Servicename) AS SKU_Name, bb.tender_group_type
FROM Events_Services ep
		LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
		LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
		LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id AND mp.ilocationid = ep.center_id AND ep.source_id= 1
		LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2
		LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
		LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 
		AND ep.invoice_item_id = bb.Unit_ID
		and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id 
		LEFT OUTER JOIN Metric_0_Payment_Items mpt ON mpt.Transaction_ID = ep.Invoice_id
		AND mpt.Unit_ID = ep.invoice_item_id
		AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
		AND mpt.Source_ID = ep.Source_ID
		AND mpt.Unit_ID is null
    WHERE dd.fiscal_year = 2021 
    AND dd.Fiscal_month in (4,5,6)
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0130'
    AND lower(COALESCE(mp.CDescript,zp.Servicename)) like lower('%Eyebrows%') 
    AND bb.tender_group_type = 'Non-Monetary'
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.Servicename), 
bb.tender_group_type, COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name)
ORDER BY Fiscal_Year, Fiscal_month

