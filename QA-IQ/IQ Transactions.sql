------------------------------Scenario#1 STEP1-----------Expected----------------------------
With Revrec as (
SELECT 
        Event_type,
		Source_ID,
		Transaction_ID,
        Unit_ID,
        Center_ID,
        Sale_Price,
        Tax,
        SKU_Name,
        Sale_Date,
        Quantity,
        RevRec_Value,
        RevRec_Date
FROM RevRec_Combined
  
)
  
  SELECT         
        
        COUNT(DISTINCT CASE WHEN Revrec_Date >= cast('2021-01-01 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2021-03-31 11:59:00' as timestamp) THEN Transaction_Id END) As "Q1-21"
       --,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020  THEN Transaction_Id END) As "FY2020"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 AND month(Revrec_Date) = 03 THEN Transaction_Id END) As "MAR-19"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 AND month(Revrec_Date) = 09 THEN Transaction_Id END) As "SEP-20"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 01 THEN Transaction_Id END) As "JAN-21"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 03 THEN Transaction_Id END) As "MAR-21"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2011 THEN Transaction_Id END) As "FY2011"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2010 THEN Transaction_Id END) As "FY2010"
        ,Center_id
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
             WHEN Center_Id ='0916' THEN 'Indian Land' END "Center_Name"
  FROM revrec 
    WHERE Event_Type IN('Retail','Service')
   -- AND YEAR(Revrec_Date) IN (2010,2011,2012,2013,2016,2019,2020)
    AND Center_Id = '0875'
--     AND year(Revrec_Date) = 2019
   --AND month(Revrec_Date) = 05
    --AND Revrec_Date >= cast('2021-01-01 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2021-03-31 11:59:00' as timestamp)
    GROUP BY Center_id
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
             WHEN Center_Id ='0783' THEN 'Renton' END
             
 -------------------------Scenario#1 STEP2------------------- Acual------------
 WITH service as (
SELECT 
      'Service' As Event_Type
     ,es.Invoice_id As Transaction_Id
     ,es.final_sale_price As Sale_Price
     ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
     ,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
     ,closed_date_in_center As  Revrec_Date
FROM
     Events_Services es
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = es.Center_ID AND es.Source_ID = 2
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = es.Center_ID AND es.Source_ID = 1
    LEFT OUTER JOIN Millennium_Services ms ON ms.iid = es.service_id AND ms.ilocationid = es.center_id AND es.source_ID = 1
    LEFT OUTER JOIN Zenoti_bidimservice zs ON zs.servicewid = es.service_id AND es.Source_ID = 2
    WHERE es.net_amount > 0

 --LIMIT 1000
  
UNION
  
SELECT 
      'Retail' As Event_Type
     ,ep.Invoice_id As Transaction_Id
     ,ep.final_sale_price As Sale_Price
     ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
     ,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
     ,closed_date_in_center As  Revrec_Date
FROM
     Events_Retail ep
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
    LEFT OUTER JOIN Millennium_Services ms ON ms.iid = ep.service_id AND ms.ilocationid = ep.center_id AND ep.source_ID = 1
    LEFT OUTER JOIN Zenoti_bidimservice zs ON zs.servicewid = ep.service_id AND ep.Source_ID = 2
    WHERE ep.net_amount > 0

 --LIMIT 1000  
  
 )
 
 SELECT 
                
        COUNT(DISTINCT CASE WHEN Revrec_Date >= cast('2021-01-01 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2021-03-31 11:59:00' as timestamp) THEN Transaction_Id END) As "Q1-21"
       --,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020  THEN Transaction_Id END) As "FY2020"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 AND month(Revrec_Date) = 03 THEN Transaction_Id END) As "MAR-19"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 AND month(Revrec_Date) = 09 THEN Transaction_Id END) As "SEP-20"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 01 THEN Transaction_Id END) As "JAN-21"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 03 THEN Transaction_Id END) As "MAR-21"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2011 THEN Transaction_Id END) As "FY2011"
       ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2010 THEN Transaction_Id END) As "FY2010"
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
             WHEN Center_Id ='0916' THEN 'Indian Land' END "Center_Name"
       ,Center_Id
 FROM Service
 WHERE Center_Id IN('0875')
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
             WHEN Center_Id ='0916' THEN 'Indian Land' END
 ,Center_Id
