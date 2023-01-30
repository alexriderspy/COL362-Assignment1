with birth as (
    select
        playerid,
        birthcity,
        birthstate
    from
        people
    where
        birthcity is not null
        and birthstate is not null
),
a as (
    select
        distinct b.playerid,
        b.teamid,
        birthcity,
        birthstate
    from
        batting b,
        birth
    where
        b.playerid = birth.playerid
),
b as (
    select
        distinct p.playerid,
        p.teamid,
        birthcity,
        birthstate
    from
        pitching p,
        birth
    where
        p.playerid = birth.playerid
),
c as (
    select
        distinct b1.playerid as player1_id,
        b2.playerid as player2_id,
        b1.birthcity,
        b1.birthstate,
        'batted' as role
    from
        a b1
        join a b2 on b1.teamid = b2.teamid
        and b1.birthstate = b2.birthstate
        and b1.birthcity = b2.birthcity
        and b1.playerid != b2.playerid
),
d as (
    select
        distinct b1.playerid as player1_id,
        b2.playerid as player2_id,
        b1.birthcity,
        b1.birthstate,
        'pitched' as role
    from
        b b1
        join b b2 on b1.teamid = b2.teamid
        and b1.birthstate = b2.birthstate
        and b1.birthcity = b2.birthcity
        and b1.playerid != b2.playerid
),
e as (
    select
        *
    from
        c
    union
    select
        *
    from
        d
),
f as (
    select
        player1_id,
        player2_id,
        birthcity,
        birthstate
    from
        e
    group by
        player1_id,
        player2_id,
        birthcity,
        birthstate
    having
        count(*) = 2
),
g as (
    select
        player1_id,
        player2_id,
        birthcity,
        birthstate
    from
        e
    group by
        player1_id,
        player2_id,
        birthcity,
        birthstate
    having
        count(*) <= 1
)
select
    player1_id,
    player2_id,
    birthcity,
    birthstate,
    'both' as role
from
    f
union
(
    select
        g.player1_id,
        g.player2_id,
        g.birthcity,
        g.birthstate,
        role
    from
        g,
        c
    where
        g.player1_id = c.player1_id
        and g.player2_id = c.player2_id
        and g.birthcity = c.birthcity
        and g.birthstate = c.birthstate
    union
    select
        g.player1_id,
        g.player2_id,
        g.birthcity,
        g.birthstate,
        role
    from
        g,
        d
    where
        g.player1_id = d.player1_id
        and g.player2_id = d.player2_id
        and g.birthcity = d.birthcity
        and g.birthstate = d.birthstate
)
order by
    birthcity,
    birthstate,
    player1_id,
    player2_id;