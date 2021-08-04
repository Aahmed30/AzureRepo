--------=======================Scenario #9====Arlington - Pentagon City============-----

 with metric as (
 select 
	aa.event_type as sku_type,
    CASE WHEN aa.Event_Type = 'Refund' THEN aa.Sku_name ELSE aa.Event_Type END AS Sku_Source_Type,
  	CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE bb.tender_group_type END as tender_group_type,
    CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE mpt.Tender_Type END AS Revenue_Type,
    bb.source_ID, 
    aa.sku_name,
    aa.sale_date,
    aa.quantity,
    mpt.Total_Payment_amount AS RevRec_Value,
    aa.revrec_date,
    aa.transaction_id as transaction_id,
    aa.unit_id as unit_id,
    aa.center_id as center_id, 
    bb.tender_type_count
  from revrec_combined as aa
  LEFT OUTER JOIN metric_Pmt_type_total mpt ON 	mpt.Transaction_ID = aa.Transaction_ID
  												AND mpt.Unit_ID = aa.Unit_ID
                                                AND mpt.Center_ID = aa.Center_ID
                                                AND mpt.Source_ID = aa.Source_ID
  LEFT OUTER join tender_group_type as bb on aa.transaction_id = bb.transaction_id 
 											 AND aa.Unit_ID = bb.Unit_ID
                                         	and aa.center_id = bb.center_id 
                                         	AND aa.Unit_ID = bb.unit_ID --add source for grouping
)

 
 SELECT 
      Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2019 AND LTRIM(RTRIM(sku_name)) = 'Women''s Bikini Line' AND center_id = '0733' THEN unit_id END) as "FY 2019"  
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 06  AND LTRIM(RTRIM(sku_name)) = 'Women''s Bikini Line' AND center_id ='0733' THEN unit_id END) as "Jun-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 10 AND LTRIM(RTRIM(sku_name)) = 'Women''s Bikini Line' AND center_id ='0733' THEN unit_id END) as "Oct-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 07  AND LTRIM(RTRIM(sku_name)) = 'Women''s Bikini Line' AND center_id ='0733' THEN unit_id END) as "Jul-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 02  AND LTRIM(RTRIM(sku_name)) = 'Women''s Bikini Line' AND center_id ='0733' THEN unit_id END) as "Feb-21"                                                                                        
  
     FROM Metric 
 -------------------------------------------------------------------------------    
 
 with metric as (
 select 
	aa.event_type as sku_type,
    CASE WHEN aa.Event_Type = 'Refund' THEN aa.Sku_name ELSE aa.Event_Type END AS Sku_Source_Type,
  	CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE bb.tender_group_type END as tender_group_type,
    CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE mpt.Tender_Type END AS Revenue_Type,
    bb.source_ID, 
    aa.sku_name,
    aa.sale_date,
    aa.quantity,
    mpt.Total_Payment_amount AS RevRec_Value,
    aa.revrec_date,
    aa.transaction_id as transaction_id,
    aa.unit_id as unit_id,
    aa.center_id as center_id, 
    bb.tender_type_count
  from revrec_combined as aa
  LEFT OUTER JOIN metric_Pmt_type_total mpt ON 	mpt.Transaction_ID = aa.Transaction_ID
  												AND mpt.Unit_ID = aa.Unit_ID
                                                AND mpt.Center_ID = aa.Center_ID
                                                AND mpt.Source_ID = aa.Source_ID
  LEFT OUTER join tender_group_type as bb on aa.transaction_id = bb.transaction_id 
 											 AND aa.Unit_ID = bb.Unit_ID
                                         	and aa.center_id = bb.center_id 
                                         	AND aa.Unit_ID = bb.unit_ID --add source for grouping
)

 
 SELECT 
          --Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) IN(01,02,03) AND LTRIM(RTRIM(sku_name)) = 'Stomach (Strip)' THEN unit_id END) as "Q1-21"
      Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2019 AND LTRIM(RTRIM(sku_name)) = 'Add On Arm (half)' THEN unit_id END) as "FY 2019"  
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND month(Revrec_Date) = 05  AND LTRIM(RTRIM(sku_name)) = 'Add On Arm (half)' THEN unit_id END) as "may-20" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND month(Revrec_Date) = 03 AND LTRIM(RTRIM(sku_name)) = 'Add On Arm (half)'  THEN unit_id END) as "mar-20" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND month(Revrec_Date) = 11  AND LTRIM(RTRIM(sku_name)) = 'Add On Arm (half)' THEN unit_id END) as "Nov-20" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND month(Revrec_Date) = 01  AND LTRIM(RTRIM(sku_name)) = 'Add On Arm (half)' THEN unit_id END) as "Jan-20"  
      ,CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END "Center_Name"
                ,Center_id
  
     FROM Metric 
     WHERE center_id ='0043'
     GROUP BY 
      CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END
                ,Center_id
				
