CREATE DATABASE cloudtask_analysis;

USE cloudtask_analysis;

CREATE TABLE subscriptions (
    customer_id INT,
    plan VARCHAR(50),
    billing_cycle VARCHAR(20),
    industry VARCHAR(100),
    company_size VARCHAR(50),
    seats INT,
    monthly_revenue DECIMAL(12,2),
    acquisition_channel VARCHAR(100),
    region VARCHAR(100),
    signup_date DATE,
    churned BOOLEAN,
    churn_date DATE,
    churn_reason VARCHAR(255),
    support_tickets_12mo INT,
    nps_score INT,
    feature_usage_pct DECIMAL(5,2),
    upgraded BOOLEAN
);

CREATE TABLE monthly_revenue (
    month DATE,
    total_active_customers INT,
    new_customers INT,
    churned_customers INT,
    monthly_churn_rate_pct DECIMAL(5,2),
    total_mrr DECIMAL(12,2),
    avg_revenue_per_customer DECIMAL(10,2),
    customer_acquisition_cost DECIMAL(10,2)
);

select count(*) from cloudtask_analysis.monthly_revenue;

DESCRIBE cloudtask_analysis.monthly_revenue;

ALTER TABLE cloudtask_analysis.monthly_revenue
MODIFY COLUMN month VARCHAR(7);

DESCRIBE cloudtask_analysis.subscriptions;

ALTER TABLE cloudtask_analysis.subscriptions
MODIFY COLUMN customer_id VARCHAR(20),
MODIFY COLUMN churned VARCHAR(10),
MODIFY COLUMN upgraded VARCHAR(10);

ALTER TABLE cloudtask_analysis.subscriptions
MODIFY COLUMN churn_date VARCHAR(20);

DESCRIBE cloudtask_analysis.subscriptions;

select count(*) from  cloudtask_analysis.subscriptions; 
#rows - 913


select count(*) from  monthly_revenue;
#rows - 48 

#**Data Preprocessing:
#counting Columns for revenue
select count(*) as count_columns
from information_schema.columns
where table_schema = 'cloudtask_analysis'
and table_name = 'monthly_revenue';

#counting columns for subscriptions 
select count(*) as count_columns
from information_schema.columns
where table_schema = 'cloudtask_analysis'
and table_name = 'subscriptions';

select * from monthly_revenue;

select * from subscriptions;

#Understanding Datatype of the Fields
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'cloudtask_analysis'
AND table_name = 'subscriptions';

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'cloudtask_analysis'
AND table_name = 'monthly_revenue';

#Checking for Null Values
select
count(*) as total_rows,
count(*) - count(month) as month_nulls,
count(*) - count(total_active_customers) as TAC_nulls,
count(*) - count(new_customers) as NEW_cus_nulls,
count(*)  - count(churned_customers) as churned_nulls,
count(*) - count(monthly_churn_rate_pct) as monthlyt_churned_nulls,
count(*) - count(total_mrr) as total_mrr_nulls,
count(*) - count(avg_revenue_per_customer) as avgrev_nulls,
count(*) - count(customer_acquisition_cost)as cus_aquis_nulls
from monthly_revenue;

#Zero null rows fro all columns
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(customer_id) AS customer_id_nulls,
    COUNT(*) - COUNT(plan) AS plan_nulls,
    COUNT(*) - COUNT(billing_cycle) AS billing_cycle_nulls,
    COUNT(*) - COUNT(industry) AS industry_nulls,
    COUNT(*) - COUNT(company_size) AS company_size_nulls,
    COUNT(*) - COUNT(region) AS region_nulls,
    COUNT(*) - COUNT(acquisition_channel) AS acquisition_channel_nulls,
    COUNT(*) - COUNT(monthly_revenue) AS monthly_revenue_nulls,
    COUNT(*) - COUNT(churned) AS churned_nulls,
    COUNT(*) - COUNT(churn_date) AS churn_date_nulls,
    COUNT(*) - COUNT(churn_reason) AS churn_reason_nulls,
    COUNT(*) - COUNT(upgraded) AS upgraded_nulls,
    COUNT(*) - COUNT(nps_score) AS nps_score_nulls,
    COUNT(*) - COUNT(feature_usage_pct) AS feature_usage_pct_nulls,
    COUNT(*) - COUNT(support_tickets_12mo) AS support_tickets_nulls

