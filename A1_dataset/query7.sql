select
    teamid,
    name as teamname,
    seasonid,
    winning_percentage
from
    (
        select
            distinct on (teams.teamid) teams.teamid,
            teams.name,
            yearid as seasonid,
            (((w * 100.0) / g)) as winning_percentage
        from
            teams
            join (
                select
                    teamid,
                    sum(w) as s
                from
                    teams
                group by
                    teamid
            ) as t on t.teamid = teams.teamid
        where
            t.s >= 20
        order by
            teams.teamid,
            winning_percentage desc
    ) as tb
order by
    winning_percentage desc,
    teamid asc,
    name asc,
    seasonid asc
limit
    5;