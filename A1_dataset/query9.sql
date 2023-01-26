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
                        distinct salaries.yearid,
                        salary,
                        salaries.playerid
                    from
                        salaries
                        join batting on salaries.playerid = batting.playerid
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
                        distinct salaries.yearid,
                        salary,
                        salaries.playerid
                    from
                        salaries
                        join pitching on salaries.playerid = pitching.playerid
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