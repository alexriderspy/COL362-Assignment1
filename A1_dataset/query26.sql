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
        ARRAY [win] :: varchar(3)[] as vis,
        1 as depth
    from
        edges
    where
        win = 'ARI'
    union
    all
    select
        distinct loss as next,
        (vis || win) :: varchar(3)[],
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.win
        and not (edges.win = any (vis))
        and cte.next != 'DET' --and depth <= 2
)
select count(*) as count from cte where cte.next = 'DET';