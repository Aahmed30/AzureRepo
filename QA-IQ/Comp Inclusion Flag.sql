--===========================Comp Inclusion Flag=======================

SELECT * FROM Center_MIO_By_Date

select DISTINCT
        date
       ,fiscal_year
       ,fiscal_month
       ,Center_id
       ,Comp_status
       ,WEEK(Date) as  Weeks
FROM  Lookups_Comp_Inclusion_Flag 
--WHERE comp_status = 'NonComp'
ORDER BY Weeks DESC, center_id
---------------------------------------
SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id IN('0707')
--WHERE center_id IN('0707','0233','0888','0377')
-- AND fiscal_year = 2015
-- AND fiscal_month = 12

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id IN('0707')
--WHERE center_id IN('0707','0233','0888','0377')
AND fiscal_year = 2016
AND fiscal_month = 12


-------------KPI_System_Sales_Comp---------

WITH Net AS (
SELECT fc.fiscal_month, fc.fiscal_Year, mrp.center_id, 'Net Sales' AS SKU_Type, Comp_Status, MIO_Tier_Desc, SUM(RevRec_Value) AS Sales_Revenue
FROM Metric_Payment_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
LEFT OUTER JOIN Lookups_Comp_Inclusion_Flag comp ON comp.Center_ID = mrp.Center_ID AND comp.date = fc.date
LEFT OUTER JOIN Center_MIO_By_Date mi ON mrp.Center_ID = mi.Center_ID AND mrp.revrec_date = mi.date
WHERE revenue_Type IS NOT NULL
GROUP BY fc.fiscal_month, fc.fiscal_Year, Comp_Status, MIO_Tier_Desc ,mrp.center_id
ORDER BY fc.fiscal_Year, fc.Fiscal_Month
)
SELECT fc.fiscal_month, fc.fiscal_Year, mrp.center_id
,CASE WHEN	mrp.center_id =	'0358'	THEN	'New York - 57th Street	New York -(Large)'	
     WHEN	mrp.center_id =	'0160'	THEN	'New York - First Avenue	New York -(Large)'	
     WHEN	mrp.center_id =	'0707'	THEN	'Washington DC - Dupont Circle	District of Columbia -(Large)'
     WHEN	mrp.center_id =	'0024'	THEN	'Dallas - Old Town	Texas -(Large)'
     WHEN	mrp.center_id =	'0360'	THEN	'New York - Park Ave South		New York -(Large)'
     WHEN	mrp.center_id =	'0639'	THEN	'Greensboro		North Carolina -(Large)'
     WHEN	mrp.center_id =	'0814'	THEN	'Baltimore - Canton Crossing	Maryland -(Medium)'
     WHEN	mrp.center_id =	'0454'	THEN	'Annapolis	Maryland -(Medium)'
     WHEN	mrp.center_id =	'0719'	THEN	'Downey		California -(Medium)'
     WHEN	mrp.center_id =	'0451'	THEN	'Riverside		California -(Medium)'
     WHEN	mrp.center_id =	'0563'	THEN	'Poughkeepsie	New York -(Medium)'
     WHEN	mrp.center_id =	'0421'	THEN	'Knoxville		Tennessee -(Medium)'
     WHEN	mrp.center_id =	'0893'	THEN	'Philadelphia - Roosevelt Blvd		Pennsylvania -(Medium)'	
     WHEN	mrp.center_id =	'0515'	THEN	'Powell		Ohio'
     WHEN	mrp.center_id =	'0819'	THEN	'North Haven		Connecticut'
     WHEN	mrp.center_id =	'0724'	THEN	'Sandy Springs		Georgia -(Small)'
     WHEN	mrp.center_id =	'0591'	THEN	'Miami - Bird Ludlum	Florida -(Small)'
     WHEN	mrp.center_id =	'0765'	THEN	'Palm Beach Gardens - Mirasol	Florida -(Small)'
     WHEN	mrp.center_id =	'0866'	THEN	'Altamonte Springs		Florida -(Small)'
     WHEN	mrp.center_id =	'0722'	THEN	'Cambridge - Porter Square	Massachusetts -(Small)'
     WHEN	mrp.center_id =	'0954'	THEN	'954 Canton - Belden Village	Ohio -(NCO)'
     WHEN	mrp.center_id =	'0888'	THEN	'Camarillo	California -(NCO)'
     WHEN	mrp.center_id =	'0905'	THEN	'Winston-Salem	North Carolina -(NCO)'
     WHEN	mrp.center_id =	'0894'	THEN	'Harlem	New York -(NCO)'
     WHEN	mrp.center_id =	'0894'	THEN	'Harlem	New York -(NCO)'
     WHEN	mrp.center_id =	'0915'	THEN	'Foxborough	Massachusetts -(NCO)'
     WHEN   mrp.center_id = '0628'  THEN    '628	Metairie	Louisiana - (Medium)'
     WHEN   mrp.center_id = '0378'  THEN     '378	Jamaica	New York -(Small)'
     WHEN   mrp.center_id = '0377'  THEN     '377	North Wales Montgomeryville Pennsylvania -(Medium)'
     WHEN   mrp.center_id = '0233'  THEN     '233	Lewisville	Texas -(Small)'
     WHEN   mrp.center_id = '0947'  THEN     '947 Weymouth - Pleasant Shops  (NCO)'
     WHEN   mrp.center_id = '0946'  THEN     '946 Orlando - Shoppes at Nona Place  (NCO)'
     WHEN   mrp.center_id = '0886'  THEN     '886	Rochester Hills  (NCO)'
     WHEN   mrp.center_id = '0898'  THEN     '898	Bloomington (NCO)'
     WHEN   mrp.center_id = '0805'  THEN     '805 Dallas - Pavilion North Texas (NCO)'
     WHEN	mrp.center_id =	'0899'	THEN     '899 Viera -Florida (NCO)'	END   "CenterName"
