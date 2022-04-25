-------------------------------------------------Monetary------------------------------------------------------

------KPI:
WITH Net AS (
SELECT fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, 'Net Retail' AS SKU_Type, SUM(RevRec_Value) AS Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Metric_Retail_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, sku_name, Tender_group_type, Revenue_type
ORDER BY fc.fiscal_Year, fc.Fiscal_Month
),
Centername as
(select COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name) as CenterName,
 COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID FROM Events_Retail ep
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
),
KPI_Retail_Sales_By_Center
as
(SELECT fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, SKU_Type, SUM(RevRec_Value)  AS Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Metric_Retail_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, SKU_Type, Sku_Name, Tender_group_type, Revenue_type
UNION
SELECT fiscal_month, fiscal_Year, Center_ID, SKU_Type, Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Net
ORDER BY fiscal_Year, Fiscal_Month, Center_ID
)
select fiscal_year, fiscal_month,  ep.Center_ID, CenterName,
Sku_type, round((ep.Retail_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, Revenue_type
from KPI_Retail_Sales_By_Center ep left outer join centername aa on aa.center_id = ep.center_id
where (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0361' and lower(sku_name) like lower('Aloe Body Lotion%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0116' and lower(sku_name) like lower('Aloe Body Wash%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0039' and lower(sku_name) like lower('Aloe Deodorant%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0507' and lower(sku_name) like lower('Brow Gel- Light%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0456' and lower(sku_name) like lower('Coconut Body Oil%'))
Group by fiscal_month, fiscal_year, ep.Center_ID, Sku_type, Retail_Revenue, Sku_name, Tender_group_type, Revenue_type,CenterName
ORDER BY ep.Center_ID,fiscal_month

------Event:
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Retail' as Sku_type, 
 round(SUM(COALESCE(mpt.Total_Payment_amount,Net_amount)),2) as RetailRevenue
 ,COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name) as CenterName
,COALESCE(mp.CDescript,zp.productname) AS SKU_Name, bb.tender_group_type --, mpt.Tender_Type
FROM Events_Retail ep
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
    LEFT OUTER JOIN Millennium_Products mp ON mp.iid = ep.item_id AND mp.ilocationid = ep.center_id AND ep.source_id = 1
    LEFT OUTER JOIN Zenoti_Bidimproduct zp ON zp.productwid = ep.product_id AND ep.source_ID = 2
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 
 						AND ep.invoice_item_id = bb.Unit_ID
                                         	and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id 
    LEFT OUTER JOIN metric_Pmt_type_total mpt ON mpt.Transaction_ID = ep.Invoice_id
  						AND mpt.Unit_ID = ep.invoice_item_id
                                                AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = ep.Source_ID
    LEFT OUTER JOIN Metric_0_Payment_Items m0 ON m0.Transaction_ID = ep.Invoice_id
  						AND m0.Unit_ID = ep.invoice_item_id
                                                AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
    WHERE (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0361' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Aloe Body Lotion%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0116' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Aloe Body Wash%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0039' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Aloe Deodorant%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0507' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Brow Gel- Light%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0456' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Coconut Body Oil%'))
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.productname),
bb.tender_group_type, mpt.Tender_Type ,COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name)
ORDER BY COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), Fiscal_month

-------------------------------------------------------NonMonetary--------------------------------------------------------------------------

