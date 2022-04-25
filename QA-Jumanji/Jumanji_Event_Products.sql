    ---------------------TEST FOR Scenario #1, #2, #3, #4, #5, #6--------------------
WITH Product As (
  select
    factinvoiceitemwid as product_event_id,
    2 as source_id,
    factinvoiceitemid as zenoti_invoiceitemid,
    centerwid as center_id,
    productwid as product_id,
    itemwid as item_id,
    userwid as user_id,
    itemtypewid as item_type_id,
    invoiceid as invoice_id,
    invoiceitemid as invoice_item_id,
    invoice_no as invoice_num,
    invoiceitempk as invoice_pk,
    invoicesource as invoicesource,
    cast(finalsaleprice as decimal(38, 5)) as final_sale_price,
    cast(discount as decimal(38, 5)) as discount,
    cast(taxes as decimal(38, 5)) as taxes,
    cast(saleprice as decimal(38, 5)) as saleprice,
    createdbywid as created_by_id,
    modifiedbywid as modified_by_id,
    podid as podid,
    etlcreatedby as updated_by,
    etlcreateddate as updated_at,
    invoicedatetimeincenter as invoice_timestamp,
    invoicedateincenter as invoice_date,
    saledatetimeincenter as sales_timestamp,
    saledateincenter as sales_date,
    closeddateincenter as closeddateincenter,
   
    (
      cast(finalsaleprice as decimal(38, 5)) - (
        case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(gcrevenue as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(PREPAIDCARDPAYMENT as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(LPPAYMENT as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(
            considerforfinancialzero_discount as decimal(38, 5)
          )
        end + cast(taxes as decimal(38, 5))
      )
    ) as net_amount
  from
     public.bi_factinvoiceitem bi
  where
    itemtypewid = '40'
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
    )
    
  SELECT DISTINCT
          Count(1) AS ProductCount
         ,SUM(CAST(net_amount as Decimal(18,2))) As TotalNetAmount
         ,SUM(CAST(final_sale_price as Decimal(18,2))) As Final_sale_Price
         ,SUM(CAST(taxes as Decimal(18,2))) As TotalTaxes
         ,SUM(CAST(discount as Decimal(18,2))) As TotalDiscounts
         ,COUNT(distinct concat(user_id, center_id)) as total_unique_product_purchasers
         ,DATEPART(YEAR,closeddateincenter) As Year
         ,DATEPART(QUARTER,closeddateincenter) As Quarter
         ,'June 27th Thru Sept25th' As Time
  FROM Product
  --WHERE DATEPART(YEAR,closeddateincenter) =2021
  WHERE closeddateincenter >= '2021-09-26 00:00:00' AND closeddateincenter<= '2021-12-25 23:59:00'
  AND DATEPART(QUARTER,closeddateincenter) = 3
  GROUP BY DATEPART(YEAR,closeddateincenter)
          ,DATEPART(QUARTER,closeddateincenter)
  ORDER BY 1,2,3   --Q2 2021 15,853,289.01
  
  ---------------------TEST FOR UNIQUE 11 CENTER ID-Scenario #7-------------------
  WITH Product As (
  select
    factinvoiceitemwid as product_event_id,
    2 as source_id,
    factinvoiceitemid as zenoti_invoiceitemid,
    centerwid as center_id,
    productwid as product_id,
    itemwid as item_id,
    userwid as user_id,
    itemtypewid as item_type_id,
    invoiceid as invoice_id,
    invoiceitemid as invoice_item_id,
    invoice_no as invoice_num,
    invoiceitempk as invoice_pk,
    invoicesource as invoicesource,
    cast(finalsaleprice as decimal(38, 5)) as final_sale_price,
    cast(discount as decimal(38, 5)) as discount,
    cast(taxes as decimal(38, 5)) as taxes,
    cast(saleprice as decimal(38, 5)) as saleprice,
    createdbywid as created_by_id,
    modifiedbywid as modified_by_id,
    podid as podid,
    etlcreatedby as updated_by,
    etlcreateddate as updated_at,
    invoicedatetimeincenter as invoice_timestamp,
    invoicedateincenter as invoice_date,
    saledatetimeincenter as sales_timestamp,
    saledateincenter as sales_date,
    closeddateincenter as closeddateincenter,
   
    (
      cast(finalsaleprice as decimal(38, 5)) - (
        case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(gcrevenue as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(PREPAIDCARDPAYMENT as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(LPPAYMENT as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(
            considerforfinancialzero_discount as decimal(38, 5)
          )
        end + cast(taxes as decimal(38, 5))
      )
    ) as net_amount
  from
     public.bi_factinvoiceitem bi
  where
    itemtypewid = '40'
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
    )
    
  SELECT DISTINCT
            'REDSHIFT-ZENOTI' As SourceId
           ,center_id
      --    Count(1) AS ProductCount
           ,CAST(ROUND(SUM(saleprice),2) As Decimal(18,2)) As TotalSalePrice
         --,SUM(CAST(final_sale_price as Decimal(18,2))) As Final_sale_Price
      --   ,SUM(CAST(taxes as Decimal(18,2))) As TotalTaxes
      --   ,SUM(CAST(discount as Decimal(18,2))) As TotalDiscounts
      --   ,COUNT(distinct concat(user_id, center_id)) as total_unique_product_purchasers
         ,DATEPART(YEAR,closeddateincenter) As Year
         ,DATEPART(QUARTER,closeddateincenter) As Quarter
         ,'June 27th Thru Sept24th' As Time
  FROM Product
  --WHERE DATEPART(YEAR,closeddateincenter) =2021
  WHERE closeddateincenter >= '2021-09-26 00:00:00' AND closeddateincenter<= '2021-12-25 23:59:00'
  AND center_id in ('69','306','886','230','556','350','651','319','49','192','145')
  AND DATEPART(QUARTER,closeddateincenter) = 3
  GROUP BY center_id, DATEPART(YEAR,closeddateincenter)
          ,DATEPART(QUARTER,closeddateincenter)
  ORDER BY 1,2,3   --Q2 2021 15,853,289.01
  
  ------------------------Final_Sale_price, Sale_Price-- 660, 678,685- Scenario #8, #9---------------
    WITH Product As (
  select
    factinvoiceitemwid as product_event_id,
    2 as source_id,
    factinvoiceitemid as zenoti_invoiceitemid,
    centerwid as center_id,
    productwid as product_id,
    itemwid as item_id,
    userwid as user_id,
    itemtypewid as item_type_id,
    invoiceid as invoice_id,
    invoiceitemid as invoice_item_id,
    invoice_no as invoice_num,
    invoiceitempk as invoice_pk,
    invoicesource as invoicesource,
    cast(finalsaleprice as decimal(38, 5)) as final_sale_price,
    cast(discount as decimal(38, 5)) as discount,
    cast(taxes as decimal(38, 5)) as taxes,
    cast(saleprice as decimal(38, 5)) as saleprice,
    createdbywid as created_by_id,
    modifiedbywid as modified_by_id,
    podid as podid,
    etlcreatedby as updated_by,
    etlcreateddate as updated_at,
    invoicedatetimeincenter as invoice_timestamp,
    invoicedateincenter as invoice_date,
    saledatetimeincenter as sales_timestamp,
    saledateincenter as sales_date,
    closeddateincenter as closeddateincenter,
   
    (
      cast(finalsaleprice as decimal(38, 5)) - (
        case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(gcrevenue as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(PREPAIDCARDPAYMENT as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(LPPAYMENT as decimal(38, 5))
        end + case
          when cast(finalsaleprice as decimal(38, 5)) = 0 then 0
          else (
            (
              cast(finalsaleprice as decimal(38, 5)) - cast(taxes as decimal(38, 5))
            ) / cast(finalsaleprice as decimal(38, 5))
          ) * cast(
            considerforfinancialzero_discount as decimal(38, 5)
          )
        end + cast(taxes as decimal(38, 5))
      )
    ) as net_amount
  from
     public.bi_factinvoiceitem bi
  where
    itemtypewid = '40'
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
    )
    
  SELECT DISTINCT
          center_id
      --   ,Count(1) AS ProductCount
         ,SUM(CAST(saleprice as Decimal(18,2))) As Totalsaleprice
         ,SUM(CAST(final_sale_price as Decimal(18,2))) As Final_sale_Price
        -- ,SUM(CAST(taxes as Decimal(18,2))) As TotalTaxes
         --,SUM(CAST(discount as Decimal(18,2))) As TotalDiscounts
        -- ,COUNT(distinct concat(user_id, center_id)) as total_unique_product_purchasers
         ,DATEPART(YEAR,closeddateincenter) As Year
         ,DATEPART(QUARTER,closeddateincenter) As Quarter
         ,'June 27th Thru Sept25th' As Time
  FROM Product
  --WHERE DATEPART(YEAR,closeddateincenter) =2021
  WHERE closeddateincenter >= '2021-09-26 00:00:00' AND closeddateincenter<= '2021-12-25 23:59:00'
  AND center_id IN('660','678','685')
  AND DATEPART(QUARTER,closeddateincenter) = 3
  GROUP BY center_id,DATEPART(YEAR,closeddateincenter)
          ,DATEPART(QUARTER,closeddateincenter)
  ORDER BY 1,2,3   --Q2 2021 15,853,289.01
  -----------------------------------------------------------------------------------