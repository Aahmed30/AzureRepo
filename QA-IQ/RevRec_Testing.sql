-----------------------------------------------------------
********************* RevRec Testing **********************
-----------------------------------------------------------


select * from lookups_centercrossreference
where franconnect_center_id = '0547'


-----------------------------------------------------------
Alexandria - Alexandria Commons (Mid Center), Nov 2012, Millenium (POS)
-----------------------------------------------------------

Pick Random Service (Gross Sale) Invoice :

/*
select * 
from RevRec_Service 
where center_id = '0547' 
and month(sale_date) = 11 and Year(Sale_date) = 2012 
limit 10

select distinct (event_type) from RevRec_Service limit 10

*/

select sum(revrec_value) as Revenue_Amt
from RevRec_Service
where center_id = '0547'
--and Transaction_ID = ''
--and source_id = 1
and month(sale_date) = 11 and Year(Sale_date) = 2012

Output: 0

/*
select * 
from Events_Services 
where center_id = '0547' 
and month(sale_date) = 11 and Year(Sale_date) = 2012 
limit 10

select distinct (event_type) from RevRec_Service limit 10
*/

select sum(net_amount) as revenue
from Events_Services
where center_id = '547'
and source_id = 1
--and invoice_id = ''
and month(sales_date) = 11 and Year(sales_date) = 2012

Output: 0

-----------------------------------------------------------
Pick Random Service (Refund) Invoice:

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0547'
--and Transaction_ID = ''
--and source_id = 1
and month(sale_date) = 11 and Year(Sale_date) = 2012

Output: 0

select sum(Cast (amount_paid_net as double)) as revenue
from Events_Refunds
where center_id = '547'
and source_id = 1
--and invoice_id = ''
and month(sale_in_center_date) = 11 and Year(sale_in_center_date) = 2012

Output: 0

-----------------------------------------------------------
Pick Random Retail (Gross Sale) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Retail
where center_id = '0547'
--and Transaction_ID = ''
--and sku_name = 'service'
and event_type =  'Retail'
and source_id = 1
and month(sale_date) = 11 and Year(Sale_date) = 2012

Output: 0

select sum(net_amount) as revenue
from Events_Retail
where center_id = '547'
and source_id = 1
--and invoice_id = ''
and month(sales_date) = 11 and Year(sales_date) = 2012

Output: 0

-----------------------------------------------------------
Pick Random Retail (Refund) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0547'
--and Transaction_ID = ''
and sku_name = 'Retail'
and event_type =  'Refund'
and source_id = 1
and month(sale_date) = 11 and Year(Sale_date) = 2012

Output: 0

select sum(amount_paid_net) as revenue
from Events_Refunds
where center_id = '547'
and source_id = 1
--and invoice_id = ''
and month(sale_in_center_date) = 11 and Year(sale_in_center_date) = 2012

Output: 0

-----------------------------------------------------------
Pick Random Wax Pass Invoice event pkg_redump

select sum(revrec_value) as Revenue_Amt
from RevRec_Unlimited_Pass
where center_id = '0547'
--and Transaction_ID = ''
and event_type =  'Unlimited Pass'
and source_id = '1'
and month(sale_date) = 11 and Year(Sale_date) = 2012

Output: 0

select sum(netsales_price) as revenue
from Events_Package_Redemptions
where center_id = '547'
and source_id = 1
--and invoice_id = ''
and month(sale_date) = 11 and Year(sale_date) = 2012

Output: 0

-----------------------------------------------------------
-----------------------------------------------------------
Hamilton (Small Center), May 2016, Millenium (POS)

Pick Random Service (Gross Sale) Invoice :

select sum(revrec_value) as Revenue_Amt
from RevRec_Service
where center_id = '0938'
--and Transaction_ID = ''
and source_id = 1
and month(sale_date) = 05 and Year(Sale_date) = 2016

Output: 0

select sum(net_amount) as revenue
from Events_Services
where center_id = '817'
and source_id = 1
--and invoice_id = ''
and month(sales_date) = 05 and Year(sales_date) = 2016

