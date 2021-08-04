  select
    factinvoiceitemwid as product_event_id,
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
  	(cast(saleprice as double) - cast(discount as double)) as net_amount,
    (
      cast(finalsaleprice as double) - (
        case
          when cast(finalsaleprice as double) = 0 then 0
          else (
            (
              cast(finalsaleprice as double) - cast(taxes as double)
            ) / cast(finalsaleprice as double)
          ) * cast(gcrevenue as double)
        end + case
          when cast(finalsaleprice as double) = 0 then 0
          else (
            (
              cast(finalsaleprice as double) - cast(taxes as double)
            ) / cast(finalsaleprice as double)
          ) * cast(PREPAIDCARDPAYMENT as double)
        end + case
          when cast(finalsaleprice as double) = 0 then 0
          else (
            (
              cast(finalsaleprice as double) - cast(taxes as double)
            ) / cast(finalsaleprice as double)
          ) * cast(LPPAYMENT as double)
        end + case
          when cast(finalsaleprice as double) = 0 then 0
          else (
            (
              cast(finalsaleprice as double) - cast(taxes as double)
            ) / cast(finalsaleprice as double)
          ) * cast(
            considerforfinancialzero_discount as double
          )
        end + cast(taxes as double)
      )
    ) as net_amount_monetary
  from
    Zenoti_bifactinvoiceitem bi
  where
    itemtypewid = '40'
    and packageversionwid = '79'
    and invoiceid = '3552d588-2615-485e-b9b8-eda5b7eefbf8'
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