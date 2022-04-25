*********************************************** Snowflake************************************************
_____________________Tc  Mid Center_Jan 2022___________________________________
----------------------revrec_combined--------------------------------------------


select -- *
center_id,transaction_id,source_id,event_type,Month(sale_date) as month, Year(sale_date) as Year, sum(revrec_value) as Revenue_Amt --,sku_name						
from  dbt_kpi.q1_2022.revrec_combined							
where center_id = '0547'							
and Transaction_ID like '%5d740ce7-6fa4-4acb-a3a3-a541c2500269%'							
and event_type ='Fixed Pass' --and sku_name='Retail'											
and cast(sale_date as date) between cast('2022-01-01' as date) and cast('2022-01-31' as date)	
group by center_id,transaction_id,source_id,event_type,Month(sale_date),Year(sale_date)--,sku_name;								


---------------------------- service_events--------------------------------------------

select --*
CENTER_ID,INVOICE_ID,ewc_center_id,source_id,sum(net_amount) as revenue								
from dbt.q1_2022.service_events								
where ewc_center_id = '0547' 													
and invoice_id like '%39307010-202b-4075-a43f-66ed6d8a9149%'								
and cast(sales_date as date) between cast('2022-01-01' as date) and cast('2022-01-31' as date)	
group by CENTER_ID,INVOICE_ID,ewc_center_id,source_id



------------------------ refund_events------------------------------------------------

select									
--*
center_id,source_id,invoice_id,ewc_center_id,sum(amount_paid_net) as revenue									
from dbt.q1_2022.refund_events									
where ewc_center_id = '0547'									
And source_id = 2									
and Refund_Product_Type NOT IN ('Package','Package - Fixed', 'Package - Unlimited','WPA')									
and invoice_id like '%b25eb9e5-91cf-42dc-9ea5-fabe6682f2cd%'									
and month(sale_in_center_date) = 01 and Year(sale_in_center_date) = 2022									
--and cast(sale_in_center_date as date) between cast('2021-12-26' as date) and cast('2022-03-26' as date)	
group by center_id,source_id,invoice_id,ewc_center_id	


--------------------------- retail_events----------------------------------------------

select --*
source_id,center_id,ewc_center_id,invoice_id,month(sales_date)  as month	,Year(sales_date) as Year,sum(net_amount) as revenue							
from dbt.q1_2022.retail_events								
where ewc_center_id = '0547'														
and invoice_id like '%169a6201-7e8a-47dd-beda-c97a2012ca46%'								
--and cast(sales_date as date) between cast('2021-06-27' as date) and cast('2021-06-30' as date)	
and month(sales_date) = 01 and Year(sales_date) = 2022
group by source_id,center_id,ewc_center_id,invoice_id ,month(sales_date) ,Year(sales_date)


------------------------ package_redemption_events--------------------------------------------

select --*
epr.center_id,epr.ewc_center_id,epr.purchase_invoice_id,month(epr.sale_date)  as month	,Year(epr.sale_date) as Year,sum(CAST(pp.net_amount AS Double) / COALESCE(epr.package_qty, 1)) as revenue								
FROM dbt.q1_2022.package_redemption_events epr								
INNER JOIN dbt.q1_2022.package_purchase_events pp ON pp.invoice_item_id = epr.invoice_item_id	--- events_package_purchases							
AND pp.center_id = epr.purchase_center_id								
where epr.ewc_center_id = '0547'														
and epr.invoice_id like '%5d740ce7-6fa4-4acb-a3a3-a541c2500269%'	
and month(epr.sale_date) = 01 and Year(epr.sale_date) = 2022
--and cast(epr.sale_date as date) between cast('2021-06-27' as date) and cast('2021-06-30' as date)		
group by epr.center_id,epr.ewc_center_id,epr.purchase_invoice_id,month(epr.sale_date),Year(epr.sale_date) ;								
								
								
___________________________________________________________________________________________________________________________________________________________________________________________________

________________TC- Q1-2022_______________________

revrec_combined
-------------------------
select  --*
center_id,event_type,source_id, Year(sale_date) as Year, sum(revrec_value) as Revenue_Amt--,sku_name	,transaction_id,,Month(sale_date) as month				
from  dbt_kpi.q1_2022.revrec_combined							
where center_id = '0568'							
--and transaction_id like '%45801a79-5287-45fe-8646-1a7391173211%'							
and event_type ='Fixed Pass' --and sku_name='Retail'
and month(sale_date) in(1,2,3) and Year(sale_date) = 2022
--and cast(sale_date as date) between cast('2022-01-01' as date) and cast('2022-01-31' as date)	
group by center_id,event_type,source_id,Year(sale_date)--,sku_name,,transaction_id,Month(sale_date);	

------------------------------------------------------------------------------------------------------

package_redemption_events
--------------------------------------

select --*
centercode,
Year(epr.sale_date) as Year,
sum(CAST(pp.net_amount AS Double) / COALESCE(epr.package_qty, 1)) as revenue

FROM dbt.q1_2022.package_redemption_events epr
INNER JOIN dbt.q1_2022.package_purchase_events pp ON pp.invoice_item_id = epr.invoice_item_id AND pp.center_id = epr.purchase_center_id
inner join zenoti.q1_2022.bi_dimcenter zc on zc.centerwid=epr.redemption_center_id
where epr.source_id=2
and zc.centercode = '0568'
and pp.is_unlimited = 0
AND epr.transaction_type IN ('Redemption','Transfer-In')
AND epr.redemption_timestamp IS NOT NULL
AND epr.Package_qty < 13
AND epr.Package_Qty > 1
AND epr.Void = False
and month(epr.sale_date) in(1,2,3) and Year(epr.sale_date) = 2022
group by 1,2						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
					
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
								
								
								
								
								
								
								
								
								
								

								
								
								
								
								
								
								
								
								
								
								
			
			
			
			
			
			
			
			
			
			
	
		
		
		
		
		
		
		
		
		
		
		
		
