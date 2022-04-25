************** Sc -101_Verify Payment_Type_id = 64, 65, 66  returns Tender_Type = Monetary****************************
################ Condition: When Source = 2, Q4 FY2021 #########

Query for  Event Payments:-
-------------------------------
select DISTINCT
      invoice_id
      ,invoice_item_id
,payment_type_id
,source_id
,center_Id
,ewc_center_id
from events_payments
where 
source_id = 2
----AND ewc_center_id = '16'
AND payment_type_id in ('64','65','66')
and invoice_id in('bfccf873-e8b1-4794-9864-810a29bba9ee'
  ,'98ff7def-3040-4d81-9cdc-fc859eea5ab0','ee5d58de-cf41-42f9-9580-dd7d9e3477a1')
  
AND sale_timestamp >= cast('2021-09-26 00:00:00' as timestamp) 
AND sale_timestamp <= Cast('2021-12-25 11:59:00' as timestamp)
order by payment_type_id


Query for Tender Group Type :-
-------------------------------------

	select * from Tender_Group_Type
 
   where transaction_id in (
   'bfccf873-e8b1-4794-9864-810a29bba9ee'
  ,'98ff7def-3040-4d81-9cdc-fc859eea5ab0','ee5d58de-cf41-42f9-9580-dd7d9e3477a1'
  )
  order by center_id


********************** Sc- 201_Verify Payment_Type_id = 129 returns Tender_Type = WP Redemption *********************************
 ################# Condition :- When Source = 2 Q4 FY2021 ##############

Query for Event Payments:-
----------------------------


select DISTINCT
      invoice_id
      ,invoice_item_id
,payment_type_id
,source_id
,center_Id
,ewc_center_id
from events_payments
where 
source_id = 2
----AND ewc_center_id = '16'
AND payment_type_id ='129'
and invoice_id in('c26afde2-2478-481b-a558-305648910232','07be10f7-ecac-4c13-b19b-8f4843fd4967')
AND sale_timestamp >= cast('2021-09-26 00:00:00' as timestamp) 
AND sale_timestamp <= Cast('2021-12-25 11:59:00' as timestamp)
--Group by ewc_center_id
order by center_Id

Query for Tender Group Type :-
-------------------------------

		select * from Tender_Group_Type
 
   where transaction_id in (
   '07be10f7-ecac-4c13-b19b-8f4843fd4967','c26afde2-2478-481b-a558-305648910232'
  )
  order by center_id



*************************** Sc-301_Verify Payment_Type_id <> 64, 65, 66 or 129 returns Tender_Type = Non Monetary **************************
	################# Condition :- When Source = 2 Q4 FY2021 ##############

Query for Event Payments:-
----------------------------

	
select DISTINCT
      invoice_id
      ,invoice_item_id
,payment_type_id
,source_id
,center_Id
,ewc_center_id
from events_payments
where 
source_id = 2
----AND ewc_center_id = '16'
AND payment_type_id NOT IN ('64','65','66','129')
and invoice_id in('e7733932-2eee-4675-85a0-fe78a71089b3','06cb04bd-07ad-43d1-b9f5-91fb48172801')
AND sale_timestamp >= cast('2021-09-26 00:00:00' as timestamp) 
AND sale_timestamp <= Cast('2021-12-25 11:59:00' as timestamp)
--Group by ewc_center_id
order by ewc_center_id	


Query for Tender Group Types:-
-------------------------------

	/*select * from Metric_Pmt_Type_Total 
where transaction_id in (
  'e7733932-2eee-4675-85a0-fe78a71089b3','06cb04bd-07ad-43d1-b9f5-91fb48172801')*/
  
  
  
  
  select * from Tender_Group_Type
   where transaction_id in (
   'e7733932-2eee-4675-85a0-fe78a71089b3','06cb04bd-07ad-43d1-b9f5-91fb48172801'
  )
  order by center_id



********************************** SC- 401_Payment Amount is -ve, Tender_Type is NON MONETARY ***************************
################# Condition :- When Source = 2 Q4 FY2021 ##############

Query for Event Payments:-
----------------------------

select DISTINCT
      invoice_id
      ,invoice_item_id
,payment_type_id
,source_id
,center_Id
,ewc_center_id,
payment_amount
,CASE
      WHEN payment_type_id IN ('64', '65', '66') THEN 'Monetary'
      WHEN payment_type_id IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
  END AS Tender_Type
from events_payments
where source_id = 2

AND cast(payment_amount as decimal) < 0
AND sale_timestamp >= cast('2021-09-26 00:00:00' as timestamp) 
AND sale_timestamp <= Cast('2021-12-25 11:59:00' as timestamp)
order by ewc_center_id, invoice_id
limit 10