-----------------------Total Transactions---------------------------------

With Revrec as (
SELECT 
        Event_type,
		Source_ID,
		Transaction_ID,
        Unit_ID,
        Center_ID,
        Sale_Price,
        Tax,
        SKU_Name,
        Sale_Date,
        Quantity,
        RevRec_Value,
        RevRec_Date
FROM RevRec_Combined
  
)
  
  SELECT         
         COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2010 THEN Transaction_Id END) As "FY2010"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2011 THEN Transaction_Id END) As "FY2011"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2012 THEN Transaction_Id END) As "FY2012"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2013 THEN Transaction_Id END) As "FY2013"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2016 THEN Transaction_Id END) As "FY2016"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 THEN Transaction_Id END) As "FY2019"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 THEN Transaction_Id END) As "FY2020"
        ,COUNT(DISTINCT CASE WHEN Revrec_Date >= cast('2021-01-01 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2021-03-31 11:59:00' as timestamp) THEN Transaction_Id  END) As "Q1-21"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 AND month(Revrec_Date) = 08 THEN Transaction_Id END) As "Aug-19"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 AND month(Revrec_Date) = 06 THEN Transaction_Id END) As "Jun-20"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 01 THEN Transaction_Id END) As "Jan-21"
  FROM revrec 
    WHERE Event_Type IN('Retail','Service','refund')
 
----------------------------------------
 WITH service as (
SELECT 
      'Service' As Event_Type
     ,es.Invoice_id As Transaction_Id
     ,es.final_sale_price As Sale_Price
     ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
     ,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
     ,closed_date_in_center As  Revrec_Date
FROM
     Events_Services es
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = es.Center_ID AND es.Source_ID = 2
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = es.Center_ID AND es.Source_ID = 1
    LEFT OUTER JOIN Millennium_Services ms ON ms.iid = es.service_id AND ms.ilocationid = es.center_id AND es.source_ID = 1
    LEFT OUTER JOIN Zenoti_bidimservice zs ON zs.servicewid = es.service_id AND es.Source_ID = 2
    WHERE es.net_amount > 0

 --LIMIT 1000
  
UNION
  
SELECT 
      'Retail' As Event_Type
     ,ep.Invoice_id As Transaction_Id
     ,ep.final_sale_price As Sale_Price
     ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
     ,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
     ,closed_date_in_center As  Revrec_Date
FROM
     Events_Retail ep
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
    LEFT OUTER JOIN Millennium_Services ms ON ms.iid = ep.service_id AND ms.ilocationid = ep.center_id AND ep.source_ID = 1
    LEFT OUTER JOIN Zenoti_bidimservice zs ON zs.servicewid = ep.service_id AND ep.Source_ID = 2
    WHERE ep.net_amount > 0

 --LIMIT 1000  
  
 )
 
 SELECT 
                
         COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2010 THEN Transaction_Id END) As "FY2010"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2011 THEN Transaction_Id END) As "FY2011"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2012 THEN Transaction_Id END) As "FY2012"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2013 THEN Transaction_Id END) As "FY2013"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2016 THEN Transaction_Id END) As "FY2016"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 THEN Transaction_Id END) As "FY2019"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 THEN Transaction_Id END) As "FY2020"
        ,COUNT(DISTINCT CASE WHEN Revrec_Date >= cast('2021-01-01 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2021-03-31 11:59:00' as timestamp) THEN Transaction_Id  END) As "Q1-21"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 AND month(Revrec_Date) = 08 THEN Transaction_Id END) As "Aug-19"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 AND month(Revrec_Date) = 06 THEN Transaction_Id END) As "Jun-20"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 01 THEN Transaction_Id END) As "Jan-21"

 FROM Service

