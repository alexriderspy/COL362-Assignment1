select
    p.playerid,
    p.namefirst as firstname,
    p.namelast as lastname,
    p.birthyear || '-' || p.birthmonth || '-' || p.birthday as date_of_birth,
    count(distinct t.yearid) as num_seasons
from
    people as p
    join ((select playerid, yearid from batting) union
    (select playerid, yearid from pitching) union
    (select playerid, yearid from fielding)) as t on p.playerid = t.playerid
group by
    p.playerid,
    firstname,
    lastname,
    date_of_birth
order by
    num_seasons desc,
    p.playerid asc,
    firstname asc,
    lastname asc,
    date_of_birth asc;