,SKU_Type, Comp_Status, MIO_Tier_Desc, SUM(RevRec_Value) AS Sales_Revenue
FROM Metric_Payment_Base mrp
LEFT OUTER JOIN Lookups_FiscalConversion fc ON fc.date = mrp.revrec_date
LEFT OUTER JOIN Lookups_Comp_Inclusion_Flag comp ON comp.Center_ID = mrp.Center_ID AND comp.date = fc.date
LEFT OUTER JOIN Center_MIO_By_Date mi ON mrp.Center_ID = mi.Center_ID AND mrp.revrec_date = mi.date
WHERE revenue_Type IS NOT NULL
AND mrp.Center_id IN('0160','0707','0024','0360','0639','0814','0454','0719','0451','0563','0421','0893','0515','0819','0724'
                     ,'0591','0765','0866','0722','0954','0888','0905','0894','0894','0915','0227','0628','0378','0377','0233','0947','0946','0886','0898''0724','0535', '0972','0805', '0899' )
                     
GROUP BY fc.fiscal_month, fc.fiscal_Year, SKU_Type, Comp_Status, MIO_Tier_Desc,mrp.center_id
,CASE WHEN	mrp.center_id =	'0358'	THEN	'New York - 57th Street	New York -(Large)'	
     WHEN	mrp.center_id =	'0160'	THEN	'New York - First Avenue	New York -(Large)'	
     WHEN	mrp.center_id =	'0707'	THEN	'Washington DC - Dupont Circle	District of Columbia -(Large)'
     WHEN	mrp.center_id =	'0024'	THEN	'Dallas - Old Town	Texas -(Large)'
     WHEN	mrp.center_id =	'0360'	THEN	'New York - Park Ave South		New York -(Large)'
     WHEN	mrp.center_id =	'0639'	THEN	'Greensboro		North Carolina -(Large)'
     WHEN	mrp.center_id =	'0814'	THEN	'Baltimore - Canton Crossing	Maryland -(Medium)'
     WHEN	mrp.center_id =	'0454'	THEN	'Annapolis	Maryland -(Medium)'
     WHEN	mrp.center_id =	'0719'	THEN	'Downey		California -(Medium)'
     WHEN	mrp.center_id =	'0451'	THEN	'Riverside		California -(Medium)'
     WHEN	mrp.center_id =	'0563'	THEN	'Poughkeepsie	New York -(Medium)'
     WHEN	mrp.center_id =	'0421'	THEN	'Knoxville		Tennessee -(Medium)'
     WHEN	mrp.center_id =	'0893'	THEN	'Philadelphia - Roosevelt Blvd		Pennsylvania -(Medium)'	
     WHEN	mrp.center_id =	'0515'	THEN	'Powell		Ohio'
     WHEN	mrp.center_id =	'0819'	THEN	'North Haven		Connecticut'
     WHEN	mrp.center_id =	'0724'	THEN	'Sandy Springs		Georgia -(Small)'
     WHEN	mrp.center_id =	'0591'	THEN	'Miami - Bird Ludlum	Florida -(Small)'
     WHEN	mrp.center_id =	'0765'	THEN	'Palm Beach Gardens - Mirasol	Florida -(Small)'
     WHEN	mrp.center_id =	'0866'	THEN	'Altamonte Springs		Florida -(Small)'
     WHEN	mrp.center_id =	'0722'	THEN	'Cambridge - Porter Square	Massachusetts -(Small)'
     WHEN	mrp.center_id =	'0954'	THEN	'954 Canton - Belden Village	Ohio -(NCO)'
     WHEN	mrp.center_id =	'0888'	THEN	'Camarillo	California -(NCO)'
     WHEN	mrp.center_id =	'0905'	THEN	'Winston-Salem	North Carolina -(NCO)'
     WHEN	mrp.center_id =	'0894'	THEN	'Harlem	New York -(NCO)'
     WHEN	mrp.center_id =	'0894'	THEN	'Harlem	New York -(NCO)'
     WHEN	mrp.center_id =	'0915'	THEN	'Foxborough	Massachusetts -(NCO)'
     WHEN   mrp.center_id = '0628'  THEN    '628	Metairie	Louisiana - (Medium)'
     WHEN   mrp.center_id = '0378'  THEN     '378	Jamaica	New York -(Small)'
     WHEN   mrp.center_id = '0377'  THEN     '377	North Wales Montgomeryville Pennsylvania -(Medium)'
     WHEN   mrp.center_id = '0233'  THEN     '233	Lewisville	Texas -(Small)'
     WHEN   mrp.center_id = '0947'  THEN     '947 Weymouth - Pleasant Shops  (NCO)'
     WHEN   mrp.center_id = '0946'  THEN     '946 Orlando - Shoppes at Nona Place  (NCO)'
     WHEN   mrp.center_id = '0886'  THEN     '886	Rochester Hills  (NCO)'
     WHEN   mrp.center_id = '0898'  THEN     '898	Bloomington (NCO)'
     WHEN   mrp.center_id = '0805'  THEN     '805 Dallas - Pavilion North Texas (NCO)'
     WHEN	mrp.center_id =	'0899'	THEN     '899 Viera -Florida (NCO)'	END
     