Output: 0

-----------------------------------------------------------
Pick Random Service (Refund) Invoice:

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0938'
--and Transaction_ID = ''
and source_id = 1
and month(sale_date) = 05 and Year(Sale_date) = 2016

Output: 0

select sum(Cast (amount_paid_net as double)) as revenue
from Events_Refunds
where center_id = '817'
and source_id = 1
--and invoice_id = ''
and month(sale_in_center_date) = 05 and Year(sale_in_center_date) = 2016

Output: 0

-----------------------------------------------------------
Pick Random Retail (Gross Sale) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Retail
where center_id = '0938'
--and Transaction_ID = ''
--and sku_name = 'service'
and event_type =  'Retail'
and source_id = 1
and month(sale_date) = 05 and Year(Sale_date) = 2016

Output: 0

select sum(net_amount) as revenue
from Events_Retail
where center_id = '817'
and source_id = 1
--and invoice_id = ''
and month(sales_date) = 05 and Year(sales_date) = 2016

Output: 0

-----------------------------------------------------------
Pick Random Retail (Refund) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0938'
--and Transaction_ID = ''
and sku_name = 'Retail'
and event_type =  'Refund'
and source_id = 1
and month(sale_date) = 05 and Year(Sale_date) = 2016

Output: 0

select sum(amount_paid_net) as revenue
from Events_Refunds
where center_id = '817'
and source_id = 1
--and invoice_id = ''
and month(sale_in_center_date) = 05 and Year(sale_in_center_date) = 2016

Output: 0

-----------------------------------------------------------
Pick Random Wax Pass Invoice event pkg_redump

select sum(revrec_value) as Revenue_Amt
from RevRec_Unlimited_Pass
where center_id = '0938'
--and Transaction_ID = ''
and event_type =  'Unlimited Pass'
and source_id = '1'
and month(sale_date) = 05 and Year(Sale_date) = 2016

Output: 0

select sum(netsales_price) as revenue
from Events_Package_Redemptions
where center_id = '817'
and source_id = 1
--and invoice_id = ''
and month(sale_date) = 05 and Year(sale_date) = 2016

Output: 0

-----------------------------------------------------------
-----------------------------------------------------------
Brooklyn - Montague (Large Center), Apr 2019, Millenium (POS)

Pick Random Service (Gross Sale) Invoice :

select sum(revrec_value) as Revenue_Amt
from RevRec_Service
where center_id = '0407'
--and Transaction_ID = ''
and source_id = 1
and month(sale_date) = 04 and Year(Sale_date) = 2019

Output: 0

select sum(net_amount) as revenue
from Events_Services
where center_id = '345'
and source_id = 1
--and invoice_id = ''
and month(sales_date) = 04 and Year(sales_date) = 2019

Output: 0

-----------------------------------------------------------
Pick Random Service (Refund) Invoice:

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0407'
--and Transaction_ID = ''
and source_id = 1
and month(sale_date) = 04 and Year(Sale_date) = 2019

Output: 0

select sum(Cast (amount_paid_net as double)) as revenue
from Events_Refunds
where center_id = '345'
and source_id = 1
--and invoice_id = ''
and month(sale_in_center_date) = 04 and Year(sale_in_center_date) = 2019

Output: 0

-----------------------------------------------------------
Pick Random Retail (Gross Sale) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Retail
where center_id = '0407'
--and Transaction_ID = ''
--and sku_name = 'service'
and event_type =  'Retail'
and source_id = 1
and month(sale_date) = 04 and Year(Sale_date) = 2019

Output: 0

select sum(net_amount) as revenue
from Events_Retail
where center_id = '345'
and source_id = 1
--and invoice_id = ''
and month(sales_date) = 04 and Year(sales_date) = 2019

Output: 0

-----------------------------------------------------------
Pick Random Retail (Refund) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0407'
--and Transaction_ID = ''
and sku_name = 'Retail'
and event_type =  'Refund'
and source_id = 1
and month(sale_date) = 04 and Year(Sale_date) = 2019

Output: 0