-----KPI:
WITH Net AS (
SELECT fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, 'Net Retail' AS SKU_Type, SUM(RevRec_Value) AS Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Metric_Retail_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, sku_name, Tender_group_type, Revenue_type
ORDER BY fc.fiscal_Year, fc.Fiscal_Month
),
Centername as
(select COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name) as CenterName,
 COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID FROM Events_Retail ep
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
),
KPI_Retail_Sales_By_Center
as
(SELECT fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, SKU_Type, SUM(RevRec_Value)  AS Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Metric_Retail_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, SKU_Type, Sku_Name, Tender_group_type, Revenue_type
UNION
SELECT fiscal_month, fiscal_Year, Center_ID, SKU_Type, Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Net
ORDER BY fiscal_Year, Fiscal_Month, Center_ID
)
select fiscal_year, fiscal_month,  ep.Center_ID, CenterName,
Sku_type, round((ep.Retail_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, Revenue_type
from KPI_Retail_Sales_By_Center ep left outer join centername aa on aa.center_id = ep.center_id
where (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10) and tender_group_type = 'Non-Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0043' and lower(sku_name) like lower('Brow Liner & Shaper- Medium%'))
OR (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (11) and tender_group_type = 'Non-Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0043' and lower(sku_name) like lower('Ingrown Hair Serum%'))
OR (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (12) and tender_group_type = 'Non-Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0043' and lower(sku_name) like lower('Brow Powder Duo- Medium%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Non-Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0736' and lower(sku_name) like lower('Coconut%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Non-Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0284' and lower(sku_name) like lower('Shea%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Non-Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0454' and lower(sku_name) like lower('Brow Liner & Shaper%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Non-Monetary' --and revenue_type = 'Non-Monetary'
and ep.center_id = '0939' and lower(sku_name) like lower('Aloe%')
   )
Group by fiscal_month, fiscal_year, ep.Center_ID, Sku_type, Retail_Revenue, Sku_name, Tender_group_type, Revenue_type,CenterName
ORDER BY ep.Center_ID,fiscal_month

Event:
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Retail' as Sku_type, 
 round(SUM(COALESCE(mpt.Total_Payment_amount,Net_amount)),2) as RetailRevenue
 ,COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name) as CenterName
,COALESCE(mp.CDescript,zp.productname) AS SKU_Name, bb.tender_group_type --, mpt.Tender_Type
FROM Events_Retail ep
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
    LEFT OUTER JOIN Millennium_Products mp ON mp.iid = ep.item_id AND mp.ilocationid = ep.center_id AND ep.source_id = 1
    LEFT OUTER JOIN Zenoti_Bidimproduct zp ON zp.productwid = ep.product_id AND ep.source_ID = 2
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 
 						AND ep.invoice_item_id = bb.Unit_ID
                                         	and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id 
    LEFT OUTER JOIN metric_Pmt_type_total mpt ON mpt.Transaction_ID = ep.Invoice_id
  						AND mpt.Unit_ID = ep.invoice_item_id
                                                AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = ep.Source_ID
    LEFT OUTER JOIN Metric_0_Payment_Items m0 ON m0.Transaction_ID = ep.Invoice_id
  						AND m0.Unit_ID = ep.invoice_item_id
                                                AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
    WHERE (dd.fiscal_year = 2021  and bb.tender_group_type = 'Non-Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0043' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('%Brow Liner & Shaper- Medium%') and dd.fiscal_month in (10))
or (dd.fiscal_year = 2021  and bb.tender_group_type = 'Non-Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0043' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('%Ingrown Hair Serum%') and dd.fiscal_month in (11))
or (dd.fiscal_year = 2021  and bb.tender_group_type = 'Non-Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0043' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('%Brow Powder Duo- Medium%') and dd.fiscal_month in (12))
or (dd.fiscal_year = 2021   and bb.tender_group_type = 'Non-Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0736' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Coconut%') and dd.fiscal_month in (10,11,12))
or (dd.fiscal_year = 2021   and bb.tender_group_type = 'Non-Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0284' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Shea%') and dd.fiscal_month in (10,11,12))
or (dd.fiscal_year = 2021  and bb.tender_group_type = 'Non-Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0454' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Brow Liner & Shaper%') and dd.fiscal_month in (10,11,12))
or (dd.fiscal_year = 2021  and bb.tender_group_type = 'Non-Monetary' --and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0939' and dd.fiscal_month in (10,11,12) --and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Aloe Body Lotion%')
   )
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.productname),
bb.tender_group_type, mpt.Tender_Type ,COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name)
ORDER BY COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), Fiscal_month


--------------------------------------------------HybridNonMonetary-----------------------------------------------------------

---------KPI:
WITH Net AS (
SELECT fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, 'Net Retail' AS SKU_Type, SUM(RevRec_Value) AS Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Metric_Retail_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, sku_name, Tender_group_type, Revenue_type
ORDER BY fc.fiscal_Year, fc.Fiscal_Month
),
Centername as
(select COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name) as CenterName,
 COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID FROM Events_Retail ep
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
),
KPI_Retail_Sales_By_Center
as
(SELECT fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, SKU_Type, SUM(RevRec_Value)  AS Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Metric_Retail_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, SKU_Type, Sku_Name, Tender_group_type, Revenue_type
UNION
SELECT fiscal_month, fiscal_Year, Center_ID, SKU_Type, Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Net
ORDER BY fiscal_Year, Fiscal_Month, Center_ID
)
select fiscal_year, fiscal_month,  ep.Center_ID, CenterName,
Sku_type, round((ep.Retail_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, Revenue_type
from KPI_Retail_Sales_By_Center ep left outer join centername aa on aa.center_id = ep.center_id
where (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Hybrid' and revenue_type = 'Non-Monetary'
and ep.center_id = '0140' and lower(sku_name) like lower('Calming Ingrown Hair Serum'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Hybrid' and revenue_type = 'Non-Monetary'
and ep.center_id = '0048' and lower(sku_name) like lower('Brightening Ingrown Hair Serum%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Hybrid' and revenue_type = 'Non-Monetary'
and ep.center_id = '0757' and lower(sku_name) like lower('Brow Building Serum%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Hybrid' and revenue_type = 'Non-Monetary'
and ep.center_id = '0559' and lower(sku_name) like lower('%Brightening Ingrown Hair Serum%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Hybrid' and revenue_type = 'Non-Monetary'
and ep.center_id = '0889' and lower(sku_name) like lower('Ingrown Hair Serum%')
   )
Group by fiscal_month, fiscal_year, ep.Center_ID, Sku_type, Retail_Revenue, Sku_name, Tender_group_type, Revenue_type,CenterName
ORDER BY ep.Center_ID,fiscal_month

Event:
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Retail' as Sku_type, 
 round(SUM(COALESCE(mpt.Total_Payment_amount,Net_amount)),2) as RetailRevenue
 ,COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name) as CenterName
,COALESCE(mp.CDescript,zp.productname) AS SKU_Name, bb.tender_group_type --, mpt.Tender_Type
FROM Events_Retail ep
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
    LEFT OUTER JOIN Millennium_Products mp ON mp.iid = ep.item_id AND mp.ilocationid = ep.center_id AND ep.source_id = 1
    LEFT OUTER JOIN Zenoti_Bidimproduct zp ON zp.productwid = ep.product_id AND ep.source_ID = 2
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 
 						AND ep.invoice_item_id = bb.Unit_ID
                                         	and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id 
    LEFT OUTER JOIN metric_Pmt_type_total mpt ON mpt.Transaction_ID = ep.Invoice_id
  						AND mpt.Unit_ID = ep.invoice_item_id
                                                AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = ep.Source_ID
    LEFT OUTER JOIN Metric_0_Payment_Items m0 ON m0.Transaction_ID = ep.Invoice_id
  						AND m0.Unit_ID = ep.invoice_item_id
                                                AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
    WHERE (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Hybrid' and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0140' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Calming Ingrown Hair Serum%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Hybrid' and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0048' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Brightening Ingrown Hair Serum%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Hybrid' and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0757' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Brow Building Serum%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Hybrid' and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0559' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('%Brightening Ingrown Hair Serum%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Hybrid' and mpt.Tender_Type = 'Non-Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0889' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Ingrown Hair Serum%')
   )
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.productname),
bb.tender_group_type, mpt.Tender_Type ,COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name)
ORDER BY COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), Fiscal_month

-----------------------------------------------------------HybridMonetary---------------------------------------------------------

----------------KPI:
WITH Net AS (
SELECT fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, 'Net Retail' AS SKU_Type, SUM(RevRec_Value) AS Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Metric_Retail_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, sku_name, Tender_group_type, Revenue_type
ORDER BY fc.fiscal_Year, fc.Fiscal_Month
),
Centername as
(select COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name) as CenterName,
 COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID FROM Events_Retail ep
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
),
KPI_Retail_Sales_By_Center
as
(SELECT fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, SKU_Type, SUM(RevRec_Value)  AS Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Metric_Retail_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_month, fc.fiscal_Year, mrp.Center_ID, SKU_Type, Sku_Name, Tender_group_type, Revenue_type
UNION
SELECT fiscal_month, fiscal_Year, Center_ID, SKU_Type, Retail_Revenue, Sku_Name, Tender_group_type, Revenue_type
FROM Net
ORDER BY fiscal_Year, Fiscal_Month, Center_ID
)
select fiscal_year, fiscal_month,  ep.Center_ID, CenterName,
Sku_type, round((ep.Retail_Revenue),2) as RetailRevenue, Sku_name, Tender_group_type--, Revenue_type
from KPI_Retail_Sales_By_Center ep left outer join centername aa on aa.center_id = ep.center_id
where (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Hybrid'and revenue_type = 'Monetary'
and ep.center_id = '0216' and lower(sku_name) like lower('Ingrown Hair Serum%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Hybrid' and revenue_type = 'Monetary'
and ep.center_id = '0048' and lower(sku_name) like lower('Aloe Deodorant%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Hybrid' and revenue_type = 'Monetary'
and ep.center_id = '0312' and lower(sku_name) like lower('Calming Ingrown Hair Serum%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Hybrid' and revenue_type = 'Monetary'
and ep.center_id = '0223' and lower(sku_name) like lower('Ingrown Hair Serum%'))
or (sku_type= 'Retail' AND fiscal_year = '2021'  and fiscal_month in (10,11,12) and tender_group_type = 'Hybrid' and revenue_type = 'Monetary'
and ep.center_id = '0899' and lower(sku_name) like lower('Coconut Body Polish%'))
Group by fiscal_month, fiscal_year, ep.Center_ID, Sku_type, Retail_Revenue, Sku_name, Tender_group_type,CenterName, Revenue_type
ORDER BY ep.Center_ID,fiscal_month

-------------------Event:
SELECT Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID, 'Retail' as Sku_type, 
 round(SUM(COALESCE(mpt.Total_Payment_amount,Net_amount)),2) as RetailRevenue
 ,COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name) as CenterName
,COALESCE(mp.CDescript,zp.productname) AS SKU_Name, bb.tender_group_type --, mpt.Tender_Type
FROM Events_Retail ep
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
    LEFT OUTER JOIN Millennium_Products mp ON mp.iid = ep.item_id AND mp.ilocationid = ep.center_id AND ep.source_id = 1
    LEFT OUTER JOIN Zenoti_Bidimproduct zp ON zp.productwid = ep.product_id AND ep.source_ID = 2
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id 
 						AND ep.invoice_item_id = bb.Unit_ID
                                         	AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id 
    LEFT OUTER JOIN metric_Pmt_type_total mpt ON mpt.Transaction_ID = ep.Invoice_id
  						AND mpt.Unit_ID = ep.invoice_item_id
                                                AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = ep.Source_ID
    LEFT OUTER JOIN Metric_0_Payment_Items m0 ON m0.Transaction_ID = ep.Invoice_id
  						AND m0.Unit_ID = ep.invoice_item_id
                                                AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
    WHERE (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Hybrid' and mpt.Tender_Type = 'Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0216' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Ingrown Hair Serum%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Hybrid' and mpt.Tender_Type = 'Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0048' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Aloe Deodorant%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Hybrid' and mpt.Tender_Type = 'Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0312' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Calming Ingrown Hair Serum%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Hybrid' and mpt.Tender_Type = 'Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0223' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Ingrown Hair Serum%'))
or (dd.fiscal_year = 2021  and dd.fiscal_month in (10,11,12) and bb.tender_group_type = 'Hybrid' and mpt.Tender_Type = 'Monetary'
and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = '0899' and lower(COALESCE(mp.CDescript,zp.productname)) like lower('Coconut Body Polish%'))
GROUP BY Fiscal_Year, Fiscal_Month, COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), COALESCE(mp.CDescript,zp.productname),
bb.tender_group_type, mpt.Tender_Type ,COALESCE(zcr.franconnect_center_name,mcr.franconnect_center_name)
ORDER BY COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID), Fiscal_month

-----------------------------------------------------------------SystemWide----------------------------------------------------------------

------------------KPI:
WITH Net AS (
SELECT fc.fiscal_month, fc.fiscal_Year, 'Net Retail' AS SKU_Type, SUM(RevRec_Value) AS Retail_Revenue,  Tender_group_type, Revenue_type
FROM Metric_Retail_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_month, fc.fiscal_Year,   Tender_group_type, Revenue_type
ORDER BY fc.fiscal_Year, fc.Fiscal_Month
),
KPI_Retail_Sales_By_Center
as
(SELECT fc.fiscal_month, fc.fiscal_Year,  SKU_Type, SUM(RevRec_Value)  AS Retail_Revenue,  Tender_group_type, Revenue_type
FROM Metric_Retail_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_month, fc.fiscal_Year,  SKU_Type, Tender_group_type, Revenue_type
UNION
SELECT fiscal_month, fiscal_Year,  SKU_Type, Retail_Revenue, Tender_group_type, Revenue_type
FROM Net
ORDER BY fiscal_Year, Fiscal_Month
)
select fiscal_year, fiscal_month, -- ep.Center_ID,
Sku_type, round((ep.Retail_Revenue),2) as RetailRevenue, Tender_group_type, Revenue_type
from KPI_Retail_Sales_By_Center ep 
where sku_type= 'Retail' 
	AND fiscal_year = '2021'
	AND fiscal_Month in (10,11,12)
Group by fiscal_year, fiscal_Month,SKU_Type, Retail_Revenue, Tender_group_type, Revenue_type--,ep.Center_ID
ORDER BY fiscal_year,fiscal_Month, Tender_group_type, Revenue_type

-------------------Event:
SELECT Fiscal_Year,fiscal_month, 'Retail' as Sku_type,
 round(SUM(COALESCE(mpt.Total_Payment_amount,Net_amount)),2) as RetailRevenue, bb.tender_group_type , mpt.Tender_Type as Revenue_Type
FROM Events_Retail ep
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
    LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
    LEFT OUTER join tender_group_type as bb on ep.Invoice_id = bb.transaction_id
                                              AND ep.invoice_item_id = bb.Unit_ID
                                             and COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) = bb.center_id
    LEFT OUTER JOIN metric_Pmt_type_total mpt ON mpt.Transaction_ID = ep.Invoice_id
                                              AND mpt.Unit_ID = ep.invoice_item_id
                                              AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                              AND mpt.Source_ID = ep.Source_ID
   LEFT OUTER JOIN Metric_0_Payment_Items m0 ON m0.Transaction_ID = ep.Invoice_id
                                              AND m0.Unit_ID = ep.invoice_item_id
                                              AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
    WHERE dd.fiscal_year = 2021 and dd.fiscal_month in (10,11,12)
    and m0.Unit_ID is null
    and mpt.Tender_Type is not null
GROUP BY Fiscal_Year,fiscal_month, bb.tender_group_type, mpt.Tender_Type
ORDER BY Fiscal_Year,fiscal_month, bb.tender_group_type, mpt.Tender_Type