--Invoice Level Testing Queries

--REV REC – FIXED PASS
-- Query for pulling the revenue recognition information for a fixed pass purchased for a specific package -- at a specific center in a specific month
-- To run this query:
-- In the cte_centerids CTE, update the franconnect_center_id to the center desired
-- In the cte_packagenames CTE, update the packagename conditions to the specified package desired
-- In the cte_purchases CTE, update the Year and Month conditions to the specific year and month desired

-- Find M and Z center ID's for a particular FranConnect Center ID

WITH cte_centerids AS
(
       SELECT *
       FROM   lookups_centercrossreference
       WHERE  franconnect_center_id = '0858') ,
-- Find service_package_IDs for a particular service
cte_packagenames AS
(
       SELECT *
       FROM   lookups_wax_pass_info
       WHERE  package_name LIKE '%Bikini%'
       AND    package_name LIKE '%12%' ),

-- Find service_package_IDs for a particular service at a particular center

cte_packagenamescenters AS
(
                SELECT DISTINCT service_package_id AS lwpi_service_package_id,
                                center_id          AS lwpi_center_id,
                                source_id          AS lwpi_source_id,
                                cte_ids.franconnect_center_id
                FROM            cte_packagenames
                INNER JOIN      cte_centerids cte_ids
                ON              ((
                                                                center_id = millennium_center_id
                                                AND             source_id = 1)
                                OR              (
                                                                center_id = zenoti_center_id
                                               AND             source_id = 2))) ,

-- Pick one invoice from the purchase Events from the specified date in the test

cte_purchases AS
(
           SELECT     source_id          AS epp_source_id,
                      center_id          AS epp_center_id,
                      invoice_id         AS epp_invoice_id,
                      service_package_id AS epp_service_package_id,
                      saleprice          AS epp_saleprice,
                      sales_date         AS epp_sales_date,
                      item_id            AS epp_item_id,
                      invoice_item_id    AS epp_invoice_item_id,
                      invoice_num        AS epp_invoice_num,
                      cte_pnc.franconnect_center_id
           FROM       events_package_purchases EPP
           INNER JOIN cte_packagenamescenters cte_pnc
           ON         epp.service_package_id = lwpi_service_package_id
           AND        epp.center_id = lwpi_center_id
           AND        epp.source_id = Cast(lwpi_source_id AS INT)
           AND        Year(sales_date) = 2021
           AND        Month(sales_date) = 6
                      --ORDER BY epp_sales_date
                      limit 1 ) ,

-- Pull in redemptions for the selected purchase

cte_purchasesredemptions AS
(
                SELECT          cte_purchases.*,
                                epr.invoice_item_id            AS epr_invoice_item_id,
                                epr.invoice_id                 AS epr_invoice_id,
                                epr.redemption_invoice_item_id AS epr_redemption_invoice_item_id,
                                epr.package_redemption_id      AS epr_package_redemption_id,
                                epr.redemption_timestamp       AS epr_redemption_timestamp,
                                                                                                                   COALESCE(epr.redemption_invoice_item_id, epr.Package_redemption_ID) AS epr_unit_ID      
                FROM            cte_purchases
                LEFT OUTER JOIN events_package_redemptions epr
                ON              epp_invoice_item_id = epr.invoice_item_id
                AND             epp_center_id = epr.purchase_center_id
                AND             epp_source_id = epr.source_id)

-- Pull in revenue recognition for the selected purchase

SELECT          *
FROM            cte_purchasesredemptions
LEFT OUTER JOIN revrec_combined rrc
ON              ( CAST(franconnect_center_id AS INT) = CAST(rrc.center_id AS INT)
AND epr_unit_id = rrc.unit_id             
                ) 
ORDER BY        revrec_date

--REV REC – UNLIMITED PASS