UNION
SELECT fiscal_month, fiscal_Year, center_id 
,CASE WHEN	center_id =	'0358'	THEN	'New York - 57th Street	New York -(Large)'	
     WHEN	center_id =	'0160'	THEN	'New York - First Avenue	New York -(Large)'	
     WHEN	center_id =	'0707'	THEN	'Washington DC - Dupont Circle	District of Columbia -(Large)'
     WHEN	center_id =	'0024'	THEN	'Dallas - Old Town	Texas -(Large)'
     WHEN	center_id =	'0360'	THEN	'New York - Park Ave South		New York -(Large)'
     WHEN	center_id =	'0639'	THEN	'Greensboro		North Carolina -(Large)'
     WHEN	center_id =	'0814'	THEN	'Baltimore - Canton Crossing	Maryland -(Medium)'
     WHEN	center_id =	'0454'	THEN	'Annapolis	Maryland -(Medium)'
     WHEN	center_id =	'0719'	THEN	'Downey		California -(Medium)'
     WHEN	center_id =	'0451'	THEN	'Riverside		California -(Medium)'
     WHEN	center_id =	'0563'	THEN	'Poughkeepsie	New York -(Medium)'
     WHEN	center_id =	'0421'	THEN	'Knoxville		Tennessee -(Medium)'
     WHEN	center_id =	'0893'	THEN	'Philadelphia - Roosevelt Blvd		Pennsylvania -(Medium)'	
     WHEN	center_id =	'0515'	THEN	'Powell		Ohio'
     WHEN	center_id =	'0819'	THEN	'North Haven		Connecticut'
     WHEN	center_id =	'0724'	THEN	'Sandy Springs		Georgia -(Small)'
     WHEN	center_id =	'0591'	THEN	'Miami - Bird Ludlum	Florida -(Small)'
     WHEN	center_id =	'0765'	THEN	'Palm Beach Gardens - Mirasol	Florida -(Small)'
     WHEN	center_id =	'0866'	THEN	'Altamonte Springs		Florida -(Small)'
     WHEN	center_id =	'0722'	THEN	'Cambridge - Porter Square	Massachusetts -(Small)'
     WHEN	center_id =	'0954'	THEN	'954 Canton - Belden Village	Ohio -(NCO)'
     WHEN	center_id =	'0888'	THEN	'Camarillo	California -(NCO)'
     WHEN	center_id =	'0905'	THEN	'Winston-Salem	North Carolina -(NCO)'
     WHEN	center_id =	'0894'	THEN	'Harlem	New York -(NCO)'
     WHEN	center_id =	'0894'	THEN	'Harlem	New York -(NCO)'
     WHEN	center_id =	'0915'	THEN	'Foxborough	Massachusetts -(NCO)'
     WHEN   center_id = '0628'  THEN    '628	Metairie	Louisiana - (Medium)'
     WHEN   center_id = '0378'  THEN     '378	Jamaica	New York -(Small)'
     WHEN   center_id = '0377'  THEN     '377	North Wales Montgomeryville Pennsylvania -(Medium)'
     WHEN   center_id = '0233'  THEN     '233	Lewisville	Texas -(Small)'
     WHEN   center_id = '0947'  THEN     '947 Weymouth - Pleasant Shops  (NCO)'
     WHEN   center_id = '0946'  THEN     '946 Orlando - Shoppes at Nona Place  (NCO)'
     WHEN   center_id = '0886'  THEN     '886	Rochester Hills  (NCO)'
     WHEN   center_id = '0898'  THEN     '898	Bloomington (NCO)'
     WHEN   center_id = '0805'  THEN     '805 Dallas - Pavilion North Texas (NCO)'
     WHEN	center_id =	'0899'	THEN     '899 Viera -Florida (NCO)'	END "CenterName"
    ,SKU_Type, Comp_Status, MIO_Tier_Desc, Sales_Revenue

