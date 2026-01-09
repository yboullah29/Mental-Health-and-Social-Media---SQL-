## Preparation and Cleaning of the Table

--Duplicate Check

--To ensure the uniqueness of records, several SQL queries were tested.
--At first, the search for duplicates was performed only on the columns person_name and date:

SELECT *
FROM mental_health_social_media_dataset
WHERE (person_name, date) IN (
    SELECT person_name, date
    FROM mental_health_social_media_dataset
    GROUP BY person_name, date
    HAVING COUNT(*) > 1
)
ORDER BY person_name;

--This query did return results, but they were false duplicates: some individuals appeared multiple times at different dates or using different platforms, which is normal in the context of longitudinal tracking.
--To refine the detection, the column age was added

SELECT *
FROM mental_health_social_media_dataset
WHERE (person_name, date, age) IN (
    SELECT person_name, date, age
    FROM mental_health_social_media_dataset
    GROUP BY person_name, date, age
    HAVING COUNT(*) > 1
)
ORDER BY person_name;

--However, this approach still produced ambiguous cases: two distinct individuals could share the same name, the same age, and the same date of recording, but differ by gender.
--The final solution was therefore to also include the column gender, which defines a complete logical key


SELECT *
FROM mental_health_social_media_dataset
WHERE (person_name, date, age, gender) IN (
    SELECT person_name, date, age, gender
    FROM mental_health_social_media_dataset
    GROUP BY person_name, date, age, gender
    HAVING COUNT(*) > 1
)
ORDER BY person_name;

--The verification process showed that duplicate detection cannot be limited to one or two columns. Only the combination person_name + age + date + gender ensures reliable identification of duplicates and avoids false positives.

--Conclusion
--The analysis demonstrated that there are no real duplicates in the dataset. To facilitate the identification and manipulation of rows in the database, it is preferable to add a technical primary key in the form of an auto‑incremented identifier (id). This unique identifier simplifies queries, improves readability, and makes it easier to manage relationships between tables.


--Verification of NULL Values

--The following query was used to check for missing values (NULL) across all columns of the dataset:

SELECT
    SUM(CASE WHEN person_name IS NULL THEN 1 ELSE 0 END) AS null_person_name,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN platform IS NULL THEN 1 ELSE 0 END) AS null_platform,
    SUM(CASE WHEN daily_screen_time_min IS NULL THEN 1 ELSE 0 END) AS null_daily_screen_time,
    SUM(CASE WHEN social_media_time_min IS NULL THEN 1 ELSE 0 END) AS null_social_media_time,
    SUM(CASE WHEN negative_interactions_count IS NULL THEN 1 ELSE 0 END) AS null_negative_interactions,
    SUM(CASE WHEN positive_interactions_count IS NULL THEN 1 ELSE 0 END) AS null_positive_interactions,
    SUM(CASE WHEN sleep_hours IS NULL THEN 1 ELSE 0 END) AS null_sleep_hours,
    SUM(CASE WHEN physical_activity_min IS NULL THEN 1 ELSE 0 END) AS null_physical_activity,
    SUM(CASE WHEN anxiety_level IS NULL THEN 1 ELSE 0 END) AS null_anxiety_level,
    SUM(CASE WHEN stress_level IS NULL THEN 1 ELSE 0 END) AS null_stress_level,
    SUM(CASE WHEN mood_level IS NULL THEN 1 ELSE 0 END) AS null_mood_level,
    SUM(CASE WHEN mental_state IS NULL THEN 1 ELSE 0 END) AS null_mental_state
FROM mental_health_social_media_dataset;

--The output of this query showed 0 for all columns, meaning that there are no NULL values in the dataset.

--Conclusion
--This verification confirms that the dataset is complete and consistent, with no missing entries across personal information, digital usage, social interactions, or health indicators. This is an important quality check, as it ensures that subsequent analyses will not be biased or distorted by missing data.


--Detection of Abnormal Values in Numeric Columns

--The following query was designed to identify outliers in the dataset by checking whether numeric values fall outside logical or expected ranges:

SELECT
    SUM(CASE WHEN age < 3 OR age > 110 THEN 1 ELSE 0 END) AS outlier_age,
    SUM(CASE WHEN daily_screen_time_min < 0 OR daily_screen_time_min > 1440 THEN 1 ELSE 0 END) AS outlier_daily_screen_time,
    SUM(CASE WHEN social_media_time_min < 0 OR social_media_time_min > 1440 THEN 1 ELSE 0 END) AS outlier_social_media_time,
    SUM(CASE WHEN negative_interactions_count < 0 THEN 1 ELSE 0 END) AS outlier_negative_interactions,
    SUM(CASE WHEN positive_interactions_count < 0 THEN 1 ELSE 0 END) AS outlier_positive_interactions,
    SUM(CASE WHEN sleep_hours < 0 OR sleep_hours > 24 THEN 1 ELSE 0 END) AS outlier_sleep_hours,
    SUM(CASE WHEN physical_activity_min < 0 OR physical_activity_min > 1440 THEN 1 ELSE 0 END) AS outlier_physical_activity,
    SUM(CASE WHEN anxiety_level < 0 OR anxiety_level > 10 THEN 1 ELSE 0 END) AS outlier_anxiety_level,
    SUM(CASE WHEN stress_level < 0 OR stress_level > 10 THEN 1 ELSE 0 END) AS outlier_stress_level,
    SUM(CASE WHEN mood_level < 0 OR mood_level > 10 THEN 1 ELSE 0 END) AS outlier_mood_level