-- Query for pulling the revenue recognition information for an unlimited pass purchased for a specific
-- package at a specific center in a specific month
-- To run this query:
-- In the cte_centerids CTE, update the franconnect_center_id to the center desired
-- In the cte_packagenames CTE, update the packagename conditions to the specified package desired
-- In the cte_purchases CTE, update the Year and Month conditions to the specific year and onth desired


-- Find M and Z center ID's for a particular FranConnect Center ID

WITH cte_centerids AS
(
       SELECT *
       FROM   lookups_centercrossreference
       WHERE  franconnect_center_id = '0709') ,

-- Find service_package_IDs for a particular service

cte_packagenames AS
(
       SELECT *
       FROM   lookups_wax_pass_info
       WHERE  package_name LIKE '%Unlimited%'
       AND    package_name LIKE '%Bikini%'
       AND    package_name LIKE '%Bikini%' ),

-- Find service_package_IDs for a particular service at a particular center

cte_packagenamescenters AS
(
                SELECT DISTINCT package_name,
                                service_package_id AS lwpi_service_package_id,
                                center_id          AS lwpi_center_id,
                                source_id          AS lwpi_source_id,
                                cte_ids.franconnect_center_id
                FROM            cte_packagenames
                INNER JOIN      cte_centerids cte_ids
                ON              ((
                                                                center_id = millennium_center_id
                                                AND             source_id = 1)
                                OR              (
                                                                center_id = zenoti_center_id
                                                AND             source_id = 2))) ,

-- Pick one invoice from the purchase Events from the specified date in the test

cte_purchases AS
(
           SELECT     package_name,
                      source_id          AS epp_source_id,
                      center_id          AS epp_center_id,
                      invoice_id         AS epp_invoice_id,
                      service_package_id AS epp_service_package_id,
                      saleprice          AS epp_saleprice,
                      sales_date         AS epp_sales_date,
                      item_id            AS epp_item_id,
                      invoice_item_id    AS epp_invoice_item_id,
                      invoice_num        AS epp_invoice_num,
                      cte_pnc.franconnect_center_id
           FROM       events_package_purchases EPP
           INNER JOIN cte_packagenamescenters cte_pnc
           ON         epp.service_package_id = lwpi_service_package_id
           AND        epp.center_id = lwpi_center_id
           AND        epp.source_id = Cast(lwpi_source_id AS INT)
                                AND        Year(sales_date) = 2021
           AND        Month(sales_date) = 4
                      ORDER BY epp_sales_date DESC
                      limit 1 )

-- Pull in revenue recognition for the selected purchase

SELECT          *
FROM            cte_purchases
LEFT OUTER JOIN revrec_combined rrc
ON              ( CAST(franconnect_center_id AS INT) = CAST(rrc.center_id AS INT)
AND epp_invoice_id = rrc.transaction_id             
                ) 
ORDER BY        revrec_date


--REFUNDS – FIXED PASS

-- Query for pulling the refund information for a fixed pass purchased for a specific
-- package at a specific center in a specific month
-- To run this query:
-- In the cte_centerids CTE, update the franconnect_center_id to the center desired
-- In the cte_packagenames CTE, update the packagename conditions to the specified package desired
-- In the cte_packagesrefundsspecific CTE, update the Year and Month conditions to the specific year and --- month desired


-- Find M and Z center ID's for a particular FranConnect Center ID

WITH cte_centerids AS
(
       SELECT *
       FROM   lookups_centercrossreference
       WHERE  franconnect_center_id = '0007') ,

-- Pull all refunds from specified center

cte_refunds AS
(
           SELECT     source_id                  AS eref_source_id,
                      center_id                  AS eref_center_id,
                      invoice_id                 AS eref_invoice_id,
                      amount_paid_net_monetary   AS eref_amount_paid_net_monetary,
                      amount_paid_gross          AS eref_amount_paid_gross,
                      amount_paid_net            AS eref_amount_paid_net,
                      closed_in_center_timestamp AS eref_closed_in_center_timestamp,
                      refund_invoice_item_id     AS eref_refund_invoice_item_id,
                      refund_invoice_id          AS eref_refund_invoice_id,
                      cte_cid.franconnect_center_id
           FROM       events_refunds eref
           INNER JOIN cte_centerids cte_cid
           ON         (
                                 eref.center_id = cte_cid.millennium_center_id
                      AND        eref.source_id = 1)
           OR         (
                                 eref.center_id = cte_cid.zenoti_center_id
                      AND        eref.source_id = 2) ) ,

