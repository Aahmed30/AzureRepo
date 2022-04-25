Scenario #1 EdgeWater
Expected

SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,												
 round(SUM(Net_amount),2) as RetailRevenue												
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type												
FROM Events_Services ep												
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2												
      LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1												
    --LEFT OUTER JOIN Millennium_Products mp ON mp.iid = ep.item_id AND mp.ilocationid = ep.center_id AND ep.source_id = 1												
    --LEFT OUTER JOIN Zenoti_Bidimproduct zp ON zp.productwid = ep.product_id AND ep.source_ID = 2												
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center												
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1												
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2												
        												
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 												
 	 AND ep.invoice_item_id = bb.Unit_ID											
                                         	and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id 											
      LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = ep.Invoice_id												
                                                  AND mpt.Unit_ID = ep.invoice_item_id												
                                                  AND mpt.Center_ID =                                  COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)												
                                                AND mpt.Source_ID = ep.Source_ID												
    and  mpt.Unit_ID is null                                     												
    WHERE dd.fiscal_year = 2021												
    and  dd.fiscal_month in(6,7,8,9)												
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0052'												
    and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Bikini Full (v)%') AND  bb.tender_group_type = 'Monetary'												
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type												
ORDER BY Fiscal_Year, Fiscal_month												
    --'MASK ME SLEEP MASK%' 												
    
    
Scenario #1 Edgewater
Actual
    
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
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, Revenue_type												
from KPI_Service_Sales_By_Center												
where sku_type= 'Service'												
AND fiscal_year = 2021												
and fiscal_month in (6,7,8,9)										
and center_id = '0052'												
and lower(sku_name) like lower('%Bikini Full (v)%')												
and tender_group_type = 'Monetary'												
--and revenue_type = 'Monetary'												
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type--, Revenue_type												
ORDER BY fiscal_month												
------------------------------------------------------------------------------



------------------------------------------------------------------------------
Scenario #1 estero
Expected

SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,												
 round(SUM(Net_amount),2) as RetailRevenue												
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type												
FROM Events_Services ep												
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2												
      LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1												
    --LEFT OUTER JOIN Millennium_Products mp ON mp.iid = ep.item_id AND mp.ilocationid = ep.center_id AND ep.source_id = 1												
    --LEFT OUTER JOIN Zenoti_Bidimproduct zp ON zp.productwid = ep.product_id AND ep.source_ID = 2												
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center												
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1												
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2												
        												
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 												
 	 AND ep.invoice_item_id = bb.Unit_ID											
                                         	and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id 											
      LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = ep.Invoice_id												
                                                  AND mpt.Unit_ID = ep.invoice_item_id												
                                                  AND mpt.Center_ID =                                  COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)												
                                                AND mpt.Source_ID = ep.Source_ID												
    and  mpt.Unit_ID is null                                     												
    WHERE dd.fiscal_year = 2021												
    and  dd.fiscal_month in(6,7,8,9)												
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0137'												
    and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Butt Full (V)%') AND  bb.tender_group_type = 'Monetary'												
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type												
ORDER BY Fiscal_Year, Fiscal_month												
    --'MASK ME SLEEP MASK%' 												

    
Scenario #1 Estero
Actual
    
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
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, Revenue_type												
from KPI_Service_Sales_By_Center												
where sku_type= 'Service'												
AND fiscal_year = 2021												
and fiscal_month in (6,7,8,9)										
and center_id = '0137'												
and lower(sku_name) like lower('%Butt Full (V)%')												
and tender_group_type = 'Monetary'												
--and revenue_type = 'Monetary'												
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type--, Revenue_type												
ORDER BY fiscal_month												
------------------------------------------------------------------------------
Scenario #1 Bloomingdale
Expected

SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,												
 round(SUM(Net_amount),2) as RetailRevenue												
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type												
FROM Events_Services ep												
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2												
      LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1												
    --LEFT OUTER JOIN Millennium_Products mp ON mp.iid = ep.item_id AND mp.ilocationid = ep.center_id AND ep.source_id = 1												
    --LEFT OUTER JOIN Zenoti_Bidimproduct zp ON zp.productwid = ep.product_id AND ep.source_ID = 2												
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center												
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1												
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2												
        												
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 												
 	 AND ep.invoice_item_id = bb.Unit_ID											
                                         	and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id 											
      LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = ep.Invoice_id												
                                                  AND mpt.Unit_ID = ep.invoice_item_id												
                                                  AND mpt.Center_ID =                                  COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)												
                                                AND mpt.Source_ID = ep.Source_ID												
    and  mpt.Unit_ID is null                                     												
    WHERE dd.fiscal_year = 2021												
    and  dd.fiscal_month in(6,7,8,9)												
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0794'												
    and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Nose%') AND  bb.tender_group_type = 'Monetary'												
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type												
ORDER BY Fiscal_Year, Fiscal_month												
    --'MASK ME SLEEP MASK%' 												
    
    
Scenario #1 Bloomingdale
Actual
    
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
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, Revenue_type												
from KPI_Service_Sales_By_Center												
where sku_type= 'Service'												
AND fiscal_year = 2021												
and fiscal_month in (6,7,8,9)										
and center_id = '0794'												
and lower(sku_name) like lower('%Nose%')												
and tender_group_type = 'Monetary'												
--and revenue_type = 'Monetary'												
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type--, Revenue_type												
ORDER BY fiscal_month



------------------------------------------------------------------------------
Scenario #1 Philadelphia - Frankford Ave (0961)
Expected

SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,												
 round(SUM(Net_amount),2) as RetailRevenue												
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type												
FROM Events_Services ep												
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2												
      LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1												
    --LEFT OUTER JOIN Millennium_Products mp ON mp.iid = ep.item_id AND mp.ilocationid = ep.center_id AND ep.source_id = 1												
    --LEFT OUTER JOIN Zenoti_Bidimproduct zp ON zp.productwid = ep.product_id AND ep.source_ID = 2												
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center												
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1												
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2												
        												
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 												
 	 AND ep.invoice_item_id = bb.Unit_ID											
                                         	and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id 											
      LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = ep.Invoice_id												
                                                  AND mpt.Unit_ID = ep.invoice_item_id												
                                                  AND mpt.Center_ID =                                  COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)												
                                                AND mpt.Source_ID = ep.Source_ID												
    and  mpt.Unit_ID is null                                     												
    WHERE dd.fiscal_year = 2021												
    and  dd.fiscal_month in(6,7,8,9)												
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0961'									
    and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Nose%') AND  bb.tender_group_type = 'Monetary'												
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type												
ORDER BY Fiscal_Year, Fiscal_month												
    --'MASK ME SLEEP MASK%' 												
    
    
Scenario #1 Philadelphia - Frankford Ave (0961)
Actual
    
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
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, Revenue_type												
from KPI_Service_Sales_By_Center												
where sku_type= 'Service'												
AND fiscal_year = 2021												
and fiscal_month in (6,7,8,9)										
and center_id = '0961'												
and lower(sku_name) like lower('%Nose%')												
and tender_group_type = 'Monetary'												
--and revenue_type = 'Monetary'												
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type--, Revenue_type												
ORDER BY fiscal_month


------------------------------------------------------------------------------


