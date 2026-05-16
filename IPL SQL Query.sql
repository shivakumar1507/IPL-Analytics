-- Top Run Scorers
SELECT 
    batter,
    SUM(runs_batter) AS total_runs
FROM IPL_BALL_BY_BALL
GROUP BY batter
ORDER BY total_runs DESC
LIMIT 10;

-- Most Successful Teams
SELECT 
    match_won_by,
    COUNT(DISTINCT match_id) AS total_wins
FROM IPL_BALL_BY_BALL
WHERE match_won_by IS NOT NULL
GROUP BY match_won_by
ORDER BY total_wins DESC;

-- Highest Scoring Venues
SELECT 
    venue,
    ROUND(AVG(team_runs),2) AS avg_score
FROM IPL_BALL_BY_BALL
GROUP BY venue
ORDER BY avg_score DESC;

-- Players With Best Strike Rate
SELECT 
    batter,
    SUM(runs_batter) AS total_runs,
    COUNT(ball_no) AS balls_faced,
    ROUND(
        SUM(runs_batter) * 100.0 /
        COUNT(ball_no),
    2) AS strike_rate
FROM IPL_BALL_BY_BALL
GROUP BY batter
ORDER BY strike_rate DESC
LIMIT 10;

-- Most Sixes
SELECT 
    batter,
    COUNT(*) AS total_sixes
FROM IPL_BALL_BY_BALL
WHERE runs_batter = 6
GROUP BY batter
ORDER BY total_sixes DESC
LIMIT 10;

-- Most Wickets
SELECT 
    bowler,
    COUNT(player_out) AS wickets
FROM IPL_BALL_BY_BALL
WHERE player_out IS NOT NULL
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;

-- Toss Decision Analysis
SELECT 
    toss_decision,
    COUNT(DISTINCT match_id) AS total_matches
FROM IPL_BALL_BY_BALL
GROUP BY toss_decision;

-- Season-wise Total Runs
SELECT 
    season,
    SUM(runs_total) AS total_runs
FROM IPL_BALL_BY_BALL
GROUP BY season
ORDER BY season;

-- Team Win Percentage
SELECT 
    match_won_by,
    COUNT(DISTINCT match_id) AS wins,
    ROUND(
        COUNT(DISTINCT match_id) * 100.0 /
        (
            SELECT COUNT(DISTINCT match_id)
            FROM IPL_BALL_BY_BALL
        ),
    2) AS win_percentage
FROM IPL_BALL_BY_BALL
WHERE match_won_by IS NOT NULL
GROUP BY match_won_by
ORDER BY wins DESC;

-- Powerplay vs Death Overs Runs
SELECT
    CASE
        WHEN over_no <= 5 THEN 'Powerplay'
        WHEN over_no <= 14 THEN 'Middle Overs'
        ELSE 'Death Overs'
    END AS match_phase,

    SUM(runs_total) AS total_runs

FROM IPL_BALL_BY_BALL
GROUP BY
    CASE
        WHEN over_no <= 5 THEN 'Powerplay'
        WHEN over_no <= 14 THEN 'Middle Overs'
        ELSE 'Death Overs'
    END;

-- Orange Cap Winners By Season
SELECT season, batter, total_runs
FROM (
    SELECT 
        season,
        batter,
        SUM(runs_batter) AS total_runs,
        RANK() OVER (
            PARTITION BY season
            ORDER BY SUM(runs_batter) DESC
        ) AS rnk
    FROM IPL_BALL_BY_BALL
    GROUP BY season, batter
) t
WHERE rnk = 1;