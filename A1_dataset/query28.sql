with recursive edges as (
    select
        distinct teamidwinner as win,
        teamidloser as loss
    from
        seriespost
),
cte as (
    select
        distinct loss as next,
        ARRAY [win] :: varchar(3) [] as vis,
        1 as depth
    from
        edges
    where
        win = 'WS1'
    union
    all
    select
        distinct loss as next,
        (vis || win) :: varchar(3) [],
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.win
        and not (loss = any (vis))
        and depth <= 2
),
a as (
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
    distinct cte.next as teamid,
    name as teamname,
    depth as pathlength
from
    cte,
    a
where
    a.teamid = cte.next
    and depth = (
        select
            max(depth)
        from
            cte
    )
order by
    teamid,
    teamname;