Scenario #3 Columbia
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
AND fiscal_month in (6,7,8,9)
--and fiscal_month =4
--in(1,2,3)
and center_id = '0497'
and lower(sku_name) like lower('%Bikini Full (v)%')
--('%Butt (Strip)%')
and tender_group_type = 'Non-Monetary'
--and revenue_type = 'Monetary'
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type--, Revenue_type
ORDER BY fiscal_month

Scenario #3 Columbia
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
    AND dd.Fiscal_month in (6,7,8,9)
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0497'
    AND lower(COALESCE(mp.CDescript,zp.Servicename)) like lower('%Bikini Full (v)%') 
    AND bb.tender_group_type = 'Non-Monetary'
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.Servicename), 
bb.tender_group_type, COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name)
ORDER BY Fiscal_Year, Fiscal_month
---------------------------------------------------------------------------------



Scenario #3 Teterboro
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
AND fiscal_month in (6,7,8,9)
--and fiscal_month =4
--in(1,2,3)
and center_id = '0130'
and lower(sku_name) like lower('%Bikini Full (v)%')
--('%Butt (Strip)%')
and tender_group_type = 'Non-Monetary'
--and revenue_type = 'Monetary'
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type--, Revenue_type
ORDER BY fiscal_month

Scenario #3 Teterboro
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
    AND dd.Fiscal_month in (6,7,8,9)
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0130'
    AND lower(COALESCE(mp.CDescript,zp.Servicename)) like lower('%Bikini Full (v)%') 
    AND bb.tender_group_type = 'Non-Monetary'
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.Servicename), 
bb.tender_group_type, COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name)
ORDER BY Fiscal_Year, Fiscal_month
------------------------------------------------------------------------



Scenario #3 union
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
AND fiscal_month in (6,7,8,9)
--and fiscal_month =4
--in(1,2,3)
and center_id = '0862'
and lower(sku_name) like lower('%tigh%')
--('%Butt (Strip)%')
and tender_group_type = 'Non-Monetary'
--and revenue_type = 'Monetary'
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type--, Revenue_type
ORDER BY fiscal_month

Scenario #3 union
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
    AND dd.Fiscal_month in (6,7,8,9)
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0862'
    AND lower(COALESCE(mp.CDescript,zp.Servicename)) like lower('%tigh%') 
    AND bb.tender_group_type = 'Non-Monetary'
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.Servicename), 
bb.tender_group_type, COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name)
ORDER BY Fiscal_Year, Fiscal_month
----------------------------------------------------------------------------------------------

Scenario #3 Burlington
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
AND fiscal_month in (6,7,8,9)
--and fiscal_month =4
--in(1,2,3)
and center_id = '0921'
and lower(sku_name) like lower('%Chest (Strip)%')
--('%Butt (Strip)%')
and tender_group_type = 'Non-Monetary'
--and revenue_type = 'Monetary'
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type--, Revenue_type
ORDER BY fiscal_month

Scenario #3 Burlington
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
    AND dd.Fiscal_month in (6,7,8,9)
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0921'
    AND lower(COALESCE(mp.CDescript,zp.Servicename)) like lower('%Chest (Strip)%') 
    AND bb.tender_group_type = 'Non-Monetary'
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.Servicename), 
bb.tender_group_type, COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name)
ORDER BY Fiscal_Year, Fiscal_month
----------------------------------------------------------------------------------------------------------

Scenario #5 Tucson

Events
0161
0138
0447
0866
																			
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,																			
 round(SUM(Net_amount),2) as RetailRevenue																			
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type--,mp.Tender_Type																			
FROM Events_Services ep																			
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2																			
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1																			
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center																			
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1																			
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2																			
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id AND ep.invoice_item_id = bb.Unit_ID																			
                                         	AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id																		
    /*LEFT OUTER JOIN metric_Pmt_type_total mp 																			
    ON 	mp.Transaction_ID = ep.Invoice_id																		
  	AND mp.Unit_ID = ep.invoice_item_id																		
    AND mp.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)  */                                      																			
    LEFT OUTER JOIN Metric_0_Payment_Items mpt 																			
      ON  mpt.Transaction_ID = ep.Invoice_id																			
      AND mpt.Unit_ID = ep.invoice_item_id																			
      AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)																			
      AND mpt.Source_ID = ep.Source_ID																			
       AND  mpt.Unit_ID is null  																			
       WHERE dd.fiscal_year=2021																			
       and  dd.Fiscal_Month in(6,7,8,9)																			
    --in(1,2,3)																			
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) ='0161' 																			
  and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Legs (Upper)%')																			
    --('%Butt (Strip)%') 																			
    --AND  bb.tender_group_type = 'Monetary'																			
    AND bb.tender_group_type = 'Hybrid' --and mp.Tender_Type = 'Non-Monetary'																			
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type--,mp.Tender_Type																			
ORDER BY Fiscal_Year, Fiscal_month																			
    --'MASK ME SLEEP MASK%' 																			
   																			
                                                                            
Scenario #5  Tucson
KPI

																	
    WITH Net AS (																	
SELECT fc.fiscal_month, fc.fiscal_Year, 'Net Service' AS SKU_Type, SKU_Name, Tender_Group_Type,SUM(RevRec_Value) AS Service_Revenue, mrp.Center_ID--,Revenue_Type 																	
FROM Metric_Service_Base mrp																	
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date																	
WHERE revenue_Type IS NOT NULL																	
  AND center_ID <> '9999'																	
GROUP BY fc.fiscal_month, fc.fiscal_Year, Tender_Group_Type,SKU_Name,mrp.Center_ID --,Revenue_Type																	
ORDER BY fc.fiscal_Year, fc.Fiscal_Month																	
),																	
KPI_Service_Sales_By_Center as (																	
SELECT fc.fiscal_month, fc.fiscal_Year, SKU_Type, SKU_name, Tender_Group_Type,  SUM(RevRec_Value)  AS Service_Revenue, mrp.Center_ID --,Revenue_Type																	
FROM Metric_Service_Base mrp																	
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date																	
WHERE revenue_Type IS NOT NULL																	
 AND center_ID <> '9999'																	
 GROUP BY fc.fiscal_month, fc.fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, mrp.Center_ID---, Revenue_Type																	
UNION																	
SELECT fiscal_month, fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, Service_Revenue, Center_ID--, Revenue_Type																	
FROM Net																	
ORDER BY fiscal_Year, Fiscal_Month																	
)																	
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, revenue_type																	
from KPI_Service_Sales_By_Center																	
where sku_type= 'Service'																	
AND fiscal_year = 2021
and Fiscal_Month in (6,7,8,9)
and center_id = '0161'																	
and lower(sku_name) like lower('%Legs (Upper)%')																	
--('%Butt (Strip)%')																	
and tender_group_type = 'Hybrid'																	
--and revenue_type = 'Non-Monetary'																	
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type---, Revenue_type																	
ORDER BY fiscal_month

-----------------------------------------------------------------------------------------
Scenario #5 Costa Mesa

