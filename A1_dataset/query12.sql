select
    distinct people.playerid,
    namefirst as firstname,
    namelast as lastname,
    sum (sv) as career_saves,
    t.num_seasons
from
    pitching
    join people on people.playerid = pitching.playerid
    join (
        select
            playerid,
            count(distinct yearid) as num_seasons
        from
            pitching
        group by
            playerid
    ) as t on t.playerid = people.playerid
where
    t.num_seasons >= 15
group by
    people.playerid,
    firstname,
    lastname,
    t.num_seasons
order by
    career_saves desc,
    t.num_seasons desc,
    people.playerid desc,
    firstname asc,
    lastname asc
limit
    10;