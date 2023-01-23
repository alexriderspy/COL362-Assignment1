--1--
SELECT
    tournament_id,
    tournament_name,
    year,
    winner
FROM
    Tournaments
WHERE
    host_country = winner;

--2--
SELECT
    player_id,
    family_name,
    given_name,
    count_tournaments
FROM
    Players
WHERE
    count_tournaments >= 4;

--3--
SELECT
    COUNT(*) as num_matches
FROM
    Matches
    JOIN Teams ON (
        Matches.home_team_id = Teams.team_id
        OR Matches.away_team_id = Teams.team_id
    )
WHERE
    Teams.team_name = 'Croatia'
    AND Matches.draw = 't';

--4--
SELECT
    stadium_name,
    city_name,
    country_name
FROM
    Stadiums
    JOIN (
        SELECT
            *
        FROM
            Matches
            JOIN Tournaments ON Tournaments.tournament_id = Matches.tournament_id
            AND tournament_name = '1990 FIFA World Cup'
            AND stage_name = 'final'
    ) AS t ON Stadiums.stadium_id = t.stadium_id;

--5--
SELECT
    count (*) AS num_goals
FROM
    goals
    JOIN players ON players.player_id = goals.player_id
    AND family_name = 'Ronaldo'
    AND given_name = 'Cristiano'
    AND own_goal = 'f';

--6--
SELECT
    tb.player_id,
    tb.family_name,
    tb.given_name,
    max(t) AS num_goals
FROM
    (
        select
            players.player_id,
            players.family_name,
            players.given_name,
            count(*) AS t
        FROM
            players
            JOIN (
                SELECT
                    *
                FROM
                    goals
                    JOIN (
                        SELECT
                            *
                        FROM
                            matches
                            JOIN tournaments ON tournaments.tournament_id = matches.tournament_id
                            AND year >= 2002
                            AND year <= 2018
                    ) AS t1 ON goals.match_id = t1.match_id
                    AND goals.own_goal = 'f'
            ) AS t2 ON t2.player_id = players.player_id
        group by
            players.player_id,
            players.family_name,
            players.given_name
    ) as tb
where
    t = (
        select
            max(t)
        from
            (
                select
                    count(*) as t
                FROM
                    players
                    JOIN (
                        SELECT
                            *
                        FROM
                            goals
                            JOIN (
                                SELECT
                                    *
                                FROM
                                    matches
                                    JOIN tournaments ON tournaments.tournament_id = matches.tournament_id
                                    AND year >= 2002
                                    AND year <= 2018
                            ) AS t1 ON goals.match_id = t1.match_id
                            AND goals.own_goal = 'f'
                    ) AS t2 ON t2.player_id = players.player_id
                group by
                    players.player_id,
                    players.family_name,
                    players.given_name
            ) as q
    )
group by
    tb.player_id,
    tb.family_name,
    tb.given_name;

--7--
select
    teams.team_id,
    team_name,
    max(t) as num_self_goals
FROM
    teams
    join goals on goals.player_team_id = teams.team_id
    and goals.own_goal = 't'
    join matches on matches.match_id = goals.match_id
    join tournaments t1 on t1.tournament_id = matches.tournament_id
where
    2 = (
        select
            count(distinct(year))
        from
            teams
            join goals on goals.player_team_id = teams.team_id
            and goals.own_goal = 't'
            join matches on matches.match_id = goals.match_id
            join tournaments t2 on t2.tournament_id = matches.tournament_id
            and t2.year >= t1.year
    )
    and t = (
        select
            max(t)
        from
            (
                SELECT
                    goals.player_team_id,
                    teams.team_name,
                    count(goals.player_team_id) as t
                from
                    goals
                    join teams on teams.team_id = goals.player_team_id
                    join matches on matches.match_id = goals.match_id
                    join tournaments on tournaments.tournament_id = matches.tournament_id
                where
                    own_goal = true
                    and tournaments.year >= 2010
                group by
                    teams.team_id,
                    goals.player_team_id,
                    teams.team_name
                order by
                    player_team_id
            ) as q
    )
group by
    teams.team_id,
    team_name;