---------------------------------------------------------------------------------------------------------
with metric as (
 select 
	aa.event_type as sku_type,
    CASE WHEN aa.Event_Type = 'Refund' THEN aa.Sku_name ELSE aa.Event_Type END AS Sku_Source_Type,
  	CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE bb.tender_group_type END as tender_group_type,
    CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE mpt.Tender_Type END AS Revenue_Type,
    bb.source_ID, 
    aa.sku_name,
    aa.sale_date,
    aa.quantity,
    mpt.Total_Payment_amount AS RevRec_Value,
    aa.revrec_date,
    aa.transaction_id as transaction_id,
    aa.unit_id as unit_id,
    aa.center_id as center_id, 
    bb.tender_type_count
  from revrec_combined as aa
  LEFT OUTER JOIN metric_Pmt_type_total mpt ON 	mpt.Transaction_ID = aa.Transaction_ID
  												AND mpt.Unit_ID = aa.Unit_ID
                                                AND mpt.Center_ID = aa.Center_ID
                                                AND mpt.Source_ID = aa.Source_ID
  LEFT OUTER join tender_group_type as bb on aa.transaction_id = bb.transaction_id 
 											 AND aa.Unit_ID = bb.Unit_ID
                                         	and aa.center_id = bb.center_id 
                                         	AND aa.Unit_ID = bb.unit_ID --add source for grouping
  WHERE aa.event_type = 'Service'
)

 
 SELECT 
      --Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) IN(01,02,03) AND LTRIM(RTRIM(sku_name)) = 'Stomach (Strip)' THEN unit_id END) as "Q1-21"
      Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2019 AND LTRIM(RTRIM(sku_name)) = 'Ears' THEN unit_id END) as "FY 2019"  
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND month(Revrec_Date) = 05  AND LTRIM(RTRIM(sku_name)) = 'Ears' THEN unit_id END) as "may-20" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 02 AND LTRIM(RTRIM(sku_name)) =  'Ears'  THEN unit_id END) as "Feb-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 03  AND LTRIM(RTRIM(sku_name)) = 'Ears' THEN unit_id END) as "mar-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND month(Revrec_Date) = 01  AND LTRIM(RTRIM(sku_name)) = 'Ears' THEN unit_id END) as "Jan-20"

      ,CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END "Center_Name"
                ,Center_id
  
     FROM Metric 
     WHERE center_id ='0131'
     GROUP BY 
      CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END
                ,Center_id
