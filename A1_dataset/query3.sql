select
    distinct people.playerid,
    case
        when people.namefirst is null
        and people.namelast is null then ''
        when people.namefirst is null then people.namelast
        when people.namelast is null then people.namefirst
        else people.namefirst || ' ' || people.namelast
    end as playername,
    sum(pointsWon) as total_points
from
    awardsshareplayers
    join people on people.playerid = awardsshareplayers.playerid
where
    yearid >= 2000
group by
    people.playerid,
    people.namefirst,
    people.namelast
order by
    total_points desc,
    people.playerid;