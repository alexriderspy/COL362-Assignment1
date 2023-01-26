select
    teams.teamid,
    teams.name as teamname,
    count(wswin) as total_ws_wins
from
    (
        select
            teamid,
            name,
            yearid
        from
            (
                select
                    teamid,
                    name,
                    yearid,
                    sum(g) as s
                from
                    teams
                where
                    wswin = 'y'
                group by
                    teamid,
                    name,
                    yearid
            ) as tb
        where
            tb.s >= 110
    ) as t
    join teams on teams.teamid = t.teamid
    and teams.yearid = t.yearid
    and teams.name = t.name
where
    wswin = 'y'
group by
    teams.teamid,
    teamname
order by
    total_ws_wins desc,
    teams.teamid asc,
    teamname asc
limit
    5;