-----------------------------------------------------------------------------
 with metric as (
 select 
	aa.event_type as sku_type,
    CASE WHEN aa.Event_Type = 'Refund' THEN aa.Sku_name ELSE aa.Event_Type END AS Sku_Source_Type,
  	CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE bb.tender_group_type END as tender_group_type,
    CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE mpt.Tender_Type END AS Revenue_Type,
    bb.source_ID, 
    aa.sku_name,
    aa.sale_date,
    aa.quantity,
    mpt.Total_Payment_amount AS RevRec_Value,
    aa.revrec_date,
    aa.transaction_id as transaction_id,
    aa.unit_id as unit_id,
    aa.center_id as center_id, 
    bb.tender_type_count
  from revrec_combined as aa
  LEFT OUTER JOIN metric_Pmt_type_total mpt ON 	mpt.Transaction_ID = aa.Transaction_ID
  												AND mpt.Unit_ID = aa.Unit_ID
                                                AND mpt.Center_ID = aa.Center_ID
                                                AND mpt.Source_ID = aa.Source_ID
  LEFT OUTER join tender_group_type as bb on aa.transaction_id = bb.transaction_id 
 											 AND aa.Unit_ID = bb.Unit_ID
                                         	and aa.center_id = bb.center_id 
                                         	AND aa.Unit_ID = bb.unit_ID --add source for grouping
)

 
 SELECT 
           Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2019 AND LTRIM(RTRIM(sku_name)) = 'Legs (Upper)' THEN unit_id END) as "FY 2019"  
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 03  AND LTRIM(RTRIM(sku_name)) = 'Legs (Upper)' THEN unit_id END) as "mar-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2019 AND month(Revrec_Date) = 05 AND LTRIM(RTRIM(sku_name)) =  'Legs (Upper)'  THEN unit_id END) as "may-19" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND month(Revrec_Date) = 04  AND LTRIM(RTRIM(sku_name)) = 'Legs (Upper)' THEN unit_id END) as "Apr-20" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND month(Revrec_Date) = 06  AND LTRIM(RTRIM(sku_name)) = 'Legs (Upper)' THEN unit_id END) as "Jun-20" 
      ,CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END "Center_Name"
                ,Center_id
  
     FROM Metric 
     WHERE center_id ='0862'
     GROUP BY 
      CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END
                ,Center_id	
-----------------------------------------------------------------------------
 with metric as (
 select 
	aa.event_type as sku_type,
    CASE WHEN aa.Event_Type = 'Refund' THEN aa.Sku_name ELSE aa.Event_Type END AS Sku_Source_Type,
  	CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE bb.tender_group_type END as tender_group_type,
    CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE mpt.Tender_Type END AS Revenue_Type,
    bb.source_ID, 
    aa.sku_name,
    aa.sale_date,
    aa.quantity,
    mpt.Total_Payment_amount AS RevRec_Value,
    aa.revrec_date,
    aa.transaction_id as transaction_id,
    aa.unit_id as unit_id,
    aa.center_id as center_id, 
    bb.tender_type_count
  from revrec_combined as aa
  LEFT OUTER JOIN metric_Pmt_type_total mpt ON 	mpt.Transaction_ID = aa.Transaction_ID
  												AND mpt.Unit_ID = aa.Unit_ID
                                                AND mpt.Center_ID = aa.Center_ID
                                                AND mpt.Source_ID = aa.Source_ID
  LEFT OUTER join tender_group_type as bb on aa.transaction_id = bb.transaction_id 
 											 AND aa.Unit_ID = bb.Unit_ID
                                         	and aa.center_id = bb.center_id 
                                         	AND aa.Unit_ID = bb.unit_ID --add source for grouping
)

 
 SELECT 
      Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2016 AND LTRIM(RTRIM(sku_name)) = 'Lower Lip' THEN unit_id END) as "FY 2016"  
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 02  AND LTRIM(RTRIM(sku_name)) = 'Lower Lip' THEN unit_id END) as "feb-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND month(Revrec_Date) = 05 AND LTRIM(RTRIM(sku_name)) =  'Lower Lip'  THEN unit_id END) as "may-20" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND month(Revrec_Date) = 11  AND LTRIM(RTRIM(sku_name)) = 'Lower Lip' THEN unit_id END) as "Nov-20" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND month(Revrec_Date) = 07  AND LTRIM(RTRIM(sku_name)) = 'Lower Lip' THEN unit_id END) as "Jul-20" 
      ,CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END "Center_Name"
                ,Center_id
  
     FROM Metric 
     WHERE center_id ='0888'
     GROUP BY 
      CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END
                ,Center_id
