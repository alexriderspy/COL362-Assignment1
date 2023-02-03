--1--
select
    distinct people.playerid,
    coalesce(people.namefirst,'') as firstname,
    coalesce(people.namelast,'') as lastname,
    sum(cs) as total_caught_stealing
from
    batting
    join people on people.playerid = batting.playerid
where
    cs is not null
group by
    people.playerid,
    firstname,
    lastname
order by
    total_caught_stealing desc,
    firstname asc,
    lastname asc,
    people.playerid asc
limit
    10;

--2--
select
    distinct people.playerid,
    coalesce(people.namefirst,'') as firstname,
    (
        (2 * sum(coalesce(batting.h2b, 0))) + 3 * sum(coalesce(batting.h3b, 0)) + 4 * sum(coalesce(batting.hr, 0))
    ) as runscore
from
    batting
    join people on people.playerid = batting.playerid
group by
    people.playerid,
    firstname
order by
    runscore desc,
    firstname desc,
    people.playerid asc
limit
    10;

--3--
select
    distinct people.playerid,
    case
        when people.namefirst is null
        and people.namelast is null then ''
        when people.namefirst is null then people.namelast
        when people.namelast is null then people.namefirst
        else people.namefirst || ' ' || people.namelast
    end as playername,
    sum(coalesce(pointsWon,0)) as total_points
from
    awardsshareplayers
    join people on people.playerid = awardsshareplayers.playerid
where
    yearid >= 2000
group by
    people.playerid,
    playername
order by
    total_points desc,
    people.playerid;

--4--
with a as (
    select
        batting.playerid,
        batting.yearid,
        sum(h) * 1.0 / sum(ab) * 1.0 as batting_average
    from
        batting
    where
        h>=0
        and ab>0
    group by
        batting.playerid,
        batting.yearid
)
select
    distinct people.playerid,
    coalesce(people.namefirst,'') as firstname,
    coalesce(people.namelast,'') as lastname,
    avg(batting_average) as career_batting_average
from
    a
    join people on people.playerid = a.playerid
group by
    people.playerid,
    firstname,
    lastname
having count(distinct yearid) >= 10
order by
    career_batting_average desc,
    people.playerid asc,
    firstname asc,
    lastname asc
limit
    10;

--5--
select
    distinct p.playerid,
    coalesce(p.namefirst,'') as firstname,
    coalesce(p.namelast,'') as lastname,
    case
        when birthyear is null
        or birthmonth is null
        or birthday is null then ''
        else lpad(p.birthyear :: text, 2, '0') || '-' || lpad(p.birthmonth :: text, 2, '0') || '-' || lpad(p.birthday :: text, 2, '0')
    end as date_of_birth,
        count(distinct t.yearid) as num_seasons
        from
            people as p
            join (
                (
                    select
                        playerid,
                        yearid
                    from
                        batting
                )
                union
                (
                    select
                        playerid,
                        yearid
                    from
                        pitching
                )
                union
                (
                    select
                        playerid,
                        yearid
                    from
                        fielding
                )
            ) as t on p.playerid = t.playerid
        group by
            p.playerid,
            firstname,
            lastname,
            date_of_birth
        order by
            num_seasons desc,
            p.playerid asc,
            firstname asc,
            lastname asc,
            date_of_birth asc;

--6--
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
        distinct teams.teamid, yearid
    from
        teams
    where
        divwin = 'y'
)
select
    distinct a.teamid,
    a.name as teamname,
    coalesce(f.franchname,'') as franchisename,
    max(coalesce(w,0)) as num_wins
from
    a,
    b,
    teams,
    teamsfranchises f
where
    a.teamid = b.teamid
    and b.teamid = teams.teamid
    and b.yearid = teams.yearid
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

--7--
select
    distinct teamid,
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
                    name,
                    sum(w) as s
                from
                    teams
                group by
                    teamid,
                    name
            ) as t on t.teamid = teams.teamid
            and t.name = teams.name
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

--8--
select
    distinct t.teamid,
    t.name as teamname,
    s.seasonid,
    p.playerid,
    coalesce(p.namefirst,'') as player_firstname,
    coalesce(p.namelast,'') as player_lastname,
    s.salary
