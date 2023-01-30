select
    *
from
    collegeplaying c1
    join collegeplaying c2 on c1.schoolid = c2.schoolid
    and c1.yearid = c2.yearid
    and c1.playerid != c2.playerid;
-- group by
--     people.playerid,
--     namefirst,
--     namelast
-- order by
--     number_of_batchmates desc,
--     people.playerid asc;