WITH
	cte_pr_vy_merge AS (
		SELECT
			id,
			--COALESCE(pr.kod_sukl, vy.kod_sukl) AS kod_sukl,
			COALESCE(pr.atc_who, vy.atc_who) AS atc_who,
			COALESCE(pr.okres_kod, vy.okres_kod) AS okres_kod,
			COALESCE(pr.rok, vy.rok) AS rok,
			COALESCE(pr.mesic, vy.mesic) AS mesic,
			--
			CASE WHEN pr.atc_who IS NOT NULL THEN TRUE ELSE FALSE END AS pr_exists,
			CASE WHEN vy.atc_who IS NOT NULL THEN TRUE ELSE FALSE END AS vy_exists,
			--
			COALESCE(pr.okres_nazev, vy.okres_nazev) AS okres_nazev,
			COALESCE(pr.lek_nazev, vy.lek_nazev) AS lek_nazev,
			COALESCE(pr.mnozstvi, 0) AS pr_mnoz,
			COALESCE(vy.mnozstvi, 0) AS vy_mnoz
		FROM
			public.l2_predpisy pr
			FULL JOIN public.l2_vydeje vy
				USING (id)
	)
	,
	cte_saldo AS (
		SELECT
			*,
			pr_mnoz - vy_mnoz AS nevydane_mnoz,
			ROUND(((pr_mnoz::NUMERIC - vy_mnoz)/pr_mnoz)*100, 2) AS nevydane_mnoz_pct
		FROM
			cte_pr_vy_merge
		WHERE 1 = 1
  			AND pr_mnoz > 0 --division BY zero protection
	)
	,
	cte_saldo_pct AS (
		SELECT
			*,
			lag(nevydane_mnoz_pct) OVER (PARTITION BY atc_who, okres_kod ORDER BY rok, mesic) AS nevydane_mnoz_pct_prev,
			CASE
				WHEN nevydane_mnoz_pct <= 0 THEN -1
				WHEN nevydane_mnoz_pct <= 10 THEN 10
				WHEN nevydane_mnoz_pct <= 20 THEN 20
				WHEN nevydane_mnoz_pct <= 30 THEN 30
				WHEN nevydane_mnoz_pct <= 40 THEN 40
				WHEN nevydane_mnoz_pct <= 50 THEN 50
				ELSE 51
			END AS nevydane_mnoz_int --interval
		FROM
			cte_saldo
		WHERE 1 = 1
	)
	,
	cte_saldo_chng AS (
		SELECT
			*,
			nevydane_mnoz_pct - nevydane_mnoz_pct_prev AS nevydane_mnoz_pct_chng 
		FROM
			cte_saldo_pct
	)
SELECT *
FROM
	--cte_pr_vy_merge
	cte_saldo_chng
WHERE 1 = 1
	--AND (NOT pr_exists OR NOT vy_exists)
	/*AND pr_mnoz > 100
	AND vy_mnoz > 100
	AND pr_mnoz > vy_mnoz
	AND nevydane_mnoz_pct_prev > 0*/
	--
	--AND lek_nazev LIKE '%TRIT%'
	--
	AND atc_who = 'D07AC01'
	--AND rok = 2023
	--AND mesic = 1
	AND okres_kod = '3809'
ORDER BY
	--m.pr_mnoz DESC
	--abs(pr_mnoz - vy_mnoz) DESC
	--nevydane_mnoz_pct_chng DESC NULLS LAST
	rok,
	mesic
;