select sum(amount_paid_net) as revenue
from Events_Refunds
where center_id = '345'
and source_id = 1
--and invoice_id = ''
and month(sale_in_center_date) = 04 and Year(sale_in_center_date) = 2019

Output: 0

-----------------------------------------------------------
Pick Random Wax Pass Invoice event pkg_redump

select sum(revrec_value) as Revenue_Amt
from RevRec_Unlimited_Pass
where center_id = '0407'
--and Transaction_ID = ''
and event_type =  'Unlimited Pass'
and source_id = '1'
and month(sale_date) = 04 and Year(Sale_date) = 2019

Output: 0

select sum(netsales_price) as revenue
from Events_Package_Redemptions
where center_id = '345'
and source_id = 1
--and invoice_id = ''
and month(sale_date) = 04 and Year(sale_date) = 2019

Output: 0

-----------------------------------------------------------
-----------------------------------------------------------
Hoboken (Large Center), Aug 2020, Zenoti (POS)


Pick Random Service (Gross Sale) Invoice :

select sum(revrec_value) as Revenue_Amt
from RevRec_Service
where center_id = '0059'
--and Transaction_ID = ''
--and source_id = 2
and month(sale_date) = 08 and Year(Sale_date) = 2020

Output: 0

select sum(net_amount) as revenue
from Events_Services
where center_id = '770'
and source_id = 2
--and invoice_id = ''
and month(sales_date) = 08 and Year(sales_date) = 2020

Output: 0

-----------------------------------------------------------
Pick Random Service (Refund) Invoice:

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0059'
--and Transaction_ID = ''
and source_id = 2
and month(sale_date) = 08 and Year(Sale_date) = 2020

Output: 0

select sum(Cast (amount_paid_net as double)) as revenue
from Events_Refunds
where center_id = '770'
and source_id = 2
--and invoice_id = ''
and month(sale_in_center_date) = 08 and Year(sale_in_center_date) = 2020

Output: 0

-----------------------------------------------------------
Pick Random Retail (Gross Sale) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Retail
where center_id = '0059'
--and Transaction_ID = ''
--and sku_name = 'service'
and event_type =  'Retail'
and source_id = 2
and month(sale_date) = 08 and Year(Sale_date) = 2020

Output: 0

select sum(net_amount) as revenue
from Events_Retail
where center_id = '770'
and source_id = 2
--and invoice_id = ''
and month(sales_date) = 08 and Year(sales_date) = 2020

Output: 0

-----------------------------------------------------------
Pick Random Retail (Refund) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0059'
--and Transaction_ID = ''
and sku_name = 'Retail'
and event_type =  'Refund'
and source_id = 2
and month(sale_date) = 08 and Year(Sale_date) = 2020

Output: 0

select sum(amount_paid_net) as revenue
from Events_Refunds
where center_id = '770'
and source_id = 2
--and invoice_id = ''
and month(sale_in_center_date) = 08 and Year(sale_in_center_date) = 2020

Output: 0

-----------------------------------------------------------
Pick Random Wax Pass Invoice event pkg_redump

select sum(revrec_value) as Revenue_Amt
from RevRec_Unlimited_Pass
where center_id = '0059'
--and Transaction_ID = ''
and event_type =  'Unlimited Pass'
and source_id = '2'
and month(sale_date) = 08 and Year(Sale_date) = 2020

Output: 0

select sum(netsales_price) as revenue
from Events_Package_Redemptions
where center_id = '770'
and source_id = 2
--and invoice_id = ''
and month(sale_date) = 08 and Year(sale_date) = 2020

Output: 0

-----------------------------------------------------------
Wyckoff (Large Center), Nov 2020, Zenoti (POS)
-----------------------------------------------------------

Pick Random Service (Gross Sale) Invoice :

select sum(revrec_value) as Revenue_Amt
from RevRec_Service
where center_id = '0084'
--and Transaction_ID = ''
and source_id = 2
and month(sale_date) = 11 and Year(Sale_date) = 2020

Output: 0

