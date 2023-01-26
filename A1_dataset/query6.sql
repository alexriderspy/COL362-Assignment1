select
    distinct teams.teamid,
    f.franchname,
    max(w) as num_wins
from
    teams
    join teamsfranchises f on f.franchid = teams.franchid
where
    divwin = 'y'
group by
    teams.teamid,
    f.franchname
order by
    num_wins desc,
    teams.teamid asc,
    f.franchname asc;