from
    (
        select
            teamid,
            yearid as seasonid,
            max(coalesce(salary,0)) as salary
        from
            salaries
        group by
            teamid,
            seasonid
    ) as s
    join salaries on salaries.salary = s.salary
    and salaries.teamid = s.teamid
    and salaries.yearid = s.seasonid
    join (
        select
            distinct playerid,
            namefirst,
            namelast
        from
            people
    ) as p on p.playerid = salaries.playerid
    join (
        select
            distinct teamid,
            name,
            yearid
        from
            teams
    ) as t on t.teamid = salaries.teamid
    and t.yearid = salaries.yearid
order by
    t.teamid asc,
    teamname asc,
    s.seasonid asc,
    p.playerid asc,
    player_firstname asc,
    player_lastname asc,
    s.salary desc;

--9--
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

--10--
select
    distinct people.playerid,
    case
        when people.namefirst is null
        and people.namelast is null then ''
        when people.namefirst is null then people.namelast
        when people.namelast is null then people.namefirst
        else people.namefirst || ' ' || people.namelast
    end as playername,
    count(distinct c2.playerid) as number_of_batchmates
from
    collegeplaying c1
    left outer join collegeplaying c2 on c1.schoolid = c2.schoolid
    and c1.yearid = c2.yearid
    and c1.playerid != c2.playerid
    join people on people.playerid = c1.playerid
group by
    people.playerid,
    playername
order by
    number_of_batchmates desc,
    people.playerid asc;

--11--
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
    distinct b.teamid,
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

--12--
select
    distinct people.playerid,
    coalesce(namefirst,'') as firstname,
    coalesce(namelast,'') as lastname,
    sum (coalesce(sv,0)) as career_saves,
    t.num_seasons
from
    pitching
    join people on people.playerid = pitching.playerid
    join (
        select
            playerid,
            count(distinct yearid) as num_seasons
        from
            pitching
        group by
            playerid
    ) as t on t.playerid = people.playerid
where
    t.num_seasons >= 15
group by
    people.playerid,
    firstname,
    lastname,
    t.num_seasons
order by
    career_saves desc,
    t.num_seasons desc,
    people.playerid desc,
    firstname asc,
    lastname asc
limit
    10;

