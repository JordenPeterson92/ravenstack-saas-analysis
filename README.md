# RavenStack SaaS Analysis

> **Why are RavenStack's customers churning, and where should the company focus to protect its revenue?**

RavenStack is a fictional SaaS startup. This project works through its accounts, subscriptions, product usage, support and churn data to answer that question end to end, using SQL, Python and Power BI.

## The Short Answer

Customers are leaving because of **product gaps and support experience, not price or competitors**. The risk is concentrated in the **DevTools industry** and the **Pro plan**, while revenue depends heavily on **Enterprise**. RavenStack should prioritise feature development and support quality for these segments, and lean into organic acquisition, which brings in the highest-value customers.

## Breaking the Question Down

### 1. Where does the revenue come from?
**Enterprise accounts generate 74.7% of total MRR**, despite being one of three plan tiers. Losing Enterprise customers is the single biggest revenue threat.

### 2. Who is churning?
**DevTools has the highest churn rate at 22.3%**, compared with 16% for Cybersecurity, the lowest. Churn is not evenly spread, so retention efforts can be targeted.

### 3. Why are they churning?
**Missing features and support issues are the top churn reasons**, ahead of pricing and competition. Discounting is unlikely to fix the problem.

### 4. Does support ticket volume signal churn risk?
**No.** Churned and retained accounts raise similar numbers of tickets. Combined with finding 3, this suggests it's the *quality* of support that matters, not how often customers ask for help, so ticket counts alone shouldn't be used as an early warning signal.

### 5. Which plan is most at risk of losing revenue?
**The Pro plan has the worst downgrade ratio**, making it the tier most likely to shrink revenue even when customers don't fully churn.

### 6. Which acquisition channel brings in the best customers?
**Organic acquisition has the highest average MRR per customer at $2,392**, outperforming paid channels.

## Recommendations
- **Close feature gaps first**, starting with DevTools customers, where churn is highest.
- **Measure support quality, not volume.** Track resolution time and satisfaction rather than ticket counts.
- **Investigate Pro plan downgrades** to understand what customers feel they aren't getting.

## Approach

| Step | Tool | Output |
|---|---|---|
| Load raw CSVs into a database | Python, PostgreSQL | `load_data.py` |
| Data quality checks and 8 business queries | SQL | `analysis.sql` |
| Visualise findings | Python (pandas, matplotlib, seaborn) | `analysis.ipynb` |
| Interactive dashboard | Power BI | `ravenstack_dashboard.pbix` |

## Dataset
Synthetic SaaS dataset by River @ Rivalytics, containing 5 tables:
- 500 accounts
- 5,000 subscriptions
- 25,000 feature usage events
- 2,000 support tickets
- 600 churn events

## Data Quality Notes
- **825 satisfaction scores (41%) are null**, from customers who did not respond to surveys. This limits how far support satisfaction can be tied to churn.
- **2 accounts have 3 churn events each**, likely reactivation cycles. These were retained in the analysis.
- No orphaned records, duplicate primary keys or invalid date ranges were found.

## Project Structure
```
├── data/                      # Raw CSV files
├── load_data.py               # Loads CSVs into PostgreSQL
├── analysis.sql               # Data quality checks + 8 business queries
├── analysis.ipynb             # Python visualisations
└── ravenstack_dashboard.pbix  # Power BI dashboard
```
