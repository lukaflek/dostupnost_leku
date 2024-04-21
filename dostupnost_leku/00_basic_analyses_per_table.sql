DROP DATABASE dostlek;
CREATE DATABASE dostlek WITH OWNER dba;

--očekávání: jaký existují druhy výpadků
-- - globální
-- - lokální

SELECT 'public.lecivepripravky' AS tbl_name, count(*) AS cnt FROM public.lecivepripravky union all
SELECT 'public.mr_hlaseni' AS tbl_name, count(*) AS cnt FROM public.mr_hlaseni union all
SELECT 'public.okresy' AS tbl_name, count(*) AS cnt FROM public.okresy union all
SELECT 'public.predpisy' AS tbl_name, count(*) AS cnt FROM public.predpisy union all
SELECT 'public.vydeje' AS tbl_name, count(*) AS cnt FROM public.vydeje;

--================
-- lecivepripravky
--================

--atc_who: skupina léků se stejnou aktivní látkou
--forma: mast, gel, tableta (např.) lék se může jmenovat stejně (ASENTRA)
--sdov: souběžný dovoz: 
--atc_who = 'N07CA01'
SELECT * FROM public.lecivepripravky;

SELECT * FROM public.lecivepripravky lp
WHERE 1 = 1
	--AND lower(lp.nazev) LIKE lower('%BETAHISTIN RATIOPHARM%')
	--AND lp.atc_who = 'N07CA01'
	--AND lp.nazev = 'TRITTICO AC'
	AND lower(lp.nazev) LIKE lower('%Victo%')	
;

SELECT
	p.reg,
    --
	COUNT(*) AS cnt,
	SUM(COUNT(*)) OVER () AS cnt_all,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS cnt_pct
FROM
	public.lecivepripravky p
GROUP BY
	p.reg
ORDER BY
	cnt DESC
;

--================
-- mr_hlaseni
--================

--mr: market report
--suklu poskytuje registátor léku (firma, která zastupuje výrobce)
--jak moc info o preruseni/obnovení koreluje s reálnym výdejem léků
SELECT * FROM public.mr_hlaseni;

SELECT * FROM public.mr_hlaseni h WHERE h.duvod_preruseni_ukonceni IS NOT NULL AND h.duvod_preruseni_ukonceni != '';

SELECT
	h.duvod_preruseni_ukonceni,
    --
	COUNT(*) AS cnt,
	SUM(COUNT(*)) OVER () AS cnt_all,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS cnt_pct
FROM
	public.mr_hlaseni h
WHERE 1 = 1
	AND h.typ_oznameni IN ('ukonceni', 'preruseni')
GROUP BY
	h.duvod_preruseni_ukonceni
ORDER BY
	cnt DESC
;

--================
-- predpisy
--================

--předepsaný léky agregovaný po kód sukl/rok/měsíc/okres
SELECT * FROM public.predpisy;

SELECT
	kod_sukl, okres_kod, rok, mesic,
    --
	COUNT(*) AS cnt,
	SUM(COUNT(*)) OVER () AS cnt_all,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS cnt_pct
FROM
	public.predpisy pr
GROUP BY
	kod_sukl, okres_kod, rok, mesic
HAVING
	COUNT(*) > 1
ORDER BY
	cnt DESC
;

SELECT
	pr.*
	lp.atc_who
FROM
	public.predpisy pr
	LEFT JOIN public.lecivepripravky lp
		ON (lp.kod_sukl = pr.kod_sukl)
;

--================
-- vydeje
--================

SELECT * FROM public.vydeje;

SELECT
	kod_sukl, okres_kod, rok, mesic,
    --
	COUNT(*) AS cnt,
	SUM(COUNT(*)) OVER () AS cnt_all,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS cnt_pct
FROM
	public.vydeje v
GROUP BY
	kod_sukl, okres_kod, rok, mesic
HAVING
	COUNT(*) > 1
ORDER BY
	cnt DESC
;

--================
-- okresy
--================

SELECT * FROM public.okresy;

SELECT
	*
FROM
	public.okresy o
WHERE 1 = 1
	AND o.okres_kod = '3100'
;

SELECT
	o.okres_kod,
    --
	COUNT(*) AS cnt,
	SUM(COUNT(*)) OVER () AS cnt_all,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS cnt_pct
FROM
	public.okresy o
GROUP BY
	o.okres_kod
ORDER BY
	cnt DESC
;
