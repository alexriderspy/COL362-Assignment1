with a as (
    select
        schoolid,
        playerid
    from
        collegeplaying c1
    where
        yearid = (
            select
                max(yearid)
            from
                collegeplaying c2
            where
                c1.playerid = c2.playerid
        )
),
b as (
    select
        playerid,
        count(*) as total_awards
    from
        awardsplayers
    group by
        playerid
)
select
    b.playerid,
    schoolname as colleges_name,
    total_awards
from
    b
    left outer join a on a.playerid = b.playerid
    left outer join schools on a.schoolid = schools.schoolid
order by
    total_awards desc,
    colleges_name,
    b.playerid
limit
    10;