--================
-- l2_predpisy
--================

DROP TABLE IF EXISTS public.l2_predpisy;

CREATE TABLE IF NOT EXISTS public.l2_predpisy
AS
SELECT
	/*format('%s_%s_%s_%s', kod_sukl, okres_kod, rok, mesic) AS id,
	kod_sukl, okres_kod, rok, mesic,*/
	format('%s_%s_%s_%s', atc_who, okres_kod, rok, mesic) AS id,
	atc_who, okres_kod, rok, mesic,
	--
	max(okres_nazev) AS okres_nazev,
	string_agg(DISTINCT nazev, ';') AS lek_nazev,
	--
	sum(pr.mnozstvi) AS mnozstvi,
	COUNT(*) as gr_rows_cnt,
	clock_timestamp() AS ins_dt
FROM
	public.predpisy_vw pr
GROUP BY
	--kod_sukl, okres_kod, rok, mesic
	atc_who, okres_kod, rok, mesic
;

--DROP INDEX l2_predpisy_pk;
CREATE UNIQUE INDEX l2_predpisy_pk ON public.l2_predpisy(id);

SELECT *
FROM
	public.l2_predpisy pr
WHERE 1 = 1
	--AND pr.id = '0216963_3100_2022_7'
	AND mnozstvi = 0
;

SELECT
	id,
    --
	COUNT(*) AS cnt,
	SUM(COUNT(*)) OVER () AS cnt_all,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS cnt_pct
FROM
	public.l2_predpisy
GROUP BY
	id
HAVING
	COUNT(*) > 1
ORDER BY
	cnt DESC
;

--================
-- l2_vydeje
--================

DROP TABLE IF EXISTS public.l2_vydeje;

CREATE TABLE IF NOT EXISTS public.l2_vydeje
AS
SELECT
	/*format('%s_%s_%s_%s', kod_sukl, okres_kod, rok, mesic) AS id,
	kod_sukl, okres_kod, rok, mesic,*/
	format('%s_%s_%s_%s', atc_who, okres_kod, rok, mesic) AS id,
	atc_who, okres_kod, rok, mesic,
	--
	max(okres_nazev) AS okres_nazev,
	string_agg(DISTINCT nazev, ';') AS lek_nazev,
	--
	sum(pr.mnozstvi) AS mnozstvi,
	COUNT(*) as gr_rows_cnt,
	clock_timestamp() AS ins_dt
FROM
	public.vydeje_vw pr
GROUP BY
	--kod_sukl, okres_kod, rok, mesic
	atc_who, okres_kod, rok, mesic
;

--DROP INDEX l2_predpisy_pk;
CREATE UNIQUE INDEX l2_vydeje_pk ON public.l2_vydeje(id);

SELECT *
FROM
	public.l2_vydeje pr
WHERE 1 = 1
	--AND pr.id = '0216963_3100_2022_7'
;

SELECT
	id,
    --
	COUNT(*) AS cnt,
	SUM(COUNT(*)) OVER () AS cnt_all,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS cnt_pct
FROM
	public.l2_vydeje
GROUP BY
	id
HAVING
	COUNT(*) > 1
ORDER BY
	cnt DESC
;