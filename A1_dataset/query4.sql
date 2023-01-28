with b as (
    select
        playerid,
        yearid,
        sum(ab) as at_bats
    from
        batting
    where
        ab is not null
    group by
        playerid,
        yearid
),
a as (
    select
        batting.playerid,
        batting.yearid,
        sum(h) * 1.0 / sum(ab) * 1.0 as batting_average
    from
        batting
        join b on b.playerid = batting.playerid
        and b.yearid = batting.yearid
    where
        h is not null
        and ab is not null
        and at_bats > 0
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
    join (
        select
            playerid,
            count(distinct yearid) as cnt
        from
            batting
        where
            h is not null
            and ab is not null
        group by
            playerid
    ) as t on t.playerid = people.playerid
where
    t.cnt >= 10
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