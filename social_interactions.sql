/*
Understanding the impact of social interactions on mental well‑being is crucial for 
identifying potential risk factors. In this analysis, we examine whether individuals with 
more negative interactions tend to have a more fragile mental state. By grouping users 
according to the number of negative interactions and comparing the distribution of mental states, 
we aim to highlight patterns that reveal how adverse social experiences may influence stress, 
anxiety, and overall psychological resilience.
*/

-- Do people with more negative interactions have a more fragile mental_state?

SELECT min(negative_interactions_count), max(negative_interactions_count), 
		min(positive_interactions_count), max(positive_interactions_count)
FROM mental_health_social_media_correct;

-- The minimum negative_interactions_count is 0 and the max is 2 
-- The minimum positive_interactions_count is 0 and the max is 4


-- Approach: Group by exact negative_interactions_count and compare the distribution of mental_state.

SELECT
    negative_interactions_count,
    mental_state,
    COUNT(*) AS user_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY negative_interactions_count), 2) AS percentage
FROM mental_health_social_media_correct
GROUP BY negative_interactions_count, mental_state
ORDER BY negative_interactions_count, user_count DESC;

--The analysis shows that the majority of users are already classified as “Stressed” even when they report zero negative interactions (65.5%). A smaller proportion are categorized as “Healthy” (29.5%) or “At_Risk” (5%).
--Once users report one or two negative interactions, the distribution shifts entirely: 100% of individuals are classified as “Stressed.”

--These results suggest a strong association between negative interactions and a fragile mental state. However, it is important to remain cautious in interpretation:
	--Stress is already the dominant mental state even in the absence of negative interactions.
	--Therefore, we cannot conclude that negative interactions are the primary cause of stress.
	--Instead, they appear to act as an aggravating factor, reinforcing the likelihood of a fragile mental state.

--Negative interactions are associated with increased fragility of mental state, but they do not fully explain the high prevalence of stress observed across the dataset.


-- Do positive interactions compensate for the effects of negative interactions on stress and anxiety?
-- Approach: Group users by both positive_interactions_count and negative_interactions_count
-- Then compare average stress_level and anxiety_level across groups.

SELECT
    negative_interactions_count,
    positive_interactions_count,
    AVG(stress_level) AS avg_stress,
    AVG(anxiety_level) AS avg_anxiety,
    COUNT(*) AS user_count
FROM mental_health_social_media_correct
GROUP BY negative_interactions_count, positive_interactions_count
ORDER BY negative_interactions_count, positive_interactions_count;

-- Negative interactions dominate: Even a single negative interaction is associated with a 
-- sharp increase in stress and anxiety.

-- Positive interactions do not compensate: Contrary to expectations, higher numbers of 
-- positive interactions do not reduce stress or anxiety. Instead, stress and anxiety continue 
-- to rise alongside them.

-- The presence of negative interactions appears to outweigh the potential benefits of positive ones,
-- suggesting that avoiding negative experiences is more critical for mental well-being than 
-- simply increasing positive interactions.


-- Do differences exist by gender in how interactions influence well-being?
-- Approach: Group by gender and interaction levels, then compare average stress, anxiety, and mood.

SELECT
    gender,
    negative_interactions_count,
    positive_interactions_count,
    AVG(stress_level) AS avg_stress,
    AVG(anxiety_level) AS avg_anxiety,
    AVG(mood_level) AS avg_mood,
    COUNT(*) AS user_count
FROM mental_health_social_media_correct
GROUP BY gender, negative_interactions_count, positive_interactions_count
ORDER BY gender, negative_interactions_count, positive_interactions_count;

-- General trend (all genders combined)
	--As the number of negative interactions increases, stress and anxiety rise, 
	--while mood decreases.
	
-- Comparison by gender
	-- The averages are very close across genders.
	-- Differences are minimal (often <0.1 point), suggesting that gender is not a major 
	-- differentiating factor in this dataset

-- Mood levels
	-- Mood consistently declines with more negative interactions across all genders.
	-- Gender differences remain marginal

-- Social interactions (mostly negative) strongly influence well‑being indicators such as stress, 
-- anxiety, and mood.
-- Gender does not significantly alter this relationship: the trends are nearly identical 
-- across groups.
-- This suggests that, in this dataset, the impact of social interactions on well‑being 
-- is universal, with no notable gender‑based differences

/*
Conclusion
The findings show that while negative interactions are strongly associated with a fragile 
mental state, stress is already the dominant condition even among users with zero negative 
interactions. This indicates that negative interactions act more as an aggravating factor 
than as the sole cause of stress. Furthermore, positive interactions do not appear to compensate 
for the effects of negative ones, as stress and anxiety continue to rise alongside them. Finally, 
the influence of social interactions on well‑being is consistent across genders, suggesting that 
the universal impact of negative interactions outweighs demographic differences. Overall, avoiding 
negative social experiences emerges as more critical for mental health than simply increasing 
positive interactions.
*/	



