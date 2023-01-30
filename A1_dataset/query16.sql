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
    schoolid as colleges_name,
    total_awards
from
    b,
    a
where
    a.playerid = b.playerid
order by
    total_awards desc,
    colleges_name,
    a.playerid;