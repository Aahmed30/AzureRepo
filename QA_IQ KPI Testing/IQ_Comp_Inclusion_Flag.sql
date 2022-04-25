/********************************* Snowflake ***************************************************************/


/****TC -Comp Inclusion Flag_Q2_2022******/
------------------------------------

------------dbt_kpi.q1_2022.comp_inclusion_flag


SELECT
  --Datekey AS Datekey,
 -- Date AS Date,
  Fiscal_Year AS FISCAL_YEAR,
  fiscal_yearquarter AS fiscal_yearquarter,
  Fiscal_Month AS fiscal_month,
 -- weeknum AS """"weeknum"""",
  Center_ID AS center_id,
  Comp_Status AS COMP_STATUS,
  CASE 
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
     WHEN	center_id =	'0899'	THEN     '899 Viera -Florida (NCO)'	END  CenterName
  
FROM
dbt_kpi.q1_2022.comp_inclusion_flag
 -------------------- Lookups_Comp_Inclusion_Flag
  where  fiscal_month in(1,2,3) and fiscal_year=2022
  and Center_ID in ('0160','0454','0591','0954')
 
  
  group by 
  CASE 
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
     WHEN	center_id =	'0899'	THEN     '899 Viera -Florida (NCO)'	END
     
    -- , Datekey ,
  --,Date 
  ,Fiscal_Year ,
  fiscal_yearquarter ,
  Fiscal_Month ,
  --weeknum AS """"weeknum"""",
  Center_ID ,
  Comp_Status 
  
  order by Center_ID,Fiscal_Month	

------------------------------------------------------------------------------------------------------------------------

-----------------KPI _System_Sale_Comp	

					
					
WITH Net AS (
SELECT fc.fiscal_month, fc.fiscal_Year, mrp.center_id,'Net Sales' AS SKU_Type, 
  Comp_Status, MIO_Tier_Desc, SUM(RevRec_Value) AS Sales_Revenue
FROM   dbt_kpi.q1_2022.payment_base mrp ---------- payment_base mrp
LEFT OUTER JOIN dbt.prod.fiscalcalendar fc ON fc.day = mrp.revrec_date
LEFT OUTER JOIN comp_inclusion_flag comp ON comp.Center_ID = mrp.Center_ID AND comp.day = fc.day
LEFT OUTER JOIN Center_MIO_By_Date mi ON mrp.Center_ID = mi.Center_ID AND mrp.revrec_date = mi.day
WHERE revenue_Type IS NOT NULL  and fc.fiscal_month in(1,2,3) and fc.fiscal_Year='2022'
GROUP BY fc.fiscal_month, fc.fiscal_Year, Comp_Status, MIO_Tier_Desc ,mrp.center_id,SKU_Type
 ORDER BY fc.fiscal_Year, fc.Fiscal_Month
),
COvidException as 
(SELECT fiscal_month, fiscal_Year, center_id 
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
     WHEN   center_id = '0839'  THEN     '839 Virginia Beach - Town Center (NCO)'
     WHEN	center_id =	'0899'	THEN     '899 Viera -Florida (NCO)'	END CenterName
  ,SKU_Type
   ,Comp_Status
      ,sum(Sales_Revenue)

FROM Net
 WHERE Center_id IN('0160','0454','0591','0954')
     Group by fiscal_month,fiscal_year,Center_id ,Comp_Status,SKU_Type 
      ORDER BY  Center_id,fiscal_month
   )
   
   select * , CASE WHEN Comp_status='Comp' THEN 'yes' ELSE 'No' END COVID19_Exception  from COvidException					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
													
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