Events
0161
0138
0447
0866
																			
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,																			
 round(SUM(Net_amount),2) as RetailRevenue																			
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type--,mp.Tender_Type																			
FROM Events_Services ep																			
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2																			
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1																			
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center																			
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1																			
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2																			
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id AND ep.invoice_item_id = bb.Unit_ID																			
                                         	AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id																		
    /*LEFT OUTER JOIN metric_Pmt_type_total mp 																			
    ON 	mp.Transaction_ID = ep.Invoice_id																		
  	AND mp.Unit_ID = ep.invoice_item_id																		
    AND mp.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)  */                                      																			
    LEFT OUTER JOIN Metric_0_Payment_Items mpt 																			
      ON  mpt.Transaction_ID = ep.Invoice_id																			
      AND mpt.Unit_ID = ep.invoice_item_id																			
      AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)																			
      AND mpt.Source_ID = ep.Source_ID																			
       AND  mpt.Unit_ID is null  																			
       WHERE dd.fiscal_year=2021																			
       and  dd.Fiscal_Month in(6,7,8,9)																			
    --in(1,2,3)																			
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) ='0138' 																			
  and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Nose%')																			
    --('%Butt (Strip)%') 																			
    --AND  bb.tender_group_type = 'Monetary'																			
    AND bb.tender_group_type = 'Hybrid' --and mp.Tender_Type = 'Non-Monetary'																			
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type--,mp.Tender_Type																			
ORDER BY Fiscal_Year, Fiscal_month																			
    --'MASK ME SLEEP MASK%' 																			
   																			
                                                                            
Scenario #5 Costa Mesa
KPI

																	
    WITH Net AS (																	
SELECT fc.fiscal_month, fc.fiscal_Year, 'Net Service' AS SKU_Type, SKU_Name, Tender_Group_Type,SUM(RevRec_Value) AS Service_Revenue, mrp.Center_ID--,Revenue_Type 																	
FROM Metric_Service_Base mrp																	
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date																	
WHERE revenue_Type IS NOT NULL																	
  AND center_ID <> '9999'																	
GROUP BY fc.fiscal_month, fc.fiscal_Year, Tender_Group_Type,SKU_Name,mrp.Center_ID --,Revenue_Type																	
ORDER BY fc.fiscal_Year, fc.Fiscal_Month																	
),																	
KPI_Service_Sales_By_Center as (																	
SELECT fc.fiscal_month, fc.fiscal_Year, SKU_Type, SKU_name, Tender_Group_Type,  SUM(RevRec_Value)  AS Service_Revenue, mrp.Center_ID --,Revenue_Type																	
FROM Metric_Service_Base mrp																	
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date																	
WHERE revenue_Type IS NOT NULL																	
 AND center_ID <> '9999'																	
 GROUP BY fc.fiscal_month, fc.fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, mrp.Center_ID---, Revenue_Type																	
UNION																	
SELECT fiscal_month, fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, Service_Revenue, Center_ID--, Revenue_Type																	
FROM Net																	
ORDER BY fiscal_Year, Fiscal_Month																	
)																	
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, revenue_type																	
from KPI_Service_Sales_By_Center																	
where sku_type= 'Service'																	
AND fiscal_year = 2021
and Fiscal_Month in (6,7,8,9)
and center_id = '0138'																	
and lower(sku_name) like lower('%Nose%')																	
--('%Butt (Strip)%')																	
and tender_group_type = 'Hybrid'																	
--and revenue_type = 'Non-Monetary'																	
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type---, Revenue_type																	
ORDER BY fiscal_month


							
-------------------------------------------------------------------------------------------------
Scenario #5 Federal Way

Events
0161
0138
0447
0866
																			
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,																			
 round(SUM(Net_amount),2) as RetailRevenue																			
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type--,mp.Tender_Type																			
FROM Events_Services ep																			
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2																			
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1																			
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center																			
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1																			
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2																			
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id AND ep.invoice_item_id = bb.Unit_ID																			
                                         	AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id																		
    /*LEFT OUTER JOIN metric_Pmt_type_total mp 																			
    ON 	mp.Transaction_ID = ep.Invoice_id																		
  	AND mp.Unit_ID = ep.invoice_item_id																		
    AND mp.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)  */                                      																			
    LEFT OUTER JOIN Metric_0_Payment_Items mpt 																			
      ON  mpt.Transaction_ID = ep.Invoice_id																			
      AND mpt.Unit_ID = ep.invoice_item_id																			
      AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)																			
      AND mpt.Source_ID = ep.Source_ID																			
       AND  mpt.Unit_ID is null  																			
       WHERE dd.fiscal_year=2021																			
       and  dd.Fiscal_Month in(6,7,8,9)																			
    --in(1,2,3)																			
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) ='0447' 																			
  and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Bikini Full (V)%')																			
    --('%Butt (Strip)%') 																			
    --AND  bb.tender_group_type = 'Monetary'																			
    AND bb.tender_group_type = 'Hybrid' --and mp.Tender_Type = 'Non-Monetary'																			
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type--,mp.Tender_Type																			
ORDER BY Fiscal_Year, Fiscal_month																			
    --'MASK ME SLEEP MASK%' 																			
   																			
                                                                            
Scenario #5 Federal Way
KPI

																	
    WITH Net AS (																	
SELECT fc.fiscal_month, fc.fiscal_Year, 'Net Service' AS SKU_Type, SKU_Name, Tender_Group_Type,SUM(RevRec_Value) AS Service_Revenue, mrp.Center_ID--,Revenue_Type 																	
FROM Metric_Service_Base mrp																	
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date																	
WHERE revenue_Type IS NOT NULL																	
  AND center_ID <> '9999'																	
GROUP BY fc.fiscal_month, fc.fiscal_Year, Tender_Group_Type,SKU_Name,mrp.Center_ID --,Revenue_Type																	
ORDER BY fc.fiscal_Year, fc.Fiscal_Month																	
),																	
KPI_Service_Sales_By_Center as (																	
SELECT fc.fiscal_month, fc.fiscal_Year, SKU_Type, SKU_name, Tender_Group_Type,  SUM(RevRec_Value)  AS Service_Revenue, mrp.Center_ID --,Revenue_Type																	
FROM Metric_Service_Base mrp																	
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date																	
WHERE revenue_Type IS NOT NULL																	
 AND center_ID <> '9999'																	
 GROUP BY fc.fiscal_month, fc.fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, mrp.Center_ID---, Revenue_Type																	
UNION																	
SELECT fiscal_month, fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, Service_Revenue, Center_ID--, Revenue_Type																	
FROM Net																	
ORDER BY fiscal_Year, Fiscal_Month																	
)																	
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, revenue_type																	
from KPI_Service_Sales_By_Center																	
where sku_type= 'Service'																	
AND fiscal_year = 2021
and Fiscal_Month in (6,7,8,9)
and center_id = '0447'																	
and lower(sku_name) like lower('%Bikini Full (V)%')																	
--('%Butt (Strip)%')																	
and tender_group_type = 'Hybrid'																	
--and revenue_type = 'Non-Monetary'																	
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type---, Revenue_type																	
ORDER BY fiscal_month
-------------------------------------------------------------------------------------------------------------------
Scenario #5 Altamonte Springs

