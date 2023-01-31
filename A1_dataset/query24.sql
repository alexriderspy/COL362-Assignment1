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
    having count(*) > 0
    order by
        p1_id,
        p2_id
),
cte as (
    select
        p2_id as next,
        --ARRAY [p1_id]::varchar(10)[] as vis,
        cnt as len,
        1 as depth
    from
        edges
    where
        p1_id = 'webbbr01'
    union
    all
    select
        case when p2_id = 'clemero02' and len >= 3 then NULL else  
        p2_id end,
        case when p2_id = 'clemero02' and len >= 3 then NULL else  
        
        (cnt + len) end,
        case when p2_id = 'clemero02' and len >= 3 then NULL else  
        
        (depth + 1) end
    from
        edges,
        cte
    where
        cte.next = edges.p1_id
        --and depth <= 2
)
-- select * from edges where (p1_id = 'webbbr01' and p2_id = 'choatra01') or (p1_id = 'choatra01' and p2_id = 'almanca01') or (p1_id = 'webbbr01' and p2_id = 'choatra01') or (p1_id = 'almanca01' and p2_id = 'choatra01') or (p1_id = 'choatra01' and p2_id = 'clemero02');
-- select
--     *
-- from
--     cte
-- where cte.next = 'clemero02';
select True as pathexists from cte where cte.next = 'clemero02' and cte.len>=3 group by cte.next having count(*) >=1 
union
select False as pathexists from cte where cte.next = 'clemero02' and cte.len>=3 group by cte.next having count(*) = 0;