--13--
with a as (
    select
        distinct playerid
    from
        pitching
    group by
        playerid
    having
        count(distinct teamid) >= 5
),
b as (
    select
        p1.playerid
    from
        a,
        pitching p1
    where
        a.playerid = p1.playerid
        and yearid = (
            select
                min(yearid)
            from
                pitching p2
            where
                p1.playerid = p2.playerid
        )
    group by
        p1.playerid,
        yearid
    having
        count(distinct teamid) >= 2
),
c as (
    select
        distinct a.playerid
    from
        a,
        pitching
    where
        a.playerid = pitching.playerid
    except
    select
        *
    from
        b
),
d as (
    select
        distinct c.playerid,
        teamid
    from
        c,
        pitching
    where
        c.playerid = pitching.playerid
),
e as (
    select
        distinct d.playerid,
        d.teamid,
        yearid
    from
        d,
        pitching p1
    where
        d.playerid = p1.playerid
        and d.teamid = p1.teamid
        and yearid = (
            select
                min(yearid)
            from
                pitching p2
            where
                p1.playerid = p2.playerid
                and p1.teamid = p2.teamid
        )
),
f as (
    select
        e.playerid,
        e.teamid,
        e.yearid,
        rank() over (
            partition by e.playerid
            order by
                e.yearid,
                stint
        ) as rank
    from
        e, pitching where pitching.playerid = e.playerid and pitching.yearid = e.yearid and pitching.teamid = e.teamid
),
g as (
    select
        distinct playerid,
        teamid
    from
        f
    where
        rank <= 2
    order by playerid
),
h as (
    select
        distinct on (g1.playerid) g1.playerid,
        g1.teamid as t1,
        g2.teamid as t2
    from
        g g1
        join g g2 on g1.playerid = g2.playerid
        and g1.teamid != g2.teamid
    order by
        g1.playerid
),
i as (
    select
        distinct b.playerid,
        yearid,
        teamid
    from
        b,
        pitching p1
    where
        b.playerid = p1.playerid
        and yearid = (
            select
                min(yearid)
            from
                pitching p2
            where
                p1.playerid = p2.playerid
        )
),
j as (
    select
        distinct i.playerid,
        i.teamid,
        stint
    from
        i,
        pitching p1
    where
        i.playerid = p1.playerid
        and i.teamid = p1.teamid
        and i.yearid = p1.yearid
        and stint = (
            select
                min(stint)
            from
                pitching p2
            where
                p1.playerid = p2.playerid
                and p1.teamid = p2.teamid
                and p1.yearid = p2.yearid
        )
    order by
        i.playerid
),
k as (
    select
        playerid,
        teamid,
        stint,
        rank() over (
            partition by playerid
            order by
                stint
        ) as rank
    from
        j
),
l as (
    select
        playerid,
        teamid
    from
        k
    where
        rank <= 2
),
m as (
    select
        distinct on (l1.playerid) l1.playerid,
        l1.teamid as t1,
        l2.teamid as t2
    from
        l l1
        join l l2 on l1.playerid = l2.playerid
        and l1.teamid != l2.teamid
    order by
        l1.playerid
),
n as (
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
final as (
    select
        *
    from
        m
    union
    select
        *
    from
        h
),
o as (
    select
        playerid,
        name as t1_name,
        t2
    from
        final,
        n
    where
        n.teamid = final.t1
),
p as (
    select
        playerid,
        t1_name,
        name as t2_name
    from
        o,
        n
    where
        n.teamid = o.t2
)
select
    distinct p.playerid,
    coalesce(namefirst,'') as firstname,
    coalesce(namelast,'') as lastname,
    case
        when birthcity is null
        or birthstate is null
        or birthcountry is null then ''
        else birthcity || ' ' || birthstate || ' ' || birthcountry
    end as birth_address,
    t1_name as first_teamname,
    t2_name as second_teamname
from
    p,
    people
where
    p.playerid = people.playerid
order by
    p.playerid,
    firstname,
    lastname,
    birth_address,
    first_teamname,
    second_teamname;

--14--
insert into
    people (playerid, namefirst, namelast)
values
    ('dunphil02', 'Phil', 'Dunphy');
insert into
    people (playerid, namefirst, namelast)
values
    ('tuckcam01', 'Cameron', 'Tucker');
insert into
    people (playerid, namefirst, namelast)
values
    ('scottm02', 'Michael', 'Scott');
insert into
    people (playerid, namefirst, namelast)
values
    ('waltjoe', 'Joe', 'Walt');
insert into
    awardsplayers(awardid, playerid, lgid, yearid, tie)
values
    ('Best Baseman', 'dunphil02', '', 2014, true);
insert into
    awardsplayers(awardid, playerid, lgid, yearid, tie)
values
    ('Best Baseman', 'tuckcam01', '', 2014, true);
insert into
    awardsplayers(awardid, playerid, lgid, yearid, tie)
values
    ('ALCS MVP', 'scottm02', 'AA', 2015, false);
insert into
    awardsplayers(awardid, playerid, lgid, yearid, tie)
values
    ('Triple Crown', 'waltjoe', '', 2016, NULL);
insert into
    awardsplayers(awardid, playerid, lgid, yearid, tie)
values
    ('Gold Glove', 'adamswi01', '', 2017, false);
insert into
    awardsplayers(awardid, playerid, lgid, yearid, tie)
values
    ('ALCS MVP', 'yostne01', '', 2017, null);
with a as (
    select
        awardid,
        playerid,
        count(*) as cnt
    from
        awardsplayers
    group by
        awardid,
        playerid
),
b as (
    select
        *
    from
        a a1
    where
        cnt = (
            select
                max(cnt)
            from
                a a2
            where
                a2.awardid = a1.awardid
        )
)
select
    distinct awardid,
    b1.playerid,
    coalesce(namefirst,'') as firstname,
    coalesce(namelast,'') as lastname,
    cnt as num_wins
from
    b b1
    join people on people.playerid = b1.playerid
where
    b1.playerid = (
        select
            min(playerid)
        from
            b b2
        where
            b1.awardid = b2.awardid
    )
order by
    awardid asc,
    num_wins desc;

--15--
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
)
select
    distinct a.teamid,
    name as teamname,
    yearid as seasonid,
    managers.playerid as managerid,
    coalesce(namefirst,'') as managerfirstname,
    coalesce(namelast,'') as managerlastname
