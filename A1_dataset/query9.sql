

select avg(t.salary) from (
select
    distinct salaries.yearid,
    salary,
    salaries.playerid
from
    salaries
    join batting on salaries.playerid = batting.playerid    
) as t;