------------------Scenario#2 STEP1------------------- Expected----------------
With Revrec as (
  
SELECT 	Event_type, Source_ID, Transaction_ID, Unit_ID, Center_ID, Sale_Price, Tax, SKU_Name, Sale_Date, Quantity, RevRec_Value, RevRec_Date
        
FROM RevRec_Retail
  )
  
  SELECT         
         Event_Type
     -- ,COUNT(DISTINCT CASE WHEN Revrec_Date >= cast('2021-01-01 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2021-03-31 11:59:00' as timestamp) THEN Transaction_Id END) As "Q1-21"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date)  =2020 THEN Transaction_Id END) As "FY2020"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 AND month(Revrec_Date) = 04 THEN Transaction_Id END) As "Apr-19"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 AND month(Revrec_Date) = 11 THEN Transaction_Id END) As "Nov-20"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 03 THEN Transaction_Id END) As "Mar-21"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 02 THEN Transaction_Id END) As "Feb-21"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2010 THEN Transaction_Id END) As "FY2010"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2011 THEN Transaction_Id END) As "FY2011"
        ,CASE WHEN Center_id =  '0350'    THEN  'EWC - Arlington - Courthouse (0350)'
              WHEN Center_id =  '0106'    THEN  'EWC - Lawrenceville-Princeton (0106)'
              WHEN Center_id =  '0098'    THEN  'EWC - Sugar Land (0098)'
              WHEN Center_id =  '0853'    THEN  'EWC - Wyomissing (0853)'
              WHEN Center_id =  '0904'    THEN  'EWC - Victoria (0904)'
        END "Center_Name"
       ,Center_id
        
  FROM revrec 
    WHERE Event_Type IN('Retail')
   -- AND YEAR(Revrec_Date) IN (2010,2011,2012,2013,2016,2019,2020)
    AND Center_Id ='0904'
    --AND year(Revrec_Date) = 2011
   --AND month(Revrec_Date) = 05
    --AND Revrec_Date >= cast('2021-01-01 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2021-03-31 11:59:00' as timestamp)
    GROUP BY 
             Event_Type
            ,CASE WHEN Center_id =  '0350'    THEN  'EWC - Arlington - Courthouse (0350)'
              WHEN Center_id =  '0106'    THEN  'EWC - Lawrenceville-Princeton (0106)'
              WHEN Center_id =  '0098'    THEN  'EWC - Sugar Land (0098)'
              WHEN Center_id =  '0853'    THEN  'EWC - Wyomissing (0853)'
              WHEN Center_id =  '0904'    THEN  'EWC - Victoria (0904)'  END
                ,Center_id

    
----------Step2 Scenerio#2 Events_Products ------Retail ------ Acual---------

WITH Retail as (
  
SELECT 
      'Retail' As Event_Type
     ,ep.Invoice_id As Transaction_Id
     ,ep.final_sale_price As Sale_Price
     ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
     ,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
     ,closed_date_in_center As  Revrec_Date
FROM
     Events_Retail ep
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
    LEFT OUTER JOIN Millennium_Services ms ON ms.iid = ep.service_id AND ms.ilocationid = ep.center_id AND ep.source_ID = 1
    LEFT OUTER JOIN Zenoti_bidimservice zs ON zs.servicewid = ep.service_id AND ep.Source_ID = 2
    WHERE ep.net_amount > 0

 --LIMIT 1000  
  
 )
 
 SELECT 
         Event_type
     -- ,COUNT(DISTINCT CASE WHEN Revrec_Date >= cast('2021-01-01 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2021-03-31 11:59:00' as timestamp) THEN Transaction_Id END) As "Q1-21"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date)  =2020 THEN Transaction_Id END) As "FY2020"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 AND month(Revrec_Date) = 04 THEN Transaction_Id END) As "Apr-19"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 AND month(Revrec_Date) = 11 THEN Transaction_Id END) As "Nov-20"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 03 THEN Transaction_Id END) As "Mar-21"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 02 THEN Transaction_Id END) As "Feb-21"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2010 THEN Transaction_Id END) As "FY2010"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2011 THEN Transaction_Id END) As "FY2011"
        ,CASE WHEN Center_id =  '0350'    THEN  'EWC - Arlington - Courthouse (0350)'
              WHEN Center_id =  '0106'    THEN  'EWC - Lawrenceville-Princeton (0106)'
              WHEN Center_id =  '0098'    THEN  'EWC - Sugar Land (0098)'
              WHEN Center_id =  '0853'    THEN  'EWC - Wyomissing (0853)'
              WHEN Center_id =  '0904'    THEN  'EWC - Victoria (0904)'
        END "Center_Name"
       ,Center_Id
 FROM Retail
 WHERE Center_Id ='0904'
 GROUP BY 
         Event_Type
         ,CASE WHEN Center_id =  '0350'    THEN  'EWC - Arlington - Courthouse (0350)'
              WHEN Center_id =  '0106'    THEN  'EWC - Lawrenceville-Princeton (0106)'
              WHEN Center_id =  '0098'    THEN  'EWC - Sugar Land (0098)'
              WHEN Center_id =  '0853'    THEN  'EWC - Wyomissing (0853)'
              WHEN Center_id =  '0904'    THEN  'EWC - Victoria (0904)' END
         ,Center_Id    