from
    managers,
    a,
    people
where
    a.teamid = managers.teamid
    and people.playerid = managers.playerid
    and yearid >= 2000
    and yearid <= 2010
    and (
        inseason = 0
        or inseason = 1
    )
order by
    teamid,
    teamname,
    seasonid desc,
    managerid,
    managerfirstname,
    managerlastname;

--16--
with a as (
    select
        schoolid,
        playerid
    from
        collegeplaying c1
    where
        yearid = (
            select
                max(yearid)
            from
                collegeplaying c2
            where
                c1.playerid = c2.playerid
        )
),
b as (
    select
        playerid,
        count(*) as total_awards
    from
        awardsplayers
    group by
        playerid
)
select
    distinct b.playerid,
    coalesce(schoolname,'') as colleges_name,
    total_awards
from
    b
    left outer join a on a.playerid = b.playerid
    left outer join schools on a.schoolid = schools.schoolid
order by
    total_awards desc,
    colleges_name,
    b.playerid
limit
    10;

--17--
with a as (
    select
        ap.playerid
    from
        awardsmanagers am,
        awardsplayers ap
    where
        am.playerid = ap.playerid
),
b as (
    select
        distinct a.playerid,
        awardid,
        yearid
    from
        awardsplayers ap,
        a
    where
        a.playerid = ap.playerid
        and yearid = (
            select
                min(yearid)
            from
                awardsplayers ap2
            where
                ap.playerid = ap2.playerid
        )
        and awardid = (
            select
                min(awardid)
            from
                awardsplayers ap2
            where
                ap.playerid = ap2.playerid
                and ap.yearid = ap2.yearid
        )
    order by
        a.playerid
),
c as (
    select
        distinct a.playerid,
        awardid,
        yearid
    from
        awardsmanagers ap,
        a
    where
        a.playerid = ap.playerid
        and yearid = (
            select
                min(yearid)
            from
                awardsmanagers ap2
            where
                ap.playerid = ap2.playerid
        )
        and awardid = (
            select
                min(awardid)
            from
                awardsmanagers ap2
            where
                ap.playerid = ap2.playerid
                and ap.yearid = ap2.yearid
        )
    order by
        a.playerid
)
select
    distinct b.playerid,
    coalesce(namefirst,'') as firstname,
    coalesce(namelast,'') as lastname,
    b.awardid as playerawardid,
    b.yearid as playerawardyear,
    c.awardid as managerawardid,
    c.yearid as managerawardyear
from
    b,
    c,
    people
where
    b.playerid = c.playerid
    and b.playerid = people.playerid
order by
    b.playerid,
    firstname,
    lastname;

--18--
with a as (
    select
        playerid,
        count(distinct category) as num_honored_categories
    from
        halloffame
    group by
        playerid
    having
        count(distinct category) >= 2
)
select
    distinct a1.playerid,
    coalesce(namefirst,'') as firstname,
    coalesce(namelast,'') as lastname,
    num_honored_categories,
    yearid as seasonid
from
    allstarfull a1,
    people,
    a
where
    a1.playerid = people.playerid
    and a1.playerid = a.playerid
    and yearid = (
        select
            min(yearid)
        from
            allstarfull a2
        where
            a2.gp = 1
            and a1.playerid = a2.playerid
    )
    and a1.gp = 1
order by
    num_honored_categories desc,
    a1.playerid,
    firstname,
    lastname,
    seasonid;

--19--
select
    distinct a.playerid,
    namefirst as firstname,
    namelast as lastname,
    sum(coalesce(g_all,0)) as G_all,
    sum(coalesce(g_1b,0)) as G_1b,
    sum(coalesce(g_2b,0)) as G_2b,
    sum(coalesce(g_3b,0)) as G_3b
from
    appearances a,
    people
where
    people.playerid = a.playerid
group by
    a.playerid,
    firstname,
    lastname