FROM subscriptions;
#Zero null rows fro all columns

SELECT
    COUNT(*) - COUNT(NULLIF(TRIM(customer_id), '')) AS customer_id_blank,
    COUNT(*) - COUNT(NULLIF(TRIM(plan), '')) AS plan_blank,
    COUNT(*) - COUNT(NULLIF(TRIM(billing_cycle), '')) AS billing_cycle_blank,
    COUNT(*) - COUNT(NULLIF(TRIM(industry), '')) AS industry_blank,
    COUNT(*) - COUNT(NULLIF(TRIM(company_size), '')) AS company_size_blank,
    COUNT(*) - COUNT(NULLIF(TRIM(region), '')) AS region_blank,
    COUNT(*) - COUNT(NULLIF(TRIM(acquisition_channel), '')) AS acquisition_channel_blank,
    COUNT(*) - COUNT(NULLIF(TRIM(churned), '')) AS churned_blank,
    COUNT(*) - COUNT(NULLIF(TRIM(churn_date), '')) AS churn_date_blank,
    COUNT(*) - COUNT(NULLIF(TRIM(churn_reason), '')) AS churn_reason_blank,
    COUNT(*) - COUNT(NULLIF(TRIM(upgraded), '')) AS upgraded_blank
FROM subscriptions;

#There are 287 blanks in churn_date and churn_reason


SELECT
    churned,
    COUNT(*) AS customer_count
FROM subscriptions
WHERE TRIM(churn_date) = ''
   OR TRIM(churn_reason) = ''
GROUP BY churned;
#Blanks are valid

SELECT
    COUNT(*) - COUNT(NULLIF(TRIM(month), '')) AS month_blank
FROM monthly_revenue;
#No Blanks

#checking for duplicates - 626 dupli
SELECT
    customer_id,
    COUNT(*) AS record_count
FROM subscriptions
GROUP BY customer_id
HAVING COUNT(*) > 1;

# duplicates are identical or different - "Identical"
SELECT *
FROM subscriptions
WHERE customer_id IN (
    SELECT customer_id
    FROM subscriptions
    GROUP BY customer_id
    HAVING COUNT(*) > 1
)
ORDER BY customer_id;

#total rows in subscriptions
SELECT COUNT(*) AS total_rows
FROM subscriptions;

#taking unique rows and comparing
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM subscriptions;

#Duplicate checking for monthly_revenue dataset - 0 dupli
SELECT
    month,
    COUNT(*) AS record_count
FROM monthly_revenue
GROUP BY month
HAVING COUNT(*) > 1;


#inconsistency in monthly_revn - 0
SELECT *
FROM monthly_revenue
WHERE total_active_customers < 0
   OR new_customers < 0
   OR churned_customers < 0
   OR monthly_churn_rate_pct < 0
   OR monthly_churn_rate_pct > 100
   OR total_mrr < 0
   OR avg_revenue_per_customer < 0
   OR customer_acquisition_cost < 0;

#inconistency in subscriptions - 0
SELECT *
FROM subscriptions
WHERE seats < 0
   OR monthly_revenue < 0
   OR nps_score < 0
   OR nps_score > 10
   OR feature_usage_pct < 0
   OR feature_usage_pct > 100
   OR support_tickets_12mo < 0;
   
 #Cleaned Subscription table  
CREATE TABLE subscriptions_clean AS
SELECT DISTINCT *
FROM subscriptions;
   
#Univariate Anlysis
# 1.Plan
SELECT
    plan,
    COUNT(*) AS customer_count
FROM subscriptions_clean
GROUP BY plan
ORDER BY customer_count DESC;
#Key takeaways: 1. Starter is more concenterated with 217 customers
# 2.where enterprise has smaller segment of customers
#Starter has the largest customer base with 217 customers, followed by Professional (173) and Business (160).


# 2. Billing Cycle
SELECT
    billing_cycle,
    COUNT(*) AS customer_count
FROM subscriptions_clean
GROUP BY billing_cycle
ORDER BY customer_count DESC;
#Key Takeaways : Monthly billing is more common with 352 customers, compared with 248 customers on annual billing.

