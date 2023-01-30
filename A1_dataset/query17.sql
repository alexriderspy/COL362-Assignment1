with a as (
    select
        ap.playerid
    from
        awardsmanagers am,
        awardsplayers ap
    where
        am.playerid = ap.playerid
),
b as (
    select
        distinct a.playerid,
        awardid,
        yearid
    from
        awardsplayers ap,
        a
    where
        a.playerid = ap.playerid
        and yearid = (
            select
                min(yearid)
            from
                awardsplayers ap2
            where
                ap.playerid = ap2.playerid
        )
        and awardid = (
            select
                min(awardid)
            from
                awardsplayers ap2
            where
                ap.playerid = ap2.playerid
                and ap.yearid = ap2.yearid
        )
    order by
        a.playerid
),
c as (
    select
        distinct a.playerid,
        awardid,
        yearid
    from
        awardsmanagers ap,
        a
    where
        a.playerid = ap.playerid
        and yearid = (
            select
                min(yearid)
            from
                awardsmanagers ap2
            where
                ap.playerid = ap2.playerid
        )
        and awardid = (
            select
                min(awardid)
            from
                awardsmanagers ap2
            where
                ap.playerid = ap2.playerid
                and ap.yearid = ap2.yearid
        )
    order by
        a.playerid
)
select
    b.playerid,
    namefirst as firstname,
    namelast as lastname,
    b.awardid as playerawardid,
    b.yearid as playerawardyear,
    c.awardid as managerawardid,
    c.yearid as managerawardyear
from
    b,
    c,
    people
where
    b.playerid = c.playerid
    and b.playerid = people.playerid
order by
    b.playerid,
    firstname,
    lastname;