------------------Scenario#2 STEP1-----Total Transactions-- Expected----------------
With Revrec as (
  
SELECT 	Event_type, Source_ID, Transaction_ID, Unit_ID, Center_ID, Sale_Price, Tax, SKU_Name, Sale_Date, Quantity, RevRec_Value, RevRec_Date
        
FROM RevRec_Retail
  )
  
  SELECT         
         Event_Type
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2010 THEN Transaction_Id END) As "FY2010"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2011 THEN Transaction_Id END) As "FY2011"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2012 THEN Transaction_Id END) As "FY2012"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2013 THEN Transaction_Id END) As "FY2013"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2016 THEN Transaction_Id END) As "FY2016"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 THEN Transaction_Id END) As "FY2019"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 THEN Transaction_Id END) As "FY2020"
        ,COUNT(DISTINCT CASE WHEN Revrec_Date >= cast('2021-01-01 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2021-03-31 11:59:00' as timestamp) THEN Transaction_Id             END) As "Q1-21"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 AND month(Revrec_Date) = 08 THEN Transaction_Id END) As "Aug-19"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 AND month(Revrec_Date) = 06 THEN Transaction_Id END) As "Jun-20"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 01 THEN Transaction_Id END) As "Jan-21"
               
  FROM revrec 
    WHERE Event_Type IN('Retail')
    --AND Center_Id ='0904'
    GROUP BY 
             Event_Type
-----------------------------------------------------------------------------------             
 WITH Retail as (
  
SELECT 
      'Retail' As Event_Type
     ,ep.Invoice_id As Transaction_Id
     ,ep.final_sale_price As Sale_Price
     ,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
     ,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
     ,closed_date_in_center As  Revrec_Date
FROM
     Events_Products ep
    LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
    LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
    LEFT OUTER JOIN Millennium_Services ms ON ms.iid = ep.service_id AND ms.ilocationid = ep.center_id AND ep.source_ID = 1
    LEFT OUTER JOIN Zenoti_bidimservice zs ON zs.servicewid = ep.service_id AND ep.Source_ID = 2
    WHERE ep.net_amount > 0

 --LIMIT 1000  
  
 )
 
 SELECT 
         Event_type
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2010 THEN Transaction_Id END) As "FY2010"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2011 THEN Transaction_Id END) As "FY2011"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2012 THEN Transaction_Id END) As "FY2012"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2013 THEN Transaction_Id END) As "FY2013"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2016 THEN Transaction_Id END) As "FY2016"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 THEN Transaction_Id END) As "FY2019"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 THEN Transaction_Id END) As "FY2020"
        ,COUNT(DISTINCT CASE WHEN Revrec_Date >= cast('2021-01-01 00:00:00' as timestamp)  AND Revrec_Date<= Cast('2021-03-31 11:59:00' as timestamp) THEN Transaction_Id             END) As "Q1-21"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2019 AND month(Revrec_Date) = 08 THEN Transaction_Id END) As "Aug-19"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2020 AND month(Revrec_Date) = 06 THEN Transaction_Id END) As "Jun-20"
        ,COUNT(DISTINCT CASE WHEN Year(Revrec_Date) =2021 AND month(Revrec_Date) = 01 THEN Transaction_Id END) As "Jan-21"
        
 FROM Retail
 --WHERE Center_Id ='0904'
 GROUP BY 
         Event_Type
