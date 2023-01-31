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
        win = 'DET'
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
        and not (edges.win = any (vis))
        and 
        --and depth <= 2
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