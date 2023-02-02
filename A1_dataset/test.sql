with a as (
    select
        distinct playerid
    from
        pitching
    group by
        playerid
    having
        count(distinct teamid) >= 5
),
b as (
    select
        distinct p1.playerid
    from
        a,
        pitching p1
    where
        a.playerid = p1.playerid
        and yearid = (
            select
                min(yearid)
            from
                pitching p2
            where
                p1.playerid = p2.playerid
        )
    group by
        p1.playerid,
        yearid
    having
        count(distinct teamid) >= 2
),
c as (
    select
        distinct a.playerid
    from
        a,
        pitching
    where
        a.playerid = pitching.playerid
    except
    select
        *
    from
        b
),
d as (
    select
        distinct c.playerid,
        teamid
    from
        c,
        pitching
    where
        c.playerid = pitching.playerid
),
e as (
    select
        distinct d.playerid,
        d.teamid,
        yearid
    from
        d,
        pitching p1
    where
        d.playerid = p1.playerid
        and d.teamid = p1.teamid
        and yearid = (
            select
                min(yearid)
            from
                pitching p2
            where
                p1.playerid = p2.playerid
                and p1.teamid = p2.teamid
        )
),
f as (
    select
        e.playerid,
        e.teamid,
        e.yearid,
        rank() over (
            partition by e.playerid
            order by
                e.yearid,
                stint
        ) as rank
    from
        e, pitching where pitching.playerid = e.playerid and pitching.yearid = e.yearid and pitching.teamid = e.teamid
),
g as (
    select
        distinct playerid,
        teamid
    from
        f
    where
        rank <= 2
    order by playerid
),
h as (
    select
        distinct on (g1.playerid) g1.playerid,
        g1.teamid as t1,
        g2.teamid as t2
    from
        g g1
        join g g2 on g1.playerid = g2.playerid
        and g1.teamid != g2.teamid
    order by
        g1.playerid
)
select * from h; --order by playerid;