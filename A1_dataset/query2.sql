select
    distinct people.playerid,
    people.namefirst as firstname,
    (
        (2 * sum(coalesce(batting.h2b, 0))) + 3 * sum(coalesce(batting.h3b, 0)) + 4 * sum(coalesce(batting.hr, 0))
    ) as runscore
from
    batting
    join people on people.playerid = batting.playerid
group by
    people.playerid,
    people.namefirst
order by
    runscore desc,
    people.namefirst desc,
    people.playerid asc
limit
    10;