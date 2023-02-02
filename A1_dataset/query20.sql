with a as (
    select
        schoolid,
        count(distinct playerid) as cnt
    from
        collegeplaying
    group by
        schoolid
    order by
        cnt desc
    limit
        5
)
select
    distinct cp.schoolid,
    schoolname,
    case
        when schoolcity is null
        or schoolstate is null then null
        else schoolcity || ' ' || schoolstate
    end as schooladdr,
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