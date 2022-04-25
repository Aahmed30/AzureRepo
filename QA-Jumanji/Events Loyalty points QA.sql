/***************************************************************************
                                  Loyalty points
 ***************************************************************************/
 -- ZENOTI REDSHIFT QUERY
WITH cte
AS (
	SELECT a.guestwid UserwID
		,SUM(a.loyaltypoints) AS Total_Loyalty_Points_Balance
	FROM PUBLIC.bi_factloyaltypoints a
	WHERE a.void = 0
	GROUP BY a.guestwid
	)
	,cte1
AS (
	SELECT b.userwid
		,max("sale date") AS Invoice_Based_Last_Transaction_Date
	FROM PUBLIC.bi_dimuser b
	JOIN PUBLIC.sales_fact_consolidated c ON b.userid = c."user id"
	WHERE (
			"item type code" IN ('Service','Product','Gift Card','Service Refund','Product Refund')
			AND "invoice status" = 'Closed Invoice'
			OR "item type code" IN ('Package','Package Refund')
			)
	GROUP BY b.userwid
	)
SELECT a.UserwID AS Guest_ID
	,a.Total_Loyalty_Points_Balance
	,b.Invoice_Based_Last_Transaction_Date
	,DATEPART(QUARTER,Invoice_Based_Last_Transaction_Date) As Quarter
FROM cte a
JOIN cte1 b ON a.UserwID = b.userwid
WHERE Invoice_Based_Last_Transaction_Date >= '2010-01-01' AND Invoice_Based_Last_Transaction_Date <= '2021-08-06'
ORDER BY DATEPART(QUARTER,Invoice_Based_Last_Transaction_Date)

-----------------------------
-- AMPERITY ZENOTI REDSHIFT QUERY
SELECT 
       Source_id
      ,COUNT(loyaltypoint_id) As LoyaltyPointCount
-- 	  ,loyaltypoint_action_date 
	  ,SUM(loyaltypoint_issued) As TotalLoyaltyPoints
FROM Events_Loyalty_Points 
WHERE loyaltypoint_action_date >= cast('2010-01-01 00:00:00' as timestamp) AND loyaltypoint_action_date <= Cast('2020-08-26 11:59:00' as timestamp)
--WHERE action_type IN('credit','debit') 
AND Source_id = 2
-- AND loyaltypoint_Id IN( 
--  '5838'
-- )

GROUP BY Source_id

/* When doing a total count and points
loyaltypoint_action_date    
Amperity -2666678278
millennium -2598980672
difference of -67,697,606 
*/

-----------------------------
-- MELLENNIUMCO REDSHIFT QUERY

WITH millennium_promos
AS (
	SELECT iid AS loyaltypoint_id
		,1 AS source_id
		,ilocationid AS center_id
		,iclientid AS user_id
		,cast(tdatetime AS Date) AS loyaltypoint_action_date
		,IHEADERID AS invoice_id
		,cast(ipoints AS FLOAT) AS loyaltypoint_issued
	FROM millenniumco.dbo.clientpromos
	)
	,millennium_adjusts
AS (
	SELECT iid AS loyaltypoint_id
		,1 AS source_id
		,ilocationid AS center_id
		,iclientid AS user_id
		,cast(tdatetime AS Date) AS loyaltypoint_action_date
		,ITRANSHEADID AS invoice_id
		,cast(ipoints AS FLOAT) AS loyaltypoint_issued
	FROM millenniumco.dbo.clientpointsadjust
	)
	,millennium_usage
AS (
	SELECT c.iid AS loyaltypoint_id
		,1 AS source_id
		,c.ilocationid AS center_id
		,c.iclientid AS user_id
		,cast(th.tdatetime AS Date) AS loyaltypoint_action_date
		,th.iid AS invoice_id
		,cast(IPOINTSUSED AS FLOAT) * - 1 AS loyaltypoint_issued
	FROM millenniumco.dbo.clientpointsusage c
	INNER JOIN millenniumco.dbo.transhead th ON c.iheaderid = th.iid
		AND c.ilocationid = th.ilocationid
	), Unionall As (
SELECT loyaltypoint_id
	,source_id
	,center_id
	,user_id
	,loyaltypoint_action_date
	,invoice_id
	,loyaltypoint_issued
FROM millennium_promos

UNION ALL

SELECT loyaltypoint_id
	,source_id
	,center_id
	,user_id
	,loyaltypoint_action_date
	,invoice_id
	,loyaltypoint_issued
FROM millennium_adjusts

UNION ALL

SELECT loyaltypoint_id
	,source_id
	,center_id
	,user_id
	,loyaltypoint_action_date
	,invoice_id
	,loyaltypoint_issued
FROM millennium_usage
)
SELECT
             source_id
			,COUNT ( loyaltypoint_id) As LoyaltyPointCount
			--,loyaltypoint_action_date 
			,SUM(loyaltypoint_issued) As TotalLoyaltyPoints
FROM Unionall
--WHERE loyaltypoint_id  IN(
--'5838'
--)
--AND loyaltypoint_action_date <= '2021-08-27'
WHERE loyaltypoint_action_date >='2010-01-01' AND loyaltypoint_action_date <= '2021-08-26'
GROUP BY source_id
--,loyaltypoint_action_date 

-----------------------------
-- AMPERITY MELLENNIUMCO REDSHIFT QUERY

SELECT 
       Source_id
      ,COUNT(loyaltypoint_id) As LoyaltyPointCount
-- 	  ,loyaltypoint_action_date 
	  ,SUM(loyaltypoint_issued) As TotalLoyaltyPoints
FROM Events_Loyalty_Points 
WHERE loyaltypoint_action_date >= cast('2010-01-01 00:00:00' as timestamp) AND loyaltypoint_action_date <= Cast('2020-08-26 11:59:00' as timestamp)
--WHERE action_type IN('credit','debit') 
AND Source_id = 1
-- AND loyaltypoint_Id IN( 
--  '5838'
-- )

GROUP BY Source_id

/* When doing a total count and points
loyaltypoint_action_date    
Amperity -2666678278
millennium -2598980672
difference of -67,697,606 
------------------------------------------------------------------------

'80378'
,'80377'
,'80384'
,'80376'
,'88887'
,'5224'
,'5838'
,'5839'
,'5835'
,'5836'
,'5837'
,'4898'
,'81088'
,'81102'
,'81103'
,'105336'