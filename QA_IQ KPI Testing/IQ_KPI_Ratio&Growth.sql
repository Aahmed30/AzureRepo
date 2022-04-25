---KPI - Wax 
----------------------------
with KPI_System_Sales as 
(SELECT fc.fiscal_month, fc.fiscal_Year, 
   count(distinct Transaction_id) AS Total_Transaction
  ,count(distinct case when sku_type in('Unlimited Pass','Fixed Pass') then Transaction_id end) AS Retail_Transaction
FROM Metric_Payment_Base mrp
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
      AND Center_ID <> '9999'
GROUP BY fc.fiscal_month, fc.fiscal_Year)
select Fiscal_year, Fiscal_month,
Total_Transaction, Retail_Transaction, 
  round(cast(Retail_Transaction as double)/cast(Total_Transaction as double),8) as RetailRate  
  from KPI_System_Sales
  where fiscal_year=2021 and fiscal_month in (10,11,12)
  order by fiscal_month			
				
---------------------------------------------------------------

--Event - Wax Pass 
---------------------------------------------------------------

"""""""with retail as (
SELECT
  fc.fiscal_year, fc.fiscal_month,
  count(distinct Transaction_id) AS Total_Transaction
  ,count(distinct case when Event_type in('Unlimited Pass','Fixed Pass') then Transaction_id end) AS Retail_Transaction
 FROM RevRec_combined rr
  LEFT OUTER JOIN full_Datedimension fc ON fc.date = rr.RevRec_date
  group by fc.fiscal_year, fc.fiscal_month
  )
  select Fiscal_year, Fiscal_month,
  Total_Transaction, Retail_Transaction, 
  round(cast(Retail_Transaction as double)/cast(Total_Transaction as double),8) as RetailRate
  from retail
  where fiscal_year=2021 and fiscal_month in (10,11,12)
  order by fiscal_month			
				
				
---------------------------------------------------------------------------

--------Sc1 - RetailRate KPI 
-------------------------------

"""""""with KPI_System_Sales as 
(SELECT fc.fiscal_month, fc.fiscal_Year, 
   count(distinct Transaction_id) AS Total_Transaction
  ,count(distinct case when sku_type = 'Retail' then Transaction_id end) AS Retail_Transaction
FROM Metric_Payment_Base mrp
LEFT OUTER JOIN full_datedimension fc ON fc.date = mrp.revrec_date
WHERE revenue_Type IS NOT NULL
      AND Center_ID <> '9999'
GROUP BY fc.fiscal_month, fc.fiscal_Year)
select Fiscal_year, Fiscal_month,
Total_Transaction, Retail_Transaction, 
  round(cast(Retail_Transaction as double)/cast(Total_Transaction as double),8) as RetailRate  
  from KPI_System_Sales
  where fiscal_year=2021 and fiscal_month in (10,11,12)
  order by fiscal_month				
				
---------------------------------------------------

---Event - RetailRate
----------------------------------

with retail as (
SELECT
  fc.fiscal_year, fc.fiscal_month,
  count(distinct Transaction_id) AS Total_Transaction
  ,count(distinct case when Event_type = 'Retail' then Transaction_id end) AS Retail_Transaction
 FROM RevRec_combined rr
  LEFT OUTER JOIN full_Datedimension fc ON fc.date = rr.RevRec_date
  group by fc.fiscal_year, fc.fiscal_month
  )
  select Fiscal_year, Fiscal_month,
  Total_Transaction, Retail_Transaction, 
  round(cast(Retail_Transaction as double)/cast(Total_Transaction as double),8) as RetailRate
  from retail
  where fiscal_year=2021 and fiscal_month in (10,11,12)
  order by fiscal_month				
				
				
---------------------------------------------------------------

--------Sc - 3 - SystemSale KPI

with totalrevenue as ( SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt, Fiscal_year,Fiscal_month
FROM (select sum(Retail_Revenue) as Revenue_Amt, Fiscal_year, Fiscal_month
from KPI_Retail_Sales
where sku_type = 'Retail'
group by Fiscal_year,Fiscal_month, Retail_Revenue
UNION ALL
select sum(Service_Revenue) as Revenue_Amt, Fiscal_year, Fiscal_month
from KPI_Service_Sales
where sku_type = 'Service'
group by Fiscal_year,Fiscal_month, Service_Revenue
)t
group by Fiscal_year,Fiscal_month
) --
select c1.Total_Revenue_Amt as Current_Year_Revenue , c2.Total_Revenue_Amt as Previous_Year_Revenue,
((c1.Total_Revenue_Amt - c2.Total_Revenue_Amt)/c2.Total_Revenue_Amt+1) as SalesGrowth,
c1.fiscal_year as Current_Year, c2.fiscal_year as Previous_year
,c1.Fiscal_month as Month
FROM totalrevenue c1
LEFT JOIN totalrevenue c2 ON c2.fiscal_year = c1.fiscal_year - 1 and c1.Fiscal_month =c2.Fiscal_month
where c1.fiscal_year = 2021 and c1.Fiscal_month in (10,11,12)
group by c1.fiscal_year, c1.Total_Revenue_Amt, c2.Total_Revenue_Amt, c2.fiscal_year,c1.Fiscal_month
order by c1.fiscal_year
				
				
-----------------------------------------------------------

-----Event - Sc3 

---------------------------------
with totalrevenue as ( SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt, fiscal_year, fiscal_month--, t.sku_type
FROM (select sum(net_amount) as Revenue_Amt, fiscal_year, fiscal_month--, 'Service' as sku_type
from Events_Services es
LEFT OUTER JOIN full_Datedimension dd ON dd.date = es.closed_date_in_center
LEFT OUTER JOIN Metric_0_Payment_Items m0 ON m0.Transaction_ID = es.Invoice_id
AND m0.Unit_ID = es.invoice_item_id
--AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
where m0.Unit_ID is null 
group by fiscal_year, fiscal_month --,net_amount
UNION ALL
select sum(net_amount) as Revenue_Amt, fiscal_year, fiscal_month--, 'Retail' as sku_type
from Events_Retail ep
LEFT OUTER JOIN full_Datedimension dd ON dd.date = ep.closed_date_in_center
LEFT OUTER JOIN Metric_0_Payment_Items m0 ON m0.Transaction_ID = ep.Invoice_id
AND m0.Unit_ID = ep.invoice_item_id
--AND m0.Center_ID = COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID)
where m0.Unit_ID is null
group by fiscal_year, fiscal_month --, net_amount
)t
group by fiscal_year, fiscal_month--, t.sku_type
)
select c1.Total_Revenue_Amt as Current_Year_Revenue , c2.Total_Revenue_Amt as Previous_Year_Revenue,
((c1.Total_Revenue_Amt - c2.Total_Revenue_Amt)/c2.Total_Revenue_Amt+1) as SalesGrowth,
c1.fiscal_year as Current_Year, c2.fiscal_year as Previous_year, c1.fiscal_month --, c1.sku_type as Skutype, c2.sku_type
FROM totalrevenue c1
LEFT JOIN totalrevenue c2 ON c2.fiscal_year = c1.fiscal_year - 1 and c2.fiscal_month = c1.fiscal_month--and c1.sku_type = c2.sku_type
where c1.fiscal_year = 2021 and c1.fiscal_month in (10,11,12)
group by c1.fiscal_year, c1.Total_Revenue_Amt, c2.Total_Revenue_Amt, c2.fiscal_year, c1.fiscal_month --, c1.sku_type, c2.sku_type
order by c1.fiscal_year, c1.fiscal_month 



