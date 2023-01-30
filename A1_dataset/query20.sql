with a as (
    select
        schoolid,
        count(distinct playerid)
    from
        collegeplaying
    group by
        schoolid
    limit
        5
)
select
    distinct cp.schoolid,
    schoolname,
    schoolcity || ' ' || schoolstate as schooladdr,
    cp.playerid,
    namefirst as firstname,
    namelast as lastname
from
    collegeplaying cp,
    schools,
    people,
    a
where
    cp.schoolid = schools.schoolid
    and people.playerid = cp.playerid
    and a.schoolid = cp.schoolid
order by
    cp.schoolid,
    schoolname,
    schooladdr,
    cp.playerid,
    firstname,
    lastname;