having
    (
        sum(g_2b) > 0
        and sum(g_3b) > 0
    )
    or (
        sum(g_1b) > 0
        and sum(g_2b) > 0
    )
    or (
        sum(g_1b) > 0
        and sum(g_3b) > 0
    )
order by
    g_all desc,
    a.playerid,
    firstname,
    lastname,
    g_1b desc,
    g_2b desc,
    g_3b desc;

--20--
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
    coalesce(schoolname,'') as schoolname,
    case
        when schoolcity is null
        or schoolstate is null then ''
        else schoolcity || ' ' || schoolstate
    end as schooladdr,
    cp.playerid,
    coalesce(namefirst,'') as firstname,
    coalesce(namelast,'') as lastname
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

--21--
with birth as (
    select
        playerid,
        birthcity,
        birthstate
    from
        people
    where
        birthcity is not null
        and birthstate is not null
),
a as (
    select
        distinct b.playerid,
        b.teamid,
        birthcity,
        birthstate
    from
        batting b,
        birth
    where
        b.playerid = birth.playerid
),
b as (
    select
        distinct p.playerid,
        p.teamid,
        birthcity,
        birthstate
    from
        pitching p,
        birth
    where
        p.playerid = birth.playerid
),
c as (
    select
        distinct b1.playerid as player1_id,
        b2.playerid as player2_id,
        b1.birthcity,
        b1.birthstate,
        'batted' as role
    from
        a b1
        join a b2 on b1.teamid = b2.teamid
        and b1.birthstate = b2.birthstate
        and b1.birthcity = b2.birthcity
        and b1.playerid != b2.playerid
),
d as (
    select
        distinct b1.playerid as player1_id,
        b2.playerid as player2_id,
        b1.birthcity,
        b1.birthstate,
        'pitched' as role
    from
        b b1
        join b b2 on b1.teamid = b2.teamid
        and b1.birthstate = b2.birthstate
        and b1.birthcity = b2.birthcity
        and b1.playerid != b2.playerid
),
e as (
    select
        *
    from
        c
    union
    select
        *
    from
        d
),
f as (
    select
        player1_id,
        player2_id,
        birthcity,
        birthstate
    from
        e
    group by
        player1_id,
        player2_id,
        birthcity,
        birthstate
    having
        count(*) = 2
),
g as (
    select
        player1_id,
        player2_id,
        birthcity,
        birthstate
    from
        e
    group by
        player1_id,
        player2_id,
        birthcity,
        birthstate
    having
        count(*) <= 1
) (
    select
        distinct player1_id,
        player2_id,
        birthcity,
        birthstate,
        'both' as role
    from
        f
)
union
(
    select
        distinct g.player1_id,
        g.player2_id,
        g.birthcity,
        g.birthstate,
        role
    from
        g,
        c
    where
        g.player1_id = c.player1_id
        and g.player2_id = c.player2_id
        and g.birthcity = c.birthcity
        and g.birthstate = c.birthstate
    union
    select
        g.player1_id,
        g.player2_id,
        g.birthcity,
        g.birthstate,
        role
    from
        g,
        d
    where
        g.player1_id = d.player1_id
        and g.player2_id = d.player2_id
        and g.birthcity = d.birthcity
        and g.birthstate = d.birthstate
)
order by
    birthcity,
    birthstate,
    player1_id,
    player2_id;

--22--
with a as (
    select
        awardid,
        yearid,
        avg(coalesce(pointswon,0))
    from
        awardsshareplayers
    group by
        awardid,
        yearid
)
select
    distinct ap1.awardid,
    ap1.yearid as seasonid,
    playerid,
    sum(coalesce(pointswon,0)) as playerpoints,
    avg as averagepoints
from
    awardsshareplayers ap1,
    a
where
    a.awardid = ap1.awardid
    and a.yearid = ap1.yearid
group by
    ap1.awardid,
    seasonid,
    playerid,
    avg
having
    sum(coalesce(pointswon,0)) >= avg
order by
    ap1.awardid,
    seasonid,
    playerpoints desc,
    playerid;

