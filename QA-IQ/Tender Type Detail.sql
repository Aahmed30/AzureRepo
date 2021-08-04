WITH Tender_Type_Detail AS (
SELECT
    ep.Source_id,
  	ep.invoice_id,
    ep.invoice_item_id,
    ep.center_id,
    ep.payment_amount_type,
    ep.payment_type_id,
    CASE
      WHEN ep.payment_type_id IN ('64', '65', '66') THEN 'Monetary'
      WHEN ep.payment_type_id IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
    END AS Tender_Type
  FROM
    events_payments ep
  where
    ep.source_id = 2
  UNION ALL
  SELECT
    ep.Source_id,
  	ep.Invoice_Id,
    '0' AS Invoice_item_id,
    ep.center_id,
    ep.payment_amount_type,
    ep.payment_type_id,
        CASE
      WHEN ep.revenue_rec THEN 'Monetary'
      WHEN payment_type_id IN ('4') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
    END AS Tender_Type
  FROM
    events_payments ep
  WHErE
    ep.Source_id = 1
)
,Tender_Type_Count AS (
  SELECT
    ttd.Source_id,
  	ttd.invoice_id,
    ttd.invoice_Item_id,
    ttd.center_id,
    COUNT(Distinct ttd.Tender_Type) AS Tender_Type_Count
  FROM
    Tender_Type_Detail ttd
  Group by
    ttd.Source_id,
  	ttd.Invoice_id,
    ttd.invoice_item_id,
    ttd.center_id
)
SELECT
  ttd.Source_id,
  ttd.invoice_Id,
  ttd.invoice_item_id,
  ttd.center_id,
  ttc.Tender_Type_Count,
  Case
    WHEN ttc.tender_type_count > 1 THEN 'Hybrid'
    WHEN ttc.tender_type_count = 1 THEN ttd.Tender_Type
  END AS Tender_Group_Type
FROM
  Tender_Type_Detail ttd
  LEFT OUTER JOIN Tender_Type_Count ttc ON ttd.invoice_id = ttc.invoice_id
  AND ttd.invoice_item_id = ttc.invoice_item_id
  AND ttd.center_id = ttc.center_id
  where
  ttd.center_id in (
    '4',
    '19',
    '67',
    '70',
    '77',
    '85',
    '137',
    '140',
    '155',
    '156'
 ,	'157',	'169',	'172',	'180',	'181',	'182',	'184',	'204',	'257',	'333',	'335',	'350',	'370',	'442',	'447',	'457',	'469',	'505',	'506',	'524',	'526',	'554',	'581',	'636',	'639',	'644',	'645',	'660',	'678',	'684',	'685',	'707',	'708',	'783',	'794',	'801',	'823',	'831',	'832',	'847',	'866',	'909',	'928',	'946',	'955'
  )
  