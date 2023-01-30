with a as (
    select
        distinct playerid,
        namefirst || ' ' || namelast as playername
    from
        people
    where
        deathday is null
        and deathyear is null
        and deathmonth is null
),
b as (
    select
        distinct playerid,
        namefirst || ' ' || namelast as playername
    from
        people
    where
        deathday is not null
        or deathyear is not null
        or deathmonth is not null
),
c as (
    select
        *
    from
        awardsplayers
    union
    select
        *
    from
        awardsmanagers
)
select
*
from
    a
    left outer join c on a.playerid = c.playerid
where
    c.awardid is null
;