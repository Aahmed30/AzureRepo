===================================================
Total Systemwide Sales
Total Service Sales + Total Retail Sales
===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2010
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2010) t

Total_Revenue_Amt
1.6010424063399853E7

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2010
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2010) t
			
Total_Revenue_Amt
1.5991870323400008E7

===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2011
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2011) t

Total_Revenue_Amt
4.0801604179500066E7

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2011
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2011) t
			
Total_Revenue_Amt
4.076731257949999E7

===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2012
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2012) t

Total_Revenue_Amt
7.428551969169961E7 

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2012
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2012) t
			
Total_Revenue_Amt
7.427380576939994E7

===================================================
-------------Total RevRec Revenue_Amt--------------

/*

SELECT SUM(QUANTITY) AS Total_Revenue_Amt
    FROM (	SELECT
  SUM(R.Quantity) AS QUANTITY,
  EXTRACT(YEAR FROM R.sale_date) AS YEAR
  ,EXTRACT(MONTH FROM R.sale_date) AS MONTH
FROM
  RevRec_Service R
  WHERE EXTRACT(YEAR FROM R.sale_date)= 2013
GROUP BY
  EXTRACT(YEAR FROM R.sale_date)
  ,EXTRACT(MONTH FROM R.sale_date)
ORDER BY
  EXTRACT(YEAR FROM R.sale_date)
 ,EXTRACT(MONTH FROM R.sale_date))
 

 */
 

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2013
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2010) t



---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2010
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2010) t
			


===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2016
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2016) t

Total_Revenue_Amt
2.2185108151819837E8

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2016
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2016) t
			
Total_Revenue_Amt
2.2184616130819985E8

===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2019
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2019) t

Total_Revenue_Amt
3.260046112304986E8

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2019
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2019) t
			
Total_Revenue_Amt
3.2597096701850015E8

===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2020
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2020) t

Total_Revenue_Amt
2.1787630103049937E8

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2020
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2020) t
			
Total_Revenue_Amt
2.178367746783E8

===================================================
-------------Total RevRec Revenue_Amt--------------

/*

SELECT SUM(QUANTITY) AS Total_Revenue_Amt
    FROM (	SELECT
  SUM(R.Quantity) AS QUANTITY,
  EXTRACT(YEAR FROM R.sale_date) AS YEAR
  ,EXTRACT(MONTH FROM R.sale_date) AS MONTH
FROM
  RevRec_Service R
  WHERE EXTRACT(YEAR FROM R.sale_date)= 2013
GROUP BY
  EXTRACT(YEAR FROM R.sale_date)
  ,EXTRACT(MONTH FROM R.sale_date)
ORDER BY
  EXTRACT(YEAR FROM R.sale_date)
 ,EXTRACT(MONTH FROM R.sale_date))
 

 */
 
SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2021
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2021) t



---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2021
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2021) t
			


===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			month(sale_date) = 1 and 
			Year(Sale_date) = 2021
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			month(sale_date) = 1 and 
			Year(Sale_date) = 2021) t

Total_Revenue_Amt
1.95758488399999E7

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			month(sales_date) = 1 and 
			Year(sales_date) = 2021
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			month(sales_date) = 1 and 
			Year(sales_date) = 2021) t
			
Total_Revenue_Amt
1.957584883999999E7

===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			month(sale_date) = 2 and 
			Year(Sale_date) = 2021
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			month(sale_date) = 2 and 
			Year(Sale_date) = 2021) t

Total_Revenue_Amt
2.3461039509999964E7

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			month(sales_date) = 2 and 
			Year(sales_date) = 2021
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			month(sales_date) = 2 and 
			Year(sales_date) = 2021) t
			
Total_Revenue_Amt
2.3461039509999998E7

===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			month(sale_date) = 3 and 
			Year(Sale_date) = 2021
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			month(sale_date) = 3 and 
			Year(Sale_date) = 2021) t

Total_Revenue_Amt
3.0962083051000036E7

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			month(sales_date) = 3 and 
			Year(sales_date) = 2021
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			month(sales_date) = 3 and 
			Year(sales_date) = 2021) t
			
Total_Revenue_Amt
3.096208305099998E7

===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			month(sale_date) = 1 and 
			Year(Sale_date) = 2020
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			month(sale_date) = 1 and 
			Year(Sale_date) = 2020) t

Total_Revenue_Amt
2.423882614560007E7

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			month(sales_date) = 1 and 
			Year(sales_date) = 2020
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			month(sales_date) = 1 and 
			Year(sales_date) = 2020) t
			
Total_Revenue_Amt
2.423614270060002E7

===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			month(sale_date) = 2 and 
			Year(Sale_date) = 2020
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			month(sale_date) = 2 and 
			Year(Sale_date) = 2020) t

Total_Revenue_Amt
2.6041042880999997E7

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			month(sales_date) = 2 and 
			Year(sales_date) = 2020
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			month(sales_date) = 2 and 
			Year(sales_date) = 2020) t
			
Total_Revenue_Amt
2.603801396289999E7

===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			month(sale_date) = 3 and 
			Year(Sale_date) = 2020
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			month(sale_date) = 3 and 
			Year(Sale_date) = 2020) t