-- Pull all of the package purchases for the refunds

cte_packagesrefunds AS
(
           SELECT     source_id          AS epp_source_id,
                      center_id          AS epp_center_id,
                      invoice_id         AS epp_invoice_id,
                      service_package_id AS epp_service_package_id,
                      net_amount         AS epp_net_amount,
                      sales_date         AS epp_sales_date,
                      item_id            AS epp_item_id,
                      invoice_item_id    AS epp_invoice_item_id,
                      invoice_num        AS epp_invoice_num,
                      cte_refunds.*
           FROM       events_package_purchases epp
           INNER JOIN cte_refunds
           ON         epp.invoice_id = eref_refund_invoice_id
           AND        epp.invoice_item_id = eref_refund_invoice_item_id
           AND        epp.source_id = eref_source_id
           AND        epp.center_id = eref_center_id),

-- Find service_package_IDs for the specified package type in the test

cte_packagenames AS
(
                SELECT DISTINCT center_id          AS lwpi_center_id,
                                source_id          AS lwpi_source_id,
                                service_package_id AS lwpi_service_package_id,
                                                                        package_name    AS lwpi_package_name
                                                          FROM            lookups_wax_pass_info
                WHERE           package_name LIKE '%Bikini%'
                                                          AND                                                 package_name LIKE '%12%'),

-- Filter the refunds to ones for the requested package type and choose one

cte_packagesrefundsspecific AS
(
           SELECT     *
           FROM       cte_packagenames
           INNER JOIN cte_packagesrefunds
           ON         epp_service_package_id = lwpi_service_package_id
           AND        epp_center_id = lwpi_center_id
           AND        epp_source_id = Cast(lwpi_source_id AS INT) 
                                AND YEAR(epp_sales_date) = 2020
                               -- AND MONTH(epp_sales_date) = 4
  limit 1 
),

cte_packagesrefundsspecific_WithRedemptions AS
(
  SELECT          cte_packagesrefundsspecific.*,
                                epr.invoice_item_id            AS epr_invoice_item_id,
                                epr.invoice_id                 AS epr_invoice_id,
                                epr.redemption_invoice_item_id AS epr_redemption_invoice_item_id,
                                epr.package_redemption_id      AS epr_package_redemption_id,
                                epr.redemption_timestamp       AS epr_redemption_timestamp,
                                                                                                                   COALESCE(epr.redemption_invoice_item_id, epr.Package_redemption_ID) AS epr_unit_ID      
                FROM            cte_packagesrefundsspecific
                LEFT OUTER JOIN events_package_redemptions epr
                ON              epp_invoice_item_id = epr.invoice_item_id
                AND             epp_center_id = epr.purchase_center_id
                AND             epp_source_id = epr.source_id)


-- Pull in revenue recognition for packgage purchase
SELECT          *
FROM            cte_packagesrefundsspecific_WithRedemptions
LEFT OUTER JOIN revrec_combined rrc
ON (epr_package_redemption_id = rrc.unit_id AND franconnect_center_id = rrc.center_id) OR (epp_invoice_id = rrc.transaction_id AND epr_invoice_item_id = rrc.unit_id AND franconnect_center_id = rrc.center_id)
           
ORDER BY        revrec_date

--REFUNDS – UNLIMITED PASS
-- Query for pulling the revenue recognition information for an unlimited pass purchased for a specific
-- package at a specific center in a specific month
-- To run this query:
-- In the cte_centerids CTE, update the franconnect_center_id to the center desired
-- In the cte_packagenames CTE, update the packagename conditions to the specified package desired
-- In the cte_purchases CTE, update the Year and Month conditions to the specific year and onth desired


