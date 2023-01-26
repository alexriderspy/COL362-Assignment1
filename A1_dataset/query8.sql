select
    t.teamid,
    t.name as teamname,
    s.seasonid,
    p.playerid,
    p.namefirst as player_firstname,
    p.namelast as player_lastname,
    s.salary
from
    (
        select
            teamid,
            yearid as seasonid,
            max(salary) as salary
        from
            salaries
        group by
            teamid,
            seasonid
    ) as s
    join salaries on salaries.salary = s.salary
    and salaries.teamid = s.teamid
    and salaries.yearid = s.seasonid
    join (
        select
            distinct playerid,
            namefirst,
            namelast
        from
            people
    ) as p on p.playerid = salaries.playerid
    join (
        select
            distinct teamid,
            name,
            yearid 
        from
            teams
    ) as t on t.teamid = salaries.teamid and t.yearid = salaries.yearid 
    order by
        t.teamid asc,
        teamname asc,
        s.seasonid asc,
        p.playerid asc,
        player_firstname asc,
        player_lastname asc,
        s.salary desc
;