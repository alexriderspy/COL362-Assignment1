with a as (
    select
        teamid,
        name
    from
        teams t1
    where
        yearid = (
            select
                max(yearid)
            from
                teams t2
            where
                t1.teamid = t2.teamid
        )
)
select
    distinct a.teamid,
    name as teamname,
    yearid as seasonid,
    managers.playerid as managerid,
    namefirst as managerfirstname,
    namelast as managerlastname
from
    managers,
    a,
    people
where
    a.teamid = managers.teamid
    and people.playerid = managers.playerid
    and yearid >= 2000
    and yearid <= 2010
    and (
        inseason = 0
        or inseason = 1
    )
order by
    teamid,
    teamname,
    seasonid desc,
    managerid,
    managerfirstname,
    managerlastname;