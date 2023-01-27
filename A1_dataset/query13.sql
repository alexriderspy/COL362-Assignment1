with a as (
    select
        playerid,
        count(distinct name) as cnt
    from
        pitching
        join teams on teams.teamid = pitching.teamid
        and teams.yearid = pitching.yearid
    group by
        playerid
),
b as (
    select
        pitching.playerid,
        yearid,
        name
    from
        a
        join pitching on pitching.playerid = a.playerid
        join teams on teams.teamid = pitching.teamid
        and teams.yearid = pitching.yearid
    where cnt >= 5
    order by
        yearid asc
)
select
    people.playerid,
    namefirst as firstname,
    namelast as lastname,
    birthcity || ' ' || birthstate || ' ' || birthcountry as birth_address
from
    a
    join people on people.playerid = a.playerid
where
    cnt >= 5;