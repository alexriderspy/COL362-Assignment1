with recursive edges as (
    select
        distinct teamidwinner as win,
        teamidloser as loss
    from
        seriespost
),
cte as (
    select
        loss as next,
        ARRAY [win] :: varchar(3) [] as vis,
        1 as depth
    from
        edges
    where
        win = 'HOU'
    union
    all
    select
        loss as next,
        (vis || win) :: varchar(3) [],
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.win
        and not (edges.win = any (vis))
        and depth <= 2
) --select * from cte order by next;
select
    distinct next as teamid,
    depth as num_hops
from
    cte c1
where
    depth = (
        select
            max(depth)
        from
            cte c2
        where
            c1.next = c2.next
    )
    and c1.next != 'HOU'
order by
    teamid;