Events
0161
0138
0447
0866
																			
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,																			
 round(SUM(Net_amount),2) as RetailRevenue																			
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type--,mp.Tender_Type																			
FROM Events_Services ep																			
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2																			
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1																			
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center																			
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1																			
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2																			
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id AND ep.invoice_item_id = bb.Unit_ID																			
                                         	AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id																		
    /*LEFT OUTER JOIN metric_Pmt_type_total mp 																			
    ON 	mp.Transaction_ID = ep.Invoice_id																		
  	AND mp.Unit_ID = ep.invoice_item_id																		
    AND mp.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)  */                                      																			
    LEFT OUTER JOIN Metric_0_Payment_Items mpt 																			
      ON  mpt.Transaction_ID = ep.Invoice_id																			
      AND mpt.Unit_ID = ep.invoice_item_id																			
      AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)																			
      AND mpt.Source_ID = ep.Source_ID																			
       AND  mpt.Unit_ID is null  																			
       WHERE dd.fiscal_year=2021																			
       and  dd.Fiscal_Month in(6,7,8,9)																			
    --in(1,2,3)																			
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) ='0866' 																			
  and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Chin%')																			
    --('%Butt (Strip)%') 																			
    --AND  bb.tender_group_type = 'Monetary'																			
    AND bb.tender_group_type = 'Hybrid' --and mp.Tender_Type = 'Non-Monetary'																			
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type--,mp.Tender_Type																			
ORDER BY Fiscal_Year, Fiscal_month																			
    --'MASK ME SLEEP MASK%' 																			
   																			
                                                                            
Scenario #5 Altamonte Springs
KPI

																	
    WITH Net AS (																	
SELECT fc.fiscal_month, fc.fiscal_Year, 'Net Service' AS SKU_Type, SKU_Name, Tender_Group_Type,SUM(RevRec_Value) AS Service_Revenue, mrp.Center_ID--,Revenue_Type 																	
FROM Metric_Service_Base mrp																	
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date																	
WHERE revenue_Type IS NOT NULL																	
  AND center_ID <> '9999'																	
GROUP BY fc.fiscal_month, fc.fiscal_Year, Tender_Group_Type,SKU_Name,mrp.Center_ID --,Revenue_Type																	
ORDER BY fc.fiscal_Year, fc.Fiscal_Month																	
),																	
KPI_Service_Sales_By_Center as (																	
SELECT fc.fiscal_month, fc.fiscal_Year, SKU_Type, SKU_name, Tender_Group_Type,  SUM(RevRec_Value)  AS Service_Revenue, mrp.Center_ID --,Revenue_Type																	
FROM Metric_Service_Base mrp																	
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date																	
WHERE revenue_Type IS NOT NULL																	
 AND center_ID <> '9999'																	
 GROUP BY fc.fiscal_month, fc.fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, mrp.Center_ID---, Revenue_Type																	
UNION																	
SELECT fiscal_month, fiscal_Year, SKU_Type,SKU_Name, Tender_Group_Type, Service_Revenue, Center_ID--, Revenue_Type																	
FROM Net																	
ORDER BY fiscal_Year, Fiscal_Month																	
)																	
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, revenue_type																	
from KPI_Service_Sales_By_Center																	
where sku_type= 'Service'																	
AND fiscal_year = 2021
and Fiscal_Month in (6,7,8,9)
and center_id = '0866'																	
and lower(sku_name) like lower('%Chin%')																	
--('%Butt (Strip)%')																	
and tender_group_type = 'Hybrid'																	
--and revenue_type = 'Non-Monetary'																	
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type---, Revenue_type																	
ORDER BY fiscal_month


							
							
---------------------------------------------------------------------------------------------------------------------------																	
Scenario #7 Arlington

Events Query

0733
0053
EWC - Wellington 0678
EWC - Murrieta 0486

																	
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,																	
 round(SUM(Net_amount),2) as RetailRevenue																	
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type,mp.Tender_Type																	
FROM Events_Services ep																	
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2																	
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1																	
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center																	
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1																	
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2																	
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id AND ep.invoice_item_id = bb.Unit_ID																	
                                         	AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id																
    LEFT OUTER JOIN metric_Pmt_type_total mp 																	
    ON 	mp.Transaction_ID = ep.Invoice_id																
  	AND mp.Unit_ID = ep.invoice_item_id																
    AND mp.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)                                        																	
    LEFT OUTER JOIN Metric_0_Payment_Items mpt 																	
      ON  mpt.Transaction_ID = ep.Invoice_id																	
      AND mpt.Unit_ID = ep.invoice_item_id																	
      AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)																	
      AND mpt.Source_ID = ep.Source_ID																	
       AND  mpt.Unit_ID is null  																	
       WHERE dd.fiscal_year = 2021																	
       and  dd.fiscal_month in(6,7,8,9)																	
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0733' 																	
   and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Bikini Full (V)%')																	
    --('%Butt (Strip)%') 																	
    --AND  bb.tender_group_type = 'Monetary'																	
    AND bb.tender_group_type = 'Hybrid' and mp.Tender_Type = 'Non-Monetary'																	
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type,mp.Tender_Type																	
ORDER BY Fiscal_Year, Fiscal_month																	
    --'MASK ME SLEEP MASK%' 																	
   																	
																	
																	
KPI Query																	
																	
																	
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
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type, revenue_type																	
from KPI_Service_Sales_By_Center																	
where sku_type= 'Service'																	
AND fiscal_year = 2021		
and fiscal_month in (6,7,8,9)
and center_id = '0733'																	
and lower(sku_name) like lower('%Bikini Full (V)%')																	
--('%Butt (Strip)%')																	
and tender_group_type = 'Hybrid'																	
and revenue_type = 'Non-Monetary'																	
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type, Revenue_type																	
ORDER BY fiscal_month																	
--------------------------------------------------------------------------------------------------------------------
Scenario #7 Houston

Events Query

0733
0053
EWC - Wellington 0678
EWC - Murrieta 0486

																	
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,																	
 round(SUM(Net_amount),2) as RetailRevenue																	
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type,mp.Tender_Type																	
FROM Events_Services ep																	
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2																	
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1																	
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center																	
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1																	
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2																	
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id AND ep.invoice_item_id = bb.Unit_ID																	
                                         	AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id																
    LEFT OUTER JOIN metric_Pmt_type_total mp 																	
    ON 	mp.Transaction_ID = ep.Invoice_id																
  	AND mp.Unit_ID = ep.invoice_item_id																
    AND mp.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)                                        																	
    LEFT OUTER JOIN Metric_0_Payment_Items mpt 																	
      ON  mpt.Transaction_ID = ep.Invoice_id																	
      AND mpt.Unit_ID = ep.invoice_item_id																	
      AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)																	
      AND mpt.Source_ID = ep.Source_ID																	
       AND  mpt.Unit_ID is null  																	
       WHERE dd.fiscal_year = 2021																	
       and  dd.fiscal_month in(6,7,8,9)																	
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0053' 																	
   and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Legs (Lower)%')																	
    --('%Butt (Strip)%') 																	
    --AND  bb.tender_group_type = 'Monetary'																	
    AND bb.tender_group_type = 'Hybrid' and mp.Tender_Type = 'Non-Monetary'																	
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type,mp.Tender_Type																	
ORDER BY Fiscal_Year, Fiscal_month																	
    --'MASK ME SLEEP MASK%' 																	
   																	
																	
																	
