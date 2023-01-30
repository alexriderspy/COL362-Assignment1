select
    a.playerid,
    namefirst as firstname,
    namelast as lastname,
    sum(g_all) as G_all,
    sum(g_1b) as G_1b,
    sum(g_2b) as G_2b,
    sum(g_3b) as G_3b
from
    appearances a,
    people
where
    people.playerid = a.playerid
group by
    a.playerid,
    firstname,
    lastname
having
    (
        sum(g_2b) > 0
        and sum(g_3b) > 0
    )
    or (
        sum(g_1b) > 0
        and sum(g_2b) > 0
    )
    or (
        sum(g_1b) > 0
        and sum(g_3b) > 0
    )
order by
    g_all desc,
    a.playerid,
    firstname,
    lastname,
    g_1b desc,
    g_2b desc,
    g_3b desc;