FROM Net
 WHERE Center_id IN('0160','0707','0024','0360','0639','0814','0454','0719','0451','0563','0421','0893','0515','0819','0724'
                     ,'0591','0765','0866','0722','0954','0888','0905','0894','0894','0915','0227','0628','0378','0377','0233','0947','0946','0886','0898''0724','0535', '0972','0805', '0899' )
                     
   ORDER BY fiscal_year  

--------------Lookups_Comp_Inclusion_Flag-----
WITH revrec_center_ids as (
  SELECT
    Distinct Center_ID
  FROM
    RevRec_Combined
  WHERE
    RevRec_Value > 0
    and event_type in ('Retail', 'Unlimited_Wax_Pass', 'Service') -- add "Fixed Package" when available
  ORDER BY
    Center_ID
),

center_x_date_cartesian as (
  SELECT
    Distinct Datekey,
    Date,
    Fiscal_Year,
    Fiscal_Month,
    Center_ID
  FROM
    Full_DateDimension
    CROSS JOIN revrec_center_ids
  WHERE
    Fiscal_Year is not NULL  -- Remove this WHERE clause when ALL fiscal dates are available
),

store_open_dates as (
  SELECT
    Distinct Datekey,
    Date,
    Fiscal_Year,
    Fiscal_Month,
    cdc.Center_ID,
    rc.Center_ID as cid_if_open
  FROM
    center_x_date_cartesian cdc
    LEFT JOIN (SELECT *
               FROM RevRec_Combined
               WHERE RevRec_Value > 0
               and event_type in ('Retail', 'Unlimited_Wax_Pass', 'Service') -- add "Fixed Package" when available
              ) rc on cdc.Center_ID = rc.Center_ID and cdc.Date = rc.RevRec_Date
  ORDER BY
    Date,
    cdc.Center_ID
),

is_open_calendar as (
  SELECT
    Distinct Datekey,
    Date,
    Fiscal_Year,
    Fiscal_Month,
    Center_ID,
    --     cid_if_open,
    case when cid_if_open = Center_ID then False
      else True end as store_closed
  FROM
    store_open_dates
  ORDER BY
    Center_ID,
    Date
),

