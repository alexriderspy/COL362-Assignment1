select avg(t.salary) from (
select
    distinct salaries.yearid,
    salary,
    salaries.playerid
from
    salaries
    join pitching on salaries.playerid = pitching.playerid    
) as t;