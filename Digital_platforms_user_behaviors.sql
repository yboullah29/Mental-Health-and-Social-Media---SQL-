/*
This study compares user engagement across major social media platforms by analyzing average daily usage, 
frequency of negative interactions, and distribution of mental states. The goal is to identify whether certain 
platforms are associated with heavier time investment, more conflictual exchanges, or distinct patterns of 
well‑being. By grouping users according to platform, we can highlight differences in how digital environments 
shape both behavior and reported mental health outcomes.
*/

-- Compare average social media time by platform

SELECT
    platform,
    AVG(social_media_time_min) AS avg_social_media_time,
    COUNT(*) AS user_count
FROM mental_health_social_media_correct
GROUP BY platform
ORDER BY avg_social_media_time DESC;

/*
“The analysis reveals clear differences in social media engagement across platforms. TikTok and YouTube dominate in 
terms of daily usage, suggesting highly immersive experiences. Snapchat and Instagram occupy a middle ground, while 
Twitter and Facebook show more moderate engagement. WhatsApp is used more sparingly, reflecting its role as a 
communication tool rather than a time‑intensive social platform.”
*/


-- Compare average negative interactions across platforms

SELECT
    platform,
    AVG(negative_interactions_count) AS avg_negative_interactions,
    SUM(negative_interactions_count) AS total_negative_interactions,
    COUNT(*) AS user_count,
    SUM(negative_interactions_count) * 1.0 / COUNT(*) AS neg_interactions_per_user
FROM mental_health_social_media_correct
GROUP BY platform
ORDER BY avg_negative_interactions DESC;

/* 
- TikTok stands out with the highest rate of negative interactions, suggesting a more conflictual or emotionally 
charged environment.
- Twitter and YouTube follow closely, both showing nearly one negative interaction per user, consistent with their 
reputation for open comment threads and debates.
- Snapchat and Instagram are slightly lower, but still above Facebook.
- Facebook shows fewer negative interactions, possibly reflecting its more established user base and different 
usage patterns.
- WhatsApp is by far the lowest, which makes sense since it is primarily used for private messaging rather than 
public interactions.

This suggests that platform design and social dynamics strongly influence the likelihood of negative exchanges
*/


-- Compare average mental state across platforms

SELECT
    platform,
    mental_state,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY platform), 2) AS percentage
FROM mental_health_social_media_correct
GROUP BY platform, mental_state
ORDER BY platform, percentage DESC;

/*
- TikTok stands out as the most negative environment, with all users classified as Stressed.
- Instagram, Snapchat, and YouTube also show extremely high proportions of stressed users (>95%), suggesting 
these platforms are strongly associated with negative mental states.
- Twitter is slightly less extreme, but still dominated by stressed users (~93%).
- Facebook and WhatsApp show more diversity: while stress is still the majority (~80%), they also have notable 
shares of Healthy and At_Risk users.

The analysis shows that stress is overwhelmingly present across all platforms, with more than 80% of users 
classified as stressed. While small differences exist between platforms, these results suggest that mental 
state cannot be directly attributed to the choice of platform, since high stress levels are consistently observed 
everywhere.”
*/

/*
Conclusion
The results reveal clear contrasts in usage and interaction dynamics: TikTok and YouTube dominate in daily time 
spent, while WhatsApp is used more sparingly. Negative interactions are most frequent on TikTok, Twitter, and 
YouTube, reflecting their open and debate‑driven environments, whereas WhatsApp shows the lowest levels. However, 
when examining mental states, stress emerges as the dominant profile across all platforms, consistently above 80%. 
This suggests that while platforms differ in engagement intensity and interaction style, the prevalence of stress 
is a common feature, indicating that mental state cannot be directly attributed to platform choice alone.
*/