FROM mental_health_social_media_dataset;

--The query returned 0 for all columns, meaning that no abnormal values were detected in the dataset.

--Conclusion
--This verification confirms that the dataset is clean and consistent with respect to numeric ranges. All values fall within logical boundaries (age, screen time, sleep, activity, and health indicators). This strengthens the reliability of subsequent analyses, as there are no distortions caused by outliers or unrealistic entries.


--Column Type Verification

--The following command was used to check the declared column types in the table:

PRAGMA table_info(mental_health_social_media_dataset);

--All columns are correctly typed (INTEGER, REAL, TEXT) according to the expected schema.
--The date column appears as TEXT rather than DATE.


--In SQLite, there is no native DATE type. Dates are typically stored as TEXT, REAL, or INTEGER.
--Therefore, using TEXT for the date column is correct and consistent with SQLite practices.

--Format Verification

--The date format in the dataset is currently MMDDYYYY.
--The goal was to transform it into DDMMYYYY for better readability and consistency.
--Since SQLite does not directly support date format conversions, a CTE (Common Table Expression) was used to extract the day, month, and year components and reconstruct them in the desired format.


--Creating a New Table from the Original Dataset

--Although the initial table did not contain errors (no NULL values, no abnormal values), I chose to recreate a new table from the original data in order to strengthen the schema and improve data quality.
--Enhancements applied:
--Constraints: Explicit rules were added on columns (NOT NULL, CHECK) to ensure data validity at the moment of insertion.
--Unique identifier: An id column with PRIMARY KEY AUTOINCREMENT was introduced to guarantee a reliable primary key and facilitate manipulation.
--Date handling: Since SQLite does not support a native DATE type, the date_record column is stored as TEXT.
--The original format was MM/DD/YYYY.
--I transformed it into DD/MM/YYYY for consistency.
--This transformation was achieved using a CTE (Common Table Expression) that extracts the day, month, and year components and reconstructs them in the desired format.

-- Create the new table with constraints
CREATE TABLE mental_health_social_media_correct (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    person_name TEXT NOT NULL,
    age INTEGER CHECK(age BETWEEN 0 AND 110),
    date_record TEXT NOT NULL, -- SQLite does not allow a DATE type
    gender TEXT CHECK(gender IN ('Male','Female','Other')),
    platform TEXT,
    daily_screen_time_min INTEGER CHECK(daily_screen_time_min >= 0 AND daily_screen_time_min <= 1440),
    social_media_time_min INTEGER CHECK(social_media_time_min >= 0 AND social_media_time_min <= daily_screen_time_min),
    negative_interactions_count INTEGER CHECK(negative_interactions_count >= 0),
    positive_interactions_count INTEGER CHECK(positive_interactions_count >= 0),
    sleep_hours REAL CHECK(sleep_hours BETWEEN 0 AND 24),
    physical_activity_min INTEGER CHECK(physical_activity_min >= 0 AND physical_activity_min <= 1440),
    anxiety_level INTEGER CHECK(anxiety_level BETWEEN 0 AND 10),
    stress_level INTEGER CHECK(stress_level BETWEEN 0 AND 10),
    mood_level INTEGER CHECK(mood_level BETWEEN 0 AND 10),
    mental_state TEXT CHECK(mental_state IN ('Stressed', 'Healthy', 'At_Risk'))
);

-- Insert data from the old table into the new one
-- The CTE "parts" reformats the date into DD/MM/YYYY
INSERT INTO mental_health_social_media_correct (
  person_name, age, date_record, gender, platform,
  daily_screen_time_min, social_media_time_min,
  negative_interactions_count, positive_interactions_count,
  sleep_hours, physical_activity_min,
  anxiety_level, stress_level, mood_level, mental_state
)
WITH parts AS (
  SELECT
    person_name,
    age,
    TRIM(date) AS d,
    gender,
    platform,
    daily_screen_time_min,
    social_media_time_min,
    negative_interactions_count,
    positive_interactions_count,
    sleep_hours,
    physical_activity_min,
    anxiety_level,
    stress_level,
    mood_level,
    mental_state,
    instr(TRIM(date), '/') AS p1,
    instr(substr(TRIM(date), instr(TRIM(date), '/') + 1), '/') AS p2s
  FROM mental_health_social_media_dataset
)
SELECT
  person_name,
  age,
  printf('%02d/%02d/%04d',
    CAST(substr(d, p1 + 1, (p1 + p2s) - p1 - 1) AS INTEGER), -- day
    CAST(substr(d, 1, p1 - 1) AS INTEGER),                   -- month
    CAST(CASE
      WHEN length(substr(d, (p1 + p2s) + 1)) = 2
        THEN '20' || substr(d, (p1 + p2s) + 1)
      ELSE substr(d, (p1 + p2s) + 1)
    END AS INTEGER)                                          -- year
  ) AS date_record,
  gender,
  platform,
  daily_screen_time_min,
  social_media_time_min,
  negative_interactions_count,
  positive_interactions_count,
  sleep_hours,
  physical_activity_min,
  anxiety_level,
  stress_level,
  mood_level,
  mental_state
FROM parts
WHERE p1 > 0 AND p2s > 0;

--I strengthened the schema by adding constraints, introducing a primary key, and ensuring consistent date formatting. The result is a more robust and reliable table, ready for further analysis.
--The table to use now is mental_health_social_media_correct 
