select
    c1.playerid,
    namefirst || ' ' || namelast as playername,
    count(c2.playerid) as number_of_batchmates
from
    collegeplaying c1
    join collegeplaying c2 on c1.schoolid = c2.schoolid
    and c1.yearid = c2.yearid
    and not c1.playerid = c2.playerid
    join people on people.playerid = c1.playerid
group by
    c1.playerid,
    namefirst,
    namelast
order by
    number_of_batchmates desc,
    c1.playerid asc;