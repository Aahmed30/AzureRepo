--When Source = 2 --> Zenoti check in Amperity

SELECT
  invoice_id,
  invoice_item_id,
  source_id,
  payment_amount,
  payment_amount_type,
  payment_type_id,
  revenue_rec,
  CASE
      WHEN payment_type_id IN ('64', '65', '66') THEN 'Monetary'
      WHEN payment_type_id IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
  END AS Tender_Type
FROM Events_Payments
WHERE
  center_id in ('4', '19', '67', '70', '77', '85', '137', '140', '155', '156',	'157',	'169',	'172',	'180',	'181',	'182',	'184',	'204',	'257',	'333',	'335',	'350',	'370',	'442',	'447',	'457',	'469',	'505',	'506',	'524',	'526',	'554',	'581',	'636',	'639',	'644',	'645',	'660',	'678',	'684',	'685',	'707',	'708',	'783',	'794',	'801',	'823',	'831',	'832',	'847',	'866',	'909',	'928',	'946',	'955'
  )
  and source_id = 2
  and cast(payment_Amount as real) < 0
  and CASE
      WHEN payment_type_id IN ('64', '65', '66') THEN 'Monetary'
      WHEN payment_type_id IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
  END <> 'Non-Monetary'
  LIMIT 100
  
  
  /*
  select * from Tender_Group_Type
  where transaction_id = '97763142-4608-4165-862f-fed761f80010'
and center_id = '0761'
limit 100
*/
  /*
  select invoice_id A,center_id B,payment_type_id C,revenue_rec D,*
  from events_payments
  where Sale_date >= cast('2021-03-28 00:00:00' as timestamp)
    AND sale_date <= Cast('2021-06-26 23:59:00' as timestamp)
      and cast(payment_Amount as real) < 0
    AND source_id = 2
  limit 100
  --90486	352
  */