-----------------------------------------------------------------------------
with metric as (
 select 
	aa.event_type as sku_type,
    CASE WHEN aa.Event_Type = 'Refund' THEN aa.Sku_name ELSE aa.Event_Type END AS Sku_Source_Type,
  	CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE bb.tender_group_type END as tender_group_type,
    CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE mpt.Tender_Type END AS Revenue_Type,
    bb.source_ID, 
    aa.sku_name,
    aa.sale_date,
    aa.quantity,
    mpt.Total_Payment_amount AS RevRec_Value,
    aa.revrec_date,
    aa.transaction_id as transaction_id,
    aa.unit_id as unit_id,
    aa.center_id as center_id, 
    bb.tender_type_count
  from revrec_combined as aa
  LEFT OUTER JOIN metric_Pmt_type_total mpt ON 	mpt.Transaction_ID = aa.Transaction_ID
  												AND mpt.Unit_ID = aa.Unit_ID
                                                AND mpt.Center_ID = aa.Center_ID
                                                AND mpt.Source_ID = aa.Source_ID
  LEFT OUTER join tender_group_type as bb on aa.transaction_id = bb.transaction_id 
 											 AND aa.Unit_ID = bb.Unit_ID
                                         	and aa.center_id = bb.center_id 
                                         	AND aa.Unit_ID = bb.unit_ID --add source for grouping
)

 
 SELECT 
      Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) IN(01,02,03) AND LTRIM(RTRIM(sku_name)) = 'Add On Bikini Full Brazilian - for packages only' THEN unit_id END) as "Q1-21"  
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 10 AND LTRIM(RTRIM(sku_name)) = 'Add On Bikini Full Brazilian - for packages only' THEN unit_id END) as "Oct-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 06 AND LTRIM(RTRIM(sku_name)) =  'Add On Bikini Full Brazilian - for packages only'  THEN unit_id END) as "Jun-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 05  AND LTRIM(RTRIM(sku_name)) = 'Add On Bikini Full Brazilian - for packages only' THEN unit_id END) as "May-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 01  AND LTRIM(RTRIM(sku_name)) = 'Add On Bikini Full Brazilian - for packages only' THEN unit_id END) as "Jan-21" 

      ,CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END "Center_Name"
                ,Center_id
  
     FROM Metric 
     WHERE center_id ='0212'
     GROUP BY 
      CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END
                ,Center_id
-----------------------------------------------------------------------------
with metric as (
 select 
	aa.event_type as sku_type,
    CASE WHEN aa.Event_Type = 'Refund' THEN aa.Sku_name ELSE aa.Event_Type END AS Sku_Source_Type,
  	CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE bb.tender_group_type END as tender_group_type,
    CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE mpt.Tender_Type END AS Revenue_Type,
    bb.source_ID, 
    aa.sku_name,
    aa.sale_date,
    aa.quantity,
    mpt.Total_Payment_amount AS RevRec_Value,
    aa.revrec_date,
    aa.transaction_id as transaction_id,
    aa.unit_id as unit_id,
    aa.center_id as center_id, 
    bb.tender_type_count
  from revrec_combined as aa
  LEFT OUTER JOIN metric_Pmt_type_total mpt ON 	mpt.Transaction_ID = aa.Transaction_ID
  												AND mpt.Unit_ID = aa.Unit_ID
                                                AND mpt.Center_ID = aa.Center_ID
                                                AND mpt.Source_ID = aa.Source_ID
  LEFT OUTER join tender_group_type as bb on aa.transaction_id = bb.transaction_id 
 											 AND aa.Unit_ID = bb.Unit_ID
                                         	and aa.center_id = bb.center_id 
                                         	AND aa.Unit_ID = bb.unit_ID --add source for grouping
)

 
 SELECT 
      --Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) IN(01,02,03) AND LTRIM(RTRIM(sku_name)) = 'Stomach (Strip)' THEN unit_id END) as "Q1-21"
      Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2019 AND LTRIM(RTRIM(sku_name)) = 'Lower Lip' THEN unit_id END) as "FY 2019"  
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 12 AND LTRIM(RTRIM(sku_name)) = 'Stomach (Strip)' THEN unit_id END) as "Dec-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 11 AND LTRIM(RTRIM(sku_name)) =  'Stomach (Strip)'  THEN unit_id END) as "Nov-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 07  AND LTRIM(RTRIM(sku_name)) = 'Stomach (Strip)' THEN unit_id END) as "Jul-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 03  AND LTRIM(RTRIM(sku_name)) = 'Stomach (Strip)' THEN unit_id END) as "Mar-21" 

      ,CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END "Center_Name"
                ,Center_id
  
     FROM Metric 
     WHERE center_id ='0007'
     GROUP BY 
      CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END
                ,Center_id
