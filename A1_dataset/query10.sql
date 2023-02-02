select
    distinct people.playerid,
    case
        when people.namefirst is null
        and people.namelast is null then ''
        when people.namefirst is null then people.namelast
        when people.namelast is null then people.namefirst
        else people.namefirst || ' ' || people.namelast
    end as playername,
    count(distinct c2.playerid) as number_of_batchmates
from
    collegeplaying c1
    join collegeplaying c2 on c1.schoolid = c2.schoolid
    and c1.yearid = c2.yearid
    and c1.playerid != c2.playerid
    join people on people.playerid = c1.playerid
group by
    people.playerid,
    namefirst,
    namelast
order by
    number_of_batchmates desc,
    people.playerid asc;