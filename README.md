# Mental-Health-and-Social-Media---SQL-

## 📌 **Project Overview**
This project explores the impact of social media usage on mental health.
The dataset includes information about screen time, social interactions (positive and negative), sleep, physical activity, and psychological indicators such as anxiety, stress, mood, and overall mental state.
As a junior data analyst, I designed this project to showcase my skills in:
- Data cleaning and preparation
- Exploratory Data Analysis (EDA)
- Data visualization
- Feature creation and analytic storytelling
- Clear and reproducible documentation

---
## 📂 **Project Structure**

mental-health-social-media/

- README.md
- data/
  - social_media_mental_health.csv
  - data_preparation_cleaning.sql
- sql_queries/
  - digital_usage_wellbeing.sql
  - social_interactions.sql
  - physical_mental_health.sql
  - platform_behaviors.sql
  - advanced_insights.sql
- notebooks/
  - digital_usage_wellbeing.ipynb
  - social_interactions.ipynb
  - physical_mental_health.ipynb
  - platform_behaviors.ipynb
  - advanced_insights.ipynb
- visualizations/

## 📂 **Data Structure**

The dataset contains the following columns:
- person_name : Name or identifier of the person
- age	: Age of the individual in years
- date : The date on which the data was recorded
- gender : Gender of the user (Male, Female, Other)
- platform : Social media platform the person uses
- daily_screen_time_min : Total daily device screen time in minutes
- social_media_time_min : Total time spent on social media in minutes per day
- negative_interactions_count: Number of negative or harmful interactions experienced online per day
- positive_interactions_count	: Number of positive or supportive interactions experienced online per day
- sleep_hours	: Total number of hours the person sleeps per day
- physical_activity_min: Daily physical activity in minutes per day
- anxiety_level: Self-reported anxiety score (scale from 0 to 10)
- stress_level: Self-reported stress score (scale from 0 to 10)
- mood_level: Self-reported mood score (scale from 0 to 10)
- mental_state: Target label : Healthy, At_Risk, or Stressed

## ⚙️ **Analysis Goals**

This project is designed to analyze multiple dimensions of how social media and digital habits affect mental health.
Through SQL queries and exploratory analysis, I will examine:
- Digital usage and well‑being: exploring how screen time and social media activity relate to stress, anxiety, mood, and sleep quality.
- Social interactions: assessing the impact of positive vs. negative interactions on mental state, and how these effects may vary across demographic groups.
- Physical and mental health: investigating the role of sleep and physical activity in shaping overall well‑being, and identifying typical behavioral profiles.
- Platform behaviors: comparing usage patterns and interaction quality across different social media platforms.
- Advanced insights: building composite indicators (e.g., a Digital Well‑Being Index), testing predictive factors of mental state, and highlighting at‑risk population segments.
The goal is to generate meaningful insights that show how raw data can be transformed into actionable knowledge about well‑being in the digital age.

## 📚 **Limitations**

- No data cleaning required: The original dataset did not contain NULL values or abnormal entries, so no additional cleaning steps were necessary.
- SQLite constraints: Since the project was implemented in SQLite, several limitations had to be considered:
  - Restricted functions: SQLite does not support all advanced SQL functions available in other RDBMS
  - No native DATE type: Dates must be stored as TEXT, REAL, or INTEGER. In this project, dates were stored as TEXT.
  - Date format conversion: The original format (MM/DD/YYYY) was transformed into DD/MM/YYYY using a Common Table Expression (CTE). This process is more complex in SQLite                                 compared to databases with built-in date formatting functions.

## 🛠️ **Tools and Technologies**

- SQL for querying and insight generation
- Python (pandas, numpy, matplotlib, seaborn) for deeper analysis and visualization
- Jupyter Notebook for exploration and documentation
- Markdown for presenting results

## 📚 **Source**
The dataset used in this project was obtained from Kaggle:
https://www.kaggle.com/datasets/sonalshinde123/social-media-mental-health-indicators-dataset/data 







