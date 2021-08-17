Scenario1 - Metric 
==================

"SELECT 
kpi.Fiscal_Year
,kpi.fiscal_month
,kpi.Center_ID AS ""Center_ID""
,kpi.SKU_Type AS ""SKU_Type""
,sum(kpi.Current_Year_Sales_Revenue) AS Current_Year_Sales
,SUM(kpi.Prior_Year_Sales_Revenue) AS Prior_Year_Sales
,sum(kpi.Sales_Growth) AS Sales_Growth
FROM Metric_Sales_Comparison_By_Center kpi
WHERE 
kpi.SKU_Type in('Retail','Service')
--kpi.SKU_Type ='Retail'
AND kpi.Fiscal_Year=2021 
and  kpi.fiscal_month=3
and kpi.center_id='0008'
GROUP BY 
       kpi.fiscal_year
      ,kpi.fiscal_month
      ,kpi.center_id
      ,kpi.SKU_Type
     -- ,kpi.Sales_Growth
Order by kpi.fiscal_month"

==========================================================
Event - Scenario1
==================


"with totalrevenue as ( SELECT (t.Revenue_Amt) AS Total_Revenue_Amt, fiscal_year, fiscal_month, t.Center_ID,sku_type
FROM (select sum(net_amount) as Revenue_Amt, fiscal_year, fiscal_month
      ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID,'Service' as sku_type
      from Events_Services es
      LEFT OUTER JOIN full_Datedimension dd ON dd.date = es.closed_date_in_center
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = es.Center_ID AND es.Source_ID = 2
      LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = es.Center_ID AND es.Source_ID = 1
      LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = es.Invoice_id
                                                  AND mpt.Unit_ID = es.invoice_item_id
                                                AND mpt.Center_ID =                                  COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = es.Source_ID
      where mpt.Unit_ID is null
      group by fiscal_year, fiscal_month,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
      UNION ALL
      select sum(net_amount) as Revenue_Amt, fiscal_year, fiscal_month
                  ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID,'Retail'as sku_type
            
      from Events_Retail ep
              LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
              LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
              LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID =1
              LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = ep.Invoice_id
                                                  AND mpt.Unit_ID = ep.invoice_item_id
                                                AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = ep.Source_ID
      where mpt.Unit_ID is null
      
          group by fiscal_year , fiscal_month,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
         )t
                      --group by fiscal_year, fiscal_month,t.Center_ID,sku_type--,t.Revenue_Amt
)
select (c1.Total_Revenue_Amt) as Current_Year_Revenue
, (c2.Total_Revenue_Amt) as Previous_Year_Revenue
,((c1.Total_Revenue_Amt - c2.Total_Revenue_Amt)/c2.Total_Revenue_Amt+1) as SalesGrowth,
c1.fiscal_year as Current_Year
, c2.fiscal_year as Previous_year
, c1.fiscal_month as CurrentMonth
, c2.fiscal_month
, c1.Center_ID
,c1.sku_type
FROM totalrevenue c1
LEFT JOIN totalrevenue c2 ON c2.fiscal_year = c1.fiscal_year - 1 
and c2.fiscal_month = c1.fiscal_month 
and c2.Center_ID = c1.Center_ID
and c1.sku_type= c2.sku_type
where c1.fiscal_year = 2021 
and c1.Center_ID = '0008' 
and c1.fiscal_month =3
group by 
c1.fiscal_year
, c1.fiscal_month
, c2.fiscal_month
, c1.Total_Revenue_Amt
, c2.Total_Revenue_Amt
, c2.fiscal_year
, c1.Center_ID
,c1.sku_type
order by c1.fiscal_month, c2.fiscal_month"

=================================================================================

Metric - Scenario2 
==================

"SELECT 
kpi.Fiscal_Year
,kpi.fiscal_month
,kpi.Center_ID AS ""Center_ID""
,kpi.SKU_Type AS ""SKU_Type""
,sum(kpi.Current_Year_Sales_Revenue) AS Current_Year_Sales
,SUM(kpi.Prior_Year_Sales_Revenue) AS Prior_Year_Sales
,sum(kpi.Sales_Growth) AS Sales_Growth
FROM Metric_Sales_Comparison_By_Center kpi
WHERE 
--kpi.SKU_Type in('Retail','Service')
kpi.SKU_Type ='Service'
AND kpi.Fiscal_Year=2012 
and  kpi.fiscal_month =1
and kpi.center_id='0889'
GROUP BY 
       kpi.fiscal_year
      ,kpi.fiscal_month
      ,kpi.center_id
      ,kpi.SKU_Type
     -- ,kpi.Sales_Growth
