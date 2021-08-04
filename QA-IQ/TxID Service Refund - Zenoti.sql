  select transactionid as refund_id,
    2 as source_id,
    centerwid as center_id,
    salecenterwid as sale_center_id,
    userwid as user_id,
    bi.invoiceid as invoice_id,
    invoice_no as invoice_num,
    paidbyagentwid as paid_by_agent_wid,
    paymentmodenumber as payment_mode_number,
    orgpaymentoptionwid as org_payment_option_wid,
    paymenttype as payment_type,
    paymentoptiontype as payment_option_type,
    paymentmodedata as payment_mode_data,
    approvalnumber as approval_number,
    creditcardlastfourdigits as creditcard_last_four,
    cctransactionid as cc_transaction_id,
    podid,
    cast(void as boolean),
    br.invoiceid as refund_invoice_id,
    lower(REPLACE(REPLACE(REPLACE(refundsourceinvoiceitemid, '['), ']'), '"')) as refund_invoice_item_id,
    cast(considerinfinancials as int) as consider_in_financials,
    case when itemtypewid = '46' then 'Service'
      when itemtypewid = '47' then 'Retail'
      when itemtypewid = '49' and lower(p.packagename) like '%unlimited%' then 'Package - Unlimited'
      when itemtypewid = '49' and lower(p.packagename) not like '%unlimited%' then 'Package - Fixed'
      else 'Other' end as refund_product_type,
    max(saledatetimeincenter) as sale_in_center_timestamp,
    max(createddatetimeincenter) as sale_in_center_date,
    max(closeddatetimeincenter) as closed_in_center_timestamp,
    max(paymentdatetimeincenter) as payment_in_center_timestamp,
    sum(case when paymenttype in ('64', '65', '66', '67') -- (64,65,66,67) 64 == Cash, 65 == Card, 66 == Check
        and amounttype in ('59') -- 59 is Payment Without tax
        -- and paymentmodedata != 'Contributions' -- Yeah Contributions
        then cast(amount as double) else 0 end) as amount_paid_net_monetary,
    sum(case when amounttype in ('59') -- 59 is Payment Without tax
        -- and paymentmodedata != 'Contributions' -- Yeah Contributions
        then cast(amount as double) else 0 end) as amount_paid_net,
    sum(cast (amount as double)) as amount_paid_gross,
    sum(cast (adjustedamount as double)) as amount_paid_adj,
    sum(cast(taxes as double)) as taxes,
    max(cast (cctransactionfee as double)) as cc_fee,
    sum(cast (amountbypayment as double)) as amount_by_tender,
    sum(cast (DISPUTEAMOUNT as double)) as dispute_amount,
    max(disputedatetime) as dispute_timestamp,
    max(etlcreateddate) as etl_created_at
  from Zenoti_bifactcollections bc
    inner join (select refundsourceinvoiceitemid,
                  invoiceid,
                  invoiceitemid,
                  packageversionwid,
                  sum(cast(considerforfinancialzero_discount as double)) as comp_discount_refund,
                  sum(cast(taxes as double)) as taxes,
                  max(saledatetimeincenter) as sale_in_center_timestamp
                from Zenoti_bifactinvoiceitem bi
                where cast(itemtypewid as int) >= 46
                group by 1, 2, 3, 4
               ) bi on bc.invoiceitemid = bi.invoiceitemid
    left outer join (select considerinfinancials, agentwid
                     from Zenoti_bidimagent) ba on bc.PAIDBYAGENTWID = ba.agentwid -- filter out financials
    left outer join (select centerwid as cid, centergolivedate
                     from Zenoti_bidimcenter) c on bc.centerwid = c.cid
    left outer join (select packageversionwid, packagename
                     from Zenoti_bidimpackage) p on bi.packageversionwid = p.packageversionwid
    left outer join (select invoiceitemid, invoiceid
                     from Zenoti_bifactinvoiceitem) br on lower(REPLACE(REPLACE(REPLACE(refundsourceinvoiceitemid, '['), ']'), '"')) = br.invoiceitemid
  where ((centergolivedate <= createddatetimeincenter or centergolivedate is null) or (UPPER(bc.INVOICE_NO) LIKE ('IIIGN%') or UPPER(bc.INVOICE_NO) LIKE ('IRIGN%')))
  and bi.invoiceid = '653ce85b-4081-43c0-929c-54c957f08cd2'
  group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22