SELECT
  invoice_id,
  invoice_item_id,
  source_id,
  center_id,
  payment_amount,
  payment_amount_type,
  payment_type_id,
  revenue_rec,
  CASE
      WHEN revenue_rec THEN 'Monetary'
      WHEN payment_type_id IN ('4') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
  END AS Tender_Type
FROM Events_Payments
WHERE
  center_id in ('442',	'447',	'457',	'469',	'505',	'506',	'524',	'526',	'554',	'581',	'636',	'639',	'644',	'645',	'660',	'678',	'684',	'685',	'707',	'708',	'783',	'794',	'801',	'823',	'831',	'832',	'847',	'866',	'909',	'928',	'946',	'955')
  AND source_id = 1
  AND invoice_id is null
  AND cast(revenue_rec as varchar) = 'true'
  limit 100
  
  /*
select * from Tender_Group_Type
where transaction_id is null --= '61258e57-c6b7-4164-aa50-ad4df231c244'
and center_id = '0804'
limit 100
*/
  /*
  select invoice_id A,center_id B,payment_type_id C,revenue_rec D,*
  from events_payments
  where Sale_date >= cast('2021-03-28 00:00:00' as timestamp)
    AND sale_date <= Cast('2021-06-26 23:59:00' as timestamp)
    AND payment_type_id not in ('64','65','66','129')
    AND source_id = 2
  limit 100
  --90486	352
  */
  
 /*
 select *
  from Lookups_CenterCrossReference
  where millennium_center_id = '645'
  
  select *
  from Lookups_CenterCrossReference
  where zenoti_center_id = '335'
  */
