with a as (
    select
        playerid,
        count(distinct category) as num_honored_categories
    from
        halloffame
    group by
        playerid
    having
        count(distinct category) >= 2
)
select
    distinct a1.playerid,
    namefirst as firstname,
    namelast as lastname,
    num_honored_categories,
    yearid as seasonid
from
    allstarfull a1,
    people,
    a
where
    a1.playerid = people.playerid
    and a1.playerid = a.playerid
    and yearid = (
        select
            min(yearid)
        from
            allstarfull a2
        where
            a2.gp = 1
            and a1.playerid = a2.playerid
    )
    and a1.gp = 1
order by
    num_honored_categories desc,
    a1.playerid,
    firstname,
    lastname,
    seasonid;