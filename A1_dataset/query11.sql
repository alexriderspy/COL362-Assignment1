with a as (
    select
        teamid,
        name
    from
        teams t1
    where
        yearid = (
            select
                max(yearid)
            from
                teams t2
            where
                t1.teamid = t2.teamid
        )
),
b as (
    select
        teams.teamid,
        count(wswin) as total_ws_wins
    from
        (
            select
                teamid,
                yearid
            from
                (
                    select
                        teamid,
                        yearid,
                        sum(g) as s
                    from
                        teams
                    where
                        wswin = 'y'
                    group by
                        teamid,
                        yearid
                ) as tb
            where
                tb.s >= 110
        ) as t
        join teams on teams.teamid = t.teamid
        and teams.yearid = t.yearid
    where
        wswin = 'y'
    group by
        teams.teamid
)
select
    b.teamid,
    name as teamname,
    total_ws_wins
from
    a,
    b
where
    a.teamid = b.teamid
order by
    total_ws_wins desc,
    b.teamid asc,
    teamname asc
limit
    5;