Query for  Tender Group Type :-
-----------------------------------



  select ttg.*, mpt.Total_Payment_Amount from Tender_Group_Type ttg
   join Metric_Pmt_Type_Total mpt on mpt.transaction_id=ttg.transaction_id and mpt.unit_id = ttg.unit_id
where ttg.transaction_id in (
'00d012e5-93b4-4830-baa5-c026e258f14e',
'0578e7da-2a7d-4dca-a50b-18597bccbfec',
'065b4f0d-7866-4549-8084-e5b71a2ac3de',
'0ad778b7-f777-4c68-a136-1233ce56349f',
'1d302928-ce51-406a-a794-4b9c40ba6458',
'1d302928-ce51-406a-a794-4b9c40ba6458',
'39fef63a-f178-48b2-9ef2-133e103953b4',
'481cf48b-7c18-490c-9784-344f4c0e25d5',
'49e754b2-2a1d-4245-a708-569f622f2927',
'4b4f474c-90d2-4940-a342-cbd7a2fab6fd' 
  )
  order by center_id,ttg.transaction_id



********************** Sc-Total Invoices = Monetary + Non-Monetary + Hybrid ************************************************
				
	################# Condition :- When Source = 2 Q4 FY2021 ##############

Query for Event Payments:-
----------------------------

WITH Tender_Type_Detail AS (
SELECT
    ep.Source_id,
  	ep.invoice_id,
    --ep.center_id,
    ep.payment_amount_type,
    ep.payment_type_id,
  YEAR(ep.payment_in_center_timestamp) AS SalesYear,
  MONTH(ep.payment_in_center_timestamp) AS SalesMonth,
  CASE
      WHEN ep.payment_type_id IN ('64', '65', '66') THEN 'Monetary'
      WHEN ep.payment_type_id IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
    END AS Tender_Type
  FROM
    events_payments ep
  where
    ep.source_id = 2
   and ep.payment_type_id NOT IN ('129')
  AND ep.payment_in_center_timestamp >= cast('2021-09-26 00:00:00' as timestamp)
  AND ep.payment_in_center_timestamp <= Cast('2021-12-25 23:59:59' as timestamp)
--   AND ep.center_id = '305'
)
,Tender_Type_Count AS (
  SELECT
    ttd.Source_id,
  	ttd.invoice_id,
	--ttd.center_id,
    ttd.SalesYear,
  	ttd.SalesMonth,
    COUNT(Distinct ttd.Tender_Type) AS Tender_Type_Count
  FROM
    Tender_Type_Detail ttd
  Group by
    ttd.Source_id,
  	ttd.Invoice_id,
  ---  ttd.center_id,
    ttd.SalesYear,
  	ttd.SalesMonth
)
,CTE AS (
SELECT distinct
  ttd.SalesYear,
  ttd.SalesMonth,
  ttd.Source_id,
  ttd.invoice_id,
 Case
    WHEN ttc.tender_type_count > 1 THEN 'Hybrid'
    WHEN ttc.tender_type_count = 1 THEN ttd.Tender_Type
  END AS Tender_Group_Type
FROM
  Tender_Type_Detail ttd
  LEFT OUTER JOIN Tender_Type_Count ttc ON ttd.invoice_id = ttc.invoice_id
--   AND ttd.invoice_item_id = ttc.invoice_item_id
  ---AND ttd.center_id = ttc.center_id
--   where
--   ttd.center_id in (
-- '4','19','67','70','77','85','137','140','155','156','157','169','172','180','181','182','184','204','257','333','335','350','370','442','447','457','469','505','506','524','526','554','581','636','639','644','645','660','678','684','685','707','708','783','794','801','823','831','832','847','866','909','928','946','955'  
--   )
)
SELECT 
  SalesYear,
  SalesMonth,
  Source_ID,
  Tender_Group_Type,
  count(invoice_id) as InvoiceCount
FROM CTE
GROUP BY  SalesYear,
  SalesMonth,
  Source_ID,
  Tender_Group_Type
  
  Order by Tender_Group_Type,SalesMonth
  