-----------------------------------------------------------------------------
with metric as (
 select 
	aa.event_type as sku_type,
    CASE WHEN aa.Event_Type = 'Refund' THEN aa.Sku_name ELSE aa.Event_Type END AS Sku_Source_Type,
  	CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE bb.tender_group_type END as tender_group_type,
    CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE mpt.Tender_Type END AS Revenue_Type,
    bb.source_ID, 
    aa.sku_name,
    aa.sale_date,
    aa.quantity,
    mpt.Total_Payment_amount AS RevRec_Value,
    aa.revrec_date,
    aa.transaction_id as transaction_id,
    aa.unit_id as unit_id,
    aa.center_id as center_id, 
    bb.tender_type_count
  from revrec_combined as aa
  LEFT OUTER JOIN metric_Pmt_type_total mpt ON 	mpt.Transaction_ID = aa.Transaction_ID
  												AND mpt.Unit_ID = aa.Unit_ID
                                                AND mpt.Center_ID = aa.Center_ID
                                                AND mpt.Source_ID = aa.Source_ID
  LEFT OUTER join tender_group_type as bb on aa.transaction_id = bb.transaction_id 
 											 AND aa.Unit_ID = bb.Unit_ID
                                         	and aa.center_id = bb.center_id 
                                         	AND aa.Unit_ID = bb.unit_ID --add source for grouping
)

 
 SELECT 
      --Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) IN(01,02,03) AND LTRIM(RTRIM(sku_name)) = 'Stomach (Strip)' THEN unit_id END) as "Q1-21"
      Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2016 AND LTRIM(RTRIM(sku_name)) = 'Upper Lip' THEN unit_id END) as "FY 2016"  
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 02 AND LTRIM(RTRIM(sku_name)) = 'Upper Lip' THEN unit_id END) as "Feb-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 08 AND LTRIM(RTRIM(sku_name)) =  'Upper Lip'  THEN unit_id END) as "Aug-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 06  AND LTRIM(RTRIM(sku_name)) = 'Upper Lip' THEN unit_id END) as "Jun-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 01  AND LTRIM(RTRIM(sku_name)) = 'Upper Lip' THEN unit_id END) as "Jan-21" 

      ,CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END "Center_Name"
                ,Center_id
  
     FROM Metric 
     WHERE center_id ='0473'
     GROUP BY 
      CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END
                ,Center_id
-----------------------------------------------------------------------------
with metric as (
 select 
	aa.event_type as sku_type,
    CASE WHEN aa.Event_Type = 'Refund' THEN aa.Sku_name ELSE aa.Event_Type END AS Sku_Source_Type,
  	CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE bb.tender_group_type END as tender_group_type,
    CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE mpt.Tender_Type END AS Revenue_Type,
    bb.source_ID, 
    aa.sku_name,
    aa.sale_date,
    aa.quantity,
    mpt.Total_Payment_amount AS RevRec_Value,
    aa.revrec_date,
    aa.transaction_id as transaction_id,
    aa.unit_id as unit_id,
    aa.center_id as center_id, 
    bb.tender_type_count
  from revrec_combined as aa
  LEFT OUTER JOIN metric_Pmt_type_total mpt ON 	mpt.Transaction_ID = aa.Transaction_ID
  												AND mpt.Unit_ID = aa.Unit_ID
                                                AND mpt.Center_ID = aa.Center_ID
                                                AND mpt.Source_ID = aa.Source_ID
  LEFT OUTER join tender_group_type as bb on aa.transaction_id = bb.transaction_id 
 											 AND aa.Unit_ID = bb.Unit_ID
                                         	and aa.center_id = bb.center_id 
                                         	AND aa.Unit_ID = bb.unit_ID --add source for grouping
)

 
 SELECT 
      --Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) IN(01,02,03) AND LTRIM(RTRIM(sku_name)) = 'Stomach (Strip)' THEN unit_id END) as "Q1-21"
      Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND LTRIM(RTRIM(sku_name)) = 'Eyebrows' THEN unit_id END) as "FY 2020"  
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 09 AND LTRIM(RTRIM(sku_name)) = 'Eyebrows' THEN unit_id END) as "Sep-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 07 AND LTRIM(RTRIM(sku_name)) =  'Eyebrows'  THEN unit_id END) as "Jul-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 12  AND LTRIM(RTRIM(sku_name)) = 'Eyebrows' THEN unit_id END) as "Dec-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 03  AND LTRIM(RTRIM(sku_name)) = 'Eyebrows' THEN unit_id END) as "Mar-21" 

      ,CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END "Center_Name"
                ,Center_id
  
     FROM Metric 
     WHERE center_id ='0631'
     GROUP BY 
      CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END
                ,Center_id
