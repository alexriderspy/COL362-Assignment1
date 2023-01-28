select
    distinct teams.teamid,
    teams.name as teamname,
    f.franchname as franchisename,
    max(w) as num_wins
from
    teams
    join teamsfranchises f on f.franchid = teams.franchid
where
    divwin = 'y'
group by
    teams.teamid,
    teamname,
    f.franchname
order by
    num_wins desc,
    teams.teamid asc,
    teamname asc,
    f.franchname asc;