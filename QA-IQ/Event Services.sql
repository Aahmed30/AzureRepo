---------------------Zenoti--------------------------
with zenoti_service_events as (
  select
    factinvoiceitemwid as service_event_id,
    2 as source_id,
    factinvoiceitemid as zenoti_invoiceitemid,
    centerwid as center_id,
    userwid as user_id,
    salebywid as employee_id,
    servicewid as service_id,
    productwid as product_id,
    itemwid as item_id,
    itemtypewid as item_type_id,
    invoiceid as invoice_id,
    invoiceitemid as invoice_item_id,
    invoice_no as invoice_num,
    invoiceitempk as invoice_pk,
    cast(quantity as double) as quantity,
    invoicesource as invoicesource,
    cast(finalsaleprice as double) as final_sale_price,
    cast(discount as double) as discount,
    cast(taxes as double) as taxes,
    cast(saleprice as double) as saleprice,
    campaignwid as campaign_id,
    discountwid as discount_id,
    customdiscountid as custom_discount_id,
    customdiscounttype as custom_discount_type,
    closebywid as closed_by_id,
    createdbywid as created_by_id,
    modifiedbywid as modified_by_id,
    podid as podid,
    etlcreatedby as updated_by,
    etlcreateddate as updated_at,
    invoicedatetimeincenter as invoice_timestamp,
    invoicedateincenter as invoice_date,
    saledatetimeincenter as sales_timestamp,
    saledateincenter as sales_date,
    appliedbywid as applied_by_id,
    considerforfinancialzero_discount as consider_for_financial,
    groupinvoiceid as group_invoice_id,
    groupinvoiceorder as group_invoice_order,
    isrecurringinvoicewid as is_recurring_invoice_id,
    membershipsold as membership_sold,
    membergueststatuswid as member_guest_status_id,
    firstgueststatus as first_guest_status,
    cancelornoshowstatus as cancle_or_no_show_status,
    appointmentpk as appointment_pk,
    invoicestatus as invoice_status,
    ismembershipdiscountedtwid as is_membership_discounted_wid,
    isupgrademembershipwid as is_upgraded_membership_id,
    isdowngrademembershipwid as is_downgrade_membership_id,
    membershipuserid as membership_user_id,
    itemsboughtpreviously as items_bought_previously,
    createdateincenter as created_date_in_center,
    createdatetimeincenter as created_timestamp_in_center,
    campaignusagedatetimeincenter as campaign_usage_timestamp_in_center,
    campaignusagedateincenter as campaign_usage_date_in_center,
    closeddatetimeincenter as closed_timestamp_in_center,
    closeddateincenter as closed_date_in_center,
    lastupdateddatetimeincenter as last_updated_timestamp_in_center,
    lastupdateddateincenter as last_updated_date_in_center,
    ispaymentreceivedwid as is_payment_received_wid,
    gc_ppcsold as gc_ppcsold,
    cash as cash,
    custom as custom,
    cheque as cheque,
    card as card,
    lppayment as lppayment,
    membershippayment as membership_payment,
    membershiprevenue as membership_revenue,
    membershipredemptionrevenue as membership_recemption_revenue,
    membershipbenefitredemptionrevenue as membership_benefit_redemption_revenue,
    gcpayment as gc_payment,
    gcrevenue as gc_revenue,
    gcredemptionrevenue as gc_redemption_revenue,
    prepaidcardpayment as prepaid_card_payment,
    prepaidcardrevenue as prepaid_card_revenue,
    packageredemptionrevenue as package_redemption_revenue,
    custompaymentname as custom_payment_name,
    paidbycardsname as paid_by_cards_name,
    membershipirr as membership_iir,
    packageirr as package_iir,
    switchfromusermembershipid as switch_from_user_membership_id,
    isrefundedwid as is_refunded_wid,
    refunddateincenter as refunded_date_in_center,
    refunddatetimeincenter as refunded_timestamp_in_center,
    itemsboughttogether as items_bought_together,
    isrebookwid as is_rebooked_id,
    cast(void as boolean) as void,
    soldbys_csv as soldby_csv,
    resourcewid as resource_id,
    equipmentwid as equipment_id,
    therapistwid as therapist_id,
    therapistrequesttype_statuswid as therapist_request_type_status_id,
    previoussaledate as previous_sale_date,
    nextsaledate as next_sale_date,
    loyaltytierwid as loyalty_tier_id,
    appstatuswid as app_status_id,
    isinvalidinvoice as is_invalid_invoice,
    comments as comments,
    multiplesoldby as multiple_sold_by,
    isappointmentrescheduled as is_appointment_rescheduled,
    actualappointmenttime as actual_appointment_time,
    actionperformeddatetimeincenter as action_performed_timestamp_center,
    rebookedappointmentcount as rebooked_appointment_count,
    isredo as is_redo,
    isredone as is_redone,
    redotherapistwid as redo_therapist_id,
    usagetype as usage_type,
    refundsourceinvoiceitemid as refund_source_invoice_item_id,
    refundamount as refund_amount,
    refundquantity as refund_quantity,
    ispriceadjusted as is_price_adjusted,
    originalsaleprice as orginal_sale_price,
    nextservicedate as next_service_date,
    lastservicedate as last_service_date,
    followup as follow_up,
    isupsell as is_upsell,
    saletax as sale_tax,
    discountwithtax as discount_with_tax,
    customdiscount as custom_discount,
    drr as drr,
    istaxexempted as is_tax_excempt,
    drrwithdiscountorordersetting as drr_with_discount_or_order_setting,
    refundtax as refund_tax,
    roundingadjustment as rounding_adjustment,
    restockquantity as restock_qauntity,
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
    ) as net_amount
  from
    Zenoti_bifactinvoiceitem bi
  where
    itemtypewid = '39'
    and packageversionwid = '79'
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
),



