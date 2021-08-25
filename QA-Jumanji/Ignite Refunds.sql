SELECT fc.fiscal_year
	,fc.fiscal_month
	,CAST(pr.closeddateincenter AS DATE) AS closed_date
	,DATEPART(yyyy, pr.closeddateincenter) AS closed_Year
	,DATEPART(mm, pr.closeddateincenter) AS closed_month
	,DATEPART(dd, pr.closeddateincenter) AS closed_day
	,pr.centername AS Center_Name
	,pr.sku_name AS SKU_Name
	,COUNT(DISTINCT invoiceid) AS Transaction_Count
	,COUNT(invoiceitemid) AS Unit_Count
	,SUM(quantity) AS Quantity_Sum
	,SUM(finalsaleprice - taxes) AS Total_Refund_Value
FROM Zenoti.dbo.Ignite_Refunds_Detail pr
LEFT OUTER JOIN Metadata.dbo.Fiscal_Calendar fc ON fc.DATE = CAST(pr.closeddateincenter AS DATE)
WHERE itemtypecode = 'Product Refund'
GROUP BY fc.fiscal_year
	,fc.fiscal_month
	,CAST(pr.closeddateincenter AS DATE)
	,DATEPART(yyyy, pr.closeddateincenter)
	,DATEPART(mm, pr.closeddateincenter)
	,DATEPART(dd, pr.closeddateincenter)
	,pr.centername
	,pr.SKU_Name

SELECT fc.fiscal_year
	,fc.fiscal_month
	,CAST(pr.closeddateincenter AS DATE) AS closed_date
	,DATEPART(yyyy, pr.closeddateincenter) AS closed_Year
	,DATEPART(mm, pr.closeddateincenter) AS closed_month
	,DATEPART(dd, pr.closeddateincenter) AS closed_day
	,pr.centername AS Center_Name
	,pr.sku_name AS SKU_Name
	,COUNT(DISTINCT invoiceid) AS Transaction_Count
	,COUNT(invoiceitemid) AS Unit_Count
	,SUM(quantity) AS Quantity_Sum
	,SUM(finalsaleprice - taxes) AS Total_Refund_Value
FROM Zenoti.dbo.Ignite_Refunds_Detail pr
LEFT OUTER JOIN Metadata.dbo.Fiscal_Calendar fc ON fc.DATE = CAST(pr.closeddateincenter AS DATE)
WHERE itemtypecode = 'Service Refund'
GROUP BY fc.fiscal_year
	,fc.fiscal_month
	,CAST(pr.closeddateincenter AS DATE)
	,DATEPART(yyyy, pr.closeddateincenter)
	,DATEPART(mm, pr.closeddateincenter)
	,DATEPART(dd, pr.closeddateincenter)
	,pr.centername
	,pr.SKU_Name