consecutive_days_closed_calendar as (
  SELECT
    *,
    sum(cast(store_closed as int)) over (
      partition by Fiscal_Year, Center_ID
      order by date rows between 6 preceding and current row) as consecutive_days_closed
  FROM
    is_open_calendar
),

flag_1 as (
  SELECT
    *,
    case when consecutive_days_closed = 7 then True
      else NULL end as flag_1
  FROM
    consecutive_days_closed_calendar
  ORDER BY
    Date,
    Center_ID
),

first_day_reopened as (
  SELECT
    *,
    row_number() over (
      partition by Center_ID, flag_1
      order by date) as days_passed
  FROM
    flag_1
),

flag_2 as (
  SELECT
    *,
    case when days_passed < 364 then True
      else NULL end as flag_2
  FROM
    first_day_reopened
),

in_exclusion_window as (
  SELECT
    *,
    coalesce(flag_1, flag_2) as in_exclusion_window
  FROM
    flag_2
)

SELECT
  Datekey
  ,Date
  ,Fiscal_Year
--   ,Fiscal_Month
  ,Center_ID
  ,store_closed
  ,consecutive_days_closed
  ,flag_1 --consecutive_days_closed = 7
  ,days_passed
  ,flag_2   --days_passed < 364
  ,in_exclusion_window
  ,CASE WHEN in_exclusion_window = True then 'NonComp' ELSE 'Comp' END as "Comp_Status"
 ,CASE WHEN (CASE WHEN in_exclusion_window = True then 'NonComp' ELSE 'Comp' END)= 'Comp' THEN 'yes' ELSE 'No' END "COVID-19 Exception" 
  ,CASE 
     WHEN	center_id =	'0358'	THEN	'New York - 57th Street	New York -(Large)'	
     WHEN	center_id =	'0160'	THEN	'New York - First Avenue	New York -(Large)'	
     WHEN	center_id =	'0707'	THEN	'Washington DC - Dupont Circle	District of Columbia -(Large)'
     WHEN	center_id =	'0024'	THEN	'Dallas - Old Town	Texas -(Large)'
     WHEN	center_id =	'0360'	THEN	'New York - Park Ave South		New York -(Large)'
     WHEN	center_id =	'0639'	THEN	'Greensboro		North Carolina -(Large)'
     WHEN	center_id =	'0814'	THEN	'Baltimore - Canton Crossing	Maryland -(Medium)'
     WHEN	center_id =	'0454'	THEN	'Annapolis	Maryland -(Medium)'
     WHEN	center_id =	'0719'	THEN	'Downey		California -(Medium)'
     WHEN	center_id =	'0451'	THEN	'Riverside		California -(Medium)'
     WHEN	center_id =	'0563'	THEN	'Poughkeepsie	New York -(Medium)'
     WHEN	center_id =	'0421'	THEN	'Knoxville		Tennessee -(Medium)'
     WHEN	center_id =	'0893'	THEN	'Philadelphia - Roosevelt Blvd		Pennsylvania -(Medium)'	
     WHEN	center_id =	'0515'	THEN	'Powell		Ohio'
     WHEN	center_id =	'0819'	THEN	'North Haven		Connecticut'
     WHEN	center_id =	'0724'	THEN	'Sandy Springs		Georgia -(Small)'
     WHEN	center_id =	'0591'	THEN	'Miami - Bird Ludlum	Florida -(Small)'
     WHEN	center_id =	'0765'	THEN	'Palm Beach Gardens - Mirasol	Florida -(Small)'
     WHEN	center_id =	'0866'	THEN	'Altamonte Springs		Florida -(Small)'
     WHEN	center_id =	'0722'	THEN	'Cambridge - Porter Square	Massachusetts -(Small)'
     WHEN	center_id =	'0954'	THEN	'954 Canton - Belden Village	Ohio -(NCO)'
     WHEN	center_id =	'0888'	THEN	'Camarillo	California -(NCO)'
     WHEN	center_id =	'0905'	THEN	'Winston-Salem	North Carolina -(NCO)'
     WHEN	center_id =	'0894'	THEN	'Harlem	New York -(NCO)'
     WHEN	center_id =	'0915'	THEN	'Foxborough	Massachusetts -(NCO)'
     WHEN   Center_id = '0053'  THEN  'Houston - Bunker Hill -(Medium)'
     WHEN   Center_id = '0466'  THEN  '466	Shakopee Minnesota -(Small)'
     WHEN   Center_id = '0920'  THEN  'Providence - Wayland Ave	Rhode Island -(NCO)'
     WHEN   center_id = '0628'  THEN     '628	Metairie	Louisiana - (Medium)'
     WHEN   center_id = '0378'  THEN     '378	Jamaica	New York -(Small)'
     WHEN   center_id = '0792'  THEN     '792	Waldorf	Maryland -(Large)'
     WHEN   center_id = '0833'  THEN     '833	Highland	Indiana -(Medium)'
     WHEN   center_id = '0633'  THEN     '633	Austin - Four Points Texas -(Small)'
     WHEN   center_id = '0183'  THEN     '183	Fair Lawn	New Jersey -(Large)'
     WHEN   center_id = '0740'  THEN     '740	Boise	Idaho -(Medium)'
     WHEN   center_id = '0900'  THEN     '900	North Attleboro	Massachusetts -(Small)'
     WHEN   center_id = '0377'  THEN     '377	North Wales Montgomeryville Pennsylvania -(Medium)'
     WHEN   center_id = '0233'  THEN     '233	Lewisville	Texas -(Small)'
     WHEN   center_id = '0947'  THEN     '947 Weymouth - Pleasant Shops (NCO)'
     WHEN   center_id = '0957'  THEN     '957 Fayetteville - The Shoppes At Steele Crossing (NCO)'
     WHEN   center_id = '0946'  THEN     '946 Orlando - Shoppes at Nona Place (NCO)'
     WHEN   center_id = '0931'  THEN     '931 Houston - The Heights (NCO)'
     WHEN   center_id = '0886'  THEN     '886 Rochester Hills (NCO)'
     WHEN   center_id = '0898'  THEN     '898 Bloomington (NCO)'
     WHEN   center_id = '0828'  THEN     '828 Brandon (NCO)'
     WHEN    center_id = '0805'  THEN     '805 Dallas - Pavilion North Texas (NCO)'
     WHEN	center_id =	'0899'	THEN     '899 Viera -Florida (NCO)'	END  "CenterName"
