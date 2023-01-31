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
        1 as depth
    from
        edges
    where
        win = 'ARI'
    union
    all
    select
        distinct loss as next,
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.win
        and cte.next != 'DET'
        and depth <= 2*(
            select
                count(*)
            from
                edges
        ) --and depth <= 2
)
--select * from cte;
select
    count(*) as count
from
    cte
where
    cte.next = 'DET';