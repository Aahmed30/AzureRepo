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