--====================================================================================
                        Total Transactions = KPI Transactions + KPI VISITS
--====================================================================================
SELECT 
       MIN(date)
      ,MAX(date)
FROM Lookups_FiscalConversion 

SELECT MIN(fiscal_year) FROM KPI_Visits 

--  SELECT * FROM KPI_Visits

-- SELECT COUNT(Visit_Count) KPI_Visits 

 SELECT DISTINCT
         SUM(DISTINCT CASE WHEN fiscal_year = 2010 THEN visit_count END) As "FY2010"
        ,SUM(DISTINCT CASE WHEN fiscal_year = 2011 THEN visit_count END) As "FY2011"
        ,SUM(DISTINCT CASE WHEN fiscal_year = 2012 THEN visit_count END) As "FY2012"
        ,SUM(DISTINCT CASE WHEN fiscal_year = 2013 THEN visit_count END) As "FY2013"
        ,SUM(DISTINCT CASE WHEN fiscal_year = 2016 THEN visit_count END) As "FY2016"
        ,SUM(DISTINCT CASE WHEN fiscal_year = 2019 THEN visit_count END) As "FY2019"
        ,SUM(DISTINCT CASE WHEN fiscal_year = 2020 THEN visit_count END) As "FY2020"
        ,SUM(DISTINCT CASE WHEN Fiscal_Year = 2021 AND fiscal_month IN(01,02,03) THEN visit_count END) as "Q1-21"
        ,SUM(DISTINCT CASE WHEN fiscal_year = 2019 AND fiscal_month = 08 THEN visit_count END) As "Aug-19"
        ,SUM(DISTINCT CASE WHEN fiscal_year = 2020 AND fiscal_month = 06 THEN visit_count END) As "Jun-20"
        ,SUM(DISTINCT CASE WHEN fiscal_year = 2021 AND fiscal_month = 01 THEN visit_count END) As "Jan-21"
FROM KPI_visits


----------
--SELECT * FROM Metric_Visit_Detail Limit 1000
with metric as (
SELECT 
       fc.fiscal_Year
      ,fc.fiscal_month
      ,COUNT(Invoice_ID) AS Visit_Count
FROM Metric_Visit_Detail tl
LEFT OUTER JOIN full_datedimension fc ON fc.date = tl.eff_date
GROUP BY fc.fiscal_Year,fc.fiscal_month
)
SELECT 
       SUM(CASE WHEN  Fiscal_Year =2010 THEN visit_count END) As "FY 2010"
      ,SUM(CASE WHEN  Fiscal_Year =2011 THEN visit_count END) As "FY 2011"
      ,SUM(CASE WHEN  Fiscal_Year =2012 THEN visit_count END) As "FY 2012"
      ,SUM(CASE WHEN  Fiscal_Year =2013 THEN visit_count END) As "FY 2013"
      ,SUM(CASE WHEN  Fiscal_Year =2016 THEN visit_count END) As "FY 2016"
      ,SUM(CASE WHEN  Fiscal_Year =2019 THEN visit_count END) As "FY 2019"
      ,SUM(CASE WHEN  Fiscal_Year =2020 THEN visit_count END) As "FY 2020"
      ,SUM(DISTINCT CASE WHEN Fiscal_Year =2021 AND fiscal_month IN(01,02,03) THEN visit_count END) as "Q1-21"
      ,SUM(CASE WHEN  Fiscal_Year =2019 AND fiscal_month =08 THEN visit_count END) As "Aug-19"
      ,SUM(CASE WHEN  Fiscal_Year =2020 AND fiscal_month =06 THEN visit_count END) As "Jun-20"
      ,SUM(CASE WHEN  Fiscal_Year =2021 AND fiscal_month =01 THEN visit_count END) As "Jan-21"
FROM metric      

