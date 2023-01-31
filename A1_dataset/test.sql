with a as (
    select
        playerid
    from
        pitching
    group by
        playerid
    having
        count(distinct teamid) >= 5
),
b as (
    select
        p1.playerid,
        yearid
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
        distinct a.playerid,
        yearid
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
        playerid,
        teamid,
        yearid,
        rank() over (
            partition by playerid
            order by
                yearid
        ) as rank
    from
        e
),
g as (
    select
        playerid,
        teamid
    from
        f
    where
        rank <= 2
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
),
i as (
    select
        distinct b.playerid,
        b.yearid,
        teamid
    from
        b,
        pitching
    where
        b.playerid = pitching.playerid
        and b.yearid = pitching.yearid
),
j as (
    select
        distinct i.playerid,
        i.teamid,
        stint
    from
        i,
        pitching p1
    where
        i.playerid = p1.playerid
        and i.teamid = p1.teamid
        and i.yearid = p1.yearid
        and stint = (
            select
                min(stint)
            from
                pitching p2
            where
                p1.playerid = p2.playerid
                and p1.teamid = p2.teamid
                and p1.yearid = p2.yearid
        )
    order by
        i.playerid
),
k as (
    select
        playerid,
        teamid,
        stint,
        rank() over (
            partition by playerid
            order by
                stint
        ) as rank
    from
        j
),
l as (
    select
        playerid,
        teamid
    from
        k
    where
        rank <= 2
),
m as (
    select
        distinct on (l1.playerid) l1.playerid,
        l1.teamid as t1,
        l2.teamid as t2
    from
        l l1
        join l l2 on l1.playerid = l2.playerid
        and l1.teamid != l2.teamid
    order by
        l1.playerid
),
n as (
    select
        teamid,
        name
    from
        teams t1
    where
        yearid = (
            select
                max(yearid)
            from
                teams t2
            where
                t1.teamid = t2.teamid
        )
),
final as (
    select
        *
    from
        m
    union
    select
        *
    from
        h
),
o as (
    select playerid, name as t1_name, t2 from final, n where n.teamid = final.t1 
),
p as (
    select playerid, t1_name, name as t2_name from o, n where n.teamid = o.t2 

)
select
    p.playerid,
    namefirst as firstname,
    namelast as lastname,
    birthcity || ' ' || birthstate || ' ' || birthcountry as birth_address,
    t1_name as first_teamname,
    t2_name as second_teamname
    from p, people where p.playerid=people.playerid
;