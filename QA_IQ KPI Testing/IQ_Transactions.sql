/*************************************************************************************
       Q1-2022 KPI Test Cases  Source Database Zenoti.Q1_2022
 *************************************************************************************/  
 ---Q1-TOTAL Transactiosn Retail+Services CenterId 0098
WITH service as (
SELECT 
     'Service' As Event_Type
     ,es.Invoice_id As Transaction_Id
     ,es.final_sale_price As Sale_Price
     ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
     ,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
     ,closed_date_in_center As  Revrec_Date
  FROM dbt.q1_2022.service_events es 
  LEFT OUTER JOIN dbt.q1_2022.centers_finance zcr ON zcr.Zenoti_Center_ID = es.Center_ID AND es.Source_ID = 2
  LEFT OUTER JOIN dbt.q1_2022.centers_finance mcr ON mcr.Millennium_Center_ID = es.Center_ID AND es.Source_ID = 1
  LEFT OUTER JOIN Millennium.PUBLIC.services ms ON ms.iid = es.service_id AND ms.ilocationid = es.center_id AND es.source_ID = 1
  LEFT OUTER JOIN zenoti.q1_2022.bi_dimservice zs ON zs.servicewid = es.service_id AND es.Source_ID = 2
  WHERE es.net_amount > 0
    AND es.closed_date_in_center IS NOT NULL
    AND es.void = false
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) <> '9999'

UNION
  
SELECT 
      'Retail' As Event_Type
     ,ep.Invoice_id As Transaction_Id
     ,ep.final_sale_price As Sale_Price
     ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
     ,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
     ,closed_date_in_center As  Revrec_Date