#3. Industries
SELECT
    industry,
    COUNT(*) AS customer_count
FROM subscriptions_clean
GROUP BY industry
ORDER BY customer_count DESC;
# Key takeaways: Education has the highest number of customers (77), followed by Manufacturing (64). Technology has the lowest number of customers (51). 
# The remaining industries are relatively close in customer count.

#4. Company size
SELECT
    company_size,
    COUNT(*) AS customer_count
FROM subscriptions_clean
GROUP BY company_size
ORDER BY customer_count DESC;
#Found quality issue : Suspicious category values (Nov-50 and 01-Oct).

# 5. Region
SELECT
    region,
    COUNT(*) AS customer_count
FROM subscriptions_clean
GROUP BY region
ORDER BY customer_count DESC;
# 1.North America has the largest customer base, with 284 customers, followed by Europe with 162 and Asia Pacific with 94. 
#2.Latin America has the smallest customer base, with 60 customers.
#Interpretation: CloudTask's customer base is concentrated in North America, while Latin America represents the smallest share of customers.


#6.Aquisition channel
SELECT
    acquisition_channel,
    COUNT(*) AS customer_count
FROM subscriptions_clean
GROUP BY acquisition_channel
ORDER BY customer_count DESC;	
# Organic search has largest customer base, with 153 customers, Social Media has the smallest customer count among the acquisition channels.	
#Interpretation: Organic is the most represented acquisition channel in CloudTask's customer base.	

#7.Churned 
SELECT
    churned,
    COUNT(*) AS customer_count
FROM subscriptions_clean
GROUP BY churned
ORDER BY customer_count DESC;
#Overall customers - 600 customers	
#313 churned, while 287 did not churn.

# In percentage
SELECT
    churned,
    COUNT(*) AS customer_count,
    round(100.0 * count(*) / (SELECT COUNT(*) FROM subscriptions_clean),2) as churn_Percentage
FROM subscriptions_clean
GROUP BY churned
ORDER BY customer_count DESC;
#Key Takeaway: 52.17% churned,While 47.83 did not churn.

describe monthly_revenue;


#Univariate for Monthly_revenue
#1.Month
SELECT
    MIN(month) AS first_month,
    MAX(month) AS last_month,
    COUNT(*) AS total_months
FROM monthly_revenue;
#The dataset covers four years, from January 2022 to December 2025, with 48 monthly records. 


SELECT
    month,
    monthly_churn_rate_pct
FROM monthly_revenue
ORDER BY month;

#2.Total Active customers
SELECT
    MIN(total_active_customers) AS min_active_customers,
    MAX(total_active_customers) AS max_active_customers,
    ROUND(AVG(total_active_customers), 2) AS avg_active_customers
FROM monthly_revenue;
#The active-customer count ranged from 0 to 281, with an average of approximately 167 customers per month.

#3.New Customers
SELECT
    MIN(new_customers) AS min_new_customers,
    MAX(new_customers) AS max_new_customers,
    ROUND(AVG(new_customers), 2) AS avg_new_customers,
    SUM(new_customers) AS total_new_customers
FROM monthly_revenue;
#Interpretation: CloudTask acquired between 5 and 19 new customers per month, averaging 12.5. 
#Across the four-year period, the monthly acquisition counts sum to 600.

#4.Churned customers
SELECT
    MIN(churned_customers) AS min_churned_customers,
    MAX(churned_customers) AS max_churned_customers,
    ROUND(AVG(churned_customers), 2) AS avg_churned_customers,
    SUM(churned_customers) AS total_churned_customers
FROM monthly_revenue;
# Interpretation: Across the four-year period, monthly churn ranged from 0 to 17 customers, averaging 6.52 churned customers per month.
# The monthly counts sum to 313.

#Churn Rate
SELECT
    MIN(monthly_churn_rate_pct) AS min_churn_rate,
    MAX(monthly_churn_rate_pct) AS max_churn_rate,
    ROUND(AVG(monthly_churn_rate_pct), 2) AS avg_churn_rate
FROM monthly_revenue;
# Interpretation: Across the four-year period, monthly churn rate ranged from 0% to 20%, averaging 4.52% churned customers per month.