select sum(net_amount) as revenue
from Events_Services
where center_id = '942'
and source_id = 2
--and invoice_id = ''
and month(sales_date) = 11 and Year(sales_date) = 2020

Output: 0

-----------------------------------------------------------
Pick Random Service (Refund) Invoice:

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0084'
and Transaction_ID = '488c1713-92bf-4de6-81f3-d044c30cb4ea'
and source_id = 2
and month(sale_date) = 11 and Year(Sale_date) = 2020

Output: 0

select sum(Cast (amount_paid_net as double)) as revenue
from Events_Refunds
where center_id = '942'
and source_id = 2
and invoice_id = '488c1713-92bf-4de6-81f3-d044c30cb4ea'
and month(sale_in_center_date) = 11 and Year(sale_in_center_date) = 2020

Output: 0

-----------------------------------------------------------
Pick Random Retail (Gross Sale) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Retail
where center_id = '0084'
and Transaction_ID = 'fd444ae0-00fd-4751-9667-1242619a8059'
--and sku_name = 'service'
and event_type =  'Retail'
and source_id = 2
and month(sale_date) = 11 and Year(Sale_date) = 2020

Output: 0

select sum(net_amount) as revenue
from Events_Retail
where center_id = '942'
and source_id = 2
and invoice_id = 'fd444ae0-00fd-4751-9667-1242619a8059'
and month(sales_date) = 11 and Year(sales_date) = 2020

Output: 0

-----------------------------------------------------------
Pick Random Retail (Refund) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0084'
and Transaction_ID = '488c1713-92bf-4de6-81f3-d044c30cb4ea'
--and sku_name = 'Retail'
and event_type =  'Refund'
and source_id = 2
and month(sale_date) = 11 and Year(Sale_date) = 2020

Output: 0

select sum(amount_paid_net) as revenue
from Events_Refunds
where center_id = '942'
and source_id = 2
and invoice_id = '488c1713-92bf-4de6-81f3-d044c30cb4ea'
and month(sale_in_center_date) = 11 and Year(sale_in_center_date) = 2020

Output: 0

-----------------------------------------------------------
Pick Random Wax Pass Invoice event pkg_redump

select sum(revrec_value) as Revenue_Amt
from RevRec_Unlimited_Pass
where center_id = '0084'
--and Transaction_ID = ''
and event_type ='Unlimited Pass'
and source_id = '2'
and month(sale_date) = 11 and Year(Sale_date) = 2020

Output: 0

select sum(netsales_price) as revenue
from Events_Package_Redemptions
where center_id = '942'
and source_id = 2
--and invoice_id = ''
and month(sale_date) = 11 and Year(sale_date) = 2020

Output: 0

-----------------------------------------------------------
-----------------------------------------------------------
West Bloomfield (Mid Center), Mar 2021, Zenoti (POS)
-----------------------------------------------------------

--select * from lookups_centercrossreference where franconnect_center_id = '0701'

Pick Random Service (Gross Sale) Invoice :

select sum(revrec_value) as Revenue_Amt
from RevRec_Service
where center_id = '0701'
--and Transaction_ID = ''
and source_id = 2
and month(sale_date) = 03 and Year(Sale_date) = 2021

Output: 0

select sum(net_amount) as revenue
from Events_Services
where center_id = '305'
and source_id = 2
--and invoice_id = ''
and month(sales_date) = 03 and Year(sales_date) = 2021

Output: 0

-----------------------------------------------------------
Pick Random Service (Refund) Invoice:

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0701'
and Transaction_ID = 'f9067dab-8488-4173-a970-2c791170f15b'
and source_id = 2
and month(sale_date) = 03 and Year(Sale_date) = 2021

Output: 0

select sum(Cast (amount_paid_net as double)) as revenue
from Events_Refunds
where center_id = '305'
and source_id = 2
and invoice_id = 'f9067dab-8488-4173-a970-2c791170f15b'
and month(sale_in_center_date) = 03 and Year(sale_in_center_date) = 2021

Output: 0

