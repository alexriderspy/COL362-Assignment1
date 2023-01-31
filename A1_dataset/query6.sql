with a as(
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
        distinct teams.teamid
    from
        teams
    where
        divwin = 'y'
)
select
    distinct a.teamid,
    a.name as teamname,
    f.franchname as franchisename,
    max(w) as num_wins
from
    a,
    b,
    teams,
    teamsfranchises f
where
    a.teamid = b.teamid
    and b.teamid = teams.teamid
    and f.franchid = teams.franchid
group by
    a.teamid,
    teamname,
    franchisename
order by
    num_wins desc,
    a.teamid asc,
    teamname asc,
    franchisename asc;