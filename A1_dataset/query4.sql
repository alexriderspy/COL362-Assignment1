select
    people.playerid,
    people.namefirst as firstname,
    people.namelast as lastname,
    avg(h / ab) as career_batting_average
from
    batting
    join people on people.playerid = batting.playerid
    join (
        select
            people.playerid,
            count(people.playerid) as cnt
        from
            batting
            join people on people.playerid = batting.playerid
        where
            h is not null
            and ab is not null
        group by
            people.playerid
    ) as t on t.playerid = people.playerid
where
    h is not null
    and ab is not null
    and ab > 0
    and t.cnt >= 10
group by
    people.playerid,
    firstname,
    lastname
order by
    career_batting_average desc,
    people.playerid asc,
    firstname asc,
    lastname asc
limit
    10;