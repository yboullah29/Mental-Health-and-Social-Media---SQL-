--Preparation and Cleaning of the Table

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