millennium_service_events as (
  SELECT
    t.iid as service_event_id,
    1 as source_id,
      NULL as zenoti_invoiceitemid,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    ILOGINID as employee_id,
    IPRDSRVID as service_id,
      NULL as product_id,
    IPRDSRVID as item_id,
      NULL as item_type_id,
    th.iid as invoice_id,
    t.iid as invoice_item_id,
    th.CINVOICENO as invoice_num,
    th.IPKID as invoice_pk,
    NQUANTITY as quantity,
      NULL as invoicesource,
    (NPRICE * NQUANTITY) + (
      NPRICE * NQUANTITY * (
        case
          when t.LTAXABLE = True then cast(NSERVTAX as double)
          else 0.0
        end
      )
    ) as final_sale_price,
    case
      when discount is Null then 0
      else discount
    end as discount,
    -- the sale price already has the discount removed
    (NPRICE * NQUANTITY) * (
      case
        when t.LTAXABLE = True then cast(NSERVTAX as double)
        else 0.0
      end
    ) as taxes,
    (NPRICE * NQUANTITY) as saleprice,
      NULL as campaign_id,
      NULL as discount_id,
      NULL as custom_discount_id,
      NULL as custom_discount_type,
    ILOGINID as closed_by_id,
    ILOGINID as created_by_id,
    ILOGINID as modified_by_id,
      NULL as podid,
      NULL as updated_by,
    th.TLASTUPDATE as updated_at,
    th.TLASTUPDATE as invoice_timestamp,
    cast(TDATETIME as date) as invoice_date,
    TDATETIME as sales_timestamp,
    cast(TDATETIME as date) as sales_date,
    ILOGINID as applied_by_id,
      NULL as consider_for_financial,
      NULL as group_invoice_id,
      NULL as group_invoice_order,
      NULL as is_recurring_invoice_id,
      NULL as membership_sold,
      NULL as member_guest_status_id,
      NULL as first_guest_status,
      NULL as cancle_or_no_show_status,
      NULL as appointment_pk,
      NULL as invoice_status,
      NULL as is_membership_discounted_wid,
      NULL as is_upgraded_membership_id,
      NULL as is_downgrade_membership_id,
      NULL as membership_user_id,
      NULL as items_bought_previously,
    cast(TDATETIME as date) as created_date_in_center,
    TDATETIME as created_timestamp_in_center,
    TDATETIME as campaign_usage_timestamp_in_center,
    cast(TDATETIME as date) as campaign_usage_date_in_center,
    TDATETIME as closed_timestamp_in_center,
    cast(TDATETIME as date) as closed_date_in_center,
    TDATETIME as last_updated_timestamp_in_center,
    cast(TDATETIME as date) as last_updated_date_in_center,
      NULL as is_payment_received_wid,
      NULL as gc_ppcsold,
      NULL as cash,
      NULL as custom,
      NULL as cheque,
      NULL as card,
      NULL as lppayment,
      NULL as membership_payment,
      NULL as membership_revenue,
      NULL as membership_recemption_revenue,
      NULL as membership_benefit_redemption_revenue,
      NULL as gc_payment,
      NULL as gc_revenue,
      NULL as gc_redemption_revenue,
      NULL as prepaid_card_payment,
      NULL as prepaid_card_revenue,
      NULL as package_redemption_revenue,
      NULL as custom_payment_name,
      NULL as paid_by_cards_name,
      NULL as membership_iir,
      NULL as package_iir,
      NULL as switch_from_user_membership_id,
      NULL as is_refunded_wid,
      NULL as refunded_date_in_center,
      NULL as refunded_timestamp_in_center,
      NULL as items_bought_together,
      NULL as is_rebooked_id,
    /* case
          when LVOID = False then 0
          else 1
        end as void,*/
    LVOID as void,
      NULL as soldby_csv,
      NULL as resource_id,
      NULL as equipment_id,
      NULL as therapist_id,
      NULL as therapist_request_type_status_id,
      NULL as previous_sale_date,
      NULL as next_sale_date,
      NULL as loyalty_tier_id,
      NULL as app_status_id,
      NULL as is_invalid_invoice,
      NULL as comments,
      NULL as multiple_sold_by,
      NULL as is_appointment_rescheduled,
      NULL as actual_appointment_time,
      NULL as action_performed_timestamp_center,
      NULL as rebooked_appointment_count,
      NULL as is_redo,
      NULL as is_redone,
      NULL as redo_therapist_id,
      NULL as usage_type,
      NULL as refund_source_invoice_item_id,
      NULL as refund_amount,
      NULL as refund_quantity,
      NULL as is_price_adjusted,
      NULL as orginal_sale_price,
      NULL as next_service_date,
      NULL as last_service_date,
      NULL as follow_up,
      NULL as is_upsell,
      NULL as sale_tax,
      NULL as discount_with_tax,
      NULL as custom_discount,
      NULL as drr,
      NULL as is_tax_excempt,
      NULL as drr_with_discount_or_order_setting,
      NULL as refund_tax,
      NULL as rounding_adjustment,
      NULL as restock_qauntity,
    (NPRICE * NQUANTITY) as net_amount
  FROM
    Millennium_TransactionHeader th
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
  WHERE
    cast(t.IpackageID as int) = 0
    aND t.CTRANSTYPE = 'S'
    AND LVOID = False
),



