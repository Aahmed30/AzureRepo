--Center Ending Counts By Fiscal Dates 


select 
COUNT(*) as "Center_Ending_Count" 
from 
center_dates c1 
where 
c1.center_opening_date <= (select max(date) from Lookups_fiscalconversion where fiscal_year = '2019' and fiscal_month = 12 ) 
and c1.center_id not in (select center_id from center_dates  
where center_terminated_date <= (select max(date) from Lookups_fiscalconversion where fiscal_year = '2019' and fiscal_month = 12)) 

--New Center Open Counts By Fiscal Dates 

select 
COUNT(*) as "NCO_Counts" 
from 
center_dates c1  
inner join Lookups_fiscalconversion l1 
on c1.center_opening_date = l1.date 
where 
l1.fiscal_year = '2020' and l1.fiscal_month = 1 


--Closed Center Count

select
COUNT(*) as "StoreClose_Counts"
from
center_dates c1
inner join Lookups_fiscalconversion |1
on c1.center_terminated_date = |1.date
where
|1.fiscal_year = '2019' and |1.fiscal_month = 9


--Center Count by State

Select Store_State,
COUNT(*) as "Open_Center_Count"
from
Franconnect_Centers c1
where
c1.center_id not in (select center_id from center_dates where center_terminated_date is not null and center_opening_date <= CAST('2020-12-31' AS DATE))
group by Store_State
Order by Store_State