Order by kpi.fiscal_month"

==============================================================================

Event - Scenario 2
===================

"with Events_Services as (
SELECT DISTINCT
        sum(aa.net_amount) as Sales_Revenue,
        fc.fiscal_year, fc.fiscal_month
        ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID,'Service' as sku_type
      
FROM Events_Services aa
    
   LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = aa.Center_ID AND aa.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = aa.Center_ID AND aa.Source_ID = 1
   LEFT OUTER JOIN Millennium_Services mp  ON mp.iid = aa.service_id AND mp.ilocationid = aa.center_id  AND aa.source_id = 1
  LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = aa.service_id AND aa.source_ID = 2
  LEFT OUTER JOIN full_Datedimension fc ON fc.Date = aa.closed_date_in_center
  LEFT OUTER JOIN Metric_0_Payment_Items mpt ON mpt.Transaction_ID = aa.Invoice_id
                                                  AND mpt.Unit_ID = aa.invoice_item_id
                                                AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = aa.Source_ID
 where mpt.Unit_ID is null
GROUP BY  fc.fiscal_year, fc.fiscal_month
        ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID))
  select cy.fiscal_year
  ,py.fiscal_year as fiscalyear
  , cy.fiscal_month
  , cy.Center_ID
  ,cy.sku_type
  , (cy.Sales_Revenue )as Current_Year_Sales_Revenue
  ,(py.Sales_Revenue) as Prior_Year_Sales_Revenue
 ,((cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1) as Sales_Growth
from
Events_Services cy
  left join Events_Services py 
  on cast(cy.fiscal_Year as int) -1 = cast(py.fiscal_Year as int)
  and cy.fiscal_month = py.fiscal_month 
  and cy.sku_type = py.sku_type
  and cy.Center_ID = py.Center_ID
  where cy.Center_ID='0889' and cy.fiscal_year=2012  
  and cy.fiscal_month=1
  Group by cy.fiscal_year
  , cy.fiscal_month
  , cy.Center_ID
  ,py.fiscal_year
  ,cy.sku_type
  ,cy.Sales_Revenue
  ,py.Sales_Revenue
  order by cy.fiscal_month"

==============================================================================================

Metric - Scenario3
==================

"SELECT 
kpi.Fiscal_Year
,kpi.fiscal_month
,kpi.Center_ID AS ""Center_ID""
,kpi.SKU_Type AS ""SKU_Type""
,sum(kpi.Current_Year_Sales_Revenue) AS Current_Year_Sales
,SUM(kpi.Prior_Year_Sales_Revenue) AS Prior_Year_Sales
,sum(kpi.Sales_Growth) AS Sales_Growth
FROM Metric_Sales_Comparison_By_Center kpi
WHERE 
--kpi.SKU_Type in('Retail','Service')
kpi.SKU_Type ='Retail'
AND kpi.Fiscal_Year=2014 
and  kpi.fiscal_month=5
and kpi.center_id='0334'
GROUP BY 
       kpi.fiscal_year
      ,kpi.fiscal_month
      ,kpi.center_id
      ,kpi.SKU_Type
     -- ,kpi.Sales_Growth
Order by kpi.fiscal_month"


==============================================================================

Event - Scenario3
==================

"with retail as (
SELECT DISTINCT
  		sum(aa.net_amount) as Sales_Revenue
       ,fc.fiscal_year, fc.fiscal_month
        ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
        --,COALESCE(mp.CDescript,zp.productname) AS SKU_Name---, 'Retail' as sku_type
        ,'Retail' as sku_type
FROM Events_Retail aa
  
   LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = aa.Center_ID AND aa.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = aa.Center_ID AND aa.Source_ID = 1
    LEFT OUTER JOIN Millennium_Products mp ON mp.iid = aa.item_id AND mp.ilocationid = aa.center_id AND aa.source_id = 1
    LEFT OUTER JOIN Zenoti_Bidimproduct zp ON zp.productwid = aa.product_id AND aa.source_ID = 2
  LEFT OUTER JOIN full_Datedimension fc ON fc.Date = aa.closed_date_in_center
  LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = aa.Invoice_id
                                                  AND mpt.Unit_ID = aa.invoice_item_id
                                                AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = aa.Source_ID
  where mpt.Unit_ID is null
Group BY fc.fiscal_year, fc.fiscal_month
        ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) )
 
  select
  cy.fiscal_year
  ,py.fiscal_year as fiscalyear
  --,(py.fiscal_year+2) as fiscalyear
  ,cy.fiscal_month
  ,cy.sku_type
 ,cy.Center_ID
   ,cy.Sales_Revenue as Current_Year_Sales_Revenue
  ,py.Sales_Revenue as Prior_Year_Sales_Revenue
