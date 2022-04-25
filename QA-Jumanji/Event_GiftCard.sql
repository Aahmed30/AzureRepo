--EVentGiftCard Quantity 
--Amperity This query will work with Q1 and Q2

select zc.centercode, count(current_giftcard_wid) as GiftCardCount
from events_giftcards pp
JOIN Zenoti_bidimcenter zc ON zc.centerwid = pp.center_id
AND pp.SOURCE_ID = 2
where purchase_date >= (date '2021-01-01') 
and purchase_date < (date '2021-07-01')
and gc_type = 'Sales'
group by zc.centercode
order by zc.centercode


--Zenoti Query
--This query will work with Q1 & Q2 Data

select  bd.centercode, sum("quantity sold") as "qty"
from sales_fact_consolidated sfc 
inner join bi_dimcenter bd 
on sfc."center wid" = bd.centerwid
where "invoice date in center"  >= '1/1/2021'
and "invoice date in center" < '7/1/2021'
and "item type code" = 'Gift Card'
group by bd.centercode
order by bd.centercode

-- EventGiftCard Amount
-- Amperity This will work for Q1 & Q2

select zc.centercode, sum(cast(purchase_amount as decimal(12,2))) as GiftCardAmount
from events_giftcards pp
JOIN Zenoti_bidimcenter zc ON zc.centerwid = pp.center_id
AND pp.SOURCE_ID = 2
where purchase_date >= (date '2021-01-01') 
and purchase_date < (date '2021-07-01')
and gc_type = 'Sales'
group by zc.centercode
order by zc.centercode

--Zenoti Query
--This query will work with Q1 & Q2 Data

select  bd.centercode, sum("giftcard purchase price") as "giftcardamount"
from sales_fact_consolidated sfc 
inner join bi_dimcenter bd 
on sfc."center wid" = bd.centerwid
where "invoice date in center"  >= '1/1/2021'
and "invoice date in center" < '7/1/2021'
and "item type code" = 'Gift Card'
group by bd.centercode
order by bd.centercode


--Millennium GiftCard Quantity
--Amperity Query

select REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '') as centercode, 
count(gift_card_event_id) as GiftCardCount
from events_giftcards pp
INNER JOIN millennium_locations zc ON zc.ilocationid = pp.center_id 
AND pp.SOURCE_ID = 1
where purchase_date >= (date '2019-01-01') 
and purchase_date < (date '2020-01-01')
and gc_type = 'Sales'
and TRIM(cstorename) != 'Guest Services Location'
group by REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')
order by REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')

--Millennium Query

SELECT REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') as centercode, 
count(g.iheaderid) as GiftCardQuantity
FROM transHead th JOIN  trangift g on g.iheaderid = th.iid  and th.ilocationid = g.ilocationid 
inner join locations lo on lo.ilocationid = g.ILOCATIONID
WHERE th.TDATETIME >= '1/1/2019' AND
th.TDATETIME < '1/1/2020' AND LVOID = 0  
and LOFFSITEGC = 0
GROUP BY REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') 
ORDER BY REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') 

--Millennium GiftCard Amount
--Amperity Query

select REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '') as centercode, 
sum(cast(purchase_amount as decimal(15,2))) as giftcardamount, 
sum(cast(tip_amount as decimal(15,2))) as tipamount
from events_giftcards pp
INNER JOIN millennium_locations zc ON zc.ilocationid = pp.center_id 
AND pp.SOURCE_ID = 1
where purchase_date >= (date '2019-01-01') 
and purchase_date < (date '2020-01-01')
and gc_type = 'Sales'
and TRIM(cstorename) != 'Guest Services Location'
group by REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')
order by REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')

--Millennium Query

SELECT REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') as centercode, 
sum(nprice) as giftcardamount, sum(ntip) as giftcardtip
FROM transHead th JOIN  trangift g on g.iheaderid = th.iid  and th.ilocationid = g.ilocationid 
inner join locations lo on lo.ilocationid = g.ILOCATIONID
WHERE th.TDATETIME >= '1/1/2019' AND
th.TDATETIME < '1/1/2020' AND LVOID = 0  
and LOFFSITEGC = 0
GROUP BY REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') 
ORDER BY REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') 


--Cross Period GiftCard Quantity
--Amperity Query

with giftcard as 
(
 select 'Millennium' as source, REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '') as centercode, 
