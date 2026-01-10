/*Understanding the relationship between lifestyle behaviors and psychological well‑being is central to mental 
health research. In this analysis, we examine whether the amount of daily physical activity is associated with 
better sleep quality and higher mood levels. By grouping individuals into low, moderate, and high activity 
categories, and comparing their average sleep duration and mood scores, we aim to identify clear patterns that 
highlight the role of exercise in rest and emotional balance. We also extend the analysis to consider the 
influence of daily screen time, as excessive digital exposure may compete with opportunities for physical activity 
and thereby affect both sleep and mood outcomes.
*/

-- Is physical activity time associated with better sleep quality and higher mood level?

SELECT min(physical_activity_min), max(physical_activity_min)
FROM mental_health_social_media_correct;

-- Min physical_activity_min = 8
-- Max physical_activity_min = 46

-- Approach: Group users by ranges of physical_activity_min and compare average sleep_quality and mood_level.

SELECT
    CASE
        WHEN physical_activity_min < 15 THEN 'Low activity ( < 15 min)'
        WHEN physical_activity_min BETWEEN 15 AND 30 THEN 'Moderate activity (15–30 min)'
        ELSE 'High activity (> 30 min)'
    END AS activity_group,
    AVG(sleep_hours) AS avg_sleep_hours,
    AVG(mood_level) AS avg_mood,
    COUNT(*) AS user_count
FROM mental_health_social_media_correct
GROUP BY activity_group
ORDER BY avg_sleep_hours;

-- There is a clear positive association between physical activity and both sleep duration and mood level.
-- As physical activity increases, individuals tend to sleep longer and report higher mood scores.

-- This suggests that regular physical activity contributes to better rest and emotional well‑being in this dataset.

--Now that we found that higher physical activity is associated with longer sleep and better mood, 
--I want to analyse whether daily screen time also plays a role. My reasoning is that individuals who spend more 
--time on screens may simply have less available time for physical activity, which could limit the benefits observed.
--In other words, excessive screen exposure might act as a competing factor, reducing opportunities for exercise 
--and thereby influencing both sleep quality and mood levels.

SELECT
    CASE
        WHEN physical_activity_min < 15 THEN 'Low activity (8–14 min)'
        WHEN physical_activity_min BETWEEN 15 AND 30 THEN 'Moderate activity (15–30 min)'
        ELSE 'High activity (31–46 min)'
    END AS activity_group,
    AVG(daily_screen_time_min) AS avg_screen_time,
    AVG(sleep_hours) AS avg_sleep_hours,
    AVG(mood_level) AS avg_mood,
    COUNT(*) AS user_count
FROM mental_health_social_media_correct
GROUP BY activity_group
ORDER BY avg_sleep_hours;

--There is a clear inverse relationship between screen time and physical activity:
	-- More screen time → less activity → shorter sleep and lower mood.
	-- Less screen time → more activity → longer sleep and higher mood.

--This supports my reasoning: excessive screen exposure reduces the time available for physical activity, 
--which in turn negatively impacts sleep quality and emotional well‑being.


-- Do people who sleep less systematically have higher anxiety levels?
-- Approach: Split sleep_hours into multiple intervals and compare average anxiety_level

SELECT
    CASE
        WHEN sleep_hours BETWEEN 6.4 AND 6.7 THEN 'Very short sleep (6.4–6.7h)'
        WHEN sleep_hours BETWEEN 6.8 AND 7.1 THEN 'Short sleep (6.8–7.1h)'
        WHEN sleep_hours BETWEEN 7.2 AND 7.5 THEN 'Moderate sleep (7.2–7.5h)'
        WHEN sleep_hours BETWEEN 7.6 AND 7.9 THEN 'Longer sleep (7.6–7.9h)'
        ELSE 'Longest sleep (8.0–8.3h)'
    END AS sleep_group,
    AVG(anxiety_level) AS avg_anxiety,
    COUNT(*) AS user_count
FROM mental_health_social_media_correct
GROUP BY sleep_group
ORDER BY avg_anxiety;

-- There is a clear inverse relationship: as sleep duration increases, average anxiety levels decrease.
-- Individuals with the shortest sleep (6.4–6.7h) show the highest anxiety levels.
-- Conversely, those with the longest sleep (8.0–8.3h) report the lowest anxiety levels.
-- The trend is progressive and consistent: each additional sleep interval is associated with a reduction in anxiety.

-- shorter sleep duration is consistently associated with higher anxiety levels. 
-- Although not every individual with reduced sleep shows elevated anxiety, the group averages reveal a clear 
-- downward trend: from ~2.95 in the shortest sleep group to ~1.53 in the longest sleep group. 
-- This supports the hypothesis that insufficient sleep contributes to greater anxiety.


--Can we identify typical lifestyle profiles (clusters) across different age groups, for example younger individuals 
--with short sleep and high anxiety versus older adults with longer sleep, higher activity, and lower anxiety?

SELECT
    CASE
        WHEN physical_activity_min < 15 THEN 'Low activity'
        WHEN physical_activity_min BETWEEN 15 AND 30 THEN 'Moderate activity'
        ELSE 'High activity'
    END AS activity_group,
    CASE
        WHEN sleep_hours < 7 THEN 'Short sleep'
        WHEN sleep_hours BETWEEN 7 AND 8 THEN 'Normal sleep'
        ELSE 'Long sleep'
    END AS sleep_group,
    CASE
        WHEN anxiety_level >= 3 THEN 'High anxiety'
        ELSE 'Low anxiety'
    END AS anxiety_group,
    AVG(age) AS avg_age,
    COUNT(*) AS user_count
FROM mental_health_social_media_correct
GROUP BY activity_group, sleep_group, anxiety_group
ORDER BY activity_group, sleep_group, anxiety_group;

-- The youngest group (18–22 years) is mainly found in profiles with low or moderate activity combined with short 
-- sleep, often accompanied by high anxiety.
-- Young adults (28–30 years) show a clear distinction between “balanced” profiles (normal sleep + low anxiety) 
-- and “stressed” profiles (normal sleep + high anxiety).
-- Adults (40–45 years) who are active and have normal sleep generally present low levels of anxiety.
-- Seniors (57+) stand out with a very positive profile: high activity, long sleep, and low anxiety.

-- The analysis reveals age‑linked lifestyle profiles. Younger groups (18–22 years) are more likely to combine 
-- short sleep and high anxiety, especially when activity levels are low or moderate. In contrast, older adults 
-- and seniors tend to show healthier profiles, with higher activity, longer sleep, and lower anxiety. 
-- This suggests that lifestyle factors such as physical activity and sleep duration play a protective role 
--against anxiety, and that these protective patterns become more evident with age

/* Conclusion 
Higher physical activity is linked to longer sleep and better mood, while excessive screen time reduces these 
benefits. Age‑specific profiles also emerge: younger individuals often show short sleep and high anxiety, 
young adults split between balanced and stressed profiles, adults in their 40s remain active with low anxiety, 
and seniors stand out with the healthiest lifestyle—high activity, long sleep, and low anxiety.
*/