KPI Query																	
																	
																	
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
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type, revenue_type																	
from KPI_Service_Sales_By_Center																	
where sku_type= 'Service'																	
AND fiscal_year = 2021		
and fiscal_month in (6,7,8,9)
and center_id = '0053'																	
and lower(sku_name) like lower('%Legs (Lower)%')																	
--('%Butt (Strip)%')																	
and tender_group_type = 'Hybrid'																	
and revenue_type = 'Non-Monetary'																	
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type, Revenue_type																	
ORDER BY fiscal_month		
------------------------------------------------------------
Scenario #7 Wellington

Events Query

0733
0053
EWC - Wellington 0678
EWC - Murrieta 0486

																	
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,																	
 round(SUM(Net_amount),2) as RetailRevenue																	
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type,mp.Tender_Type																	
FROM Events_Services ep																	
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2																	
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1																	
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center																	
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1																	
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2																	
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id AND ep.invoice_item_id = bb.Unit_ID																	
                                         	AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id																
    LEFT OUTER JOIN metric_Pmt_type_total mp 																	
    ON 	mp.Transaction_ID = ep.Invoice_id																
  	AND mp.Unit_ID = ep.invoice_item_id																
    AND mp.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)                                        																	
    LEFT OUTER JOIN Metric_0_Payment_Items mpt 																	
      ON  mpt.Transaction_ID = ep.Invoice_id																	
      AND mpt.Unit_ID = ep.invoice_item_id																	
      AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)																	
      AND mpt.Source_ID = ep.Source_ID																	
       AND  mpt.Unit_ID is null  																	
       WHERE dd.fiscal_year = 2021																	
       and  dd.fiscal_month in(6,7,8,9)																	
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0678' 																	
   and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Inner Thighs%')																	
    --('%Butt (Strip)%') 																	
    --AND  bb.tender_group_type = 'Monetary'																	
    AND bb.tender_group_type = 'Hybrid' and mp.Tender_Type = 'Non-Monetary'																	
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type,mp.Tender_Type																	
ORDER BY Fiscal_Year, Fiscal_month																	
    --'MASK ME SLEEP MASK%' 																	
   																	
																	
																	
KPI Query																	
																	
																	
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
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type, revenue_type																	
from KPI_Service_Sales_By_Center																	
where sku_type= 'Service'																	
AND fiscal_year = 2021		
and fiscal_month in (6,7,8,9)
and center_id = '0678'																	
and lower(sku_name) like lower('%Inner Thighs%')																	
--('%Butt (Strip)%')																	
and tender_group_type = 'Hybrid'																	
and revenue_type = 'Non-Monetary'																	
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type, Revenue_type																	
ORDER BY fiscal_month																	
-----------------------------------------------------------------
Scenario #7  Murrieta 

Events Query

0733
0053
EWC - Wellington 0678
EWC - Murrieta 0486

																	
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Service' as Sku_type,																	
 round(SUM(Net_amount),2) as RetailRevenue																	
,COALESCE(mp.CDescript,zp.SERVICENAME) AS SKU_Name, bb.tender_group_type,mp.Tender_Type																	
FROM Events_Services ep																	
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2																	
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1																	
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center																	
    LEFT OUTER JOIN Millennium_Services mp ON mp.iid = ep.service_id  AND mp.ilocationid = ep.center_id AND ep.source_id= 1																	
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2																	
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id AND ep.invoice_item_id = bb.Unit_ID																	
                                         	AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id																
    LEFT OUTER JOIN metric_Pmt_type_total mp 																	
    ON 	mp.Transaction_ID = ep.Invoice_id																
  	AND mp.Unit_ID = ep.invoice_item_id																
    AND mp.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)                                        																	
    LEFT OUTER JOIN Metric_0_Payment_Items mpt 																	
      ON  mpt.Transaction_ID = ep.Invoice_id																	
      AND mpt.Unit_ID = ep.invoice_item_id																	
      AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)																	
      AND mpt.Source_ID = ep.Source_ID																	
       AND  mpt.Unit_ID is null  																	
       WHERE dd.fiscal_year = 2021																	
       and  dd.fiscal_month in(6,7,8,9)																	
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0486' 																	
   and lower(COALESCE(mp.CDescript,zp.SERVICENAME)) like lower('%Sideburns%')																	
    --('%Butt (Strip)%') 																	
    --AND  bb.tender_group_type = 'Monetary'																	
    AND bb.tender_group_type = 'Hybrid' and mp.Tender_Type = 'Non-Monetary'																	
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.SERVICENAME), bb.tender_group_type,mp.Tender_Type																	
ORDER BY Fiscal_Year, Fiscal_month																	
    --'MASK ME SLEEP MASK%' 																	
   																	
																	
																	
KPI Query																	
																	
																	
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
select fiscal_year, fiscal_month,  Center_ID, Sku_type, round(SUM(Service_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type, revenue_type																	
from KPI_Service_Sales_By_Center																	
where sku_type= 'Service'																	
AND fiscal_year = 2021		
and fiscal_month in (6,7,8,9)
and center_id = '0486'																	
and lower(sku_name) like lower('%Sideburns%')																	
--('%Butt (Strip)%')																	
and tender_group_type = 'Hybrid'																	
and revenue_type = 'Non-Monetary'																	
Group by fiscal_month, fiscal_year, Center_ID, Sku_type, Service_Revenue, Sku_name, Tender_group_type, Revenue_type																	
ORDER BY fiscal_month																	
--------------------------------------------------------------------------------------------

Scenario #8			
			
RevRec Query			
			
			
With Revrec as (			
  			
SELECT     Event_type, Source_ID, Transaction_ID, Unit_ID, Center_ID, Sale_Price, Tax, SKU_Name, Sale_Date, Quantity, RevRec_Value, RevRec_Date			
        			
FROM RevRec_combined
  where SKU_Name = 'Service'
  )			
  			
  SELECT         			
                  SUM(CASE WHEN  Year(Revrec_Date) =2021 AND Month(Revrec_Date)  IN(06,07,08,09) THEN RevRec_Value END) as "Q3-21"			
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND month(Revrec_Date) = 06  THEN RevRec_Value END) As "Jun-21"			
                , SUM(CASE WHEN  Year(Revrec_Date) =2021  AND month(Revrec_Date) = 07 THEN RevRec_Value END) As "Jul-21"			
                , SUM(CASE WHEN  Year(Revrec_Date)  =2021  AND month(Revrec_Date) = 08 THEN RevRec_Value END) As "Aug-21"			
                , SUM(CASE WHEN  Year(Revrec_Date)  =2021  AND month(Revrec_Date) = 09 THEN RevRec_Value END) As "Sep-21"	   			
  FROM Revrec			
  			
  -------------------when compared to event services-----------			
  			
  WITH service as (			
SELECT			
'Service' As Event_Type			
,ep.Invoice_id As Transaction_Id			
,ep.invoice_item_id As unit_id			
,ep.net_amount As net_amount			
,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID			
,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name			
,closed_date_in_center As Revrec_Date			
FROM			
Events_Services ep			
LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2			
LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1			
LEFT OUTER JOIN Millennium_Services ms ON ms.iid = ep.service_id AND ms.ilocationid = ep.center_id AND ep.source_ID = 1			
LEFT OUTER JOIN Zenoti_bidimservice zs ON zs.servicewid = ep.service_id AND ep.Source_ID = 2			
WHERE ep.net_amount > 0			
			
 			
			
   			
  ) 			
   SELECT         SUM(CASE WHEN  Year(Revrec_Date) =2021 AND Month(Revrec_Date)  IN(06,07,08,09) THEN net_amount_monetary END) as "Q3-21"		
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND month(Revrec_Date) = 06  THEN net_amount_monetary END) As "Jun-21"			
                , SUM(CASE WHEN  Year(Revrec_Date) =2021  AND month(Revrec_Date) = 07 THEN net_amount_monetary END) As "Jul-21"			
                , SUM(CASE WHEN  Year(Revrec_Date)  =2021  AND month(Revrec_Date) = 08 THEN net_amount_monetary END) As "Aug-21"			
                , SUM(CASE WHEN  Year(Revrec_Date)  =2021  AND month(Revrec_Date) = 09 THEN net_amount_monetary END) As "Sep-21"	
                			
  FROM service			
    
