with a as (
    select
        distinct playerid,
        namefirst || ' ' || namelast as playername
    from
        people
    where
        deathday is null
        and deathyear is null
        and deathmonth is null
),
b as (
    select
        distinct playerid,
        namefirst || ' ' || namelast as playername
    from
        people
    where
        deathday is not null
        or deathyear is not null
        or deathmonth is not null
) (
    select
        distinct a.playerid,
        playername,
        false as alive
    from
        a
        left outer join (
            select
                *
            from
                awardsplayers
            union
            select
                *
            from
                awardsmanagers
        ) as m1 on m1.playerid = a.playerid
    where
        m1.awardid is null
)
union
(
    select
        distinct b.playerid,
        playername,
        true as alive
    from
        b
        left outer join (
            select
                *
            from
                awardsplayers
            union
            select
                *
            from
                awardsmanagers
        ) as m2 on m2.playerid = b.playerid
    where
        m2.awardid is null
)
order by
    playerid,
    playername;