-- Find M and Z center ID's for a particular FranConnect Center ID

WITH cte_centerids AS
(
       SELECT *
       FROM   lookups_centercrossreference
       WHERE  franconnect_center_id = '0709') ,
-- Find service_package_IDs for a particular service
cte_packagenames AS
(
       SELECT *
       FROM   lookups_wax_pass_info
       WHERE  package_name LIKE '%Unlimited%'
       AND    package_name LIKE '%Bikini%'
       AND    package_name LIKE '%Bikini%' ),

-- Find service_package_IDs for a particular service at a particular center

cte_packagenamescenters AS
(
                SELECT DISTINCT package_name,
                                service_package_id AS lwpi_service_package_id,
                                center_id          AS lwpi_center_id,
                                source_id          AS lwpi_source_id,
                                cte_ids.franconnect_center_id
                FROM            cte_packagenames
                INNER JOIN      cte_centerids cte_ids
                ON              ((
                                                                center_id = millennium_center_id
                                                AND             source_id = 1)
                                OR              (
                                                                center_id = zenoti_center_id
                                                AND             source_id = 2))) ,

-- Pick one invoice from the purchase Events from the specified date in the test

cte_purchases AS
(
           SELECT     package_name,
                      source_id          AS epp_source_id,
                      center_id          AS epp_center_id,
                      invoice_id         AS epp_invoice_id,
                      service_package_id AS epp_service_package_id,
                      saleprice          AS epp_saleprice,
                      sales_date         AS epp_sales_date,
                      item_id            AS epp_item_id,
                      invoice_item_id    AS epp_invoice_item_id,
                      invoice_num        AS epp_invoice_num,
                      cte_pnc.franconnect_center_id
           FROM       events_package_purchases EPP
           INNER JOIN cte_packagenamescenters cte_pnc
           ON         epp.service_package_id = lwpi_service_package_id
           AND        epp.center_id = lwpi_center_id
           AND        epp.source_id = Cast(lwpi_source_id AS INT)
                                AND        Year(sales_date) = 2021
           AND        Month(sales_date) = 4
                      ORDER BY epp_sales_date DESC
                      limit 1 )

-- Pull in revenue recognition for the selected purchase

SELECT          *
FROM            cte_purchases
LEFT OUTER JOIN revrec_combined rrc
ON              ( CAST(franconnect_center_id AS INT) = CAST(rrc.center_id AS INT)
AND epp_invoice_id = rrc.transaction_id             
                ) 
ORDER BY        revrec_date

--REDEMPTIONS - UNLIMITED
-- Query for pulling the redemption information for an unlimited pass purchased for a specific
-- package at a specific center in a specific month
-- To run this query:
-- In the cte_centerids CTE, update the franconnect_center_id to the center desired
-- In the cte_packagenames CTE, update the packagename conditions to the specified package desired
-- In the cte_purchases CTE, update the Year and Month conditions to the specific year and month desired


-- Find M and Z center ID's for a particular FranConnect Center ID

WITH cte_centerids AS
(
       SELECT *
       FROM   lookups_centercrossreference
       WHERE  franconnect_center_id = '0536') ,

-- Find service_package_IDs for a particular service

cte_packagenames AS
(
       SELECT *
       FROM   lookups_wax_pass_info
       WHERE  package_name LIKE '%Unlimited%'
       AND    package_name LIKE '%Eye%'
       AND    package_name LIKE '%13%' ),

-- Find service_package_IDs for a particular service at a particular center

cte_packagenamescenters AS
(
                SELECT DISTINCT package_name AS lwpi_package_name,
                                service_package_id AS lwpi_service_package_id,
                                center_id          AS lwpi_center_id,
                                source_id          AS lwpi_source_id,
                                cte_ids.franconnect_center_id
                FROM            cte_packagenames
                INNER JOIN      cte_centerids cte_ids
                ON              ((
                                                                center_id = millennium_center_id
                                                AND             source_id = 1)
                                OR              (
                                                                center_id = zenoti_center_id
                                                AND             source_id = 2))) ,