Query for Tender Group Type :-
-------------------------------------------
											
	  WITH Tender_Type_Detail AS (
    select 
    2 as source_id,
    ---CENTERWID as center_id,
    INVOICEID as invoice_id,
    PAYMENTDATETIMEINCENTER as payment_in_center_timestamp,
    AMOUNTTYPE as payment_amount_type,
    PAYMENTTYPE as payment_type_id,
      YEAR(PAYMENTDATETIMEINCENTER) AS SalesYear,
    MONTH(PAYMENTDATETIMEINCENTER) AS SalesMonth,
    CASE
      WHEN PAYMENTTYPE IN ('64', '65', '66') THEN 'Monetary'
      WHEN PAYMENTTYPE IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
    END AS Tender_Type
  from Zenoti_bifactcollections bc
    inner join (select invoiceitemid 
                from Zenoti_bifactinvoiceitem bi 
                where (( UPPER(bi.INVOICE_NO) NOT LIKE 'II%' AND UPPER(bi.INVOICE_NO) NOT LIKE 'IR%')
                        OR ((UPPER(bi.INVOICE_NO) LIKE ('IIIGN%') OR UPPER(bi.INVOICE_NO) LIKE ('IRIGN%'))
                             and     
                             ((bi.saledateincenter >= date '2019-05-08' and bi.centerwid != '660') 
                              or
                              (bi.saledateincenter >= date '2017-02-01' and bi.centerwid  = '660'))))
               ) bi on bc.invoiceitemid = bi.invoiceitemid
where PAYMENTTYPE NOT IN ('129')
     and PAYMENTDATETIMEINCENTER >= cast('2021-09-26 00:00:00' as timestamp)
  AND PAYMENTDATETIMEINCENTER <= Cast('2021-12-25 23:59:00' as timestamp)
    --AND centerwid in ('244','31','84','701')
  )   
,Tender_Type_Count AS (
  SELECT
    ttd.Source_id,
  	ttd.invoice_id,
	---ttd.center_id,
    ttd.SalesYear,
  	ttd.SalesMonth,
    COUNT(Distinct ttd.Tender_Type) AS Tender_Type_Count
  FROM
    Tender_Type_Detail ttd
  Group by
    ttd.Source_id,
  	ttd.Invoice_id,
    ---ttd.center_id,
    ttd.SalesYear,
  	ttd.SalesMonth
)
,CTE AS (
SELECT distinct
  ttd.SalesYear,
  ttd.SalesMonth,
  --ttd.center_id,
  --c.zenoti_center_name AS Center_Name,
 -- c.franconnect_center_id AS FCenterID,
  ttd.Source_id,
  ttd.invoice_id,
 Case
    WHEN ttc.tender_type_count > 1 THEN 'Hybrid'
    WHEN ttc.tender_type_count = 1 THEN ttd.Tender_Type
  END AS Tender_Group_Type
FROM
  Tender_Type_Detail ttd
  LEFT OUTER JOIN Tender_Type_Count ttc ON ttd.invoice_id = ttc.invoice_id
--   AND ttd.invoice_item_id = ttc.invoice_item_id
 --AND ttd.center_id = ttc.center_id
 -- LEFT OUTER JOIN Lookups_CenterCrossReference c ON ttd.center_id = c.zenoti_center_id

)
SELECT 
  SalesYear,
  SalesMonth,
  --Center_ID,
  --Center_Name,
  --FCenterID,
  Source_ID,
  Tender_Group_Type,
  count(invoice_id) as InvoiceCount
FROM CTE
GROUP BY  SalesYear,
  SalesMonth,
  --Center_ID,
  --Center_Name,
  --FCenterID,
  Source_ID,
  Tender_Group_Type
  
  order by --Center_ID,
  Tender_Group_Type,SalesMonth

  
 /* Get Center info from Zenoti
  select centerwid, centername
  from Zenoti_BiDimcenter
  where centername like '%Bloomfield%'
  42	Waltham - 0244
  714	Dallas -Addison Walk - 0031
  942	Wyckoff - 0084
  305	West Bloomfield - 0701
  */


****************** SC- Accuracy Test / Spot Check (Reviewing Invoices); Verify Number of Tender Types Match; Count of Tender Group Types (M/N/H) (from TGT Table) = Total Payment Types (from Payment Event Table)*******************************************

	################# Condition :- When Source = 2 Q4 FY2021 ##############

Query for Event Payments:-
----------------------------

