  select pt.iid as refund_id,
    1 as source_id,
    th.ilocationid as center_id,
    th.ilocationid as salecenterid,
    th.iclientid as user_id,
    th.iid as invoice_id,
    th.cinvoiceno as invoice_num,
    'REFUND' as payment_mode_data,
    case when LVOID in (False) then False else True end as void,
    th.iid as refund_invoice_id,
    s.iid as refund_invoice_item_id,
    1 as consider_in_financials, -- always true for these folks
    case when trim(CCODE) in ('WPA', 'WPK1', 'PKGCF', 'BCF') then 'WPA'
      when ctranstype = 'S' then 'Service'
      when ctranstype = 'P' then 'Retail'
      else 'Other' end as refund_product_type,
    max(tdatetime) as sale_in_center_timestamp,
    max(tdatetime) as sale_in_center_date,
    max(tdatetime) as closed_in_center_timestamp,
    max(tdatetime) as payment_in_center_timestamp,
    sum(cast(pt.nprice as double) * cast(pt.nquantity as double) * -1 ) as amount_paid_net_monetary,
    sum(cast(pt.NPRICE as double) * cast(pt.NQUANTITY as double) * -1) as amount_paid_net,
    sum(cast(pt.NPRICE as double) * cast(pt.NQUANTITY as double) * -1) as amount_paid_gross,
    sum(cast(pt.NPRICE as double) * cast(pt.NQUANTITY as double) * -1) as amount_paid_adj,
    sum(ROUND(cast(pt.NPRICE as double) * cast(pt.NQUANTITY as double) * -1 * (
      case when pt.LTAXABLE = True and pt.ctranstype = 'S' then cast(NSERVTAX as double)
      when pt.LTAXABLE = True and pt.ctranstype = 'P' then cast(NRETTAX as double)
      else 0.0 end), 2)) as taxes,
    sum(0) as cc_fee,
    sum(cast(NPRICE as double)) as amount_by_tender,
    sum(0) as dispute_amount,
    max(pt.TLASTMODIFIED) as etl_created_at
  from (select * from Millennium_refunds) pt
    left outer join Millennium_transactionheader th on th.iid = pt.iheaderid and pt.ilocationid = th.ilocationid
    left outer join Millennium_services s on pt.IPRDSRVID = s.iid and s.ilocationid = pt.ilocationid
    left outer join Lookups_centerslink cl on cl.id = pt.ilocationid and cl.source_id = '1'
    left outer join Lookups_centerslink cl2 on cl2.ewc_id = cl.ewc_id and cl2.source_id = '2'
    left outer join (select centerwid, centergolivedate from Zenoti_bidimcenter) bic on cl2.id = bic.centerwid
    left outer join Millennium_taxes tr on th.ilocationid = tr.ilocationid and th.TDATETIME >= tr.ttaxstart and (th.TDATETIME <= tr.ttaxend or tr.ttaxend is null)
    -- This is used because Millennium WPA Occur after the go live, and we have no way of matching them to the Zenoti Instance.
     -- Read more in the documenation about this.
  where (TDATETIME < centergolivedate or centergolivedate is null)
  AND th.iid = '71141'
  AND th.ilocationid = '547'
  group by 1,2,3,4,5,6,7,8,9,10,11,12,13