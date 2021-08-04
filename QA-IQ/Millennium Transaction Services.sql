SELECT
    t.iid as product_event_id,
    1 as source_id,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    ILOGINID as employee_id,
    IPRDSRVID as service_id,
    IPRDSRVID as product_id,
    IPRDSRVID as item_id,
    th.iid as invoice_id,
    t.iid as invoice_item_id,
    th.CINVOICENO as invoice_num,
    th.IPKID as invoice_pk,
    ms.CDescript,
    NQUANTITY as quantity,
    round(
      (NPRICE * NQUANTITY) + cast(NPSTCOLLECTED as double),
      2
    ) as final_sale_price,
    discount as discount,
    (NPRICE * NQUANTITY) * cast(NRETTAX as double) as taxes,
    (NPRICE * NQUANTITY) as saleprice,
    ILOGINID as closed_by_id,
    ILOGINID as created_by_id,
    ILOGINID as modified_by_id,
    th.TLASTUPDATE as updated_at,
    th.TLASTUPDATE as invoice_timestamp,
    cast(TDATETIME as date) as invoice_date,
    TDATETIME as sales_timestamp,
    cast(TDATETIME as date) as sales_date,
    ILOGINID as applied_by_id,
    cast(TDATETIME as date) as created_date_in_center,
    TDATETIME as created_timestamp_in_center,
    TDATETIME as campaign_usage_timestamp_in_center,
    cast(TDATETIME as date) as campaign_usage_date_in_center,
    TDATETIME as closed_timestamp_in_center,
    cast(TDATETIME as date) as closed_date_in_center,
    TDATETIME as last_updated_timestamp_in_center,
    cast(TDATETIME as date) as last_updated_date_in_center,
    LVOID as void,
    (NPRICE * NQUANTITY) as net_amount
  FROM
    Millennium_transactionheader th
    INNER JOIN Millennium_TRANSACTIONS t ON t.IHEADERID = th.IID
    AND th.ILOCATIONID = t.ILOCATIONID
    LEFT OUTER JOIN (
      select
        IHEADERID,
        ILOCATIONID,
        NLINENO,
        sum(NDISCAMOUNT) as discount
      from
        Millennium_transactiondiscounts
      group by
        IHEADERID,
        ILOCATIONID,
        NLINENO
    ) td on td.IHEADERID = t.IHEADERID
    and td.ILOCATIONID = t.ILOCATIONID
    and td.NLINENO = t.NLINENO
    LEFT OUTER JOIN Millennium_TaxRates tr on t.ilocationid = tr.ilocationid
    and th.TDATETIME >= tr.ttaxstart
    AND (
      th.TDATETIME <= tr.ttaxend
      OR tr.ttaxend is null
    )
    LEFT OUTER JOIN Millennium_Services ms ON ms.iid = t.iprdsrvid AND ms.ilocationid = th.ilocationid
  WHERE
    cast(t.IpackageID as int) = 0
    AND t.CTRANSTYPE = 'S'
    AND th.iid = '67464'
    AND t.ilocationid = '483'