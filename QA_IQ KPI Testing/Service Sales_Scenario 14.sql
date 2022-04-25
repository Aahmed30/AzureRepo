======================================== Events =================================================================================

SELECT Fiscal_Year, 'Service' as Sku_type,
 round(SUM((Net_amount)),2) as ServiceRevenue, bb.tender_group_type , mpt.Tender_Type
FROM Events_Services ep
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id
                                              AND ep.invoice_item_id = bb.Unit_ID
                                             and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id
    LEFT OUTER JOIN metric_Pmt_type_total mpt ON     mpt.Transaction_ID = ep.Invoice_id
                                                  AND mpt.Unit_ID = ep.invoice_item_id
                                              AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = ep.Source_ID
   LEFT OUTER JOIN Metric_0_Payment_Items m0 ON     m0.Transaction_ID = ep.Invoice_id
                                                  AND m0.Unit_ID = ep.invoice_item_id
                                                AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
    WHERE dd.fiscal_year = 2019
    and m0.Unit_ID is null
    and mpt.Tender_Type is not null
GROUP BY Fiscal_Year, bb.tender_group_type, mpt.Tender_Type
ORDER BY Fiscal_Year, bb.tender_group_type, mpt.Tender_Type

======================================== KPI =================================================================================

WITH Net AS (
SELECT  fc.fiscal_Year,  'Net Service' AS SKU_Type, SUM(RevRec_Value) AS Service_Revenue, Tender_group_type, Revenue_type
FROM Metric_Service_Base msp
LEFT OUTER JOIN full_Datedimension fc ON fc.date = msp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_Year, Tender_group_type, Revenue_type
ORDER BY fc.fiscal_Year
),
KPI_Service_Sales_By_Center
as
(SELECT  fc.fiscal_Year,SKU_Type, SUM(RevRec_Value)  AS Service_Revenue, Tender_group_type, Revenue_type
FROM Metric_Service_Base msp
LEFT OUTER JOIN full_Datedimension fc ON fc.date = msp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_Year, SKU_Type, Tender_group_type, Revenue_type
UNION
SELECT fiscal_Year,SKU_Type, Service_Revenue, Tender_group_type, Revenue_type
FROM Net
ORDER BY fiscal_Year
)

 

select fiscal_year, SKU_Type,round(SUM(Service_Revenue),2) as ServiceRevenue, Tender_group_type, Revenue_type
from KPI_Service_Sales_By_Center
where sku_type= 'Service' 
	AND fiscal_year = 2019 
	--AND fiscal_Month = 3
--and tender_group_type = 'Hybrid' 
--and revenue_type = 'Non-Monetary'
Group by fiscal_year, SKU_Type, Service_Revenue, Tender_group_type, Revenue_type
ORDER BY fiscal_year, Tender_group_type, Revenue_type




Fiscal_Year 	Sku_type 		ServiceRevenue 		tender_group_type 		tender_type
2019			Service			2.547031609E7		Hybrid					Monetary
2019			Service			2.547031609E7		Hybrid					Non-Monetary
2019			Service			2.5177935435E8		Monetary				Monetary
2019			Service			2433723.54			Non-Monetary			Non-Monetary


fiscal_year		SKU_Type		ServiceRevenue		Tender_group_type		Revenue_type
2019			Service			1.850978537E7		Hybrid					Monetary
2019			Service			6971823.11			Hybrid					Non-Monetary
2019			Service			2.5178833737E8		Monetary				Monetary
2019			Service			2434297.4			Non-Monetary			Non-Monetary



===========================For 2021 Monthly wise===========================================================================


SELECT Fiscal_Year, Fiscal_Month, 'Service' as Sku_type,
 round(SUM((Net_amount)),2) as ServiceRevenue, bb.tender_group_type , mpt.Tender_Type
FROM Events_Services ep
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id
                                              AND ep.invoice_item_id = bb.Unit_ID
                                             and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id
    LEFT OUTER JOIN metric_Pmt_type_total mpt ON     mpt.Transaction_ID = ep.Invoice_id
                                                  AND mpt.Unit_ID = ep.invoice_item_id
                                              AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = ep.Source_ID
   LEFT OUTER JOIN Metric_0_Payment_Items m0 ON     m0.Transaction_ID = ep.Invoice_id
                                                  AND m0.Unit_ID = ep.invoice_item_id
                                                AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
    WHERE dd.fiscal_year = 2021
    AND dd.Fiscal_Month = 1
	--	AND fiscal_Month in (1,2,3,4)
    and m0.Unit_ID is null
    and mpt.Tender_Type is not null
GROUP BY Fiscal_Year, Fiscal_Month,  bb.tender_group_type, mpt.Tender_Type
ORDER BY Fiscal_Year, Fiscal_Month,  bb.tender_group_type, mpt.Tender_Type

===========================================================

WITH Net AS (
SELECT  fc.fiscal_Year, fc.fiscal_Month, 'Net Service' AS SKU_Type, SUM(RevRec_Value) AS Service_Revenue, Tender_group_type, Revenue_type
FROM Metric_Service_Base msp
LEFT OUTER JOIN full_Datedimension fc ON fc.date = msp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_Year, fc.fiscal_Month, Tender_group_type, Revenue_type
ORDER BY fc.fiscal_Year
),
KPI_Service_Sales_By_Center
as
(SELECT  fc.fiscal_Year, fc.fiscal_Month, SKU_Type, SUM(RevRec_Value)  AS Service_Revenue, Tender_group_type, Revenue_type
FROM Metric_Service_Base msp
LEFT OUTER JOIN full_Datedimension fc ON fc.date = msp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_Year,fc.fiscal_Month, SKU_Type, Tender_group_type, Revenue_type
UNION
SELECT fiscal_Year, fiscal_Month, SKU_Type, Service_Revenue, Tender_group_type, Revenue_type
FROM Net
ORDER BY fiscal_Year
)

 

select fiscal_year,fiscal_Month, SKU_Type,round(SUM(Service_Revenue),2) as ServiceRevenue, Tender_group_type, Revenue_type
from KPI_Service_Sales_By_Center
where sku_type= 'Service' 
	AND fiscal_year = 2021
	AND fiscal_Month = 1
	--	AND fiscal_Month in (1,2,3,4)
--and tender_group_type = 'Hybrid' 
--and revenue_type = 'Non-Monetary'
Group by fiscal_year, fiscal_Month, SKU_Type, Service_Revenue, Tender_group_type, Revenue_type
ORDER BY fiscal_year, fiscal_Month, Tender_group_type, Revenue_type