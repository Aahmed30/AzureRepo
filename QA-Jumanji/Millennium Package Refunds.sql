/* Millennium Package Refunds */
SELECT count(1) -- simple count 
--count(distinct  t.iid ,t.ilocationid, pk.ipkgid) -- distinct pkgdetail refundpkg record 
FROM transhead t
INNER JOIN refundpkg pk ON t.iid = pk.IHEADERID
	AND pk.ILOCATIONID = t.ILOCATIONID
INNER JOIN locations l ON t.ilocationid = l.ilocationid
INNER JOIN packagedetail p2 ON pk.IPKGID = p2.IID
	AND p2.ILOCATIONID = pk.ILOCATIONID
INNER JOIN package p ON p.iid = p2.iparentpkgid
	AND p2.ilocationid = p.ilocationid
LEFT OUTER JOIN servicepackages s ON s.iid = p.ipackageid
	AND p.ilocationid = s.ilocationid
--get for all time 
-- where pk.ipkgid > 0 
-- and pk.IORIGINLOCID = 0  
-- and  p.ipackageid <> 0 
-- and t.lvoid = 0     
-- and year(t.tdatetime)>= 2010   
--current unlimited logic 
--where (pk.ipkgid > 0 
--and pk.IORIGINLOCID = 0  
--and  p.ipackageid <> 0 
--and t.lvoid = 0  
--and year(t.tdatetime)>= 2010 
--and (lower(s.cpackagename) like '%unlimited%' 
--or lower(s.cpackagename)  like '%super%')) 
--new unlimited logic 
WHERE (
		pk.ipkgid > 0
		AND pk.IORIGINLOCID = 0
		AND p.ipackageid <> 0
		AND t.lvoid = 0
		AND year(t.tdatetime) >= 2010
		AND (lower(s.cpackagename) LIKE '%unlimited%')
		)
	--current prepaid logic 
	--  where (pk.ipkgid > 0 
	--  and pk.IORIGINLOCID = 0  
	--  and  p.ipackageid <> 0 
	--  and t.lvoid::boolean = False      
	--  and year(t.tdatetime)>= 2010 
	--  and (lower(s.cpackagename) not like '%unlimited%' 
	--  and lower(s.cpackagename) not like '%super%'))  
	--new prepadi logic 
	--where (pk.ipkgid > 0 
	--and pk.IORIGINLOCID = 0  
	--and  p.ipackageid <> 0 
	--and t.lvoid = 0  
	--and year(t.tdatetime)>= 2010 
	--and (lower(s.cpackagename) not like '%unlimited%' or s.iid is null)) 