Total_Revenue_Amt
1.5296526234299988E7

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			month(sales_date) = 3 and 
			Year(sales_date) = 2020
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			month(sales_date) = 3 and 
			Year(sales_date) = 2020) t
			
Total_Revenue_Amt
1.52953103643E7

===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			month(sale_date) = 3 and 
			Year(Sale_date) = 2019
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			month(sale_date) = 3 and 
			Year(Sale_date) = 2019) t

Total_Revenue_Amt
2.7672385067400005E7

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			month(sales_date) = 3 and 
			Year(sales_date) = 2019
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			month(sales_date) = 3 and 
			Year(sales_date) = 2019) t
			
Total_Revenue_Amt
2.7670263997399997E7

===================================================
-------------Total RevRec Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			month(sale_date) = 2 and 
			Year(Sale_date) = 2016
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			month(sale_date) = 2 and 
			Year(Sale_date) = 2016) t

Total_Revenue_Amt
1.5715247672500009E7

---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			month(sales_date) = 2 and 
			Year(sales_date) = 2016
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			month(sales_date) = 2 and 
			Year(sales_date) = 2016) t
			
Total_Revenue_Amt
1.5714951372500006E7

===================================================
-------------Total RevRec Revenue_Amt--------------

/*

SELECT SUM(QUANTITY) AS Total_Revenue_Amt
    FROM (	SELECT
  SUM(R.Quantity) AS QUANTITY,
  EXTRACT(YEAR FROM R.sale_date) AS YEAR
  ,EXTRACT(MONTH FROM R.sale_date) AS MONTH
FROM
  RevRec_Service R
  WHERE EXTRACT(YEAR FROM R.sale_date)= 2013
GROUP BY
  EXTRACT(YEAR FROM R.sale_date)
  ,EXTRACT(MONTH FROM R.sale_date)
ORDER BY
  EXTRACT(YEAR FROM R.sale_date)
 ,EXTRACT(MONTH FROM R.sale_date))
 

 */
 
SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2021
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2021) t



---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2021
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2021) t
			


===================================================
-------------Total RevRec Revenue_Amt--------------

/*

SELECT SUM(QUANTITY) AS Total_Revenue_Amt
    FROM (	SELECT
  SUM(R.Quantity) AS QUANTITY,
  EXTRACT(YEAR FROM R.sale_date) AS YEAR
  ,EXTRACT(MONTH FROM R.sale_date) AS MONTH
FROM
  RevRec_Service R
  WHERE EXTRACT(YEAR FROM R.sale_date)= 2013
GROUP BY
  EXTRACT(YEAR FROM R.sale_date)
  ,EXTRACT(MONTH FROM R.sale_date)
ORDER BY
  EXTRACT(YEAR FROM R.sale_date)
 ,EXTRACT(MONTH FROM R.sale_date))
 

 */
 
SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2021
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2021) t



---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2021
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2021) t
			


===================================================
-------------Total RevRec Revenue_Amt--------------

/*

SELECT SUM(QUANTITY) AS Total_Revenue_Amt
    FROM (	SELECT
  SUM(R.Quantity) AS QUANTITY,
  EXTRACT(YEAR FROM R.sale_date) AS YEAR
  ,EXTRACT(MONTH FROM R.sale_date) AS MONTH
FROM
  RevRec_Service R
  WHERE EXTRACT(YEAR FROM R.sale_date)= 2013
GROUP BY
  EXTRACT(YEAR FROM R.sale_date)
  ,EXTRACT(MONTH FROM R.sale_date)
ORDER BY
  EXTRACT(YEAR FROM R.sale_date)
 ,EXTRACT(MONTH FROM R.sale_date))
 

 */
 
SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2021
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2021) t



---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2021
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2021) t
			


===================================================
-------------Total RevRec Revenue_Amt--------------

/*

SELECT SUM(QUANTITY) AS Total_Revenue_Amt
    FROM (	SELECT
  SUM(R.Quantity) AS QUANTITY,
  EXTRACT(YEAR FROM R.sale_date) AS YEAR
  ,EXTRACT(MONTH FROM R.sale_date) AS MONTH
FROM
  RevRec_Service R
  WHERE EXTRACT(YEAR FROM R.sale_date)= 2013
GROUP BY
  EXTRACT(YEAR FROM R.sale_date)
  ,EXTRACT(MONTH FROM R.sale_date)
ORDER BY
  EXTRACT(YEAR FROM R.sale_date)
 ,EXTRACT(MONTH FROM R.sale_date))
 

 */
 
SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Service
			where 
			--month(sale_date) = 11 and 
			Year(Sale_date) = 2021
          	UNION ALL
          	SELECT SUM(revrec_value) as Revenue_Amt
			from RevRec_Retail
			where 
			-- month(sale_date) = 11 and 
			Year(Sale_date) = 2021) t



---------------------------------------------------
-------------Total Events Revenue_Amt--------------

SELECT SUM(t.Revenue_Amt) AS Total_Revenue_Amt
    FROM (	select sum(net_amount) as Revenue_Amt
			from Events_Services
			where 
			--month(sales_date) = 11 and 
			Year(sales_date) = 2021
          	UNION ALL
          	select sum(net_amount) as Revenue_Amt
			from Events_Retail
			where 
			-- month(sales_date) = 11 and 
			Year(sales_date) = 2021) t
			


===================================================