count(gift_card_event_id) as GiftCardCount
from events_giftcards pp
INNER JOIN millennium_locations zc ON zc.ilocationid = pp.center_id 
AND pp.SOURCE_ID = 1
where purchase_date >= (date '2020-01-01') 
and purchase_date < (date '2021-01-01')
and gc_type = 'Sales'
and TRIM(cstorename) != 'Guest Services Location'
group by REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')
Union all
  select 'Zenoti' as source, zc.centercode as centercode, count(current_giftcard_wid) as GiftCardCount
from events_giftcards pp
JOIN Zenoti_bidimcenter zc ON zc.centerwid = pp.center_id
AND pp.SOURCE_ID = 2
where purchase_date >= (date '2020-01-01') 
and purchase_date < (date '2021-01-01')
and gc_type = 'Sales'
group by zc.centercode
)
select source, centercode, giftcardcount
from giftcard
order by source, centercode

--Millennium Query

SELECT 'Millennium' as Source, REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') as centercode, 
count(g.iheaderid) as GiftCardQuantity
FROM transHead th JOIN  trangift g on g.iheaderid = th.iid  and th.ilocationid = g.ilocationid 
inner join locations lo on lo.ilocationid = g.ILOCATIONID
WHERE th.TDATETIME >= '1/1/2020' AND
th.TDATETIME < '1/1/2021' AND LVOID = 0  
and LOFFSITEGC = 0
GROUP BY REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') 
ORDER BY REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') 

--Zenoti Query

select 'Zenoti' as source, bd.centercode, sum("quantity sold") as "qty"
from sales_fact_consolidated sfc 
inner join bi_dimcenter bd 
on sfc."center wid" = bd.centerwid
where "invoice date in center"  >= '1/1/2020'
and "invoice date in center" < '1/1/2021'
and "item type code" = 'Gift Card'
and "invoice date in center" >= bd.centergolivedate 
group by bd.centercode
order by bd.centercode


--Cross Period GiftCard Amount
--Amperity Query

with giftcard as 
(
 select 'Millennium' as source, REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '') as centercode, 
sum(cast(purchase_amount as decimal(15,2))) as giftcardamount, 
sum(cast(tip_amount as decimal(15,2))) as tipamount
from events_giftcards pp
INNER JOIN millennium_locations zc ON zc.ilocationid = pp.center_id 
AND pp.SOURCE_ID = 1
where purchase_date >= (date '2020-01-01') 
and purchase_date < (date '2021-01-01')
and gc_type = 'Sales'
and TRIM(cstorename) != 'Guest Services Location'
group by REPLACE(SPLIT(REPLACE(cstorename, 'EWC - ', ''), '(')[2], ')', '')
Union all
select 'Zenoti' as source, zc.centercode as centercode, sum(cast(purchase_amount as decimal(12,2))) as GiftCardAmount,
0 as tipamount
from events_giftcards pp
JOIN Zenoti_bidimcenter zc ON zc.centerwid = pp.center_id
AND pp.SOURCE_ID = 2
where purchase_date >= (date '2020-01-01') 
and purchase_date < (date '2021-01-01')
and gc_type = 'Sales'
group by zc.centercode
)
select source, centercode, GiftCardAmount, tipamount
from giftcard
order by source, centercode


--Millennium Query

SELECT 'Millennium' as Source, REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') as centercode, 
sum(nprice) as giftcardamount, sum(ntip) as giftcardtip
FROM transHead th JOIN  trangift g on g.iheaderid = th.iid  and th.ilocationid = g.ilocationid 
inner join locations lo on lo.ilocationid = g.ILOCATIONID
WHERE th.TDATETIME >= '1/1/2020' AND
th.TDATETIME < '1/1/2021' AND LVOID = 0  
and LOFFSITEGC = 0
GROUP BY REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') 
ORDER BY REPLACE(RIGHT(LTRIM(RTRIM(lo.cstorename)), 5), ')', '') 

--Zenoti Query

select 'Zenoti' as source, bd.centercode, sum("giftcard purchase price") as "giftcardamount",
0 as giftcardtip
from sales_fact_consolidated sfc 
inner join bi_dimcenter bd 
on sfc."center wid" = bd.centerwid
where "invoice date in center"  >= '1/1/2020'
and "invoice date in center" < '1/1/2021'
and "item type code" = 'Gift Card'
and "invoice date in center" >= bd.centergolivedate 
group by bd.centercode
order by bd.centercode