-----------------------------------------------------------------------------
with metric as (
 select 
	aa.event_type as sku_type,
    CASE WHEN aa.Event_Type = 'Refund' THEN aa.Sku_name ELSE aa.Event_Type END AS Sku_Source_Type,
  	CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE bb.tender_group_type END as tender_group_type,
    CASE WHEN Event_type IN ('Fixed Pass','Unlimited Pass') THEN 'Non-Monetary' ELSE mpt.Tender_Type END AS Revenue_Type,
    bb.source_ID, 
    aa.sku_name,
    aa.sale_date,
    aa.quantity,
    mpt.Total_Payment_amount AS RevRec_Value,
    aa.revrec_date,
    aa.transaction_id as transaction_id,
    aa.unit_id as unit_id,
    aa.center_id as center_id, 
    bb.tender_type_count
  from revrec_combined as aa
  LEFT OUTER JOIN metric_Pmt_type_total mpt ON 	mpt.Transaction_ID = aa.Transaction_ID
  												AND mpt.Unit_ID = aa.Unit_ID
                                                AND mpt.Center_ID = aa.Center_ID
                                                AND mpt.Source_ID = aa.Source_ID
  LEFT OUTER join tender_group_type as bb on aa.transaction_id = bb.transaction_id 
 											 AND aa.Unit_ID = bb.Unit_ID
                                         	and aa.center_id = bb.center_id 
                                         	AND aa.Unit_ID = bb.unit_ID --add source for grouping
)

 
 SELECT 
      --Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) IN(01,02,03) AND LTRIM(RTRIM(sku_name)) = 'Stomach (Strip)' THEN unit_id END) as "Q1-21"
      Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2020 AND LTRIM(RTRIM(sku_name)) = 'Legs (Full)' THEN unit_id END) as "FY 2020"  
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 07 AND LTRIM(RTRIM(sku_name)) =  'Legs (Full)'  THEN unit_id END) as "Jul-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 05  AND LTRIM(RTRIM(sku_name)) = 'Legs (Full)' THEN unit_id END) as "May-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 06  AND LTRIM(RTRIM(sku_name)) = 'Legs (Full)' THEN unit_id END) as "Jun-21" 
     ,Count(DISTINCT CASE WHEN Year(Revrec_Date) = 2021 AND month(Revrec_Date) = 02  AND LTRIM(RTRIM(sku_name)) = 'Legs (Full)' THEN unit_id END) as "Feb-21" 

      ,CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END "Center_Name"
                ,Center_id
  
     FROM Metric 
     WHERE center_id ='0886'
     GROUP BY 
      CASE
              WHEN Center_id =  '0733'    THEN  'EWC - Arlington - Pentagon City (0733)'
              WHEN Center_id =  '0043'    THEN  'EWC - Denville (0043)'
              WHEN Center_id =  '0131'    THEN  'EWC - Denver -Tiffany Plaza (0131)'
			  WHEN Center_id =  '0862'    THEN  'EWC - Union - West Branch Commons (0862)'
			  WHEN Center_id =  '0888'    THEN  'EWC - Camarillo (0888)'
			  WHEN Center_id =  '0212'    THEN  'EWC - Yonkers (0212)'
			  WHEN Center_id =  '0007'    THEN  'EWC - Kendall (0007)'
			  WHEN Center_id =  '0473'    THEN  'EWC - St. Paul - Grand Avenue (0473)'
			  WHEN Center_id =  '0631'    THEN  'EWC - Slidell (0631)' 
              WHEN Center_id =  '0886'    THEN  'EWC - Rochester Hills (0886)' END
                ,Center_id
