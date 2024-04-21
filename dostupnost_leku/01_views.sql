--================
-- predpisy
--================

DROP VIEW IF EXISTS public.predpisy_vw;

CREATE OR REPLACE VIEW public.predpisy_vw
AS
SELECT
	pr.kod_sukl,
	pr.okres_kod,
	okr.okres_nazev,
	pr.rok,
	pr.mesic,
	pr.mnozstvi,
	--
	--lp.kod_sukl,
	lp.h,
	lp.nazev,
	lp.sila,
	lp.forma,
	lp.baleni,
	lp.cesta,
	lp.doplnek,
	lp.obal,
	lp.drz,
	lp.zemdrz,
	lp.akt_drz,
	lp.akt_zem,
	lp.reg,
	lp.v_platdo,
	lp.neomez,
	lp.uvadenido,
	lp.is_,
	lp.atc_who,
	lp.rc,
	lp.sdov
FROM
	public.predpisy pr
	LEFT JOIN public.lecivepripravky lp
		ON (lp.kod_sukl = pr.kod_sukl)
	LEFT JOIN public.okresy okr
		ON (okr.okres_kod = pr.okres_kod)
WHERE 1 = 1
	--AND lp.nazev = 'TRITTICO AC'
;

SELECT *
FROM
	public.predpisy_vw
;

SELECT
	pr.kod_sukl, pr.okres_kod, pr.rok, pr.mesic,
    --
	COUNT(*) AS cnt,
	SUM(COUNT(*)) OVER () AS cnt_all,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS cnt_pct
FROM
	public.predpisy_vw pr
GROUP BY
	pr.kod_sukl, pr.okres_kod, pr.rok, pr.mesic
ORDER BY
	cnt DESC
;

--================
-- vydeje
--================

DROP VIEW IF EXISTS public.vydeje_vw;

CREATE OR REPLACE VIEW public.vydeje_vw
AS
SELECT
	vy.kod_sukl,
	vy.okres_kod,
	okr.okres_nazev,
	vy.rok,
	vy.mesic,
	vy.mnozstvi,
	--
	--lp.kod_sukl,
	lp.h,
	lp.nazev,
	lp.sila,
	lp.forma,
	lp.baleni,
	lp.cesta,
	lp.doplnek,
	lp.obal,
	lp.drz,
	lp.zemdrz,
	lp.akt_drz,
	lp.akt_zem,
	lp.reg,
	lp.v_platdo,
	lp.neomez,
	lp.uvadenido,
	lp.is_,
	lp.atc_who,
	lp.rc,
	lp.sdov
FROM
	public.vydeje vy
	LEFT JOIN public.lecivepripravky lp
		ON (lp.kod_sukl = vy.kod_sukl)
	LEFT JOIN public.okresy okr
		ON (okr.okres_kod = vy.okres_kod)
WHERE 1 = 1
	--AND lp.nazev = 'TRITTICO AC'
;

SELECT *
FROM
	public.vydeje_vw
;

SELECT
	vy.kod_sukl, vy.okres_kod, vy.rok, vy.mesic,
    --
	COUNT(*) AS cnt,
	SUM(COUNT(*)) OVER () AS cnt_all,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1) AS cnt_pct
FROM
	public.vydeje_vw vy
GROUP BY
	vy.kod_sukl, vy.okres_kod, vy.rok, vy.mesic
ORDER BY
	cnt DESC
;