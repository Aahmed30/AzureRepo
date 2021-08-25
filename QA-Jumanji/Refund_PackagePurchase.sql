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
WHERE  package_name LIKE '%Bikini%'
       AND package_name LIKE '%7%'
       AND package_name LIKE '%7%'
       AND Year(epp.sales_date) = 2021
       AND Month(epp.sales_date) = 4 
ORDER BY franconnect_center_id
