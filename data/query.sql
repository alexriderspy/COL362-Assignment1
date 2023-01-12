SELECT
    tournament_id,
    tournament_name,
    year,
    winner
FROM
    Tournaments
WHERE
    host_country = winner;

SELECT
    *
FROM
    Players
WHERE
    count_tournaments >= 4;

SELECT
    COUNT(*)
FROM
    Matches
    JOIN Teams ON (
        Matches.home_team_id = Teams.team_id
        OR Matches.away_team_id = Teams.team_id
    )
WHERE
    Teams.team_name = 'Croatia'
    AND Matches.draw = 't';

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

SELECT
    count (*)
FROM
    goals
    JOIN players ON players.player_id = goals.player_id
    AND family_name = 'Ronaldo'
    AND given_name = 'Cristiano'
    AND own_goal = 'f';

