with a as (
    select
        awardid,
        playerid,
        count(*) as cnt
    from
        awardsplayers
    group by
        awardid,
        playerid
),
b as (
    select
        *
    from
        a a1
    where
        cnt = (
            select
                max(cnt)
            from
                a a2
            where
                a2.awardid = a1.awardid
        )
)
select
    awardid,
    b1.playerid,
    namefirst as firstname,
    namelast as lastname,
    cnt as num_wins
from
    b b1
    join people on people.playerid = b1.playerid
where
    b1.playerid = (
        select
            min(playerid)
        from
            b b2
        where
            b1.awardid = b2.awardid
    )
order by
    awardid asc,
    num_wins desc;