FROM
     dbt.q1_2022.retail_events ep
  LEFT OUTER JOIN dbt.q1_2022.centers_finance zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
  LEFT OUTER JOIN dbt.q1_2022.centers_finance mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
  LEFT OUTER JOIN Millennium.PUBLIC.services ms ON ms.iid = ep.service_id AND ms.ilocationid = ep.center_id AND ep.source_ID = 1
  LEFT OUTER JOIN zenoti.q1_2022.bi_dimservice zs ON zs.servicewid = ep.service_id AND ep.Source_ID = 2
    WHERE ep.net_amount > 0
    AND ep.closed_date_in_center IS NOT NULL
    AND ep.void = false
    AND COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) <> '9999'
 
)
    SELECT 
    
         COUNT(DISTINCT CASE WHEN Revrec_Date >= cast('2021-12-26 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2022-03-26 23:59:00' as timestamp) THEN Transaction_Id END) As "Q1-22"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2022 AND month(Revrec_Date) = 01 THEN Transaction_Id END) As "JAN-22"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2022 AND month(Revrec_Date) = 02 THEN Transaction_Id END) As "FEB-22"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2022 AND month(Revrec_Date) = 03 THEN Transaction_Id END) As "MAR-22"
        ,CASE WHEN Center_Id ='0253' THEN  'Boston - Beacon Hill'
             WHEN Center_Id ='0485' THEN 'Easton'
             WHEN Center_Id ='0096' THEN 'Escondido'
             WHEN Center_Id ='0265' THEN 'San Rafael'
             WHEN Center_Id ='0875' THEN 'Greenville'
             WHEN Center_Id ='0350' THEN 'Arlington'
             WHEN Center_Id ='0106' THEN 'Lawrenceville'
             WHEN Center_Id ='0098' THEN 'Sugar Land'
             WHEN Center_Id ='0853' THEN 'Wyomissing'
             WHEN Center_Id ='0904' THEN 'Victoria'
             WHEN Center_Id ='0421' THEN 'Knoxville'
             WHEN Center_Id ='0614' THEN 'Sacramento'
             WHEN Center_Id ='0530' THEN 'Santa Clara'
             WHEN Center_Id ='0783' THEN 'Renton'
             WHEN center_id ='0994' THEN 'Omaha - Shops at Legacy'
             WHEN Center_Id ='0916' THEN 'Indian Land' END "Center_Name"
       ,Center_Id
 FROM Service
 WHERE Center_Id IN('0098')
 GROUP BY 
        CASE WHEN Center_Id ='0253' THEN  'Boston - Beacon Hill'
             WHEN Center_Id ='0485' THEN 'Easton'
             WHEN Center_Id ='0096' THEN 'Escondido'
             WHEN Center_Id ='0265' THEN 'San Rafael'
             WHEN Center_Id ='0875' THEN 'Greenville'
             WHEN Center_Id ='0350' THEN 'Arlington'
             WHEN Center_Id ='0106' THEN 'Lawrenceville'
             WHEN Center_Id ='0098' THEN 'Sugar Land'
             WHEN Center_Id ='0853' THEN 'Wyomissing'
             WHEN Center_Id ='0904' THEN 'Victoria'
             WHEN Center_Id ='0421' THEN 'Knoxville'
             WHEN Center_Id ='0614' THEN 'Sacramento'
             WHEN Center_Id ='0530' THEN 'Santa Clara'
             WHEN Center_Id ='0783' THEN 'Renton'
             WHEN center_id ='0994' THEN 'Omaha - Shops at Legacy'
             WHEN Center_Id ='0916' THEN 'Indian Land' END 
 ,Center_Id
 ORDER BY Center_Id
 -----------------------------------------  
 --Q1-Total Transactions 2022
  WITH service as (
SELECT 
     'Service' As Event_Type
     ,es.Invoice_id As Transaction_Id
     ,es.final_sale_price As Sale_Price
     ,es.center_id  AS Center_ID
     ,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
     ,closed_date_in_center As  Revrec_Date
  FROM dbt.q1_2022.service_events es 
  LEFT OUTER JOIN Millennium.PUBLIC.services ms ON ms.iid = es.service_id AND ms.ilocationid = es.center_id AND es.source_ID = 1
  LEFT OUTER JOIN zenoti.q1_2022.bi_dimservice zs ON zs.servicewid = es.service_id AND es.Source_ID = 2
  LEFT OUTER JOIN dbt.q1_2022.centers_link cl ON cl.center_id = es.center_id AND cl.source_id = es.source_id
  LEFT OUTER JOIN dbt_kpi.q1_2022.nopayment_items m0 ON m0.transaction_id = es.invoice_id and m0.unit_id = es.invoice_item_id and m0.center_id = cl.center_id_str and m0.source_id = es.source_id

WHERE es.net_amount > 0
AND es.closed_date_in_center IS NOT NULL
AND m0.Unit_ID IS NULL
AND cl.center_id_str <> '9999'
AND es.void = false


UNION
  
SELECT 
      'Retail' As Event_Type
     ,ep.Invoice_id As Transaction_Id
     ,ep.final_sale_price As Sale_Price
     ,ep.center_id AS Center_ID
     ,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
     ,closed_date_in_center As  Revrec_Date
FROM
     dbt.q1_2022.retail_events ep
  LEFT OUTER JOIN dbt.q1_2022.centers_link cl ON cl.center_id = ep.center_id AND cl.source_id = ep.source_id
  LEFT OUTER JOIN Millennium.PUBLIC.services ms ON ms.iid = ep.service_id AND ms.ilocationid = ep.center_id AND ep.source_ID = 1
  LEFT OUTER JOIN zenoti.q1_2022.bi_dimservice zs ON zs.servicewid = ep.service_id AND ep.Source_ID = 2
   LEFT OUTER JOIN dbt_kpi.q1_2022.nopayment_items m0 ON m0.transaction_id = ep.invoice_id and m0.unit_id = ep.invoice_item_id and m0.center_id = cl.center_id_str and m0.source_id = ep.source_id

    WHERE ep.net_amount > 0
    AND ep.closed_date_in_center IS NOT NULL
    AND m0.Unit_ID IS NULL
    AND cl.center_id_str <> '9999'
    AND ep.void = false
        
  )
 
 SELECT         

         COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 THEN Transaction_Id END) As "FY2020"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 THEN Transaction_Id END) As "FY2021"
        ,COUNT(DISTINCT CASE WHEN Revrec_Date >= cast('2021-12-26 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2022-03-26 23:59:00' as timestamp) THEN Transaction_Id END) As "Q1-22"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2022 AND month(Revrec_Date) = 01 THEN Transaction_Id END) As "JAN-22"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2022 AND month(Revrec_Date) = 02 THEN Transaction_Id END) As "FEB-22"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2022 AND month(Revrec_Date) = 03 THEN Transaction_Id END) As "MAR-22"
       
 FROM Service 
 WHERE Event_Type IN('Retail','Service') 
 
  -----------------------------------------  
 --Q1-Total Retail Transactions 2022
 WITH Retail
AS (
	SELECT 'Retail' AS Event_Type
		,ep.Invoice_id AS Transaction_Id
		,ep.final_sale_price AS Sale_Price
		,center_id_str AS Center_ID
		,COALESCE(ms.CDescript, zs.productname) AS SKU_Name
		,closed_date_in_center AS Revrec_Date
	FROM dbt.q1_2022.retail_events ep
	LEFT OUTER JOIN dbt.q1_2022.centers_link cl ON ep.center_id = cl.center_id
		AND ep.source_id = cl.source_id
		AND ep.closed_date_in_center >= cl.start_date
		AND ep.closed_date_in_center <= cl.end_date
	LEFT OUTER JOIN Millennium.PUBLIC.products ms ON ms.iid = ep.item_id
		AND ms.ilocationid = ep.center_id
		AND ep.source_ID = 1
	LEFT OUTER JOIN zenoti.q1_2022.bi_dimproduct zs ON zs.productwid = ep.product_id
		AND ep.Source_ID = 2
	LEFT OUTER JOIN dbt_kpi.q1_2022.nopayment_items m0 ON m0.transaction_id = ep.invoice_id
		AND m0.unit_id = ep.invoice_item_id
		AND m0.center_id = cl.center_id_str
		AND m0.source_id = ep.source_id
	WHERE ep.net_amount > 0
		AND ep.closed_date_in_center IS NOT NULL
		AND m0.Unit_ID IS NULL
		AND cl.center_id_str NOT IN ('9999','9960')
		AND ep.void = False
	)