# 5.Mrr - Monthly recurring Revenue
SELECT
    MIN(total_mrr) AS min_mrr,
    MAX(total_mrr) AS max_mrr,
    ROUND(AVG(total_mrr), 2) AS avg_mrr,
    SUM(total_mrr) AS sum_of_monthly_mrr
FROM monthly_revenue;


#6. For validation,investigating whether the Mrr increases by the no.of customers!
SELECT
    month,
    total_active_customers,
    total_mrr,
    avg_revenue_per_customer
FROM monthly_revenue
WHERE total_mrr = (
    SELECT MIN(total_mrr)
    FROM monthly_revenue
)
OR total_mrr = (
    SELECT MAX(total_mrr)
    FROM monthly_revenue
)
ORDER BY month;
#Investigation: The month with the highest MRR had 281 active customers, suggesting that a large active customer base contributed to the high MRR.

#7. Avg revenue per customer
SELECT
    MIN(avg_revenue_per_customer) AS min_avg_revenue,
    MAX(avg_revenue_per_customer) AS max_avg_revenue,
    ROUND(AVG(avg_revenue_per_customer), 2) AS mean_avg_revenue
FROM monthly_revenue;
#Investigation: Minimum = 0.00: At least one month had zero average revenue per customer. ***We should investigate whether this occurred when there were zero active customers.**
#Maximum = 1,466.61: The highest monthly average revenue per customer was 1,466.61.
#Mean = 1,010.22: Across the 48 monthly observations, the average of this metric was 1,010.22.

#whether zero average revenue per customer is consistent with zero active customers and zero MRR?
SELECT 
month,
total_active_customers,
total_mrr,
avg_revenue_per_customer
FROM monthly_revenue
where total_active_customers = 0
	OR avg_revenue_per_customer = 0
order by month;
#Yes! These values are consistent with one another.

# 8.Analyse customer acquisition cost (CAC) 
# CAC-Customer Acquisition Cost (CAC) is the total amount of money a business spends on sales and marketing to win a single new customer
SELECT
    MIN(customer_acquisition_cost) AS min_cac,
    MAX(customer_acquisition_cost) AS max_cac,
    ROUND(AVG(customer_acquisition_cost), 2) AS avg_cac
FROM monthly_revenue;
#Interpretation:
#- The lowest monthly CAC was 122.99.
#- The highest monthly CAC was 279.59.
#- The average of the monthly CAC values was 200.04 across the 48 months.

#Bivariate Analysis:

#**Subscription data**
#Ques 2:
# 1.Plan vs churn
SELECT
    plan,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM subscriptions_clean
GROUP BY plan
ORDER BY churn_rate_pct DESC;
#-Starter: Highest churn rate at 70.51%. Around 71 out of every 100 Starter customers in this dataset churned.
#-Enterprise: Lowest churn rate at 22%.
#-Professional and Business: Both have lower churn rates than Starter, but higher rates than Enterprise.
#The churn rate decreases as we move from Starter to Enterprise in these results. This is an observed pattern, not proof that upgrading a plan causes customers to stay longer.
#Starter customers have the highest observed churn rate (70.51%), while Enterprise customers have the lowest (22%). The business could investigate why Starter customers leave more frequently and whether onboarding, product fit, pricing, or support experience differs across plans.

#Remember that Enterprise has only 50 customers, compared with 217 Starter customers, so its rate is based on a smaller group.

#2.churn reason by subscription plan
SELECT
    plan,
    churn_reason,
    COUNT(*) AS customers_churned
FROM subscriptions_clean
WHERE churned = 'Yes'
GROUP BY plan, churn_reason
ORDER BY plan, customers_churned DESC;
#Investigation: 
#1.Starter — price and budget concerns
#2.Business — missing features
#3.Enterprise — small sample..avoid drawing strong conclusions from these small numbers.

#Investigate another column to see whether the data offers more context:

#Ques 2:
#Billing cycle Vs churn
SELECT
    billing_cycle,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM subscriptions_clean
GROUP BY billing_cycle
ORDER BY churn_rate_pct DESC;
#Interpretation: Monthly-billed customers may be a higher-retention-risk segment. The business should investigate why they leave more often.

#3.Acquisition channel vs churn