--------------------------------------------------------------------------------------
WITH counts AS (
  SELECT
  	event_type
  	, COUNT(*) AS sourceIdCounts
  	, NULL AS centerIdCounts
  FROM RevRec_Combined
  WHERE source_id IS NULL
  	OR CAST(source_id AS VARCHAR(2)) = ''
  GROUP BY event_type
  UNION ALL
  SELECT
  	event_type
  	, NULL AS sourceIdCounts
  	, COUNT(*) AS centerIdCounts
  FROM RevRec_Combined
  WHERE center_id IS NULL
  	OR center_id = ''
  GROUP BY event_type
  
)
SELECT
	*
FROM counts
ORDER BY event_type

------------------------Retail - Source Counts-------------------------------------
SELECT
	COUNT(*) AS centerIdCountsEventsProducts
    , 0 AS centerIdCountsRevRecRetail
FROM Events_Retail
WHERE center_id IS NULL OR center_id = ''
UNION ALL
SELECT
	0 AS centerIdCountsEventsProducts
    , COUNT(*) AS centerIdCountsRevRecRetail
FROM RevRec_Retail
WHERE center_id IS NULL OR center_id = ''
------------------------Service - Source Counts-----------------------------------------
SELECT
	COUNT(*) AS centerIdCountsEventsServices
    , 0 AS centerIdCountsRevRecRetail
FROM Events_Services
WHERE center_id IS NULL OR center_id = ''
UNION ALL
SELECT
	0 AS centerIdCountsEventsServices
    , COUNT(*) AS centerIdCountsRevRecService
FROM RevRec_Service
WHERE center_id IS NULL OR center_id = ''

------------------------Unlimited - Source Counts-----------------------------------------
SELECT
	COUNT(*) AS sourceIdCountsRevRecUnlimited
    , 0 AS sourceIdCountsEventsPackagePurchase
    , 0 AS sourceIdCountsLookupRevRec
    , 0 AS sourceIdCountsLookupWaxPassInfo
FROM RevRec_Unlimited_Pass
WHERE source_id IS NULL OR CAST(source_id AS VARCHAR(2)) = ''
UNION ALL
SELECT
	0 AS sourceIdCountsRevRecUnlimited
    , COUNT(*) AS sourceIdCountsEventsPackagePurchase
    , 0 AS sourceIdCountsLookupRevRec
    , 0 AS sourceIdCountsLookupWaxPassInfo
FROM events_package_purchases
WHERE source_id IS NULL OR CAST(source_id AS VARCHAR(2)) = ''
UNION ALL
SELECT
	0 AS sourceIdCountsRevRecUnlimited
    , 0 AS sourceIdCountsEventsPackagePurchase
    , COUNT(*) AS sourceIdCountsLookupRevRec
    , 0 AS sourceIdCountsLookupWaxPassInfo
FROM Lookups_RevenueRecognition
WHERE source_id IS NULL OR CAST(source_id AS VARCHAR(2)) = ''
UNION ALL
SELECT
	0 AS sourceIdCountsRevRecUnlimited
    , 0 AS sourceIdCountsEventsPackagePurchase
    , 0 AS sourceIdCountsLookupRevRec
	, COUNT(*) AS sourceIdCountsLookupWaxPassInfo
FROM lookups_wax_pass_info
WHERE source_id IS NULL OR CAST(source_id AS VARCHAR(2)) = ''

-----------------------Fixed Pass - Source Counts--------------------------
SELECT
	COUNT(*) AS centerIdCountsEventsPackageRedemption
    , 0 AS centerIdCountsEventsRefunds
    , 0 AS centerIdCountsEventsSchedPays
FROM Events_Package_Redemptions
WHERE center_id IS NULL OR center_id = ''
UNION ALL
SELECT
	0 AS centerIdCountsEventsPackageRedemption
    , COUNT(*) AS centerIdCountsEventsRefunds
    , 0 AS centerIdCountsEventsSchedPays
FROM Events_Refunds
WHERE center_id IS NULL OR center_id = ''
UNION ALL
SELECT
	0 AS centerIdCountsEventsPackageRedemption
    , 0 AS centerIdCountsEventsRefunds
    , COUNT(*) AS centerIdCountsEventsSchedPays
FROM Events_Scheduled_Payments--Metric_Cancelled_Future_Payments
WHERE center_id IS NULL OR center_id = ''
---------------------------------------------------------------------