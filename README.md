# SaaS-Customer-Churn-Retention-Analysis
# SaaS Customer Churn & Retention Analysis using MySQL

## 📌 Project Overview

This project focuses on analyzing customer churn patterns in a SaaS (Software as a Service) business using MySQL.

The objective is to understand customer attrition, identify high-risk customer segments, investigate potential reasons for churn, and evaluate customer lifetime value across different subscription plans.

Through SQL-based analysis, I explored customer behavior, subscription patterns, churn trends, and customer economics to derive actionable business insights that could help improve customer retention.

## 🎯 Business Objectives

- Understand the overall customer churn rate and its monthly trend.
- Identify subscription plans with higher customer churn.
- Analyze churn patterns across monthly and annual billing cycles.
- Investigate common reasons for customer churn.
- Evaluate Customer Lifetime Value (CLV) against Customer Acquisition Cost (CAC).
- Identify customer segments that may require targeted retention strategies.

## 🛠️ Tools & Technologies

- **Database:** MySQL
- **SQL Concepts:** Aggregate Functions, GROUP BY, CASE Statements, Joins, Subqueries, CTEs, Date Functions, and Window Functions (where applicable).

## 📊 Key Business Insights

### Q1. Overall Customer Churn Analysis

CloudTask recorded an overall customer churn rate of **52.17%**, with 313 out of 600 customers marked as churned.

The monthly churn trend from January 2022 to December 2025 indicates worsening customer retention.

**Business Recommendation:**

CloudTask should investigate the factors contributing to rising churn and identify opportunities to improve customer retention.

### Q2. Churn Analysis by Subscription Plan and Billing Cycle

- The **Starter plan** recorded the highest observed churn rate at **70.51%**, indicating a significant retention challenge within this segment.
- Monthly-billed customers recorded a churn rate of **60.51%**, compared with **40.32%** for annual-billed customers.

**Business Recommendation:**

CloudTask should investigate the factors behind Starter-plan churn and explore whether monthly customers face different retention challenges.

These findings indicate associations and do not establish that subscription plans or billing cycles cause churn.

### Q3. Churn Reasons Among Starter Customers

The analysis identified **Budget Cuts** and **Price Too High** as the most frequently cited churn reasons among Starter customers, with 29 customers for each reason.

This suggests that affordability may be a concern for some Starter customers.

**Business Recommendation:**

CloudTask could investigate pricing and budget constraints to understand whether changes to its pricing options might help improve customer retention.

### Q4. Customer Lifetime Value (CLV) vs Customer Acquisition Cost (CAC)

The analysis compared estimated Customer Lifetime Value (CLV) against the overall average Customer Acquisition Cost (CAC) across subscription plans.

| Subscription Plan | Estimated CLV:CAC Ratio |
|---|---:|
| Starter | 6.76:1 |
| Professional | 26.45:1 |
| Business | 112.60:1 |
| Enterprise | 148.97:1 |

**Key Findings:**

- Starter recorded the lowest estimated CLV-to-CAC ratio at 6.76:1.
- Enterprise recorded the highest ratio at 148.97:1.
- Business and Professional recorded ratios of 112.60:1 and 26.45:1, respectively.

Combined with its high churn rate of 70.51%, the Starter plan appears to be a priority for further investigation into customer retention and pricing.

**Business Recommendation:**

CloudTask should investigate the Starter segment's retention challenges and evaluate whether its customer acquisition and pricing strategies need improvement.

## 💡 Overall Business Recommendations

Based on the analysis, the following areas deserve further investigation:

1. **Improve Starter Plan Retention:** Investigate affordability concerns and identify opportunities to improve the value offered to Starter customers.
2. **Monitor Monthly Subscribers:** Examine why monthly-billed customers have higher observed churn than annual subscribers.
3. **Investigate Churn Trends:** Explore the factors contributing to the worsening monthly churn trend.
4. **Evaluate Customer Economics:** Review the relationship between acquisition costs, estimated lifetime value, and customer retention across subscription plans.

## 📁 Project Structure

```text
saas-customer-churn-retention-analysis/
│
├── README.md
├── customer_churn_analysis.sql
└── dataset/
    └── (Dataset files)
```

## 📚 Key Learnings

- Applying SQL to real-world business questions.
- Analyzing customer churn and retention patterns.
- Using aggregations and conditional logic to calculate business metrics.
- Segmenting customers based on subscription plans and billing cycles.
- Evaluating customer lifetime value against acquisition costs.
- Translating SQL query results into actionable business insights.

## 👩‍💻 Project Focus

This project demonstrates how SQL can be used not only to retrieve and aggregate data but also to investigate business problems and support data-driven decision-making.

**Data Source: Analyst Builder**

**Domain:** SaaS | Customer Analytics | Business Analytics

**Tool:** MySQL