SELECT
    acquisition_channel,
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN churned = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN churned = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM subscriptions_clean
GROUP BY acquisition_channel
ORDER BY churn_rate_pct DESC;
#Interpretation: * Customers acquired through different channels have different churn rates. 
# *The Referral channel has the highest churn rate, while Direct Sales has the lowest among the channels analysed. 
#  *This suggests that retention varies by acquisition channel.

#**1.Feature Usage and NPS vs Churn.

SELECT
    churned,
    COUNT(*) AS total_customers,
    ROUND(AVG(feature_usage_pct), 2) AS avg_feature_usage_pct,
    ROUND(AVG(nps_score), 2) AS avg_nps_score
FROM subscriptions_clean
GROUP BY churned;
#Customers who use fewer features and report lower satisfaction may be at greater risk of churning. 
#CloudTask could investigate whether better onboarding, feature education, or customer support helps these customers get more value from the product.

#2.Support Ticket Vs Churn:
#“Do customers who churned raise more support tickets, on average, than customers who stayed?”

SELECT
    churned,
    COUNT(*) AS total_customers,
    ROUND(AVG(support_tickets_12mo), 2) AS avg_support_tickets
FROM subscriptions_clean
GROUP BY churned;
#Churned customers raised 1.88 more support tickets on average than retained customers over the last 12 months.
#That is approximately 34.2% higher than the retained group's average.
#Churned customers raised an average of 7.38 support tickets in the past 12 months, compared with 5.50 among retained customers. 
#**This suggests an association between higher support-ticket volume and customer churn**

#3.Does upgrading relate to customer retention?
SELECT
    upgraded,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM subscriptions_clean
GROUP BY upgraded
ORDER BY churn_rate_pct DESC;
#Customers who upgraded had a 0% observed churn rate, while customers who did not upgrade had a 56.40% churn rate.
#This suggests that upgrading is strongly associated with retention in the dataset.


#Ques 3:
#Find churn reasons by company size:

SELECT
    company_size,
    churn_reason,
    COUNT(*) AS churned_customers
FROM subscriptions_clean
WHERE churned = 'Yes'
GROUP BY company_size, churn_reason
ORDER BY company_size, churned_customers DESC;


#Ques3
SELECT
    churn_reason,
    Plan
FROM subscriptions_clean
WHERE churned = 'Yes'
ORDER BY Plan DESC;

#Ques3 : Plan Vs Churn
SELECT
    plan,
    churn_reason,
    COUNT(*) AS churned_customers
FROM subscriptions_clean
WHERE churned = 'Yes'
GROUP BY plan, churn_reason
ORDER BY plan, churned_customers DESC;
#Business - Missing Features,No Longer Needed,Poor Support
#Enterprise - 	Company Closed,	No Longer Needed,Switched Competitor
#Professional - Price Too High,	Budget Cuts,Company Closed
#Starter - Price Too High,Budget Cuts,Company Closed

#Company_size Vs Churn_reason:

SELECT
    company_size,
    churn_reason,
    COUNT(*) AS churned_customers
FROM subscriptions_clean
WHERE churned = 'Yes'
GROUP BY company_size, churn_reason
ORDER BY company_size, churned_customers DESC;
#Q3.Based on my analysis, Starter customers frequently cited Budget Cuts and Price Too High as reasons for churning, with 29 customers for each reason.
#This suggests that affordability may be a concern for some Starter customers.
#CloudTask could investigate pricing and budget constraints to understand whether changes to its pricing options might help improve retention.

#Q4. Before Comaparing CLV & CAC, We need to calculate Customer Lifetime:
#**CAC (Customer Acquisition Cost): How much does the company spend to acquire one customer?
#**Customer lifetime: How long does the customer stay?
#**CLV (Customer Lifetime Value): How much revenue does the customer generate over that relationship?

#TO CALCULATE AVG CUSTOMER LIFETIME:

SELECT
    plan,
    COUNT(*) AS churned_customers,
    ROUND(
        AVG(
            DATEDIFF(
                STR_TO_DATE(churn_date, '%Y-%m-%d'),
                STR_TO_DATE(signup_date, '%Y-%m-%d')
            )
        ),
        0
    ) AS avg_lifetime_days
FROM subscriptions_clean
WHERE churned = 'Yes'
  AND churn_date IS NOT NULL
  AND TRIM(churn_date) <> ''
