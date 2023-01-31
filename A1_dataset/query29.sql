with recursive edges as (
    select
        distinct teamidwinner as win,
        teamidloser as loss
    from
        seriespost
),
a as (
    select
        teamidwinner
    from
        seriespost
    where
        ties > losses
    group by
        teamidwinner
    having
        count (distinct yearid) >= 1
),
cte as (
    select
        distinct win as start,
        loss as next,
        ARRAY [win] :: varchar(3) [] as vis,
        1 as depth
    from
        edges
    where
        win in (
            select
                *
            from
                a
        )
    union
    all
    select
        distinct start,
        loss as next,
        (vis || win) :: varchar(3) [],
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.win
        and not (edges.win = any (vis))
        and not (cte.next = 'NYA')
        --and depth <= 2
)
select
    distinct start as teamid,
    min(depth) as pathlength
from
    cte
where
    cte.next = 'NYA'
group by
    teamid
order by
    teamid,
    pathlength;