WITH Tender_Type_Detail AS (
SELECT
ep.Source_id,
ep.invoice_id,
ep.center_id,
  lc.franconnect_center_name as Centername,
ep.payment_amount_type,
ep.payment_type_id,
YEAR(ep.payment_in_center_timestamp) AS SalesYear,
MONTH(ep.payment_in_center_timestamp) AS SalesMonth,
CASE
WHEN ep.payment_type_id IN ('64', '65', '66') THEN 'Monetary'
WHEN ep.payment_type_id IN ('129') THEN 'WP Redemption'
ELSE 'Non-Monetary'
END AS Tender_Type
FROM
events_payments ep
join Lookups_CenterCrossReference lc
  on lc.zenoti_center_id= ep.center_id
where
ep.source_id = 2
and ep.invoice_id in ('463a3151-76c1-4598-82bb-5fa89f8c5e27')
and ep.payment_type_id NOT IN ('129')

AND ep.payment_in_center_timestamp >= cast('2021-09-26 00:00:00' as timestamp)
AND ep.payment_in_center_timestamp <= Cast('2021-09-30 23:59:59' as timestamp)
AND ep.center_id like '493'

)
,Tender_Type_Count AS (
SELECT
ttd.Source_id,
ttd.invoice_id,
ttd.center_id,
  ttd.Centername,
ttd.SalesYear,
ttd.SalesMonth,
COUNT(Distinct ttd.Tender_Type) AS Tender_Type_Count
FROM
Tender_Type_Detail ttd
Group by
ttd.Source_id,
ttd.Invoice_id,
ttd.center_id,
  ttd.Centername,
ttd.SalesYear,
ttd.SalesMonth
)
,CTE AS (
SELECT distinct
ttd.SalesYear,
ttd.SalesMonth,
ttd.Source_id,
  ttd.Centername,
  ttd.center_id,
ttd.invoice_id,
Case
WHEN ttc.tender_type_count > 1 THEN 'Hybrid'
WHEN ttc.tender_type_count = 1 THEN ttd.Tender_Type
END AS Tender_Group_Type
FROM
Tender_Type_Detail ttd
LEFT OUTER JOIN Tender_Type_Count ttc ON ttd.invoice_id = ttc.invoice_id
-- AND ttd.invoice_item_id = ttc.invoice_item_id
AND ttd.center_id = ttc.center_id
-- where
-- ttd.center_id in (
-- '4','19','67','70','77','85','137','140','155','156','157','169','172','180','181','182','184','204','257','333','335','350','370','442','447','457','469','505','506','524','526','554','581','636','639','644','645','660','678','684','685','707','708','783','794','801','823','831','832','847','866','909','928','946','955'
-- )
)
SELECT
SalesYear,
SalesMonth,
Source_ID,
center_id,
Centername,
Tender_Group_Type,
invoice_id
--count(invoice_id) as InvoiceCount
FROM CTE

--where Tender_Group_Type in('Hybrid','WP Redemption')
GROUP BY SalesYear,
SalesMonth,
Source_ID,
center_id,
Centername,
Tender_Group_Type,
invoice_id

order by center_id,
SalesMonth,
Tender_Group_Type
limit 30 
						
						
						
Query for Tender Group Type :-
----------------------------------------
SELECT Transaction_ID
,unit_id
,center_id
,tender_type_count
,tender_group_type
FROM Tender_Group_Type
where source_id = 2
and center_id = '0707'
and transaction_id IN ('463a3151-76c1-4598-82bb-5fa89f8c5e27')
and tender_group_type = 'Hybrid'
and unit_id='9dc9757d-822d-4edc-8a5a-0af617879f53'


**************** SC- 	01_Accuracy Test / Spot Check (Reviewing Various Counts)*******************

Query for Event Payment and Tender Grpup Type:-
----------------------------------	

"select (
SELECT COUNT(DISTINCT Invoice_ID)--, Franconnect_Center_ID
FROM Events_Payments ep
LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID and source_id=2
WHERE invoice_Id IS NOT NULL AND CAST(payment_amount AS DOUBLE) <> 0
and payment_amount_type NOT IN( '60')
--and payment_type_id not IN (' ')
and COALESCE(payment_type_id,'') not IN ('129')
and invoice_item_id IS NOT NULL
and source_id=2
AND ewc_center_ID not in ('-1','-2') and Franconnect_Center_ID is not null
--and ewc_center_ID='59'
--group BY Franconnect_Center_ID
--order by Franconnect_Center_ID
) as pCountExpected,
(SELECT COUNT(DISTINCT Transaction_ID)--, center_id
FROM
Tender_Group_Type
where Transaction_ID IS NOT NULL and unit_id is NOT NULL and source_id =2 and Tender_Group_Type <>'WP Redemption'
--group by center_id
--order by center_id
)as tgtCountActual


************************* SC- Accuracy Test / Spot Check (Reviewing Various Counts) *************************************

### Condition :- KPI_Retail_Counts_By_Tender_Group Should Have Correct Tender_Group_Types ###################

Query for Metric_Payment_Base/Metric_Retail_Base/KPI_Retail_Counts_By_Tender_Group:-
-----------------------------------									
									
									
	SELECT 'Metric_Payment_Base' AS tableName, COUNT(DISTINCT tender_group_type) AS tenderGroupTypesCount--,tender_group_type
FROM Metric_Payment_Base
--Group By tender_group_type
UNION
SELECT 'Metric_Retail_Base' AS tableName, COUNT(DISTINCT tender_group_type) AS tenderGroupTypesCount--,tender_group_type
FROM Metric_Retail_Base
--Group By tender_group_type
UNION
SELECT 'KPI_Retail_Counts_By_Tender_Group' AS tableName, COUNT(DISTINCT tender_group_type) AS tenderGroupTypesCount--,tender_group_type
FROM KPI_Retail_Counts_By_Tender_Group
--Group By tender_group_type
ORDER BY tableName, tenderGroupTypesCount--,tender_group_type						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
								
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
	
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						

					
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
										
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
				
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					


				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				

			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
