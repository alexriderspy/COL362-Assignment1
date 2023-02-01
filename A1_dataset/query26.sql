with recursive edges as (
    select
        distinct teamidwinner as win,
        teamidloser as loss
    from
        seriespost
    where yearid >= 1990 and yearid <=2010
),
cte as (
    select
        distinct loss as next,
        ARRAY [win] :: varchar(3) [] as vis,
        1 as depth
    from
        edges
    where
        win = 'ARI'
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
        and cte.next != 'DET'
)
--select * from cte;
select
    count(*) as count
from
    cte
where
    cte.next = 'DET';