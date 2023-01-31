with tmp as (
    select
        'batsman' player_category,
        p1.bat_avg avg_salary
    from
        (
            select
                avg(t1.salary) as bat_avg
            from
                (
                    select
                        salaries.yearid,
                        salary,
                        salaries.playerid, salaries.teamid, salaries.lgid
                    from
                        salaries
                        join batting on salaries.playerid = batting.playerid and salaries.teamid = batting.teamid and salaries.lgid = batting.lgid and salaries.yearid = batting.yearid
                ) as t1
        ) as p1
    union
    select
        'pitcher' player_category,
        p2.pit_avg avg_salary
    from
        (
            select
                avg(t2.salary) as pit_avg
            from
                (
                    select
                        salaries.yearid,
                        salary,
                        salaries.playerid, salaries.teamid, salaries.lgid
                    from
                        salaries
                        join pitching on salaries.playerid = pitching.playerid and salaries.teamid = pitching.teamid and salaries.lgid = pitching.lgid and salaries.yearid = pitching.yearid
                ) as t2
        ) as p2
)
select
    player_category,
    tab2.avg_salary
from
    (
        select
            max(avg_salary) as max_salary
        from
            tmp
    ) as tab1
    join tmp as tab2 on tab2.avg_salary = tab1.max_salary;