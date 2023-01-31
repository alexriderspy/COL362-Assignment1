select
    people.playerid,
    people.namefirst as firstname,
    people.namelast as lastname,
    sum(cs) as total_caught_stealing
from
    batting
    join people on people.playerid = batting.playerid
where
    cs is not null
group by
    people.playerid,
    people.namefirst,
    people.namelast
order by
    total_caught_stealing desc,
    people.namefirst asc,
    people.namelast asc,
    people.playerid asc
limit
    10;