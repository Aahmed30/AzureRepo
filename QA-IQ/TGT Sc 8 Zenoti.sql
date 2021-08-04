  WITH Tender_Type_Detail AS (
    select 
    2 as source_id,
    CENTERWID as center_id,
    INVOICEID as invoice_id,
    PAYMENTDATETIMEINCENTER as payment_in_center_timestamp,
    AMOUNTTYPE as payment_amount_type,
    PAYMENTTYPE as payment_type_id,
      YEAR(PAYMENTDATETIMEINCENTER) AS SalesYear,
    CASE
      WHEN PAYMENTTYPE IN ('64', '65', '66') THEN 'Monetary'
      WHEN PAYMENTTYPE IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
    END AS Tender_Type
  from Zenoti_bifactcollections bc
    inner join (select invoiceitemid 
                from Zenoti_bifactinvoiceitem bi 
                where (( UPPER(bi.INVOICE_NO) NOT LIKE 'II%' AND UPPER(bi.INVOICE_NO) NOT LIKE 'IR%')
                        OR ((UPPER(bi.INVOICE_NO) LIKE ('IIIGN%') OR UPPER(bi.INVOICE_NO) LIKE ('IRIGN%'))
                             and     
                             ((bi.saledateincenter >= date '2019-05-08' and bi.centerwid != '660') 
                              or
                              (bi.saledateincenter >= date '2017-02-01' and bi.centerwid  = '660'))))
               ) bi on bc.invoiceitemid = bi.invoiceitemid
where  PAYMENTDATETIMEINCENTER >= cast('2021-03-01 00:00:00' as timestamp)
  AND PAYMENTDATETIMEINCENTER <= Cast('2021-03-31 23:59:00' as timestamp)
    AND centerwid = '305'
  )   
,Tender_Type_Count AS (
  SELECT
    ttd.Source_id,
  	ttd.invoice_id,
	ttd.center_id,
    ttd.SalesYear,
    COUNT(Distinct ttd.Tender_Type) AS Tender_Type_Count
  FROM
    Tender_Type_Detail ttd
  Group by
    ttd.Source_id,
  	ttd.Invoice_id,
    ttd.center_id,
    ttd.SalesYear
)
,CTE AS (
SELECT distinct
  ttd.SalesYear,
  ttd.Source_id,
  ttd.invoice_id,
 Case
    WHEN ttc.tender_type_count > 1 THEN 'Hybrid'
    WHEN ttc.tender_type_count = 1 THEN ttd.Tender_Type
  END AS Tender_Group_Type
FROM
  Tender_Type_Detail ttd
  LEFT OUTER JOIN Tender_Type_Count ttc ON ttd.invoice_id = ttc.invoice_id
--   AND ttd.invoice_item_id = ttc.invoice_item_id
  AND ttd.center_id = ttc.center_id
--   where
--   ttd.center_id in (
-- '4','19','67','70','77','85','137','140','155','156','157','169','172','180','181','182','184','204','257','333','335','350','370','442','447','457','469','505','506','524','526','554','581','636','639','644','645','660','678','684','685','707','708','783','794','801','823','831','832','847','866','909','928','946','955'  
--   )
)
SELECT 
  SalesYear,
  Source_ID,
  Tender_Group_Type,
  count(invoice_id) as InvoiceCount
FROM CTE
GROUP BY  SalesYear,
  Source_ID,
  Tender_Group_Type
  
 /* Get Center info from Zenoti
  select centerwid, centername
  from Zenoti_BiDimcenter
  where centername like '%Bloomfield%'
  42	Waltham - 0244
  714	Dallas -Addison Walk - 0031
  942	Wyckoff - 0084
  305	West Bloomfield - 0701
  */