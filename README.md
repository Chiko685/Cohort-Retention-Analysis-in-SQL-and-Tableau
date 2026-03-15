# Cohort Analysis: Tracking Customer Retention (Big Query and Tableau)

## 📌 Project Overview
This project focuses on analyzing customer retention and purchasing behavior for an online retail business. 
By conducting a Cohort Analysis, I evaluated how well the business retains its customers month-over-month after their initial purchase. 
The insights from this analysis can be used to optimize marketing strategies, improve product engagement, and reduce customer churn.

## 🛠️ Tools & Technologies
* **Data Extraction & Cleaning:** Google BigQuery (SQL)
* **Data Visualization:** Tableau Public
* **Dataset:** Online Retail Dataset (500k+ transactional records)

## 🔍 Methodology
1.  **Data Cleaning (SQL):** Handled missing values (e.g., NULL Customer IDs) and removed duplicate transactions using Common Table Expressions (CTEs) and Window Functions (`ROW_NUMBER`). After that, I created a new clean table to begin my cohort analysis.



2.  **Cohort Transformation (SQL):** Extracted the first purchase month for each user (`DATE_TRUNC`) and calculated the month-over-month difference (`DATE_DIFF`) to generate a Cohort Index for every transaction.
3.  **Visualization (Tableau):** Built a heatmap matrix to visualize the retention rate percentage across 13 distinct cohort groups.

## 📊 Dashboard & Visualization
You can view the interactive Tableau dashboard here: [Insert Your Tableau Public Link Here]

## 💡 Key Insights
* **Highest Retention:** The cohort from [Insert Month/Year] showed the strongest retention rate at [Insert %], suggesting that marketing campaigns or product updates during this period were highly effective.
* **Drop-off Point:** Across all cohorts, the most significant drop-off occurs during the [Insert Number] month after the initial purchase.
* *Add 1-2 more insights based on what your Tableau heatmap shows.*

## 📬 Contact
**Ika Wahyuni** * [LinkedIn Profile Link]
* [Email Address]
