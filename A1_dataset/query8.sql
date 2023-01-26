select
    teams.teamid,
    teams.name as teamname,
    salaries.yearid as seasonid,
    people.playerid,
    namefirst as player_firstname,
    namelast as player_lastname,
    max(salary) as salary
from
    salaries
    join people on people.playerid = salaries.playerid
    join teams on teams.teamid = salaries.teamid
group by
    teams.teamid,
    teamname,
    seasonid,
    people.playerid,
    player_firstname,
    player_lastname
order by
    teams.teamid asc,
    teamname asc,
    seasonid asc,
    people.playerid asc,
    player_firstname asc,
    player_lastname asc,
    salary desc;