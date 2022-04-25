--**********************Redemption Amount & Quantity********************************************************************
--Snowflake
select zc.center_id_str, sum(service_quantity) as redemptionquantity,
cast(sum(saleprice_custom) as decimal(15,2)) as redemptionamount
from package_redemption_events ef
INNER JOIN centers_link zc ON zc.center_id = ef.redemption_center_id 
AND zc.SOURCE_ID = 2 
AND ef. redemption_timestamp between zc.start_date and zc.end_date
where  redemption_timestamp >= (date '2021-12-26') 
and  redemption_timestamp < (date '2022-03-27')
and transaction_type = 'Redemption'
group by zc.center_id_str
order by zc.center_id_str

--Zenoti
WITH UnlimitedPackageRedemptions AS
(
               SELECT distinct "invoice no", "invoice item id", case when "quantity" = 0 or "quantity" is null then 0
when ISNULL(lm.servicepriceatpackagesale,0) <> 0 then 50.5*0.01*lm.servicepriceatpackagesale*"quantity redeemed"
when (lower(p."package name") like '%unlimited%') then 50.5*0.01*("item list price"/"quantity")*"quantity redeemed"
else "adjusted amount" end AS "unlimited redemption amount"
               FROM collections_fact_consolidated_uat_q1 cfc 
		 	     LEFT JOIN package_user_fact_consolidated_uat_q1 p ON p."redemption invoice item id" = cfc."invoice item id"
			     LEFT JOIN bi_dimcenter_uat_q1 c ON cfc."package center name" = c.centername
			     LEFT JOIN bi_dimservice_uat_q1 s ON cfc."service name" = s.servicename
			     LEFT JOIN bi_dimservicecenter_uat_q1 sc ON sc.serviceid = s.serviceid AND sc.centerid = c.centerid
			     LEFT JOIN ewc_mig_mill_pack_itemsaleprice lm ON lm.invoiceitemid = p."package invoice item id" 
			              and p."service name" = lm.servicename  and p."package version id" = lm.packageversionid and isunlimitedpackage = 1
               WHERE p."organization account name" = 'waxcenter' AND cfc."payment type" = 'Packageusage' 
               AND (LOWER(p."package name") LIKE '%unlimited%')
),
package_usage AS 
(
	select distinct centercode, "package redemption center", "redemption invoice item id", "quantity redeemed", "adjusted amount"
FROM package_user_fact_consolidated_uat_q1  s	
inner join bi_dimcenter_uat_q1 bd on s."package redemption center" = bd.centername 
left join collections_fact_consolidated_uat_q1 cfc on s."redemption invoice item id" = cfc."invoice item id" and cfc."payment type" = 'Packageusage' 
WHERE "redemption date" >=   '12/26/2021' and "redemption date" < '03/27/2022'
and "record type" = 'redemption'
)
select centercode, sum("quantity redeemed") as Package_RedeemQuantity,
cast(SUM(COALESCE("unlimited redemption amount", "adjusted amount")) as decimal(15,2)) AS "Package_Redemption"
from package_usage p
left join UnlimitedPackageRedemptions r ON p."redemption invoice item id" = r."invoice item id" 	
group by centercode
order by centercode

