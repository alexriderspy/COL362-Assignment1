with recursive a as (
    select
        distinct playerid,
        yearid,
        teamid
    from
        pitching
    union
    (
        select
            distinct playerid,
            yearid,
            teamid
        from
            allstarfull
        where
            gp = 1
    )
),
b as (
    select
        a1.playerid as p1_id,
        a2.playerid as p2_id,
        a1.teamid,
        a1.yearid
    from
        a a1
        join a a2 on a1.teamid = a2.teamid
        and a1.yearid = a2.yearid
        and a1.playerid != a2.playerid
),
edges as (
    select
        p1_id,
        p2_id,
        count(*) as cnt
    from
        b
    group by
        p1_id,
        p2_id
    having
        count(*) > 0
    order by
        p1_id,
        p2_id
),
cte as (
    select
        distinct p2_id as next,
        ARRAY [p1_id] :: varchar(10) [] as vis,
        cnt as len,
        1 as depth
    from
        edges
    where
        p1_id = 'garcifr02'
    union
    all
    select
        distinct p2_id,
        (vis || p1_id) :: varchar(10) [],
        (cnt + len),
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.p1_id
        and not (edges.p2_id = any (vis))
        and cte.next != 'leagubr01' 
        --and (cnt+len) <= 3
)
select
    coalesce(
        (
            select
                min(len)
            from
                cte
            where
                cte.next = 'leagubr01'
        ),
        0
    ) as pathlength;