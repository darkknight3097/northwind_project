# Northwind Sales Analysis — SQL Portfolio Project

**Tools:** PostgreSQL · DBeaver · Neon (cloud database)
**Dataset:** Northwind — a classic wholesale food distributor database with 89 customers, 9 employees, 77 products across 21 countries
**Skills demonstrated:** CTEs, window functions, aggregations, multi-table joins, CASE statements, LAG, RANK, date functions, cohort logic

---

## Project Structure

```
northwind-sql-project/
├── queries/
│   ├── 01_revenue_by_country.sql
│   ├── 02_revenue_by_category.sql
│   ├── 03_monthly_trend.sql
│   ├── 04_employee_performance.sql
│   ├── 05_customer_segmentation.sql
│   ├── 06_shipping_performance.sql
│   ├── 07_product_rank_by_category.sql
│   ├── 08_repeat_vs_onetme_customers.sql
│   └── 09_running_total.sql
├── results/
│   ├── revenue_by_country.csv
│   ├── revenue_by_category.csv
│   ├── monthly_trend.csv
│   ├── employee_performance.csv
│   ├── customer_segmentation.csv
│   └── shipping_performance.csv
├── screenshots/
│   ├── revenue_by_country.png
│   ├── revenue_by_category.png
│   ├── monthly_trend.png
│   ├── employee_performance.png
│   ├── customer_segmentation.png
│   └── shipping_performance.png
└── README.md
```

---

## Database Schema

The Northwind database contains the following key tables used in this analysis:

```
orders          — order header (date, customer, employee, shipper)
order_details   — line items (product, quantity, unit price, discount)
customers       — 89 customers across 21 countries
employees       — 9 sales staff with hierarchy
products        — 77 products across 8 categories
categories      — product category reference
suppliers       — 29 suppliers
shippers        — 3 shipping carriers
```

**Key relationships:**
- `orders` → `customers` (many-to-one)
- `orders` → `employees` (many-to-one)
- `orders` → `shippers` (many-to-one)
- `order_details` → `orders` (many-to-one)
- `order_details` → `products` (many-to-one)
- `products` → `categories` (many-to-one)

---

## Analysis Areas

### 1. Revenue by Country
### 2. Revenue by Category
### 3. Monthly Revenue Trend
### 4. Employee Performance
### 5. Customer Segmentation
### 6. Shipping Performance

---

## Key Findings

### Revenue by Country
- **USA and Germany dominate**, generating $245k and $230k respectively — together accounting for 38% of total revenue
- **Europe is the core market** — Western/European countries make up ~75% of all revenue
- **Brazil outperforms** its market size at $107k (4th largest), suggesting strong individual customer relationships rather than broad penetration
- **5 tail markets** (Norway, Poland, Argentina, Finland, Spain) collectively contribute less than 4% of revenue — inactive or underpenetrated

### Revenue by Category
- **Beverages leads** at $268k with the highest order volume (354 orders) — both the most purchased and highest revenue category
- **Meat/Poultry is the most efficient category** — $163k from only 161 orders (~$1,012 revenue per order), the highest revenue-per-order of any category
- **Seafood has high order frequency** (291 orders) but relatively modest revenue ($131k), suggesting frequent small-basket purchases
- **Grains/Cereals and Produce underperform** — under $100k revenue despite reasonable order counts, indicating low average order values

### Monthly Revenue Trend
- **Revenue grew 3.5x** from Jul 1996 ($27.9k) to Apr 1998 ($123.8k)
- **1998 monthly average ($106k) is more than double 1997 ($49k)** — strong year-on-year acceleration
- **January consistently outperforms** the prior month (+35% in Jan 1997, +32% in Jan 1998) — driven by B2B restocking cycles after year-end
- **December 1997 saw the strongest single-month growth at +64%** — likely year-end procurement
- **February is consistently weaker** — seasonal dip following January peaks in both 1997 and 1998
- **Note:** May 1998 data ($18k) is an incomplete month in the dataset and is not representative of actual performance

### Employee Performance
- **Top 3 reps (Peacock, Leverling, Davolio) generate 63% of total revenue** — high concentration risk
- **Margaret Peacock leads on total revenue** ($232k, 156 orders) through volume — her avg order line value ($555) is mid-table
- **Anne Dodsworth is the most efficient seller** — highest avg order value ($723) despite fewest orders (43), closing fewer but larger deals
- **Michael Suyama is the weakest performer** — lowest avg order value ($440) and low revenue efficiency per order despite 67 orders
- **VP Andrew Fuller handles 96 direct orders** — unusually high for a management role, suggesting he still carries a significant individual sales load

### Customer Segmentation
- **Classic 80/20 distribution**: 38 High Value customers (42% of base) generate ~87% of all revenue
- **Top 3 customers (QUICK-Stop $110k, Ernst Handel $105k, Save-a-lot $104k)** each exceed $100k — significant concentration risk if any are lost
- **Germany has 6 High Value customers** — the strongest per-country customer depth in the dataset, reinforcing Germany as the most strategically important market
- **35 Low Value customers (<$5k)** with very few orders each represent re-engagement opportunities or potential churn

### Shipping Performance
- **Federal Shipping is fastest** at 7.5 days average — 1.7 days quicker than United Package (9.2 days)
- **All three carriers share a 1-day best case** — peak performance is equal across carriers
- **Maximum delivery times of 35–37 days** across all carriers are concerning outliers and represent a customer satisfaction risk
- **United Package handles the most volume (315 orders)** despite being the slowest carrier — worth investigating whether volume is degrading performance

---

## SQL Skills Demonstrated

| Skill | Used In |
|---|---|
| Multi-table JOINs | All queries |
| CTEs (`WITH` clause) | Monthly trend, segmentation, running total |
| Window functions (`LAG`, `RANK`, `SUM OVER`) | Monthly trend, employee rank, running total |
| `CASE` statements | Customer segmentation |
| Aggregations (`SUM`, `COUNT`, `AVG`, `MIN`, `MAX`) | All queries |
| Date functions (`DATE_TRUNC`) | Monthly trend |
| `NULLIF` for safe division | Growth % calculation |
| `ROUND` + type casting | All revenue calculations |
| Subqueries / nested CTEs | Customer segmentation |

---

## How to Run

1. Connect to a PostgreSQL database with the Northwind schema loaded
2. Open any `.sql` file from the `queries/` folder in DBeaver or psql
3. Execute against the `northwind` database

To load the Northwind dataset into your own PostgreSQL instance:
```bash
psql -U postgres -d northwind -f northwind.sql
```

---

## Setup

- **Database:** PostgreSQL hosted on [Neon](https://neon.tech) (free tier)
- **Client:** DBeaver Community Edition
- **Dataset source:** [pthom/northwind_psql](https://github.com/pthom/northwind_psql)
