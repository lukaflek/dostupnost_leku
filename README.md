# 00_basic_analyses_per_table.sql
* základní analýzy zdrojových tabulek
* "l1" vrstvva
# 01_views.sql
* připraví views, které sjedocují data z různých l1 tabulek
# 02_l2_generate.sql
* l2 vrstva (tabulky, které vychází z l1, ale mají strukturu vhodnější pro různé analýzy)
* l2 tabulky jsou materializované na základě l1 tabulek/views a oindexované
# 10_analyses.sql
* analýzy na základě l2 tabulek