--------------------------------------------------------------------------------------------
 -- scenario #9 
--   KPI
   
 with KPI_Service_Sales_By_Center as (																	
	SELECT fc.fiscal_month, fc.fiscal_Year,fc.quarter, SKU_Type, SKU_Name, Tender_Group_Type,SUM(RevRec_Value) AS Service_Revenue, mrp.Center_ID, count(mrp.unit_id) as Unit, Revenue_Type
	FROM Metric_Service_Base mrp																	
	LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date and month(mrp.revrec_date) = fc.fiscal_month										
	WHERE revenue_Type IS NOT NULL AND center_ID <> '9999' and source_id ='2'										
	GROUP BY fc.fiscal_month, fc.fiscal_Year,fc.quarter, SKU_Type,SKU_Name, Tender_Group_Type, Revenue_Type, mrp.Center_ID		
	)
	select fiscal_year, fiscal_month,  Center_ID, Sku_type, cr.franconnect_center_name as CenterName,
    sum(Unit) as UnitCount,SUM(Service_Revenue) as revenue, Sku_name, Tender_group_type--, Revenue_type			
	from KPI_Service_Sales_By_Center	
    LEFT OUTER JOIN Lookups_CenterCrossreference cr ON cr.Franconnect_Center_ID = Center_ID 
	where  (fiscal_year = 2021  and fiscal_month in (6,7,8,9) and
 	center_id = '0733' and lower(sku_name) like lower('Women%s%Bikini%Line%') and sku_type='Service' and tender_group_type = 'Monetary') 
or (fiscal_year = 2021 and quarter=2 and fiscal_month in (6,7,8,9) and
    center_id = '0043' and lower(sku_name) like lower('Arm%Half%') and sku_type='Service' and tender_group_type = 'Monetary')
or (fiscal_year = 2021 and quarter=2 and fiscal_month in (6,7,8,9) and
    center_id = '0131' and lower(sku_name) like lower('Ears') and sku_type='Service' and tender_group_type = 'Monetary')
or (fiscal_year = 2021 and quarter=2 and fiscal_month in (6,7,8,9) and
    center_id = '0862' and lower(sku_name) like lower('Legs%Upper%') and sku_type='Service' and tender_group_type = 'Monetary')
or (fiscal_year = 2021 and quarter=2 and fiscal_month in (6,7,8,9) and
    center_id = '0828' and lower(sku_name) like lower('Lower%Lip%') and sku_type='Service' and tender_group_type = 'Monetary')
	Group by fiscal_month, fiscal_year, Center_ID, Sku_type,cr.franconnect_center_name, Unit, Sku_name, Tender_group_type--, Revenue_type					
	ORDER BY Center_ID,fiscal_month																	
																																		
																	
--event_services							
							
	SELECT Fiscal_Year, Fiscal_Month, zcr.Franconnect_Center_ID as Center_ID, 'Service' as Sku_type, zcr.franconnect_center_name as CenterName,					
round(SUM(Net_amount),2) as RetailRevenue, count(ep.invoice_item_id) as UnitCount, zp.SERVICENAME AS SKU_Name, bb.tender_group_type														
	FROM Events_Services ep														
	LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2											
	LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center	and month(ep.closed_date_in_center)	=dd.fiscal_month							
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 														
											AND ep.invoice_item_id = bb.Unit_ID													
											and zcr.Franconnect_Center_ID = bb.center_id 													
	LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = ep.Invoice_id
    										AND mpt.Unit_ID = ep.invoice_item_id
    										AND mpt.Center_ID = zcr.Franconnect_Center_ID
    										AND mpt.Source_ID = ep.Source_ID  and  mpt.Unit_ID is null and ep.Source_ID =2
   WHERE (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=2 AND zcr.Franconnect_Center_ID = '0733' 
          and lower(zp.SERVICENAME) like lower('Women%s%Bikini%Line%') AND bb.tender_group_type = 'Monetary' )
	  or (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=2  AND zcr.Franconnect_Center_ID = '0043'
    	  and lower(zp.SERVICENAME) like lower('Arm%Half%') AND bb.tender_group_type = 'Monetary' )   
	  or (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=2 AND zcr.Franconnect_Center_ID = '0131'
    	  and lower(zp.SERVICENAME) like lower('Ears') AND bb.tender_group_type = 'Monetary' )       
 	  or (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=2 AND zcr.Franconnect_Center_ID = '0862'
    	  and lower(zp.SERVICENAME) like lower('Legs%Upper%') AND bb.tender_group_type = 'Monetary' )  
      or (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=2 AND zcr.Franconnect_Center_ID = '0828'
    	  and lower(zp.SERVICENAME) like lower('Lower%Lip%') AND bb.tender_group_type = 'Monetary' )  
GROUP BY Fiscal_Year, Fiscal_Month, zcr.Franconnect_Center_ID, zp.SERVICENAME, bb.tender_group_type,zcr.franconnect_center_name
,zcr.franconnect_center_name--,mpt.Tender_Type
ORDER BY zcr.Franconnect_Center_ID, zcr.franconnect_center_name,zp.SERVICENAME,fiscal_month
--------------------------------------------------------------------------------------------------------------

scenario#11
KPI

with KPI_Service_Sales_By_Center as (																	
	SELECT fc.fiscal_month, fc.fiscal_Year,fc.quarter, SKU_Type, SKU_Name, Tender_Group_Type,round(SUM(RevRec_Value),2) AS Service_Revenue, mrp.Center_ID, count(mrp.unit_id) as Unit, Revenue_Type
	FROM Metric_Service_Base mrp																	
	LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date and month(mrp.revrec_date) = fc.fiscal_month												
	WHERE revenue_Type IS NOT NULL AND center_ID <> '9999'	and source_id ='2'															
	GROUP BY fc.fiscal_month, fc.fiscal_Year,fc.quarter, SKU_Type,SKU_Name, Tender_Group_Type, Revenue_Type, mrp.Center_ID																	
	)
	select fiscal_year, fiscal_month,  Center_ID, Sku_type, cr.franconnect_center_name as CenterName,
    (Unit) as UnitCount,SUM(Service_Revenue) as revenue, Sku_name, Tender_group_type--, Revenue_type			
	from KPI_Service_Sales_By_Center	
    LEFT OUTER JOIN Lookups_CenterCrossreference cr ON cr.Franconnect_Center_ID = Center_ID 
	where  (fiscal_year = 2021  and fiscal_month in (6,7,8,9) and
 	center_id = '0245' and lower(sku_name) like lower('%Full%Face%') and sku_type='Service' and tender_group_type = 'Hybrid') 