-----------------------------------------------------------------------------
With Revrec as (
  
SELECT 	Event_type, Source_ID, Transaction_ID, Unit_ID, Center_ID, Sale_Price, Tax, SKU_Name, Sale_Date, Quantity, RevRec_Value, RevRec_Date
        
FROM RevRec_Service
  )
  
  SELECT         
                  SUM(CASE WHEN  Year(Revrec_Date) =2010 THEN RevRec_Value END) As "FY 2010"
                , SUM(CASE WHEN  Year(Revrec_Date) =2011 THEN RevRec_Value END) As "FY 2011"
                , SUM(CASE WHEN  Year(Revrec_Date) =2012 THEN RevRec_Value END) As "FY 2012"
                , SUM(CASE WHEN  Year(Revrec_Date) =2013 THEN RevRec_Value END) As "FY 2013"
                , SUM(CASE WHEN  Year(Revrec_Date) =2016 THEN RevRec_Value END) As "FY 2016"
                , SUM(CASE WHEN  Year(Revrec_Date) =2019 THEN RevRec_Value END) As "FY 2019"
                , SUM(CASE WHEN  Year(Revrec_Date) =2020 THEN RevRec_Value END) As "FY 2020"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND Month(Revrec_Date)  IN(01,02,03) THEN RevRec_Value END) as "Q1-21"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND month(Revrec_Date) = 01  THEN RevRec_Value END) As "Jan-21"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021  AND month(Revrec_Date) = 12 THEN RevRec_Value END) As "Dec-21"
                , SUM(CASE WHEN  Year(Revrec_Date)  =2021  AND month(Revrec_Date) = 07 THEN RevRec_Value END) As "Jul-21"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND month(Revrec_Date) = 03  THEN RevRec_Value END) As "Mar-21"
		        
  FROM Revrec
  
  -------------------when compared to event services-----------
   WITH service as (
SELECT
'Service' As Event_Type
,ep.Invoice_id As Transaction_Id
,ep.invoice_item_id As unit_id
,ep.net_amount As net_amount
,COALESCE(zcr.Franconnect_Center_ID,mcr.Franconnect_Center_ID) AS Center_ID
,COALESCE(ms.CDescript,zs.servicename) AS SKU_Name
,closed_date_in_center As Revrec_Date
FROM
Events_Services ep
LEFT OUTER JOIN Lookups_CenterCrossreference zcr ON zcr.Zenoti_Center_ID = ep.Center_ID AND ep.Source_ID = 2
LEFT OUTER JOIN Lookups_CenterCrossreference mcr ON mcr.Millennium_Center_ID = ep.Center_ID AND ep.Source_ID = 1
LEFT OUTER JOIN Millennium_Services ms ON ms.iid = ep.service_id AND ms.ilocationid = ep.center_id AND ep.source_ID = 1
LEFT OUTER JOIN Zenoti_bidimservice zs ON zs.servicewid = ep.service_id AND ep.Source_ID = 2
WHERE ep.net_amount > 0

   
  ) 
   SELECT         
                  SUM(CASE WHEN  Year(Revrec_Date) =2010 THEN net_amount END) As "FY 2010"
                , SUM(CASE WHEN  Year(Revrec_Date) =2011 THEN net_amount END) As "FY 2011"
                , SUM(CASE WHEN  Year(Revrec_Date) =2012 THEN net_amount END) As "FY 2012"
                , SUM(CASE WHEN  Year(Revrec_Date) =2013 THEN net_amount END) As "FY 2013"
                , SUM(CASE WHEN  Year(Revrec_Date) =2016 THEN net_amount END) As "FY 2016"
                , SUM(CASE WHEN  Year(Revrec_Date) =2019 THEN net_amount END) As "FY 2019"
                , SUM(CASE WHEN  Year(Revrec_Date) =2020 THEN net_amount END) As "FY 2020"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND month(Revrec_Date) = 01  THEN net_amount END) As "Jan-21"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021  AND month(Revrec_Date) = 12 THEN net_amount END) As "Dec-21"
                , SUM(CASE WHEN  Year(Revrec_Date)  =2021  AND month(Revrec_Date) = 07 THEN net_amount END) As "Jul-21"
                , SUM(CASE WHEN  Year(Revrec_Date) =2021 AND month(Revrec_Date) = 03  THEN net_amount END) As "Mar-21"
		        
  FROM service
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

			