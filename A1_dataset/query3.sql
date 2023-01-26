select
    people.playerid,
    people.namefirst || ' ' || people.namelast as playername,
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
    people.playerid asc;