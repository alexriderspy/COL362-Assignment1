with a as (
    select
        batting.playerid,
        batting.yearid,
        sum(h) * 1.0 / sum(ab) * 1.0 as batting_average
    from
        batting
    where
        h>=0
        and ab>0
    group by
        batting.playerid,
        batting.yearid
)
select
    distinct people.playerid,
    people.namefirst as firstname,
    people.namelast as lastname,
    avg(batting_average) as career_batting_average
from
    a
    join people on people.playerid = a.playerid
group by
    people.playerid,
    firstname,
    lastname
having count(distinct yearid) >= 10
order by
    career_batting_average desc,
    people.playerid asc,
    firstname asc,
    lastname asc
limit
    10;