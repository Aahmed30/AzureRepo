  select factinvoiceitemwid as package_purchase_event_id,
    2 as source_id,
    factinvoiceitemid as zenoti_invoice_id,
    centerwid as center_id,
    userwid as user_id,
    salebywid as register_employee_id,
    bi.packageversionwid as service_package_id,
    itemwid as item_id,
    itemtypewid as item_type_id,
    p.packagecode as package_code,
    bi.invoiceid as invoice_id,
    bi.invoiceitemid as invoice_item_id,
    bi.invoice_no as invoice_num,
    invoiceitempk as invoice_pk,
    cast(quantity as int) as quantity,
    invoicesource as invoice_source,
    cast(finalsaleprice as double) as purchased_price,
    cast(discount as double) as discount,
    cast(taxes as double) as taxes,
    cast(saleprice as double) as saleprice,
    cast(retail_price as double) as retail_price,
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
    cancelornoshowstatus as cancel_or_no_show_status,
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
    cast(endDate as timestamp) as expiration_date,
    cast(startdate as timestamp) as start_date,
    (cast(finalsaleprice as double) - (case when cast(finalsaleprice as double) = 0 then 0 
                                       else ((cast(finalsaleprice as double) - cast(taxes as double)) 
                                             / cast(finalsaleprice as double)) end * cast(gcrevenue as double) 
                                       + 
                                       case when cast(finalsaleprice as double) = 0 then 0 
                                       else ((cast(finalsaleprice as double) - cast(taxes as double)) 
                                             / cast(finalsaleprice as double)) end * cast(PREPAIDCARDPAYMENT as double) 
                                       + 
                                       case when cast(finalsaleprice as double) = 0 then 0 
                                       else ((cast(finalsaleprice as double) - cast(taxes as double)) 
                                             / cast(finalsaleprice as double)) end * cast(LPPAYMENT as double) 
                                       + 
                                       case when cast(finalsaleprice as double) = 0 then 0 
                                       else ((cast(finalsaleprice as double) - cast(taxes as double)) 
                                             / cast(finalsaleprice as double)) end * cast(considerforfinancialzero_discount as double) 
                                       + 
                                       cast(taxes as double))) as net_amount,
    case when lower(p.packagename) like '%unlimited%' then 1 else 0 end as is_unlimited
    from Zenoti_bifactinvoiceitem bi
    join (select packageversionwid, packagecode, packagename 
          from Zenoti_bidimpackage) p on bi.packageversionwid = p.packageversionwid
    left join (select invoiceitemid, PACKAGEUSERWID, max(itemlistprice) as retail_price 
               from Zenoti_bifactpackageuserredemptions 
               where cast(quantityredeemed as int) = 0 
               group by 1, 2) pur on pur.invoiceitemid = bi.invoiceitemid
    join (select PACKAGEUSERWID, startdate, enddate 
          from Zenoti_bidimpackageuser) pu  on pur.PACKAGEUSERWID = pu.PACKAGEUSERWID
    left join Lookups_ImportedPackageXref ipx  on bi.packageversionwid = ipx.PACKAGEVERSIONWID
    left join Lookups_migmillpackitemsaleprice mmpisp  on bi.invoiceitemid = mmpisp.invoiceitemid
   where cast(bi.packageversionwid as int) != 79
     and cast(bi.void as boolean) = False
     and ipx.packageversionwid is null
     and mmpisp.invoiceitemid is null
     and ((NOT (UPPER(bi.INVOICE_NO) LIKE ('II%') OR UPPER(bi.INVOICE_NO) LIKE ('IIR%'))
           OR (UPPER(bi.INVOICE_NO) LIKE ('IIIGN%') OR UPPER(bi.INVOICE_NO) LIKE ('IRIGN%'))))
     and bi.invoiceid = '29e9cf2a-4a54-4368-bc0d-41a4e6ee9075'
     

           