# ravenstack-saas-analysis

An end-to-end data analysis project analysing churn, revenue, and product usage 
for RavenStack, a fictional SaaS startup. Built using SQL, Python, and Power BI.

## Tools Used
- **PostgreSQL** — data storage and querying
- **SQL** — data quality checks and business analysis
- **Python** (pandas, matplotlib, seaborn) — data visualisation
- **Power BI** — interactive dashboard

## Dataset
Synthetic SaaS dataset by River @ Rivalytics containing 5 tables:
- 500 accounts
- 5,000 subscriptions
- 25,000 feature usage events
- 2,000 support tickets
- 600 churn events

## Project Structure
```
├── data/                      # Raw CSV files
├── load_data.py               # Loads CSVs into PostgreSQL
├── analysis.sql               # Data quality checks + 8 business queries
├── analysis.ipynb             # Python visualisations
└── ravenstack_dashboard.pbix  # Power BI dashboard
```

## Key Findings
1. **Enterprise dominates revenue** — 74.7% of total MRR despite being one of three plan tiers
2. **DevTools has the highest churn** — 22.3% churn rate vs 16% for Cybersecurity
3. **Features and support drive churn** — not pricing or competition
4. **Organic acquisition outperforms paid** — highest average MRR per customer at $2,392
5. **Pro plan has worst downgrade ratio** — highest risk tier for revenue loss
6. **Support ticket volume does not predict churn** — churned and non-churned accounts raise similar numbers of tickets

## Data Quality Notes
- 825 satisfaction scores are null (41%) — customers who did not respond to surveys
- 2 accounts have 3 churn events each — likely reactivation cycles, retained in analysis
- No orphaned records, duplicate primary keys, or invalid date ranges found