FROM
  in_exclusion_window 
  --WHERE consecutive_days_closed >=7
  --WHERE Fiscal_Year =2021 AND fiscal_month IN(01,02,03)
  WHERE Center_id IN(
    '0160','0707','0024','0360','0639','0814','0454','0719','0451','0563','0421','0893','0515','0819','0724'
                     ,'0591','0765','0866','0722','0954','0888','0905','0894','0894','0915','0227','0466','0053','0920','0628','0378','0792'
                     ,'0833','0633','0227','0183','0740','0900','0377','0233',
                     '0947','0957','0946','0931','0886','0898','0828','0893','0227','0805','0899','0888')
  AND fiscal_year IN(2021,2020,2019,2018,2017,2016,2017,2016)
ORDER BY
  Date,
  Center_ID 
  
----------------------
SELECT * FROM Lookups_Comp_Inclusion_Flag WHERE Center_id = '0954' AND Fiscal_Year =2021 AND fiscal_month IN(01,02,03)
SELECT * FROM Lookups_Comp_Inclusion_Flag WHERE Center_id = '0814' AND Fiscal_Year =2016 
SELECT * FROM Lookups_Comp_Inclusion_Flag WHERE Center_id = '0915' AND Fiscal_Year =2019 
SELECT * FROM Lookups_Comp_Inclusion_Flag WHERE Center_id = '0888' AND Fiscal_Year =2019 AND fiscal_month IN(12)
SELECT * FROM Lookups_Comp_Inclusion_Flag WHERE Center_id = '0894' AND Fiscal_Year =2018 
SELECT * FROM Lookups_Comp_Inclusion_Flag WHERE Center_id = '0900' AND Fiscal_Year =2017 
SELECT * FROM Lookups_Comp_Inclusion_Flag WHERE Center_id = '0888' AND Fiscal_Year =2016 

SELECT DISTINCT
       mpb.Center_id
      ,mpb.Revrec_date
      ,comp.comp_status