-----------------------------------------------------------
Pick Random Retail (Gross Sale) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Retail
where center_id = '0701'
--and Transaction_ID = 'fd444ae0-00fd-4751-9667-1242619a8059'
--and sku_name = 'service'
and event_type =  'Retail'
and source_id = 2
and month(sale_date) = 03 and Year(Sale_date) = 2021

Output: 0

select sum(net_amount) as revenue
from Events_Retail
where center_id = '305'
and source_id = 2
--and invoice_id = 'fd444ae0-00fd-4751-9667-1242619a8059'
and month(sales_date) = 03 and Year(sales_date) = 2021

Output: 0

-----------------------------------------------------------
Pick Random Retail (Refund) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where center_id = '0701'
and Transaction_ID = '58f51378-bca1-483c-840c-9444dd503450'
--and sku_name = 'Retail'
and event_type =  'Refund'
and source_id = 2
and month(sale_date) = 03 and Year(Sale_date) = 2021

Output: 0

select sum(amount_paid_gross) as revenue
from Events_Refunds
where center_id = '305'
and source_id = 2
and invoice_id = '58f51378-bca1-483c-840c-9444dd503450'
and month(sale_in_center_date) = 03 and Year(sale_in_center_date) = 2021

Output: 0

-----------------------------------------------------------
Pick Random Wax Pass Invoice event pkg_redump

select sum(revrec_value) as Revenue_Amt
from RevRec_Unlimited_Pass
where center_id = '0701'
--and Transaction_ID = ''
and event_type ='Unlimited Pass'
and source_id = '2'
and month(sale_date) = 03 and Year(Sale_date) = 2021

Output: 0

select sum(netsales_price) as revenue
from Events_Package_Redemptions
where center_id = '305'
and source_id = 2
--and invoice_id = ''
and month(sale_date) = 03 and Year(sale_date) = 2021

Output: 0


-----------------------------------------------------------
FY 2010
-----------------------------------------------------------

Pick Random Service (Gross Sale) Invoice :

select sum(revrec_value) as Revenue_Amt
from RevRec_Service
where Year(Sale_date) = 2010 
1.3988095919899851E7

select sum(net_amount) as revenue
from Events_Services
where Year(sales_date) = 2010
1.3969697179899998E7
-----------------------------------------------------------
Pick Random Service (Refund) Invoice:

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where  Year(Sale_date) = 2010
-68556.03859999993

select sum(Cast (amount_paid_net as double)) as revenue
from Events_Refunds
where Year(sale_in_center_date) = 2010
-262540.8924000005
-----------------------------------------------------------
Pick Random Retail (Gross Sale) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Retail
where Year(Sale_date) = 2010
2018097.4834999943

select sum(net_amount) as revenue
from Events_Retail
where Year(sales_date) = 2010
2017942.4835000015
-----------------------------------------------------------
Pick Random Retail (Refund) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where Year(Sale_date) = 2010
-68556.03859999993

select sum(amount_paid_gross) as revenue
from Events_Refunds
where Year(sale_in_center_date) = 2010
-262540.8924000005
-----------------------------------------------------------
Pick Random Wax Pass Invoice event pkg_redump

select sum(revrec_value) as Revenue_Amt
from RevRec_Unlimited_Pass
where Year(Sale_date) = 2010
1319669.0599973197

select sum(netsales_price) as revenue
from Events_Package_Redemptions
where Year(sale_date) = 2010
3.5858050020799994E7
-----------------------------------------------------------
FY 2011
-----------------------------------------------------------
Pick Random Service (Gross Sale) Invoice :

select sum(revrec_value) as Revenue_Amt
from RevRec_Service
where Year(Sale_date) = 2011
3.5803998407600015E7

select sum(net_amount) as revenue
from Events_Services
where Year(sales_date) = 2011
3.5769914557600014E7
-----------------------------------------------------------
Pick Random Service (Refund) Invoice:

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where  Year(Sale_date) = 2011
-187179.5349999996

select sum(Cast (amount_paid_net as double)) as revenue
from Events_Refunds
where Year(sale_in_center_date) = 2011
-786045.8403999992
-----------------------------------------------------------
Pick Random Retail (Gross Sale) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Retail
where Year(Sale_date) = 2011
4990448.381900038