or (fiscal_year = 2021 and quarter=3 and fiscal_month in (6,7,8,9) and
    center_id = '0706' and lower(sku_name) like lower('Chin') and sku_type='Service' and tender_group_type = 'Hybrid')
or (fiscal_year = 2021 and quarter=3 and fiscal_month in (6,7,8,9) and
    center_id = '0732' and lower(sku_name) like lower('%Bikini%') and sku_type='Service' and tender_group_type = 'Hybrid')
or (fiscal_year = 2021 and quarter=3 and fiscal_month in (6,7,8,9) and
    center_id = '0645' and lower(sku_name) like lower('Eyebrows') and sku_type='Service' and tender_group_type = 'Hybrid')
or (fiscal_year = 2021 and quarter=3 and fiscal_month in (6,7,8,9) and
    center_id = '0937' and lower(sku_name) like lower('%Bikini%') and sku_type='Service' and tender_group_type = 'Hybrid')
	Group by fiscal_month, fiscal_year, Center_ID, Sku_type,cr.franconnect_center_name, Unit, Sku_name, Tender_group_type--, Revenue_type					
	ORDER BY Center_ID,fiscal_month																	
							
--Event_Service

SELECT Fiscal_Year, Fiscal_Month, zcr.Franconnect_Center_ID as Center_ID, 'Service' as Sku_type, zcr.franconnect_center_name as CenterName,					
count(ep.invoice_item_id) as UnitCount, round(SUM(Net_amount),2) as RetailRevenue,  zp.SERVICENAME AS SKU_Name, bb.tender_group_type														
	FROM Events_Services ep														
	LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2											
	LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center	and month(ep.closed_date_in_center)	=dd.fiscal_month							
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 														
											AND ep.invoice_item_id = bb.Unit_ID													
											and zcr.Franconnect_Center_ID = bb.center_id 													
	LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = ep.Invoice_id
    										AND mpt.Unit_ID = ep.invoice_item_id
    										AND mpt.Center_ID = zcr.Franconnect_Center_ID
    										AND mpt.Source_ID = ep.Source_ID  and  mpt.Unit_ID is null and ep.Source_ID =2
   WHERE (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=3 AND zcr.Franconnect_Center_ID = '0245' 
          and lower(zp.SERVICENAME) like lower('%Full%Face%') AND bb.tender_group_type = 'Hybrid' )
	  or (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=3  AND zcr.Franconnect_Center_ID = '0706'
    	  and lower(zp.SERVICENAME) like lower('Chin') AND bb.tender_group_type = 'Hybrid' )   
	  or (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=3 AND zcr.Franconnect_Center_ID = '0732'
    	  and lower(zp.SERVICENAME) like lower('%Bikini%') AND bb.tender_group_type = 'Hybrid' )       
 	  or (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=3 AND zcr.Franconnect_Center_ID = '0645'
    	  and lower(zp.SERVICENAME) like lower('Eyebrows') AND bb.tender_group_type = 'Hybrid' )  
      or (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=3 AND zcr.Franconnect_Center_ID = '0937'
    	  and lower(zp.SERVICENAME) like lower('%Bikini%') AND bb.tender_group_type = 'Hybrid' )  
GROUP BY Fiscal_Year, Fiscal_Month, zcr.Franconnect_Center_ID, zp.SERVICENAME, bb.tender_group_type,zcr.franconnect_center_name
,zcr.franconnect_center_name--,mpt.Tender_Type
ORDER BY zcr.Franconnect_Center_ID, zcr.franconnect_center_name,zp.SERVICENAME,fiscal_month							
-----------------------------------------------------------------------------------------------------------

--Scenario #13 

with KPI_Service_Sales_By_Center as (																	
	SELECT fc.fiscal_month, fc.fiscal_Year,fc.quarter, SKU_Type, SKU_Name, Tender_Group_Type, round(SUM(RevRec_Value),2) AS Service_Revenue, mrp.Center_ID, count(mrp.unit_id) as Unit, Revenue_Type
	FROM Metric_Service_Base mrp																	
	LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date and month(mrp.revrec_date) = fc.fiscal_month												
	WHERE revenue_Type IS NOT NULL AND center_ID <> '9999'	and source_id ='2'															
	GROUP BY fc.fiscal_month, fc.fiscal_Year,fc.quarter, SKU_Type,SKU_Name, Tender_Group_Type, Revenue_Type, mrp.Center_ID																	
	)
	select fiscal_year, fiscal_month,  Center_ID, Sku_type, cr.franconnect_center_name as CenterName,
    (Unit) as UnitCount,round(SUM(Service_Revenue),2) as revenue, Sku_name, Tender_group_type--, Revenue_type			
	from KPI_Service_Sales_By_Center	
    LEFT OUTER JOIN Lookups_CenterCrossreference cr ON cr.Franconnect_Center_ID = Center_ID 
	where  (fiscal_year = 2021  and fiscal_month in (6,7,8,9) and
 	center_id = '0412' and lower(sku_name) like lower('Eyebrows') and sku_type='Service' and tender_group_type = 'Non-Monetary') 
or (fiscal_year = 2021 and quarter=3 and fiscal_month in (6,7,8,9) and
    center_id = '0417' and lower(sku_name) like lower('%Women%') and sku_type='Service' and tender_group_type = 'Non-Monetary')
or (fiscal_year = 2021 and quarter=3 and fiscal_month in (6,7,8,9) and
    center_id = '0678' and lower(sku_name) like lower('Chin') and sku_type='Service' and tender_group_type = 'Non-Monetary')
or (fiscal_year = 2021 and quarter=3 and fiscal_month in (6,7,8,9) and
    center_id = '0899' and lower(sku_name) like lower('%Women%') and sku_type='Service' and tender_group_type = 'Non-Monetary')
	Group by fiscal_month, fiscal_year, Center_ID, Sku_type,cr.franconnect_center_name, Unit, Sku_name, Tender_group_type--, Revenue_type					
	ORDER BY Center_ID,fiscal_month
																		
                                                                        
--- Event_Services


SELECT Fiscal_Year, Fiscal_Month, zcr.Franconnect_Center_ID as Center_ID, 'Service' as Sku_type, zcr.franconnect_center_name as CenterName,					
count(ep.invoice_item_id) as UnitCount, round(SUM(Net_amount),2) as RetailRevenue,  zp.SERVICENAME AS SKU_Name, bb.tender_group_type														
	FROM Events_Services ep														
	LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2											
	LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center	and month(ep.closed_date_in_center)	=dd.fiscal_month							
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 														
											AND ep.invoice_item_id = bb.Unit_ID													
											and zcr.Franconnect_Center_ID = bb.center_id 													
	LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = ep.Invoice_id
    										AND mpt.Unit_ID = ep.invoice_item_id
    										AND mpt.Center_ID = zcr.Franconnect_Center_ID
    										AND mpt.Source_ID = ep.Source_ID  and  mpt.Unit_ID is null and ep.Source_ID =2
   WHERE (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=2 AND zcr.Franconnect_Center_ID = '0412' 
          and lower(zp.SERVICENAME) like lower('Eyebrows') AND bb.tender_group_type = 'Non-Monetary' )
	  or (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=2  AND zcr.Franconnect_Center_ID = '0417'
    	  and lower(zp.SERVICENAME) like lower('%Women%') AND bb.tender_group_type = 'Non-Monetary' )   
	  or (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=2 AND zcr.Franconnect_Center_ID = '0678'
    	  and lower(zp.SERVICENAME) like lower('Chin') AND bb.tender_group_type = 'Non-Monetary' )       
      or (dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=2 AND zcr.Franconnect_Center_ID = '0899'
    	  and lower(zp.SERVICENAME) like lower('%Women%') AND bb.tender_group_type = 'Non-Monetary' )  
