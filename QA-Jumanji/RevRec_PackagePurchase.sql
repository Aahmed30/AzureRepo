-- Pull in revenue recognition for packgage purchase
SELECT * FROM CTE_PackagesRefundsSpecific
LEFT OUTER JOIN RevRec_Fixed_Pass rfp ON (epp_invoice_item_id = rfp.originating_package_invoice_item_id /*AND COALESCE(epr_redemption_invoice_item_id, epr_Package_redemption_ID) = rfp.Unit_ID */AND CAST(franconnect_center_id AS INT) = CAST(rfp.center_id AS INT) ) 

ORDER BY revrec_date


-- Query for pulling the refund information for an unlimited pass purchased for a specific
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
       WHERE  franconnect_center_id = '0045') ,

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
                WHERE           package_name LIKE '%Eye%'
                                                          AND                                                 package_name LIKE '%Unlimited%'),

-- Filter the refunds to ones for for the requested package type and choose one
cte_packagesrefundsspecific AS
(
           SELECT     *
           FROM       cte_packagenames
           INNER JOIN cte_packagesrefunds
           ON         epp_service_package_id = lwpi_service_package_id
           AND        epp_center_id = lwpi_center_id
           AND        epp_source_id = Cast(lwpi_source_id AS INT) 
                               AND YEAR(epp_sales_date) = 2021
                                AND MONTH(epp_sales_date) = 4

  limit 1 )