select sum(net_amount) as revenue
from Events_Retail
where Year(sales_date) = 2011
4990245.6318999985
-----------------------------------------------------------
Pick Random Retail (Refund) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where Year(Sale_date) = 2011
-187179.5349999996

select sum(amount_paid_gross) as revenue
from Events_Refunds
where Year(sale_in_center_date) = 2011
-786045.8403999992
-----------------------------------------------------------
Pick Random Wax Pass Invoice event pkg_redump

select sum(revrec_value) as Revenue_Amt
from RevRec_Unlimited_Pass
where Year(Sale_date) = 2011
2781517.5099929003

select sum(netsales_price) as revenue
from Events_Package_Redemptions
where Year(sale_date) = 2011
1.4804157586739987E8
-----------------------------------------------------------
FY 2012
-----------------------------------------------------------
Pick Random Service (Gross Sale) Invoice :

select sum(revrec_value) as Revenue_Amt
from RevRec_Service
where Year(Sale_date) = 2012
6.3115201445999876E7

select sum(net_amount) as revenue
from Events_Services
where Year(sales_date) = 2012
6.310387688369996E7
-----------------------------------------------------------
Pick Random Service (Refund) Invoice:

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where  Year(Sale_date) = 2012
-330907.19979999965

select sum(Cast (amount_paid_net as double)) as revenue
from Events_Refunds
where Year(sale_in_center_date) = 2012
-1828863.679800016
-----------------------------------------------------------
Pick Random Retail (Gross Sale) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Retail
where Year(Sale_date) = 2012
1.1153120401099887E7

select sum(net_amount) as revenue
from Events_Retail
where Year(sales_date) = 2012
1.1152751041099975E7
-----------------------------------------------------------
Pick Random Retail (Refund) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where Year(Sale_date) = 2012
-330907.19979999965

select sum(amount_paid_gross) as revenue
from Events_Refunds
where Year(sale_in_center_date) = 2012
-1828863.679800016
-----------------------------------------------------------
Pick Random Wax Pass Invoice event pkg_redump

select sum(revrec_value) as Revenue_Amt
from RevRec_Unlimited_Pass
where Year(Sale_date) = 2012
8385737.479983291

select sum(netsales_price) as revenue
from Events_Package_Redemptions
where Year(sale_date) = 2012
3.945567899894004E8
-----------------------------------------------------------
FY 2013
-----------------------------------------------------------
Pick Random Service (Gross Sale) Invoice :

select sum(revrec_value) as Revenue_Amt
from RevRec_Service
where Year(Sale_date) = 2013
7.962438642269988E7

select sum(net_amount) as revenue
from Events_Services
where Year(sales_date) = 2013
7.962050168269995E7
-----------------------------------------------------------
Pick Random Service (Refund) Invoice:

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where  Year(Sale_date) = 2013
-569412.8799999931

select sum(Cast (amount_paid_net as double)) as revenue
from Events_Refunds
where Year(sale_in_center_date) = 2013
-3148850.340000022
-----------------------------------------------------------
Pick Random Retail (Gross Sale) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Retail
where Year(Sale_date) = 2013
1.7261518822899513E7

select sum(net_amount) as revenue
from Events_Retail
where Year(sales_date) = 2013
1.7261388822899997E7
-----------------------------------------------------------
Pick Random Retail (Refund) Invoice

select sum(revrec_value) as Revenue_Amt
from RevRec_Refund
where Year(Sale_date) = 2013
-569412.8799999931

select sum(amount_paid_gross) as revenue
from Events_Refunds
where Year(sale_in_center_date) = 2013
-3148850.340000022
-----------------------------------------------------------
Pick Random Wax Pass Invoice event pkg_redump

select sum(revrec_value) as Revenue_Amt
from RevRec_Unlimited_Pass
where Year(Sale_date) = 2013
1.4191619050140334E7

select sum(netsales_price) as revenue
from Events_Package_Redemptions
where Year(sale_date) = 2013
8.079735453234025E8


