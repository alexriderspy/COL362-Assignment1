with a as (
    select
        distinct ap.playerid
    from
        awardsmanagers am,
        awardsplayers ap
    where
        ap.playerid = am.playerid
),
b1 as (
    select
        distinct awardid,
        min(yearid) as yr,
        a.playerid
    from
        awardsmanagers,
        a
    where
        a.playerid = awardsmanagers.playerid
    group by
        awardid,
        a.playerid
),
c1 as (
    select
        distinct playerid,
        min(awardid) as id,
        yr
    from
        b1
    group by
        playerid,
        yr
),
b2 as (
    select
        distinct a.playerid,
        awardid,
        min(yearid) as yr
    from
        awardsplayers,
        a
    where
        a.playerid = awardsplayers.playerid
    group by
        awardid,
        a.playerid
),
c2 as (
    select
        distinct playerid,
        min(awardid) as id,
        yr
    from
        b2
    group by
        playerid,
        yr
)
select
    distinct c1.playerid,
    namefirst as firstname,
    namelast as lastname,
    c2.id as playerawardid,
    c2.yr as playerawardyear,
    c1.id as managerawardid,
    c1.yr as managerswardyear
from
    c1,
    c2,
    people
where
    c1.playerid = c2.playerid
    and people.playerid = c1.playerid
order by
    c1.playerid,
    firstname,
    lastname;