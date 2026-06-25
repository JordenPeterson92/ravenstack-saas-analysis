-- Nulls in every column in accounts table
SELECT 
  COUNT(*) - COUNT(account_id) AS null_account_id,
  COUNT(*) - COUNT(account_name) AS null_account_name,
  COUNT(*) - COUNT(industry) AS null_industry,
  COUNT(*) - COUNT(country) AS null_country,
  COUNT(*) - COUNT(signup_date) AS null_signup_date,
  COUNT(*) - COUNT(referral_source) AS null_referral_source,
  COUNT(*) - COUNT(plan_tier) AS null_plan_tier,
  COUNT(*) - COUNT(seats) AS null_seats
FROM accounts;

-- Unexpected values in categorical columns
SELECT DISTINCT industry FROM accounts;
SELECT DISTINCT referral_source FROM accounts;
SELECT DISTINCT plan_tier FROM accounts;

-- Negative or zero seats
SELECT * FROM accounts WHERE seats <= 0;

-- Future signup dates
SELECT * FROM accounts WHERE CAST(signup_date AS DATE) > CURRENT_DATE;

-- Nulls 
SELECT
  COUNT(*) - COUNT(subscription_id) AS null_sub_id,
  COUNT(*) - COUNT(account_id) AS null_account_id,
  COUNT(*) - COUNT(mrr_amount) AS null_mrr,
  COUNT(*) - COUNT(arr_amount) AS null_arr,
  COUNT(*) - COUNT(plan_tier) AS null_plan_tier
FROM subscriptions;

-- Negative MRR or ARR
SELECT * FROM subscriptions WHERE mrr_amount < 0 OR arr_amount < 0;

-- End date before start date
SELECT * FROM subscriptions WHERE end_date < start_date;

-- ARR should roughly equal MRR * 12
SELECT * FROM subscriptions 
WHERE ABS(arr_amount - mrr_amount * 12) > 10;

-- Orphaned subscriptions (no matching account)
SELECT s.subscription_id 
FROM subscriptions s
LEFT JOIN accounts a ON s.account_id = a.account_id
WHERE a.account_id IS NULL;


-- Nulls
SELECT
  COUNT(*) - COUNT(ticket_id) AS null_ticket_id,
  COUNT(*) - COUNT(account_id) AS null_account_id,
  COUNT(*) - COUNT(priority) AS null_priority,
  COUNT(*) - COUNT(resolution_time_hours) AS null_resolution_time,
  COUNT(*) AS total_rows,
  COUNT(*) - COUNT(satisfaction_score) AS null_satisfaction
FROM support_tickets;

-- Closed before opened
SELECT * FROM support_tickets WHERE closed_at < submitted_at;

-- Satisfaction score out of range
SELECT * FROM support_tickets 
WHERE satisfaction_score NOT BETWEEN 1 AND 5;

-- Negative resolution time
SELECT * FROM support_tickets WHERE resolution_time_hours < 0;

-- Unexpected priority values
SELECT DISTINCT priority FROM support_tickets;


-- Nulls
SELECT
  COUNT(*) - COUNT(churn_event_id) AS null_churn_id,
  COUNT(*) - COUNT(account_id) AS null_account_id,
  COUNT(*) - COUNT(churn_date) AS null_churn_date,
  COUNT(*) - COUNT(reason_code) AS null_reason_code
FROM churn_events;

-- Churn before signup
SELECT c.account_id
FROM churn_events c
JOIN accounts a ON c.account_id = a.account_id
WHERE c.churn_date < a.signup_date;

-- Negative refund amounts
SELECT * FROM churn_events WHERE refund_amount_usd < 0;

-- Unexpected reason codes
SELECT DISTINCT reason_code FROM churn_events;

-- Duplicate churn events per account
SELECT account_id, COUNT(*) 
FROM churn_events 
GROUP BY account_id 
HAVING COUNT(*) > 1;

-- End of data quality checks

-- Start of data analysis

-- Revenue per plan tier
SELECT
  plan_tier,
  COUNT(subscription_id) AS subscription_count,
  ROUND(SUM(mrr_amount)::numeric, 2) AS total_mrr,
  ROUND(SUM(arr_amount)::numeric, 2) AS total_arr
FROM subscriptions
GROUP BY plan_tier
ORDER BY total_mrr DESC;

-- Churn by industry
SELECT
  industry,
  COUNT(CASE WHEN churn_flag = true THEN 1 END) AS churned_accounts,
  COUNT(*) AS total_accounts,
  ROUND(COUNT(CASE WHEN churn_flag = true THEN 1 END) * 100.0 / COUNT(*), 1) AS churn_rate
FROM accounts
GROUP BY industry
ORDER BY churn_rate DESC;

-- Top 10 features
SELECT
	  feature_name,
	  SUM(usage_count) AS total_usage
FROM feature_usage
GROUP BY feature_name
ORDER BY total_usage DESC
LIMIT 10;

-- Referral source by mrr
SELECT 
	  a.referral_source,
	  COUNT(a.account_id) AS accounts_num,
	  ROUND(
	  	   AVG(s.mrr_amount), 2) AS avg_mrr_amount
FROM accounts a
LEFT JOIN subscriptions s 
	ON a.account_id = s.account_id
GROUP BY a.referral_source
ORDER BY avg_mrr_amount DESC;

-- Churn reasons
SELECT
	  reason_code,
	  COUNT(reason_code) AS reasonings_count
FROM churn_events
GROUP BY reason_code
ORDER BY reasonings_count DESC;

-- Support ticket analysis
SELECT
      priority AS priority,
	  ROUND(AVG(resolution_time_hours)::numeric, 2) AS avg_resolution_time_hours,
	  ROUND(AVG(satisfaction_score)::numeric, 2) AS avg_satisfaction_score
FROM support_tickets
GROUP BY priority
ORDER BY CASE priority
  WHEN 'urgent' THEN 1
  WHEN 'high' THEN 2
  WHEN 'medium' THEN 3
  WHEN 'low' THEN 4
END;

-- Upgrades vs downgrades by plan tier
SELECT
  plan_tier,
  SUM(CASE WHEN upgrade_flag = 'true' THEN 1 END) AS upgrade_count,
  SUM(CASE WHEN downgrade_flag = 'true' THEN 1 END) AS downgrade_count
FROM subscriptions
GROUP BY plan_tier
ORDER BY upgrade_count DESC;

--  Churn vs support tickets
WITH tickets_per_account AS (
  SELECT
    a.account_id,
    a.churn_flag,
    COUNT(s.ticket_id) AS ticket_count
  FROM accounts a
  LEFT JOIN support_tickets s
    ON a.account_id = s.account_id
  GROUP BY a.account_id, a.churn_flag
)
SELECT
  churn_flag,
  ROUND(AVG(ticket_count)::numeric, 2) AS avg_tickets
FROM tickets_per_account
GROUP BY churn_flag;






	  