GROUP BY Fiscal_Year, Fiscal_Month, zcr.Franconnect_Center_ID, zp.SERVICENAME, bb.tender_group_type,zcr.franconnect_center_name
,zcr.franconnect_center_name--,mpt.Tender_Type
ORDER BY zcr.Franconnect_Center_ID, zcr.franconnect_center_name,zp.SERVICENAME,fiscal_month
-------------------------------------------------------------------------------------------------------------
--Scenario #14

with KPI_Service_Sales_By_Center as (																	
	SELECT fc.fiscal_month, fc.fiscal_Year,fc.quarter, SKU_Type, Tender_Group_Type, round(SUM(RevRec_Value),2) AS Service_Revenue,  count(mrp.unit_id) as Unit, Revenue_Type
	FROM Metric_Service_Base mrp																	
	LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date and month(mrp.revrec_date) = fc.fiscal_month												
	WHERE revenue_Type IS NOT NULL 	and source_id ='2'															
	GROUP BY fc.fiscal_month, fc.fiscal_Year,fc.quarter, SKU_Type, Tender_Group_Type, Revenue_Type																
	)
	select fiscal_year, fiscal_month, Sku_type,
    (Unit) as UnitCount,round(SUM(Service_Revenue),2) as revenue, Tender_group_type--, Revenue_type			
	from KPI_Service_Sales_By_Center	
	where fiscal_year = 2021  and fiscal_month in (6,7,8,9) and sku_type = 'Service'
	Group by fiscal_month, fiscal_year,  Sku_type, Unit, Tender_group_type	
	ORDER BY fiscal_month,Tender_group_type
												                                                                        
--- Event_Services

SELECT Fiscal_Year, Fiscal_Month, 'Service' as Sku_type, 				
count(ep.invoice_item_id) as UnitCount, round(SUM(Net_amount),2) as RetailRevenue, -- zp.SERVICENAME AS SKU_Name, 
bb.tender_group_type														
	FROM Events_Services ep														
	LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2											
	LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center	and month(ep.closed_date_in_center)	=dd.fiscal_month							
    LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = ep.service_id AND ep.source_ID = 2
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 														
											AND ep.invoice_item_id = bb.Unit_ID													
											and zcr.Franconnect_Center_ID = bb.center_id 	
    LEFT OUTER JOIN Metric_0_Payment_Items m0 ON     m0.Transaction_ID = ep.Invoice_id
                                                  AND m0.Unit_ID = ep.invoice_item_id
                                                AND m0.Center_ID = (zcr.Franconnect_Center_ID) and ep.source_id=2
   WHERE dd.fiscal_year = 2021 and dd.fiscal_month in (6,7,8,9) and dd.quarter=2 AND ep.void = false
AND m0.Transaction_ID IS NULL
AND tender_group_type <> 'WP Redemption'
GROUP BY Fiscal_Year, Fiscal_Month, bb.tender_group_type 
ORDER BY fiscal_month, bb.tender_group_type
--------------------------------------------------------------------------------------------------
--Scenario 8

With Revrec as (
  
SELECT 	Event_type, Source_ID, Transaction_ID, Unit_ID, Center_ID, Sale_Price, Tax, SKU_Name, Sale_Date, Quantity, RevRec_Value, RevRec_Date
        
FROM RevRec_combined
    where SKU_Name = 'Service' 
  )
  
  SELECT         
                  SUM(CASE WHEN  Year(Revrec_Date) =2010 THEN RevRec_Value END) As "FY 2010"
                , SUM(CASE WHEN  Year(Revrec_Date) =2011 THEN RevRec_Value END) As "FY 2011"
                , SUM(CASE WHEN  Year(Revrec_Date) =2012 THEN RevRec_Value END) As "FY 2012"
                , SUM(CASE WHEN  Year(Revrec_Date) =2013 THEN RevRec_Value END) As "FY 2013"
                , SUM(CASE WHEN  Year(Revrec_Date) =2016 THEN RevRec_Value END) As "FY 2016"
                , SUM(CASE WHEN  Year(Revrec_Date) =2019 THEN RevRec_Value END) As "FY 2019"
                , SUM(CASE WHEN  Year(Revrec_Date) =2020 THEN RevRec_Value END) As "FY 2020"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND Month(Revrec_Date)  IN(06,07,08,09) THEN RevRec_Value END) as "Q3-21"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND month(Revrec_Date) = 06  THEN RevRec_Value END) As "jun-21"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021  AND month(Revrec_Date) = 07 THEN RevRec_Value END) As "jul-21"
                , SUM(CASE WHEN  Year(Revrec_Date)  =2021  AND month(Revrec_Date) = 08 THEN RevRec_Value END) As "aug-21"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND month(Revrec_Date) = 09  THEN RevRec_Value END) As "sep-21"
		        
  FROM Revrec
  
  -------------------when compared to event services-----------
   WITH service as (
SELECT
'Service' As Event_Type
,ep.Invoice_id As Transaction_Id
,ep.invoice_item_id As unit_id
,ep.net_amount As net_amount
,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
,closed_date_in_center As Revrec_Date
FROM
Events_Services ep
LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
LEFT OUTER JOIN Millennium_Services ms ON ms.iid = ep.service_id AND ms.ilocationid = ep.center_id AND ep.source_ID = 1
LEFT OUTER JOIN Zenoti_bidimservice zs ON zs.servicewid = ep.service_id AND ep.Source_ID = 2
WHERE ep.net_amount > 0

   
  ) 
   SELECT         
                  SUM(CASE WHEN  Year(Revrec_Date) =2010 THEN net_amount END) As "FY 2010"
                , SUM(CASE WHEN  Year(Revrec_Date) =2011 THEN net_amount END) As "FY 2011"
                , SUM(CASE WHEN  Year(Revrec_Date) =2012 THEN net_amount END) As "FY 2012"
                , SUM(CASE WHEN  Year(Revrec_Date) =2013 THEN net_amount END) As "FY 2013"
                , SUM(CASE WHEN  Year(Revrec_Date) =2016 THEN net_amount END) As "FY 2016"
                , SUM(CASE WHEN  Year(Revrec_Date) =2019 THEN net_amount END) As "FY 2019"
                , SUM(CASE WHEN  Year(Revrec_Date) =2020 THEN net_amount END) As "FY 2020"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND month(Revrec_Date) = 06  THEN net_amount END) As "jun-21"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021  AND month(Revrec_Date) = 07 THEN net_amount END) As "jul-21"
                , SUM(CASE WHEN  Year(Revrec_Date)  =2021  AND month(Revrec_Date) = 08 THEN net_amount END) As "aug-21"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND month(Revrec_Date) = 09  THEN net_amount END) As "sep-21"
		        
  FROM service