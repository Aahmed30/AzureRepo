with cte as (
  select
    INVOICEID as invoice_id,
    YEAR(SALEDATETIMEINCENTER) as Sales_Year,
    CASE
      WHEN paymenttype IN ('64', '65', '66') THEN 'Monetary'
      WHEN paymenttype IN ('129') THEN 'WP Redemption'
      ELSE 'Non-Monetary'
    END AS Tender_Type
  from
    Zenoti_bifactcollections bc
    inner join (
      select
        invoiceitemid
      from
        Zenoti_bifactinvoiceitem bi
      where
        (
          (
            NOT (
              UPPER(bi.INVOICE_NO) LIKE ('II%')
              OR UPPER(bi.INVOICE_NO) LIKE ('IIR%')
            )
            OR (
              UPPER(bi.INVOICE_NO) LIKE ('IIIGN%')
              OR UPPER(bi.INVOICE_NO) LIKE ('IRIGN%')
            )
          )
        )
    ) bi on bc.invoiceitemid = bi.invoiceitemid
  where
  centerwid = '305'
  /*
    centerwid in (
      '4',
      '19',
      '67',
      '70',
      '77',
      '85',
      '137',
      '140',
      '155',
      '156',
      '157',
      '169',
      '172',
      '180',
      '181',
      '182',
      '184',
      '204',
      '257',
      '333',
      '335',
      '350',
      '370',
      '442',
      '447',
      '457',
      '469',
      '505',
      '506',
      '524',
      '526',
      '554',
      '581',
      '636',
      '639',
      '644',
      '645',
      '660',
      '678',
      '684',
      '685',
      '707',
      '708',
      '783',
      '794',
      '801',
      '823',
      '831',
      '832',
      '847',
      '866',
      '909',
      '928',
      '946',
      '955'
    )
  */
    AND SALEDATETIMEINCENTER >= cast('2021-03-01 00:00:00' as timestamp)
    AND SALEDATETIMEINCENTER <= Cast('2021-03-31 23:59:59' as timestamp)
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