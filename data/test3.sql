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
            goals.player_team_id,
            teams.team_name
        order by
            player_team_id