,((cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1) as Sales_Growth
from
  retail cy
 
  left join retail py 
 on cast(cy.fiscal_Year as int) -1 = cast(py.fiscal_Year as int)
 -- on cast(cy.fiscal_Year as int) -2 = cast(py.fiscal_Year as int)
  and cy.fiscal_month = py.fiscal_month 
  and cy.center_id = py.center_id
  
   where  cy.Center_ID ='0334' and cy.fiscal_year=2014
   and cy.fiscal_month =5
   GROUP BY cy.fiscal_year ,cy.fiscal_month, py.fiscal_year
    ,cy.Center_ID
    ,cy.Sales_Revenue
  ,py.Sales_Revenue 
  ,cy.sku_type
   -- ,(cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1
 order by cy.fiscal_month"

=================================================================================================

Event - Scenario4
==================

"with totalrevenue as ( SELECT (t.Revenue_Amt) AS Total_Revenue_Amt, fiscal_year, fiscal_month, t.Center_ID,sku_type
FROM (select sum(net_amount) as Revenue_Amt, fiscal_year, fiscal_month
      ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID,'Service' as sku_type
      from Events_Services es
      LEFT OUTER JOIN full_Datedimension dd ON dd.date = es.closed_date_in_center
      LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = es.Center_ID AND es.Source_ID = 2
      LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = es.Center_ID AND es.Source_ID = 1
      LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = es.Invoice_id
                                                  AND mpt.Unit_ID = es.invoice_item_id
                                                AND mpt.Center_ID =                                  COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = es.Source_ID
      where mpt.Unit_ID is null
      group by fiscal_year, fiscal_month,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
      UNION ALL
      select sum(net_amount) as Revenue_Amt, fiscal_year, fiscal_month
                  ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) as Center_ID,'Retail'as sku_type
            
      from Events_Retail ep
              LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
              LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
              LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID =1
              LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = ep.Invoice_id
                                                  AND mpt.Unit_ID = ep.invoice_item_id
                                                AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = ep.Source_ID
      where mpt.Unit_ID is null
      
          group by fiscal_year , fiscal_month,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
         )t
                      --group by fiscal_year, fiscal_month,t.Center_ID,sku_type--,t.Revenue_Amt
)
select (c1.Total_Revenue_Amt) as Current_Year_Revenue
, (c2.Total_Revenue_Amt) as Previous_Year_Revenue
,((c1.Total_Revenue_Amt - c2.Total_Revenue_Amt)/c2.Total_Revenue_Amt+1) as SalesGrowth,
c1.fiscal_year as Current_Year
, c2.fiscal_year as Previous_year
, c1.fiscal_month as CurrentMonth
, c2.fiscal_month
, c1.Center_ID
,c1.sku_type
FROM totalrevenue c1
LEFT JOIN totalrevenue c2 ON c2.fiscal_year = c1.fiscal_year - 2 
and c2.fiscal_month = c1.fiscal_month 
and c2.Center_ID = c1.Center_ID
and c1.sku_type= c2.sku_type
where c1.fiscal_year = 2021 
and c1.Center_ID = '0908' 
and c1.fiscal_month=2
group by 
c1.fiscal_year
, c1.fiscal_month
, c2.fiscal_month
, c1.Total_Revenue_Amt
, c2.Total_Revenue_Amt
, c2.fiscal_year
, c1.Center_ID
,c1.sku_type
order by c1.fiscal_month, c2.fiscal_month"

===============================================================================

Metric - Scenario4
==================

