with cte as (
  select
    invoice_id,CASE
      WHEN revenue_rec THEN 'Monetary'
      WHEN payment_type_id IN ('4') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
    END AS Tender_Type,
    YEAR(Sale_date) AS Sales_Year
  from
    events_payments
  where
  center_id is not null
--   center_id = '701'
  
--     center_id in (
--       '4',
--       '19',
--       '67',
--       '70',
--       '77',
--       '85',
--       '137',
--       '140',
--       '155',
--       '156',
--       '157',
--       '169',
--       '172',
--       '180',
--       '181',
--       '182',
--       '184',
--       '204',
--       '257',
--       '333',
--       '335',
--       '350',
--       '370',
--       '442',
--       '447',
--       '457',
--       '469',
--       '505',
--       '506',
--       '524',
--       '526',
--       '554',
--       '581',
--       '636',
--       '639',
--       '644',
--       '645',
--       '660',
--       '678',
--       '684',
--       '685',
--       '707',
--       '708',
--       '783',
--       '794',
--       '801',
--       '823',
--       '831',
--       '832',
--       '847',
--       '866',
--       '909',
--       '928',
--       '946',
--       '955'
--     )
  
    AND Sale_date >= cast('2011-01-01 00:00:00' as timestamp)
    AND sale_date <= Cast('2011-12-31 23:59:00' as timestamp)
),
cte1 as (
  select
    invoice_id,
    Sales_Year,
    count(distinct Tender_Type) as TenderTypeCount
  from
    cte
  group by
    invoice_id,
    Sales_Year
),
cte2 as(
  select
    distinct cte.invoice_id,
    cte.sales_year,
    cte1.TenderTypeCount,case
      when cte1.TenderTypeCount > 1 then 'Hybrid'
      when cte1.TenderTypeCount = 1 then cte.Tender_Type
      else 'NA'
    end AS TenderTypeGroup
  from
    cte
    left join cte1 on cte.invoice_id = cte1.invoice_id
    and cte.sales_year = cte1.sales_year
)
select
  Sales_Year,
  TenderTypeGroup,
  count(invoice_id) as InvoiceCount
from
  cte2
group by
  Sales_Year,
  TenderTypeGroup