--23--
with a as (
    select
        distinct playerid,
    case
        when people.namefirst is null
        and people.namelast is null then ''
        when people.namefirst is null then people.namelast
        when people.namelast is null then people.namefirst
        else people.namefirst || ' ' || people.namelast
    end as playername
    from
        people
    where
        deathday is null
        and deathyear is null
        and deathmonth is null
),
b as (
    select
        distinct playerid,
    case
        when people.namefirst is null
        and people.namelast is null then ''
        when people.namefirst is null then people.namelast
        when people.namelast is null then people.namefirst
        else people.namefirst || ' ' || people.namelast
    end as playername
    from
        people
    where
        deathday is not null
        or deathyear is not null
        or deathmonth is not null
) (
    select
        distinct a.playerid,
        playername,
        true as alive
    from
        a
        left outer join (
            select
                *
            from
                awardsplayers
            union
            select
                *
            from
                awardsmanagers
        ) as m1 on m1.playerid = a.playerid
    where
        m1.awardid is null
)
union
(
    select
        distinct b.playerid,
        playername,
        false as alive
    from
        b
        left outer join (
            select
                *
            from
                awardsplayers
            union
            select
                *
            from
                awardsmanagers
        ) as m2 on m2.playerid = b.playerid
    where
        m2.awardid is null
)
order by
    playerid,
    playername;

--24--
with recursive a as (
    select
        distinct playerid,
        yearid,
        teamid
    from
        pitching
    union
    (
        select
            distinct playerid,
            yearid,
            teamid
        from
            allstarfull
        where
            gp = 1
    )
),
b as (
    select
        a1.playerid as p1_id,
        a2.playerid as p2_id,
        a1.teamid,
        a1.yearid
    from
        a a1
        join a a2 on a1.teamid = a2.teamid
        and a1.yearid = a2.yearid
        and a1.playerid != a2.playerid
),
nodes as (
    select
        distinct playerid
    from
        a
),
edges as (
    select
        p1_id,
        p2_id,
        count(*) as cnt
    from
        b
    group by
        p1_id,
        p2_id
    having
        count(*) > 0
    order by
        p1_id,
        p2_id
),
cte as (
    select
        distinct p2_id as next,
        ARRAY [p1_id] :: varchar(10) [] as vis,
        cnt as len,
        1 as depth
    from
        edges
    where
        p1_id = 'webbbr01'
    union
    all
    select
        distinct p2_id,
        (vis || p1_id) :: varchar(10) [],
        (cnt + len),
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.p1_id
        and not (edges.p2_id = any (vis))
        and not (
            cte.next = 'clemero02'
            and (len) >= 3
        )
        --and depth <= 1
)
select
    True as pathexists
from
    cte
where
    cte.next = 'clemero02'
    and cte.len >= 3
group by
    cte.next
having
    count(*) >= 1
union
select
    False as pathexists
from
    cte
where
    cte.next = 'clemero02'
    and cte.len >= 3
group by
    cte.next
having
    count(*) = 0;

--25--
with recursive a as (
    select
        distinct playerid,
        yearid,
        teamid
    from
        pitching
    union
    (
        select
            distinct playerid,
            yearid,
            teamid
        from
            allstarfull
        where
            gp = 1
    )
),
b as (
    select
        a1.playerid as p1_id,
        a2.playerid as p2_id,
        a1.teamid,
        a1.yearid
    from
        a a1
        join a a2 on a1.teamid = a2.teamid
        and a1.yearid = a2.yearid
        and a1.playerid != a2.playerid
),
edges as (
    select
        p1_id,
        p2_id,
        count(*) as cnt
    from
        b
    group by
        p1_id,
        p2_id
    having
        count(*) > 0
    order by
        p1_id,
        p2_id
),
cte as (
    select
        distinct p2_id as next,
        ARRAY [p1_id] :: varchar(10) [] as vis,
        cnt as len,
        1 as depth
    from
        edges
    where
        p1_id = 'garcifr02'
    union
    all
    select
        distinct p2_id,
        (vis || p1_id) :: varchar(10) [],
        (cnt + len),
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.p1_id
        and not (edges.p2_id = any (vis))
        and cte.next != 'leagubr01' 
        --and (depth) <= 1
)
select
    coalesce(
        (
            select
                min(len)
            from
                cte
            where
                cte.next = 'leagubr01'
        ),
        0
    ) as pathlength;

