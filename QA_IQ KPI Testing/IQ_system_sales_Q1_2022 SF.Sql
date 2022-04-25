****************** Snowflake*****************************

TC-Q1-2022
------------------------------------------
Event table 
--------------


with systemsales as (
SELECT
'Service' AS Event_Type, fiscal_year, fiscal_month,
es.source_id,
es.invoice_id as transaction_id,
es.invoice_item_id as unit_id,
center_id_str as center_id,
es.final_sale_price as sale_price,
es.taxes as tax,
coalesce(ms.cdescript,zs.servicename) as sku_name,
es.sales_date as sale_date,
--es.closed_date_in_center as closed_date,
es.quantity,
COALESCE(mpt.Total_Payment_amount,Net_amount) as revrec_value,
--es.net_amount as revrec_value,
es.closed_date_in_center as revrec_date
FROM dbt.Q1_2022.service_events es
left outer join dbt.Q1_2022.centers_link cl on es.center_id = cl.center_id and es.source_id = cl.source_id and es.closed_date_in_center >= cl.start_date and es.closed_date_in_center <= cl.end_date
left outer join Millennium.public.services ms ON ms.iid = es.service_id and ms.ilocationid = es.center_id and es.source_id = 1
LEFT OUTER JOIN ZENOTI.Q1_2022.bi_dimservice zs ON zs.servicewid = es.service_id and es.source_id = 2
LEFT OUTER JOIN dbt_kpi.Q1_2022.nopayment_items m0 ON m0.transaction_id = es.invoice_id and m0.unit_id = es.invoice_item_id and m0.center_id = cl.center_id_str and m0.source_id = es.source_id
left outer join dbt.q1_2022.fiscalcalendar dd ON dd.day = es.closed_date_in_center
LEFT OUTER join DBT_KPI.Q1_2022.TENDER_GROUP_TYPE as bb on es.Invoice_id = bb.transaction_id
AND es.invoice_item_id = bb.Unit_ID
and (cl.center_id_str) = bb.center_id
LEFT OUTER JOIN DBT_KPI.Q1_2022.PMT_TYPE_TOTAL mpt ON mpt.Transaction_ID = es.Invoice_id
AND mpt.Unit_ID = es.invoice_item_id
AND mpt.Center_ID = cl.center_id_str
AND mpt.Source_ID = es.Source_ID

WHERE es.net_amount > 0
AND es.closed_date_in_center IS NOT NULL
AND m0.Unit_ID IS NULL
and mpt.tender_type is not null
and tender_group_type <> 'WP Redemption'
AND cl.center_id_str not in ('9999','9960')
AND es.void = false

Union All

SELECT
'Retail' AS Event_Type, fiscal_year, fiscal_month,
ep.source_id,
ep.invoice_id as transaction_id,
ep.invoice_item_id as unit_id,
center_id_str as center_id,
ep.final_sale_price as sale_price,
ep.taxes as tax,
coalesce(mp.cdescript,zp.productname) as sku_name,
ep.sales_date as sale_date,
ep.quantity,
COALESCE(mpt.Total_Payment_amount,Net_amount) as revrec_value,
--ep.net_amount as revrec_value,

ep.closed_date_in_center as revrec_date
FROM dbt.Q1_2022.retail_events ep
left outer join dbt.Q1_2022.centers_link cl on ep.center_id = cl.center_id and ep.source_id = cl.source_id and ep.closed_date_in_center >= cl.start_date and ep.closed_date_in_center <= cl.end_date
LEFT OUTER JOIN Millennium.public.products mp On mp.iid = ep.item_id and mp.ilocationid = ep.center_id and ep.source_id = 1
LEFT OUTER JOIN ZENOTI.Q1_2022.bi_dimproduct zp on zp.productwid = ep.product_id and ep.source_id = 2
LEFT OUTER JOIN dbt_kpi.Q1_2022.nopayment_items m0 ON m0.transaction_id = ep.invoice_id and m0.unit_id = ep.invoice_item_id and m0.center_id = cl.center_id_str and m0.source_id = ep.source_id
left outer join dbt.q1_2022.fiscalcalendar dd ON dd.day = ep.closed_date_in_center
LEFT OUTER join DBT_KPI.Q1_2022.TENDER_GROUP_TYPE as bb on ep.Invoice_id = bb.transaction_id
AND ep.invoice_item_id = bb.Unit_ID
and (cl.center_id_str) = bb.center_id
LEFT OUTER JOIN DBT_KPI.Q1_2022.PMT_TYPE_TOTAL mpt ON mpt.Transaction_ID = ep.Invoice_id
AND mpt.Unit_ID = ep.invoice_item_id
AND mpt.Center_ID = cl.center_id_str
AND mpt.Source_ID = ep.Source_ID
WHERE ep.net_amount > 0
AND ep.closed_Date_in_center IS NOT NULL
AND m0.Unit_ID IS NULL
and mpt.tender_type is not null
and tender_group_type <> 'WP Redemption'
AND cl.center_id_str not in ('9999','9960')
AND ep.void = False

)

select sum(revrec_value), fiscal_month,fiscal_year, event_type
from systemsales
where fiscal_month in(1,2,3) and fiscal_year=2022
group by fiscal_month,fiscal_year, event_type
order by event_type,fiscal_month,fiscal_year ;
				
				
				
				
--------------------

dbt_kpi.q1_2022.system_sales
----------------------------------
SELECT
  fiscal_month AS fiscal_month,
  fiscal_Year AS fiscal_Year,
  SKU_Type AS SKU_Type,
  round(sum(Sales_Revenue),6) AS Sales_Revenue
FROM
  dbt_kpi.q1_2022.system_sales   
   where fiscal_month in (1,2,3)
  and fiscal_Year=2022
   and SKU_Type  in ('Retail','Service')
  group by fiscal_month,
  fiscal_Year
  ,SKU_Type
   order by SKU_Type,fiscal_month 


  
  
  
     
    				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
							
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
								
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
