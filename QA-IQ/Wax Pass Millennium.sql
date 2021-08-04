  select th.iid as package_purchase_event_id,
    1 as source_id,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    th.iloginid as register_employee_id,
    s.iid as service_package_id,
    p.ipackageid as item_id,
    cpkgnumber as package_code,
    th.iid as invoice_id,
    p.iid as invoice_item_id,
    th.CINVOICENO as invoice_num,
    th.ipkid as invoice_pk,
    1 as quantity,
    cast(p.NAMOUNT as double) + (cast(p.namount as double) * cast(nservtax as double)) as purchased_price,
    0 as discount,
    cast(p.NAMOUNT as double) * cast(nservtax as double) as taxes,
    cast(p.namount as double) as saleprice,
    cast(p.nvalue as double) as retail_price,
    th.iloginid as closed_by_id,
    th.iloginid as created_by_id,
    th.iloginid as modified_by_id,
    th.iloginid as updated_by,
    cast(tdatetime as timestamp) as updated_at,
    tdatetime as invoice_timestamp,
    cast(tdatetime as timestamp) as invoice_date,
    tdatetime as sales_timestamp,
    cast(tdatetime as timestamp) as sales_date,
    iloginid as applied_by_id,
    cast(TDATETIME as timestamp) as created_date_in_center,
    TDATETIME as created_timestamp_in_center,
    TDATETIME as campaign_usage_timestamp_in_center,
    cast(TDATETIME as timestamp) as campaign_usage_date_in_center,
    TDATETIME as closed_timestamp_in_center,
    cast(TDATETIME as timestamp) as closed_date_in_center,
    TDATETIME as last_updated_timestamp_in_center,
    cast(TDATETIME as timestamp) as last_updated_date_in_center,
    LVOID as void,
    cast(DEXPIRATION as timestamp) as expiration_date,
    cast(dvalidfrom as timestamp) as start_date,
    cast(p.namount as double) as net_amount,
    case when lower(s.cpackagename) like '%unlimited%' or lower(s.cpackagename) like '%super%' then 1 else 0 end as is_unlimited
FROM Millennium_transactionheader th
  JOIN Millennium_packages p on th.iid = p.iheaderid and th.ilocationid = p.ilocationid
  LEFT OUTER JOIN Millennium_servicepackages s on s.iid = p.ipackageid and s.ilocationid = p.ilocationid
  LEFT OUTER JOIN millennium_taxes tr on th.ilocationid = tr.ilocationid and th.TDATETIME >= tr.ttaxstart and (th.TDATETIME <= tr.ttaxend OR tr.ttaxend is null)
WHERE cast(p.ipackageID as int) != 0
  and (th.lvoid = False or th.lvoid is null)
  and th.iid = '104007' and th.ilocationid = '615'ss