--26--
with recursive edges as (
    select
        distinct teamidwinner as win,
        teamidloser as loss
    from
        seriespost
),
cte as (
    select
        distinct loss as next,
        ARRAY [win] :: varchar(3) [] as vis,
        1 as depth
    from
        edges
    where
        win = 'ARI'
    union
    all
    select
        distinct loss as next,
        (vis || win) :: varchar(3) [],
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.win
        and not (loss = any (vis))
        and cte.next != 'DET'
)
select
    count(*) as count
from
    cte
where
    cte.next = 'DET';

--27--
with recursive edges as (
    select
        distinct teamidwinner as win,
        teamidloser as loss
    from
        seriespost
),
cte as (
    select
        loss as next,
        ARRAY [win] :: varchar(3) [] as vis,
        1 as depth
    from
        edges
    where
        win = 'HOU'
    union
    all
    select
        loss as next,
        (vis || win) :: varchar(3) [],
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.win
        and not (loss = any (vis))
        --and depth <= 2
)
select
    distinct next as teamid,
    depth as num_hops
from
    cte c1
where
    depth = (
        select
            max(depth)
        from
            cte c2
        where
            c1.next = c2.next
    )
order by
    teamid;

--28--
with recursive edges as (
    select
        distinct teamidwinner as win,
        teamidloser as loss
    from
        seriespost
),
cte as (
    select
        distinct loss as next,
        ARRAY [win] :: varchar(3) [] as vis,
        1 as depth
    from
        edges
    where
        win = 'WS1'
    union
    all
    select
        distinct loss as next,
        (vis || win) :: varchar(3) [],
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.win
        and not (loss = any (vis))
        --and depth <= 4
),
a as (
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
)
select
    distinct cte.next as teamid,
    case when name is null then ''
    else name
    end
    as teamname,
    depth as pathlength
from
    cte left outer join a on
    a.teamid = cte.next
    where depth = (
        select
            max(depth)
        from
            cte
    )
order by
    teamid,
    teamname;

--29--
with recursive edges as (
    select
        distinct teamidwinner as win,
        teamidloser as loss
    from
        seriespost
),
a as (
    select
        teamidwinner
    from
        seriespost
    where
        coalesce(ties,0) > coalesce(losses,0)
    group by
        teamidwinner
    having
        count (distinct yearid) >= 1
),
cte as (
    select
        distinct win as start,
        loss as next,
        ARRAY [win] :: varchar(3) [] as vis,
        1 as depth
    from
        edges
    where
        win in (
            select
                *
            from
                a
        )
    union
    all
    select
        distinct start,
        loss as next,
        (vis || win) :: varchar(3) [],
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.win
        and not (loss = any (vis))
        and not (cte.next = 'NYA')
        --and depth <= 4
)
select
    distinct start as teamid,
    min(depth) as pathlength
from
    cte
where
    cte.next = 'NYA'
group by
    teamid
order by
    teamid,
    pathlength;

--30--
with recursive edges as (
    select
        distinct teamidwinner as win,
        teamidloser as loss
    from
        seriespost
),
cte as (
    select
        distinct loss as next,
        ARRAY [] :: varchar(3) [] as vis,
        1 as depth
    from
        edges
    where
        win = 'DET'
    union
    all
    select
        distinct loss as next,
        (vis || win) :: varchar(3) [],
        depth + 1
    from
        edges,
        cte
    where
        cte.next = edges.win
        and not (loss = any (vis))
        --and depth <= 2
)
select
    coalesce (
        (select
            depth
        from
            cte
        where
            cte.next = 'DET'
            and depth = (
                select
                    max(depth)
                from
                    cte
                where
                    cte.next = 'DET'
            )
        group by
            cte.next,
            depth),
            0
    ) as cyclelength,
    coalesce(
        (select
            count(*)
        from
            cte
        where
            cte.next = 'DET'
            and depth = (
                select
                    max(depth)
                from
                    cte
                where
                    cte.next = 'DET'
            )
        group by
            cte.next,
            depth),
            0
    ) as numcycles;