-- Pick one invoice from the purchase Events from the specified date in the test

cte_purchases AS
(
           SELECT     source_id          AS epp_source_id,
                      center_id          AS epp_center_id,
                      invoice_id         AS epp_invoice_id,
                      service_package_id AS epp_service_package_id,
                      saleprice          AS epp_saleprice,
                                                                          net_amount         AS epp_net_amount,                    
                                                                          sales_date         AS epp_sales_date,
                      item_id            AS epp_item_id,
                      invoice_item_id    AS epp_invoice_item_id,
                      invoice_num        AS epp_invoice_num,
                      cte_pnc.franconnect_center_id,
                                                                          lwpi_service_package_id,
                                                                          lwpi_package_name
           FROM       events_package_purchases EPP
           INNER JOIN cte_packagenamescenters cte_pnc
           ON         epp.service_package_id = lwpi_service_package_id
          AND        epp.center_id = lwpi_center_id
           AND        epp.source_id = Cast(lwpi_source_id AS INT)
           AND        Year(sales_date) = 2019
           AND                          MONTH(sales_date) = 11
                      ORDER BY epp_sales_date DESC
                      limit 1 ) ,

-- Pull in redemptions for the selected purchase

cte_packagesredemptions AS
(
                SELECT          cte_purchases.*,
                                epr.source_id                  AS epr_source_id,
                                epr.purchase_center_id         AS epr_purchase_center_id,
                                epr.center_id                  AS epr_center_id,
                                epr.ewc_center_id              AS epr_ewc_center_id,
                                epr.invoice_item_id            AS epr_invoice_item_id,
                                epr.invoice_id                 AS epr_invoice_id,
                                epr.redemption_invoice_item_id AS epr_redemption_invoice_item_id,
                                epr.package_redemption_id      AS epr_package_redemption_id,
                                epr.redemption_timestamp       AS epr_redemption_timestamp
                FROM            cte_purchases
                LEFT OUTER JOIN events_package_redemptions epr
                ON              epp_invoice_item_id = epr.invoice_item_id
                AND             epp_center_id = epr.purchase_center_id
                AND             epp_source_id = epr.source_id
                ORDER BY        epr_redemption_timestamp )
-- Pull in all

SELECT *
FROM   cte_packagesredemptions

FIND A CENTER
-- This query will return all centers where there were refunds for the specified package type purchased on -- the specified date
-- To run this query:
-- In the last lines of the code, specify the package name and the date

SELECT DISTINCT(franconnect_center_id)

-- get all refunds

FROM   events_refunds eref
       -- get the Franconnect ID for the refund
       LEFT OUTER JOIN lookups_centercrossreference l_ccr
                    ON ( eref.center_id = l_ccr.millennium_center_id
                         AND eref.source_id = 1 )
                        OR ( eref.center_id = l_ccr.zenoti_center_id
                             AND eref.source_id = 2 )
                 -- get the package purchase data for the refunds           
                 LEFT OUTER JOIN events_package_purchases epp
                    ON epp.invoice_id = eref.refund_invoice_id
                       AND epp.invoice_item_id = eref.refund_invoice_item_id
                       AND epp.source_id = eref.source_id
                       AND epp.center_id = eref.center_id
       -- filter the data only to the specified package type
       INNER JOIN lookups_wax_pass_info lwpi
               ON epp.service_package_id = lwpi.service_package_id
                  AND epp.center_id = lwpi.center_id
                  AND epp.source_id = Cast(lwpi.source_id AS INT)
WHERE  package_name LIKE '%13%'
       AND package_name LIKE '%Unlimited%'
       AND package_name LIKE '%Eye%'
       AND Year(epp.sales_date) = 2021
       AND Month(epp.sales_date) = 7 
ORDER BY franconnect_center_id

                                                                                                                            