sevice_events as (
  select
    *
  from
    zenoti_service_events
  union all
  select
    *
  from
    millennium_service_events
)




select
  se.*,
  ewc_id as ewc_center_id
from
  sevice_events se
  left outer join (
    select
      ewc_id,
      source_id as sl,
      id
    from
      Lookups_CentersLink
  ) cl on se.source_id = cast(cl.sl as int)
  and cl.id = se.center_id
  inner join (
    select
      'service_events' as table_name
  ) on 1 = 1




/*

with zenot_service_events as (
  select
    factinvoiceitemwid as service_event_id,
    2 as source_id,
    factinvoiceitemid as zenoti_invoiceitemid,
    centerwid as center_id,
    userwid as user_id,
    salebywid as employee_id,
    servicewid as service_id,
    productwid as product_id,
    itemwid as item_id,
    itemtypewid as item_type_id,
    invoiceid as invoice_id,
    invoiceitemid as invoice_item_id,
    invoice_no as invoice_num,
    invoiceitempk as invoice_pk,
    cast(quantity as decimal(38, 5)) as quantity,
    invoicesource as invoicesource,
    cast(finalsaleprice as decimal(38, 5)) as final_sale_price,
    cast(discount as decimal(38, 5)) as discount,
    cast(taxes as decimal(38, 5)) as taxes,
    cast(saleprice as decimal(38, 5)) as saleprice,
    campaignwid as campaign_id,
    discountwid as discount_id,
    customdiscountid as custom_discount_id,
    customdiscounttype as custom_discount_type,
    closebywid as closed_by_id,
    createdbywid as created_by_id,
    modifiedbywid as modified_by_id,
    podid as podid,
    etlcreatedby as updated_by,
    etlcreateddate as updated_at,
    invoicedatetimeincenter as invoice_timestamp,
    invoicedateincenter as invoice_date,
    saledatetimeincenter as sales_timestamp,
    saledateincenter as sales_date,
    appliedbywid as applied_by_id,
    considerforfinancialzero_discount as consider_for_financial,
    groupinvoiceid as group_invoice_id,
    groupinvoiceorder as group_invoice_order,
    isrecurringinvoicewid as is_recurring_invoice_id,
    membershipsold as membership_sold,
    membergueststatuswid as member_guest_status_id,
    firstgueststatus as first_guest_status,
    cancelornoshowstatus as cancle_or_no_show_status,
    appointmentpk as appointment_pk,
    invoicestatus as invoice_status,
    ismembershipdiscountedtwid as is_membership_discounted_wid,
    isupgrademembershipwid as is_upgraded_membership_id,
    isdowngrademembershipwid as is_downgrade_membership_id,
    membershipuserid as membership_user_id,
    itemsboughtpreviously as items_bought_previously,
    createdateincenter as created_date_in_center,
    createdatetimeincenter as created_timestamp_in_center,
    campaignusagedatetimeincenter as campaign_usage_timestamp_in_center,
    campaignusagedateincenter as campaign_usage_date_in_center,
    closeddatetimeincenter as closed_timestamp_in_center,
    closeddateincenter as closed_date_in_center,
    lastupdateddatetimeincenter as last_updated_timestamp_in_center,
    lastupdateddateincenter as last_updated_date_in_center,
    ispaymentreceivedwid as is_payment_received_wid,
    gc_ppcsold as gc_ppcsold,
    cash as cash,
    custom as custom,
    cheque as cheque,
    card as card,
    lppayment as lppayment,
    membershippayment as membership_payment,
    membershiprevenue as membership_revenue,
    membershipredemptionrevenue as membership_recemption_revenue,
    membershipbenefitredemptionrevenue as membership_benefit_redemption_revenue,
    gcpayment as gc_payment,
    gcrevenue as gc_revenue,
    gcredemptionrevenue as gc_redemption_revenue,
    prepaidcardpayment as prepaid_card_payment,
    prepaidcardrevenue as prepaid_card_revenue,
    packageredemptionrevenue as package_redemption_revenue,
    custompaymentname as custom_payment_name,
    paidbycardsname as paid_by_cards_name,
    membershipirr as membership_iir,
    packageirr as package_iir,
    switchfromusermembershipid as switch_from_user_membership_id,
    isrefundedwid as is_refunded_wid,
    refunddateincenter as refunded_date_in_center,
    refunddatetimeincenter as refunded_timestamp_in_center,
    itemsboughttogether as items_bought_together,
    isrebookwid as is_rebooked_id,
    cast(void as boolean) as void,
    soldbys_csv as soldby_csv,
    resourcewid as resource_id,
    equipmentwid as equipment_id,
    therapistwid as therapist_id,
    therapistrequesttype_statuswid as therapist_request_type_status_id,
    previoussaledate as previous_sale_date,
    nextsaledate as next_sale_date,
    loyaltytierwid as loyalty_tier_id,
    appstatuswid as app_status_id,
    isinvalidinvoice as is_invalid_invoice,
    comments as comments,
    multiplesoldby as multiple_sold_by,
    isappointmentrescheduled as is_appointment_rescheduled,
    actualappointmenttime as actual_appointment_time,
    actionperformeddatetimeincenter as action_performed_timestamp_center,
    rebookedappointmentcount as rebooked_appointment_count,
    isredo as is_redo,
    isredone as is_redone,
    redotherapistwid as redo_therapist_id,
    usagetype as usage_type,
    refundsourceinvoiceitemid as refund_source_invoice_item_id,
    refundamount as refund_amount,
    refundquantity as refund_quantity,
    ispriceadjusted as is_price_adjusted,
    originalsaleprice as orginal_sale_price,
    nextservicedate as next_service_date,
    lastservicedate as last_service_date,
    followup as follow_up,
    isupsell as is_upsell,
    saletax as sale_tax,
    discountwithtax as discount_with_tax,
    customdiscount as custom_discount,
    drr as drr,
    istaxexempted as is_tax_excempt,
    drrwithdiscountorordersetting as drr_with_discount_or_order_setting,
    refundtax as refund_tax,
    roundingadjustment as rounding_adjustment,
    restockquantity as restock_qauntity,
    (
      cast(finalsaleprice as decimal(38, 5)) - (
        COALESCE(
          (
            cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
          ) /(
            case
              when cast(finalsaleprice as decimal(38, 5)) != 0 then cast(finalsaleprice as decimal(38, 5))
              else null
            end
          ) * cast(gcrevenue as decimal(38, 5)),
          0.0
        ) + COALESCE(
          (
            cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
          ) /(
            case
              when cast(finalsaleprice as decimal(38, 5)) != 0 then cast(finalsaleprice as decimal(38, 5))
              else null
            end
          ) * cast(PREPAIDCARDPAYMENT as decimal(38, 5)),
          0.0
        ) + COALESCE(
          (
            cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
          ) /(
            case
              when cast(finalsaleprice as decimal(38, 5)) != 0 then cast(finalsaleprice as decimal(38, 5))
              else null
            end
          ) * cast(LPPAYMENT as decimal(38, 5)),
          0.0
        ) + COALESCE(
          (
            cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
          ) /(
            case
              when cast(finalsaleprice as decimal(38, 5)) != 0 then cast(finalsaleprice as decimal(38, 5))
              else null
            end
          ) * cast(
            considerforfinancialzero_discount as decimal(38, 5)
          ),
          0.0
        ) + cast(taxes as decimal(38, 5))
      )
    ) as net_amount
  from
    Zenoti_bifactinvoiceitem bi
  where
    itemtypewid = '39'
    and packageversionwid = '79'
    and invoiceitempk is not null
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
),
millennium_service_events as (
  SELECT
    t.iid as service_event_id,
    1 as source_id,
    NULL as zenoti_invoiceitemid,
    th.ilocationid as center_id,
    th.iclientid as user_id,
    ILOGINID as employee_id,
    IPRDSRVID as service_id,
    NULL as product_id,
    IPRDSRVID as item_id,
    NULL as item_type_id,
    th.iid as invoice_id,
    t.iid as invoice_item_id,
    th.CINVOICENO as invoice_num,
    th.IPKID as invoice_pk,
    NQUANTITY as quantity,
    NULL as invoicesource,
    (NPRICE * NQUANTITY) + NPSTCOLLECTED as final_sale_price,
    case
      when discount is null then 0
      else discount
    end as discount,
    -- the sale price already has the discount removed
    NPSTCOLLECTED as taxes,
    (NPRICE * NQUANTITY) as saleprice,
    NULL as campaign_id,
    NULL as discount_id,
    NULL as custom_discount_id,
    NULL as custom_discount_type,
    ILOGINID as closed_by_id,
    ILOGINID as created_by_id,
    ILOGINID as modified_by_id,
    NULL as podid,
    NULL as updated_by,
    th.TLASTUPDATE as updated_at,
    th.TLASTUPDATE as invoice_timestamp,
    cast(TDATETIME as date) as invoice_date,
    TDATETIME as sales_timestamp,
    cast(TDATETIME as date) as sales_date,
    ILOGINID as applied_by_id,
    NULL as consider_for_financial,
    NULL as group_invoice_id,
    NULL as group_invoice_order,
    NULL as is_recurring_invoice_id,
    NULL as membership_sold,
    NULL as member_guest_status_id,
    NULL as first_guest_status,
    NULL as cancle_or_no_show_status,
    NULL as appointment_pk,
    NULL as invoice_status,
    NULL as is_membership_discounted_wid,
    NULL as is_upgraded_membership_id,
    NULL as is_downgrade_membership_id,
    NULL as membership_user_id,
    NULL as items_bought_previously,
    cast(TDATETIME as date) as created_date_in_center,
    TDATETIME as created_timestamp_in_center,
    TDATETIME as campaign_usage_timestamp_in_center,
    cast(TDATETIME as date) as campaign_usage_date_in_center,
    TDATETIME as closed_timestamp_in_center,
    cast(TDATETIME as date) as closed_date_in_center,
    TDATETIME as last_updated_timestamp_in_center,
    cast(TDATETIME as date) as last_updated_date_in_center,
    NULL as is_payment_received_wid,
    NULL as gc_ppcsold,
    NULL as cash,
    NULL as custom,
    NULL as cheque,
    NULL as card,
    NULL as lppayment,
    NULL as membership_payment,
    NULL as membership_revenue,
    NULL as membership_recemption_revenue,
    NULL as membership_benefit_redemption_revenue,
    NULL as gc_payment,
    NULL as gc_revenue,
    NULL as gc_redemption_revenue,
    NULL as prepaid_card_payment,
    NULL as prepaid_card_revenue,
    NULL as package_redemption_revenue,
    NULL as custom_payment_name,
    NULL as paid_by_cards_name,
    NULL as membership_iir,
    NULL as package_iir,
    NULL as switch_from_user_membership_id,
    NULL as is_refunded_wid,
    NULL as refunded_date_in_center,
    NULL as refunded_timestamp_in_center,
    NULL as items_bought_together,
    NULL as is_rebooked_id,
    LVOID as void,
    NULL as soldby_csv,
    NULL as resource_id,
    NULL as equipment_id,
    NULL as therapist_id,
    NULL as therapist_request_type_status_id,
    NULL as previous_sale_date,
    NULL as next_sale_date,
    NULL as loyalty_tier_id,
    NULL as app_status_id,
    NULL as is_invalid_invoice,
    NULL as comments,
    NULL as multiple_sold_by,
    NULL as is_appointment_rescheduled,
    NULL as actual_appointment_time,
    NULL as action_performed_timestamp_center,
    NULL as rebooked_appointment_count,
    NULL as is_redo,
    NULL as is_redone,
    NULL as redo_therapist_id,
    NULL as usage_type,
    NULL as refund_source_invoice_item_id,
    NULL as refund_amount,
    NULL as refund_quantity,
    NULL as is_price_adjusted,
    NULL as orginal_sale_price,
    NULL as next_service_date,
    NULL as last_service_date,
    NULL as follow_up,
    NULL as is_upsell,
    NULL as sale_tax,
    NULL as discount_with_tax,
    NULL as custom_discount,
    NULL as drr,
    NULL as is_tax_excempt,
    NULL as drr_with_discount_or_order_setting,
    NULL as refund_tax,
    NULL as rounding_adjustment,
    NULL as restock_qauntity,
    (NPRICE * NQUANTITY) as net_amount
  FROM
    Millennium_TransactionHeader th
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
    and td.NLINENO = cast(t.NLINENO as int)
  WHERE
    t.IpackageID = '0'
    AND t.CTRANSTYPE = 'S' -- and CDISCOUNT != '' <- I think this is for discounts
),
sevice_events as (
  select
    *
  from
    zenot_service_events
  union all
  select
    *
  from
    millennium_service_events
)
select
  *
from
  sevice_events
  

*/