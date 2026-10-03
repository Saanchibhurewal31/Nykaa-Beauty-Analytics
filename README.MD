# Nykaa Beauty Analytics Dashboard

An end-to-end analysis of a beauty and personal-care e-commerce business: SQL for querying and shaping the data, Power BI for the interactive dashboard.


## Project Overview
This project analyzes customer purchasing behavior, revenue trends, category performance, and customer retention. The goal is to answer business questions such as:

- Which categories and brands drive the most revenue?
- Who are the highest-value customers, and which age and gender groups buy the most?
- Do premium products contribute meaningfully compared with non-premium ones?
- How is revenue trending month over month?

> **Note:** The dataset is synthetic (generated for this project) and does not represent real Nykaa data.

## Tools Used
| Tool | Purpose |
|------|---------|
| SQL (MySQL) | Data exploration, aggregation, and KPI queries |
| Excel | Data preparation and checks |
| Power BI | Data modelling, DAX measures, and the interactive dashboard |

## KPIs
| KPI | Value |
|-----|-------|
| Revenue | 11.22M |
| Lost Revenue | 1.47M |
| Repeat Customer % | 96.29% |
| Average Price Value | 968.24 |

## Dashboard Features
- Revenue by Category
- Revenue by Gender
- Revenue by Age Group
- Top 5 Brands
- Premium vs Non-Premium Analysis
- Monthly Revenue Trend
- Top customers table with a City slicer

## Key Insights
- **Skincare leads** with about 2.73M in revenue, followed by Makeup (2.41M) and Fragrance (2.36M). Men's Grooming and Bath & Body are the smallest categories.
- **Female customers contribute 9.81M** of the 11.22M total revenue, versus 1.42M from male customers.
- **Revenue is spread fairly evenly across age groups** (each roughly 2.6M to 2.9M), with 35-44 the highest at 2.91M.
- **Forest Essentials is the top brand** at 1.32M, followed by Biotique (1.24M) and WOW Skin Science (1.13M).
- **Non-premium products generate 7.8M** against 3.4M from premium products.
- **Monthly revenue declines** from about 1.34M at the start of the period to about 0.49M at the end, which is worth investigating further.

## Repository Structure
```
Nykaa-Beauty-Analytics/
├── Dataset/         # Source data files
├── Documentation/   # Project notes and documentation
├── Power BI/        # Power BI dashboard file
├── SQL Queries/     # SQL scripts used for the analysis
├── Screenshots/     # Dashboard screenshots
└── README.md
```

## How to Use
1. Explore the data in the `Dataset` folder.
2. Run the scripts in `SQL Queries` on MySQL to reproduce the analysis.
3. Open the file in `Power BI` using Power BI Desktop to interact with the dashboard.

## Author
**Saanchi Bhurewal**
Aspiring Data Analyst | SQL · Power BI · Excel · Tableau · Python