"
   
   select
  cy.fiscal_month as Fiscal_Month,
  cy.fiscal_Year as Fiscal_Year,py.fiscal_Year as PYear,
 cy.center_id as Center_ID,
 cy.sku_type as SKU_Type,
  sum(cy.Sales_Revenue) as Current_Year_Sales_Revenue,
 sum( py.Sales_Revenue) as Prior_Year_Sales_Revenue
 ,sum((cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1) as Sales_Growth
from
  Metric_System_Sales_By_Center cy
  left join Metric_System_Sales_By_Center py 
  on cast(cy.fiscal_Year as int) -2 = cast(py.fiscal_Year as int)
  and cy.fiscal_month = py.fiscal_month 
  and cy.center_id=py.center_id
  and cy.sku_type = py.sku_type 
  and cy.center_id = py.center_id
  where cy.fiscal_Year=2021
  and cy.center_id='0908'
and cy.fiscal_month =2
 and cy.sku_type in('Retail','Service')
 --and cy.sku_type='Retail'
 
  Group by cy.fiscal_Year,py.fiscal_Year
  ,cy.center_id
 ,cy.sku_type
  ,cy.fiscal_month
 -- ,cy.Sales_Revenue
 -- ,py.Sales_Revenue
 --,(cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1
order by 
 cy.fiscal_month
 --,cy.sku_type

    
==================================================================================================

Metric - Scenario5
==================

" select
  cy.fiscal_month as Fiscal_Month,
  cy.fiscal_Year as Fiscal_Year,py.fiscal_Year as PYear,
 cy.center_id as Center_ID,
 cy.sku_type as SKU_Type,
  sum(cy.Sales_Revenue) as Current_Year_Sales_Revenue,
 sum( py.Sales_Revenue) as Prior_Year_Sales_Revenue
 ,sum((cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1) as Sales_Growth
from
  Metric_System_Sales_By_Center cy
  left join Metric_System_Sales_By_Center py 
  on cast(cy.fiscal_Year as int) -2 = cast(py.fiscal_Year as int)
  and cy.fiscal_month = py.fiscal_month 
  and cy.center_id=py.center_id
  and cy.sku_type = py.sku_type 
  and cy.center_id = py.center_id
  where cy.fiscal_Year=2010
  and cy.center_id='0539'
 and cy.fiscal_month =6
 --and cy.sku_type in('Retail','Service')
 and cy.sku_type='Service'
 
  Group by cy.fiscal_Year,py.fiscal_Year
  ,cy.center_id
 ,cy.sku_type
  ,cy.fiscal_month
 -- ,cy.Sales_Revenue
 -- ,py.Sales_Revenue
 --,(cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1
order by 
 cy.fiscal_month
 --,cy.sku_type

    
    "

===============================================================================

Event - Scenario5
=================

"with Events_Services as (
SELECT DISTINCT
        sum(aa.net_amount) as Sales_Revenue,
        fc.fiscal_year, fc.fiscal_month
        ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID,'Service' as sku_type
      
FROM Events_Services aa
    
   LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = aa.Center_ID AND aa.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = aa.Center_ID AND aa.Source_ID = 1
   LEFT OUTER JOIN Millennium_Services mp  ON mp.iid = aa.service_id AND mp.ilocationid = aa.center_id  AND aa.source_id = 1
  LEFT OUTER JOIN Zenoti_bidimservice zp ON zp.servicewid = aa.service_id AND aa.source_ID = 2
  LEFT OUTER JOIN full_Datedimension fc ON fc.Date = aa.closed_date_in_center
  LEFT OUTER JOIN Metric_0_Payment_Items mpt ON mpt.Transaction_ID = aa.Invoice_id
   AND mpt.Unit_ID = aa.invoice_item_id
AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
  AND mpt.Source_ID = aa.Source_ID
 where mpt.Unit_ID is null
GROUP BY  fc.fiscal_year, fc.fiscal_month
        ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID))
  select cy.fiscal_year
  ,py.fiscal_year as fiscalyear
  , cy.fiscal_month
  , cy.Center_ID
  ,cy.sku_type
  , (cy.Sales_Revenue )as Current_Year_Sales_Revenue
  ,(py.Sales_Revenue) as Prior_Year_Sales_Revenue
 ,((cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1) as Sales_Growth
from
Events_Services cy
  left join Events_Services py 
  on cast(cy.fiscal_Year as int) -2 = cast(py.fiscal_Year as int)
  and cy.fiscal_month = py.fiscal_month 
  and cy.sku_type = py.sku_type
  and cy.Center_ID = py.Center_ID
  where cy.Center_ID='0539' and cy.fiscal_year=2010  
  and cy.fiscal_month=6
  Group by cy.fiscal_year
  , cy.fiscal_month
  , cy.Center_ID
  ,py.fiscal_year
  ,cy.sku_type
  ,cy.Sales_Revenue
  ,py.Sales_Revenue
  order by cy.fiscal_month"

==========================================================================================

Metric - Scenario6
==================

"select
  cy.fiscal_month as Fiscal_Month,
  cy.fiscal_Year as Fiscal_Year,py.fiscal_Year as PYear,
 cy.center_id as Center_ID,
 cy.sku_type as SKU_Type,
  sum(cy.Sales_Revenue) as Current_Year_Sales_Revenue,
 sum( py.Sales_Revenue) as Prior_Year_Sales_Revenue
 ,sum((cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1) as Sales_Growth
from
  Metric_System_Sales_By_Center cy
  left join Metric_System_Sales_By_Center py 
  on cast(cy.fiscal_Year as int) -2 = cast(py.fiscal_Year as int)
  and cy.fiscal_month = py.fiscal_month 
  and cy.center_id=py.center_id
  and cy.sku_type = py.sku_type 
  and cy.center_id = py.center_id
  where cy.fiscal_Year=2015
  and cy.center_id='0542'
and cy.fiscal_month=10
 --and cy.sku_type in('Retail','Service')
 and cy.sku_type='Retail'
 
  Group by cy.fiscal_Year,py.fiscal_Year
  ,cy.center_id
 ,cy.sku_type
  ,cy.fiscal_month
 -- ,cy.Sales_Revenue
 -- ,py.Sales_Revenue
 --,(cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1
order by 
 cy.fiscal_month
 --,cy.sku_type

    
    "
========================================================================================

Event - Scenario6
=====================

"with retail as (
SELECT DISTINCT
  		sum(aa.net_amount) as Sales_Revenue
       ,fc.fiscal_year, fc.fiscal_month
        ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
        --,COALESCE(mp.CDescript,zp.productname) AS SKU_Name---, 'Retail' as sku_type
        ,'Retail' as sku_type
FROM Events_Retail aa
  
   LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = aa.Center_ID AND aa.Source_ID = 2
   LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = aa.Center_ID AND aa.Source_ID = 1
    LEFT OUTER JOIN Millennium_Products mp ON mp.iid = aa.item_id AND mp.ilocationid = aa.center_id AND aa.source_id = 1
    LEFT OUTER JOIN Zenoti_Bidimproduct zp ON zp.productwid = aa.product_id AND aa.source_ID = 2
  LEFT OUTER JOIN full_Datedimension fc ON fc.Date = aa.closed_date_in_center
  LEFT OUTER JOIN Metric_0_Payment_Items mpt ON  mpt.Transaction_ID = aa.Invoice_id
                                                  AND mpt.Unit_ID = aa.invoice_item_id
                                                AND mpt.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
                                                AND mpt.Source_ID = aa.Source_ID
  where mpt.Unit_ID is null
Group BY fc.fiscal_year, fc.fiscal_month
        ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) )
 
  select
  cy.fiscal_year
  ,py.fiscal_year as fiscalyear
  --,(py.fiscal_year+2) as fiscalyear
  ,cy.fiscal_month
  ,cy.sku_type
 ,cy.Center_ID
   ,cy.Sales_Revenue as Current_Year_Sales_Revenue
  ,py.Sales_Revenue as Prior_Year_Sales_Revenue
,((cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1) as Sales_Growth
from
  retail cy
 
  left join retail py 
 -- on cast(cy.fiscal_Year as int) -1 = cast(py.fiscal_Year as int)
  on cast(cy.fiscal_Year as int) -2 = cast(py.fiscal_Year as int)
  and cy.fiscal_month = py.fiscal_month 
  and cy.center_id = py.center_id
  
   where  cy.Center_ID ='0542' and cy.fiscal_year=2015
   and cy.fiscal_month =10
   GROUP BY cy.fiscal_year ,cy.fiscal_month, py.fiscal_year
    ,cy.Center_ID
    ,cy.Sales_Revenue
  ,py.Sales_Revenue 
  ,cy.sku_type
   -- ,(cy.Sales_Revenue - py.Sales_Revenue) / py.Sales_Revenue + 1
 order by cy.fiscal_month"


