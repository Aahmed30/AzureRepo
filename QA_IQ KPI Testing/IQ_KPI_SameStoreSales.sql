--**********************Same Store Sales Testing********************************************************************
--SSS KPI
select Fiscal_Year, Fiscal_Month, cast(CY_Revenue as decimal(15,2)) as CY_Revenue, 
cast(Applied_Prior_Revenue as decimal(15,2)) as PY_Revenue, 
cast(SSS_Growth * 100 as decimal(15,2)) as SSS_Growth
FROM Same_Store_Sales_Growth_Month
Where Fiscal_Year = 2022
and fiscal_month in (1,2,3)
ORDER BY Fiscal_Year, Fiscal_Month


--QA Query
WITH Date_Center_Cartesian AS (
  SELECT
    fc.Fiscal_Month,
    fc.Fiscal_Year,
    fc.Day as Date,
    cd.Center_ID
  FROM
    dbt.Q1_2022.fiscalcalendar fc
    LEFT OUTER JOIN Center_Dates cd 
  ON fc.Day BETWEEN cd.Center_Opening_Date
    AND COALESCE(
      center_Terminated_Date,
      CAST('2022-03-27' AS DATE)
    )
 UNION 
SELECT fc.Fiscal_Month, fc.Fiscal_Year, fc.Day as Date, '0000' AS Center_ID
 FROM dbt.Q1_2022.fiscalcalendar fc
  WHERE fc.Day BETWEEN CAST('2020-04-02' AS DATE) AND Current_Date()
),
revenue AS (
  SELECT
    ci.Comp_Status,
    dc.date as Revrec_date,
    dc.Center_ID,
    SUM(
      CASE
        WHEN mrp.revenue_Type IS NOT NULL
        AND mrp.SKU_Type NOT IN ('Fixed Pass Refund') THEN mrp.RevRec_Value
        ELSE 0
      END
    ) AS Sales_Revenue
  FROM
    Date_Center_Cartesian dc
    left outer join Payment_Base mrp on dc.date = mrp.revrec_date
    AND mrp.Center_ID = dc.Center_ID
    LEFT OUTER JOIN (
      select
        distinct comp_status,
        center_id,
        day as date
      from
        Comp_Inclusion_Flag
    ) as ci ON ci.Center_ID = dc.Center_ID
    AND ci.date = dc.date
  WHERE
    dc.Center_ID <> '9999'
    and dc.date >= (date '2021-12-26')
    and dc.date < (date '2022-01-23')
  GROUP BY
    ci.Comp_Status,
    dc.date,
    dc.Center_ID
),
revenue_py AS (
  SELECT
    ci.Comp_Status,
    dc.date as Revrec_date,
    dc.Center_ID,
    SUM(
      CASE
        WHEN mrp.revenue_Type IS NOT NULL
        AND mrp.SKU_Type NOT IN ('Fixed Pass Refund') THEN mrp.RevRec_Value
        ELSE 0
      END
    ) AS Sales_Revenue
  FROM
    Date_Center_Cartesian dc
    left outer join Payment_Base mrp on dc.date = mrp.revrec_date
    AND mrp.Center_ID = dc.Center_ID
    LEFT OUTER JOIN (
      select
        distinct comp_status,
        center_id,
        Day as date
      from
        Comp_Inclusion_Flag
    ) as ci ON ci.Center_ID = dc.Center_ID
    AND ci.date = dc.date
  WHERE
    dc.Center_ID <> '9999'
    and dc.date >= (date '2020-12-27')
    and dc.date < (date '2021-01-24')
  GROUP BY
    ci.Comp_Status,
    dc.date,
    dc.Center_ID
),
combined_revenue as (
  select
    r1.center_id as cy_center_id,
    r1.Comp_Status as cy_comp_status,
    r1.revrec_date as cy_revrec_date,
    cast(r1.sales_revenue as decimal(15, 2)) as cy_sales_revenue,
    r2.center_id as py_center_id,
    r2.Comp_Status as py_comp_status,
    r2.revrec_date as py_revrec_date,
    cast(r2.sales_revenue as decimal(15, 2)) as py_sales_revenue,
    (
      case
        when r1.Comp_Status = 'Comp'
        and r2.Comp_Status = 'Comp' then 'Yes'
        else 'No'
      end
    ) as Include_Revenue
  from
    revenue r1
    left join revenue_py r2 on r1.center_id = r2.center_id
    and r2.RevRec_Date = DateAdd('day', -364, r1.RevRec_Date)
)
select
  *
from
  combined_revenue
order by
  cy_center_id,
cy_revrec_date
