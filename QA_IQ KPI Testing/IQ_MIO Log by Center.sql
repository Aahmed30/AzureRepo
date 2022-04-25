--MIO Log by Center

Select
C1.center_id,
c2.center_name,
min(date "Center_Opendate",
max(days_since_open) as "DaysSinceOpen",
max(mio) AS "MIO"
FROM
center_MIO_By_Date c1
INNER JOIN Center_Dates c2 ON c1.center_id = c2.center_id
where
date < (date '2020-12-27')
and c2.center_terminated_date is null
group by
c1.center_id
c2.center_name
ORDER BY c1.center_id


