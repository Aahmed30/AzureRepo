SELECT
    (SELECT COUNT(DISTINCT invoice_Id) FROM Events_Payments 
     WHERE invoice_Id IS NOT NULL AND CAST(payment_amount AS DOUBLE) <> 0) AS pCountExpected
     --13,006,486
     
     
   SELECT COUNT(DISTINCT Transaction_ID) AS tgtCountActual FROM Tender_Group_Type
   --12,960,863
