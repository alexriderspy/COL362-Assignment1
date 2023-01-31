with a as (
    select
        awardid,
        yearid,
        avg(pointswon)
    from
        awardsshareplayers
    group by
        awardid,
        yearid
)
select
    ap1.awardid,
    ap1.yearid as seasonid,
    playerid,
    sum(pointswon) as playerpoints,
    avg as averagepoints
from
    awardsshareplayers ap1,
    a
where
    a.awardid = ap1.awardid
    and a.yearid = ap1.yearid
group by
    ap1.awardid,
    seasonid,
    playerid,
    avg
having
    sum(pointswon) >= avg
order by
    ap1.awardid,
    seasonid,
    playerpoints desc,
    playerid;