FROM Metric_Payment_Base mpb 
INNER  JOIN Lookups_Comp_Inclusion_Flag comp ON comp.Center_ID = mpb.Center_ID 
WHERE mpb.center_id = '0160'
AND Revrec_Date = cast('2020-03-22 00:00:00' as timestamp)

-----------Any ≥7 consecutive day closure-----

SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0227'
AND fiscal_year = 2019
AND fiscal_month = 12

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0227'
AND fiscal_year = 2019
AND fiscal_month = 12
------------

SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0421'
AND fiscal_year = 2020
AND fiscal_month = 03

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0421'
AND fiscal_year = 2020
AND fiscal_month = 03
--------------------------
SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0451'
AND fiscal_year = 2020
AND fiscal_month = 06

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0451'
AND fiscal_year = 2020
AND fiscal_month = 06

---------------------
SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0233'
AND fiscal_year = 2019
AND fiscal_month = 12
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0233'
AND fiscal_year = 2019
AND fiscal_month = 12
-----------Multiple ≥7 consecutive day closures within 52 weeks-----------

SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0024'
AND fiscal_year = 2020
AND fiscal_month = 12
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0024'
AND fiscal_year = 2020
AND fiscal_month = 12
-----------
SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0053'
AND fiscal_year = 2017
AND fiscal_month = 12
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0053'
AND fiscal_year = 2020
AND fiscal_month = 12

------------Any closure in FY 2020 or Q1 2021 (properly apply COVID exception)------------
SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0454'
AND fiscal_year = 2016
AND fiscal_month = 09
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0454'
AND fiscal_year = 2016
AND fiscal_month = 09

----------------------------------------

SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0814'
AND fiscal_year = 2021
AND fiscal_month = 04
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0814'
AND fiscal_year = 2021
AND fiscal_month = 04

-------------------------------------
SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0866'
AND fiscal_year = 2021
-- AND fiscal_month = 09
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0866'
AND fiscal_year = 2021
--AND fiscal_month = 09
----------------------------------
SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0377'
AND fiscal_year = 2021
-- AND fiscal_month = 09
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0377'
AND fiscal_year = 2021
--AND fiscal_month = 09
-----------------------------------
SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0947'
AND fiscal_year = 2021
-- AND fiscal_month = 09
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0947'
AND fiscal_year = 2021
--AND fiscal_month = 09
------------
SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0957'
AND fiscal_year = 2021
-- AND fiscal_month = 09
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0957'
AND fiscal_year = 2021
--AND fiscal_month = 09
--------------------------

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0946'
AND fiscal_year = 2020
--AND fiscal_month = 09

SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0946'
AND fiscal_year = 2020
-- AND fiscal_month = 09
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0931'
AND fiscal_year = 2020
--AND fiscal_month = 09

SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0931'
AND fiscal_year = 2020
-- AND fiscal_month = 09
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0886'
AND fiscal_year = 2019
--AND fiscal_month = 09

SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0886'
AND fiscal_year = 2019
-- AND fiscal_month = 09
AND Sku_type = 'Net Sales'

SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0898'
AND fiscal_year = 2019
-- AND fiscal_month = 09
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0898'
AND fiscal_year = 2019
--AND fiscal_month = 09
---------

SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id = '0888'
AND fiscal_year = 2016
-- AND fiscal_month = 09
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag
WHERE center_id = '0888'
AND fiscal_year = 2016
--AND fiscal_month = 09

--------------NCO-------------


  SELECT
       ilocationId AS Mil_Id
       , cstorename
       , REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '') AS Ewc_CenterId -- format is 0000
  FROM Millennium_Locations
  --WHERE cstorename LIKE '%Washington DC%'
  WHERE ewc_centerid = '0029'

SELECT * FROM 	
KPI_System_Sales_Comp_Center
WHERE center_id IN('0888','0377','0233','0029')                 --0233  --Comp 
AND fiscal_year = 2016                                         --0377 --NonComp
-- AND fiscal_month = 01                                       --0029 --Comp 
AND Sku_type = 'Net Sales'

SELECT *
FROM Lookups_Comp_Inclusion_Flag                                --0029  --Comp
WHERE center_id IN('0888','0377','0233','0029')                  --0233 --Comp
AND fiscal_year = 2016                                          --0377 --Noncomp
-- AND fiscal_month = 01                                        --0377 --Noncomp


----------------------------------------------------------------