GROUP BY plan
ORDER BY avg_lifetime_days DESC;
#Interpretation : Enterprise customers who churned had the highest average lifetime, closely followed by Business customers.
#However, we can't yet conclude that Enterprise customers are more loyal overall. This table includes churned customers only, and the number of customers in each plan differs.

SELECT
    customer_id,
    plan,
    TIMESTAMPDIFF(
        MONTH,
        signup_date,
        STR_TO_DATE(churn_date, '%Y-%m-%d')
    ) AS lifetime_months
FROM subscriptions_clean
WHERE churned = 'Yes'
  AND churn_date IS NOT NULL;
  
  SELECT
    plan,
    COUNT(*) AS churned_customers,
    ROUND(
        AVG(
            monthly_revenue *
            TIMESTAMPDIFF(
                MONTH,
                signup_date,
                STR_TO_DATE(churn_date, '%Y-%m-%d')
            )
        ),
        2
    ) AS avg_revenue_lifetime_value
FROM subscriptions_clean
WHERE churned = 'Yes'
  AND churn_date IS NOT NULL
GROUP BY plan
ORDER BY avg_revenue_lifetime_value DESC;
#What the data tells us:
#- Enterprise: Highest average lifetime value at 29,800.73.
#- Business: Second highest at 22,524.74.
#- Professional: Much lower at 5,290.67.
#- Starter: Lowest at 1,351.96, with the largest number of churned customers (306).

#**AVG CUSTOMER AQUISITION COST:
SELECT
    ROUND(AVG(customer_acquisition_cost), 2) AS avg_cac
FROM monthly_revenue;
#The overall avg aquisition cost  is 200.04

#To find the ratio Of CAC : CLV;
SELECT
    plan,
    ROUND(
        AVG(
            monthly_revenue *
            TIMESTAMPDIFF(
                MONTH,
                signup_date,
                STR_TO_DATE(churn_date, '%Y-%m-%d')
            )
        ),
        2
    ) AS avg_clv,
    200.04 AS avg_cac,
    ROUND(
        AVG(
            monthly_revenue *
            TIMESTAMPDIFF(
                MONTH,
                signup_date,
                STR_TO_DATE(churn_date, '%Y-%m-%d')
            )
        ) / 200.04,
        2
    ) AS clv_cac_ratio
FROM subscriptions_clean
WHERE churned = 'Yes'
  AND churn_date IS NOT NULL
  AND TRIM(churn_date) <> ''
GROUP BY plan
ORDER BY clv_cac_ratio DESC;


#**Estimating AT-Risk Customers and setting a flag ;

SELECT
    CASE
        WHEN feature_usage_pct < 20 THEN '0-19%'
        WHEN feature_usage_pct < 40 THEN '20-39%'
        WHEN feature_usage_pct < 60 THEN '40-59%'
        WHEN feature_usage_pct < 80 THEN '60-79%'
        ELSE '80-100%'
    END AS feature_usage_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM subscriptions_clean
GROUP BY feature_usage_group
ORDER BY MIN(feature_usage_pct);
#**Interpretation: 1.Customers using less than 20% of the features have the highest observed churn rate: 87.85%.
#2.Churn rate decreases as feature usage increases across the first three groups.
#3.No churn was observed in the two groups with usage of 60% or more.


#NPS Vs CHURN;

SELECT
    CASE
        WHEN nps_score <= 6 THEN 'Detractors (0-6)'
        WHEN nps_score <= 8 THEN 'Passives (7-8)'
        ELSE 'Promoters (9-10)'
    END AS nps_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM subscriptions_clean
WHERE nps_score IS NOT NULL
GROUP BY nps_group
ORDER BY
    CASE nps_group
        WHEN 'Detractors (0-6)' THEN 1
        WHEN 'Passives (7-8)' THEN 2
        WHEN 'Promoters (9-10)' THEN 3
    END;
    
#**Detractors: Customers with NPS scores below 7 had a 66.60% observed churn rate.
#Passives and promoters: No churn was observed among customers scoring 7 or above in this dataset.
#This suggests that low NPS is strongly associated with churn in your data. However, we shouldn't conclude that an NPS score of 7 or above guarantees retention;
# these are observations from this dataset, and the zero-churn groups should be validated.