SELECT Event_Type
	,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) = 2019	THEN Transaction_Id	END) AS "FY2019"
	,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) = 2020	THEN Transaction_Id	END) AS "FY2020"
	,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) = 2021	THEN Transaction_Id	END) AS "FY2021"
	,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) = 2022	THEN Transaction_Id	END) AS "FY2022"
	,COUNT(DISTINCT CASE WHEN Revrec_Date >= cast('2021-12-26 00:00:00' AS TIMESTAMP) 
	       AND Revrec_Date <= Cast('2022-03-26 23:59:00' AS TIMESTAMP)THEN Transaction_Id END) AS "Q1-22"
	,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) = 2022 	AND month(Revrec_Date) = 01	THEN Transaction_Id END) AS "JAN-22"
	,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) = 2022	AND month(Revrec_Date) = 02	THEN Transaction_Id	END) AS "FEB-22"
	,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) = 2022	AND month(Revrec_Date) = 03	THEN Transaction_Id	END) AS "MAR-22"
FROM Retail
WHERE Event_Type IN ('Retail')
	AND Center_Id = '0904'
GROUP BY Event_Type
---------------------------------------------
--Q1-Total Transacitons Fixed & UnlimitedPass

WITH Waxpass as (
 
  SELECT
          center_id
         ,service_package_id
         ,CASE WHEN aa.is_unlimited = 0 then 'wpf' 
  		       WHEN aa.is_unlimited = 1 then 'wpu' 
  	end as wp_type
         ,bb.fiscal_month
         ,bb.fiscal_year
  FROM dbt.q1_2022.package_purchase_events as aa  -- package type
  LEFT JOIN amperity.q4.full_datedimension as bb on (cast(aa.updated_at as date) = bb.date) 
   
  )
 
SELECT DISTINCT
         COUNT(CASE WHEN fiscal_year = 2022 AND fiscal_month IN(1,2,3) THEN service_package_id END) As "Q1-22"
        ,COUNT(CASE WHEN fiscal_year = 2022 AND fiscal_month = 01 THEN service_package_id END) As "JAN-22"
        ,COUNT(CASE WHEN fiscal_year = 2022 AND fiscal_month = 02 THEN service_package_id END) As "FEB-22"
        ,COUNT(CASE WHEN fiscal_year = 2022 AND fiscal_month = 03 THEN service_package_id END) As "MAR-22"
        ,center_id
         ,CASE WHEN Center_Id ='253' THEN  'Boston - Beacon Hill'
             WHEN Center_Id ='485' THEN 'Easton'
             WHEN Center_Id ='96' THEN 'Escondido'
             WHEN Center_Id ='265' THEN 'San Rafael'
             WHEN Center_Id ='875' THEN 'Greenville'
             WHEN Center_Id ='350' THEN 'Arlington'
             WHEN Center_Id ='106' THEN 'Lawrenceville'
             WHEN Center_Id ='98' THEN 'Sugar Land'
             WHEN Center_Id ='853' THEN 'Wyomissing'
             WHEN Center_Id ='904' THEN 'Victoria'
             WHEN Center_Id ='421' THEN 'Knoxville'
             WHEN Center_Id ='614' THEN 'Sacramento'
             WHEN Center_Id ='530' THEN 'Santa Clara'
             WHEN Center_Id ='783' THEN 'Renton'
             WHEN center_id ='994' THEN 'Omaha - Shops at Legacy'
             WHEN Center_Id ='916' THEN 'Indian Land' END "Center_Name"

FROM Waxpass
WHERE Center_id IN('0783')
GROUP BY center_id
         ,CASE WHEN Center_Id ='253' THEN  'Boston - Beacon Hill'
             WHEN Center_Id ='485' THEN 'Easton'
             WHEN Center_Id ='96' THEN 'Escondido'
             WHEN Center_Id ='265' THEN 'San Rafael'
             WHEN Center_Id ='875' THEN 'Greenville'
             WHEN Center_Id ='350' THEN 'Arlington'
             WHEN Center_Id ='106' THEN 'Lawrenceville'
             WHEN Center_Id ='98' THEN 'Sugar Land'
             WHEN Center_Id ='853' THEN 'Wyomissing'
             WHEN Center_Id ='904' THEN 'Victoria'
             WHEN Center_Id ='421' THEN 'Knoxville'
             WHEN Center_Id ='614' THEN 'Sacramento'
             WHEN Center_Id ='530' THEN 'Santa Clara'
             WHEN Center_Id ='783' THEN 'Renton'
             WHEN center_id ='994' THEN 'Omaha - Shops at Legacy'
             WHEN Center_Id ='916' THEN 'Indian Land' END
 --------------------------------------------------------------------------