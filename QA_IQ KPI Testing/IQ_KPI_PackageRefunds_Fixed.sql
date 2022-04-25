--**********************Package Refund Amount & Quantity********************************************************************
--Jumanji
select zc.center_id_str as centercode,
Round(sum(amount_paid_net),2) as amount_net,
count(distinct refund_invoice_item_id) as qty
from dbt.Q1_2022.refund_events ef
LEFT OUTER JOIN dbt.Q1_2022.package_purchase_events epp ON ef.refund_invoice_id = epp.invoice_id
and ef.refund_invoice_item_id = epp.invoice_item_id and ef.center_id = epp.center_id and ef.source_id = epp.source_id and ef.purchase_location is null
LEFT OUTER JOIN dbt.Q1_2022.package_purchase_events epph ON ef.purchase_transaction_id = epph.invoice_id
and ef.purchase_location = epph.center_id and ef.purchase_location is not null
INNER JOIN dbt.Q1_2022.centers_link zc ON zc.center_id = coalesce(epp.center_id, epph.center_id) AND coalesce(epp.source_id, epph.source_id) = zc.source_id 
AND ef.sale_in_center_date between zc.start_date and zc.end_date AND zc.SOURCE_ID = 2
where sale_in_center_date >= (date '2021-12-26')
and sale_in_center_date < (date '2022-03-27')
and refund_product_Type in ('Package - Fixed')
AND ef.void = False
group by zc.center_id_str
order by zc.center_id_str


--IQ
select zc.center_id_str, sum(total_refund_amount) as RefundAmt, 
count(refund_invoice_item_id) as Qty
from fixed_pass_Refund ef
inner join dbt.Q1_2022.centers_link zc ON zc.center_id = ef.center_id 
AND zc.SOURCE_ID = 2
AND ef.sale_in_center_date between zc.start_date and zc.end_date
where sale_in_center_date >= (date '2021-12-26') 
and sale_in_center_date < (date '2022-03-27')
and ef.source_id = 2
group by zc.center_id_str
order by zc.center_id_str