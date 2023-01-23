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
            tb.given_name
;