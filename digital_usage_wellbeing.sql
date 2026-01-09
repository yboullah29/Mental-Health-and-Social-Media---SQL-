/*Digital usage has become a central aspect of daily life, raising important questions about its impact on mental health and well-being. 
In this analysis, we explore the relationship between screen time and key indicators such as anxiety, stress, mood, and sleep quality. 
Using SQL queries and statistical measures like the Pearson correlation coefficient, we aim to identify whether increased digital exposure is associated 
with negative outcomes, and if specific thresholds of usage can be linked to significant changes in well-being.
*/


-- Is there a correlation between screen time and anxiety/stress levels

-- This query calculates Pearson correlation coefficients (r) between:
-- 1. daily_screen_time_min and anxiety_level
-- 2. daily_screen_time_min and stress_level

-- The Pearson correlation coefficient to analyse the correlation :
-- r = (AVG(x*y) - AVG(x)*AVG(y)) / (σx * σy)
-- where σx and σy are the standard deviations of x and y.
-- if r = 1 : positive correlation 
-- if r = -1 : negative correlation
-- if r = 0 : no correlation 

SELECT
    -- Correlation with anxiety
    (
        (AVG(daily_screen_time_min * anxiety_level) - AVG(daily_screen_time_min) * AVG(anxiety_level))
        /
        (sqrt(AVG(daily_screen_time_min * daily_screen_time_min) - AVG(daily_screen_time_min) * AVG(daily_screen_time_min))
         * sqrt(AVG(anxiety_level * anxiety_level) - AVG(anxiety_level) * AVG(anxiety_level)))
    ) AS corr_screen_anxiety,

    -- Correlation with stress
    (
        (AVG(daily_screen_time_min * stress_level) - AVG(daily_screen_time_min) * AVG(stress_level))
        /
        (sqrt(AVG(daily_screen_time_min * daily_screen_time_min) - AVG(daily_screen_time_min) * AVG(daily_screen_time_min))
         * sqrt(AVG(stress_level * stress_level) - AVG(stress_level) * AVG(stress_level)))
    ) AS corr_screen_stress
FROM mental_health_social_media_correct;

--Results : 
-- corr_screen_anxiety = 0.629 : This indicates a moderately strong positive correlation. As daily screen time increases, anxiety levels also tend to rise.
-- corr_screen_stress = 0.835 : This shows a very strong positive correlation. Longer screen time is strongly associated with higher stress levels.


-- Do users who spend more time on social media have a lower or higher mood_level?
-- Approach: Compare average mood_level across groups of social_media_time_min
-- We use a simple grouping strategy: low vs high social media usage.

SELECT
    CASE
        WHEN social_media_time_min < 120 THEN 'Low usage (<2h)'
        WHEN social_media_time_min BETWEEN 120 AND 240 THEN 'Moderate usage (2-4h)'
        ELSE 'High usage (>4h)'
    END AS usage_group,
    AVG(mood_level) AS avg_mood_level,
    COUNT(*) AS user_count
FROM mental_health_social_media_correct
GROUP BY usage_group
ORDER BY avg_mood_level;

--Users with low social media usage (<2h) report the highest average mood level (6.40).
--Users with moderate usage (2–4h) have a lower average mood (5.63).
--Users with high usage (>4h) show the lowest average mood (4.68).

--This suggests a negative relationship: the more time users spend on social media, the lower their average mood level.


-- Is there a threshold of screen time beyond which sleep_hours decreases significantly?
-- Approach: Group users by screen time ranges and compare average sleep_hours.
-- Categories: Low (<2h), Moderate (2-4h), High (4-6h), Very High (>6h)

SELECT
    CASE
        WHEN daily_screen_time_min < 120 THEN 'Low (<2h)'
        WHEN daily_screen_time_min BETWEEN 120 AND 240 THEN 'Moderate (2-4h)'
        WHEN daily_screen_time_min BETWEEN 241 AND 360 THEN 'High (4-6h)'
        ELSE 'Very High (>6h)'
    END AS screen_time_group,
    AVG(sleep_hours) AS avg_sleep_hours,
    COUNT(*) AS user_count
FROM mental_health_social_media_correct
GROUP BY screen_time_group
ORDER BY avg_sleep_hours;

--Users with low screen time (<2h30) sleep the longest (8.3h on average).
--Sleep duration decreases progressively as screen time increases.
--The threshold effect appears clearly: once daily screen time exceeds 4–6 hours, average sleep drops below 7.5h, and falls further to 6.77h for very high usage (>6h).

--Excessive screen exposure (above ~4h per day) is strongly associated with reduced sleep quality.


/* Conclusion

The results highlight consistent patterns:
- Screen time and anxiety/stress: Longer daily screen exposure is positively correlated with higher anxiety (r = 0.629) and stress (r = 0.835).
- Social media and mood: Users with higher social media usage report lower average mood levels, suggesting a negative relationship between time spent online 
and emotional well-being.
- Screen time and sleep: Sleep duration decreases progressively with increased screen time, with a clear threshold effect beyond 4–6 hours per day.
Overall, these findings suggest that excessive digital usage is strongly associated with reduced well-being, particularly in terms of stress, mood, 
and sleep quality. While moderate use may not show drastic effects, prolonged exposure appears to have significant negative consequences
*/
