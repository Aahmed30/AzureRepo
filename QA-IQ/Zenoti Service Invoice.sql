  select
    2 as source_id,
    centerwid as center_id,
    invoiceid as invoice_id,
    invoiceitemid as invoice_item_id,
    cast(finalsaleprice as double) as final_sale_price,
    cast(discount as double) as discount,
    cast(taxes as double) as taxes,
    cast(saleprice as double) as saleprice,
    etlcreatedby as updated_by,
    etlcreateddate as updated_at,
    invoicedatetimeincenter as invoice_timestamp,
    invoicedateincenter as invoice_date,
    saledatetimeincenter as sales_timestamp,
    saledateincenter as sales_date,
    appliedbywid as applied_by_id,
    invoicestatus as invoice_status,
    (cast(saleprice as double) - cast(discount as double)) as net_amount,
    (
      cast(finalsaleprice as double) - (
        COALESCE(
          (
            cast(finalsaleprice as double) - cast(taxes as double)
          ) /(
            case
              when cast(finalsaleprice as double) != 0 then cast(finalsaleprice as double)
              else null
            end
          ) * cast(gcrevenue as double),
          0.0
        ) + COALESCE(
          (
            cast(finalsaleprice as double) - cast(taxes as double)
          ) /(
            case
              when cast(finalsaleprice as double) != 0 then cast(finalsaleprice as double)
              else null
            end
          ) * cast(PREPAIDCARDPAYMENT as double),
          0.0
        ) + COALESCE(
          (
            cast(finalsaleprice as double) - cast(taxes as double)
          ) /(
            case
              when cast(finalsaleprice as double) != 0 then cast(finalsaleprice as double)
              else null
            end
          ) * cast(LPPAYMENT as double),
          0.0
        ) + COALESCE(
          (
            cast(finalsaleprice as double) - cast(taxes as double)
          ) /(
            case
              when cast(finalsaleprice as double) != 0 then cast(finalsaleprice as double)
              else null
            end
          ) * cast(
            considerforfinancialzero_discount as double
          ),
          0.0
        ) + cast(taxes as double)
      )
    ) as net_amount_monetary
  from
    Zenoti_bifactinvoiceitem bi
  where
    itemtypewid = '39'
    and packageversionwid = '79'
    and invoiceid = '016913ef-8fd7-4be7-87b2-62188b53c96f'
    and invoiceitempk is not null
    and (
      NOT (
        trim(lower(bi.usagetype)) LIKE ('%packageusage%')
      )
      OR bi.usagetype is null
    )
    and (
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