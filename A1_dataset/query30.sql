with recursive edges as (
    select
        distinct teamidwinner as win,
        teamidloser as loss
    from
        seriespost
    where
        yearid >= 1970
        and yearid <= 2000
),
cte as (
    select
        distinct loss as next,
        ARRAY [] :: varchar(3) [] as vis,
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
        and not (loss = any (vis))
        and depth <= 2
)
select
    coalesce (
        (select
            depth
        from
            cte
        where
            cte.next = 'DET'
            and depth = (
                select
                    max(depth)
                from
                    cte
                where
                    cte.next = 'DET'
            )
        group by
            cte.next,
            depth),
            0
    ) as cyclelength,
    coalesce(
        (select
            count(*)
        from
            cte
        where
            cte.next = 'DET'
            and depth = (
                select
                    max(depth)
                from
                    cte
                where
                    cte.next = 'DET'
            )
        group by
            cte.next,
            depth),
            0
    ) as numcycles;