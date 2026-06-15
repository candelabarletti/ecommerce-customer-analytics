# 🛒 E-Commerce Customer Analytics

A end-to-end data analysis project exploring customer behavior, revenue trends,
and marketing performance for a fictional e-commerce store.

Built to demonstrate practical skills in **Python**, **SQL**, **Pandas**, and
**data visualization** — relevant for Data Analyst roles in marketing-driven companies.

---

## 📊 What's Covered

| Analysis | Description |
|----------|-------------|
| **Revenue trends** | Monthly revenue with 3-month rolling average |
| **Category performance** | Revenue and return rates by product category |
| **Acquisition channels** | Comparing Paid Search, Social, Email, Organic, Direct |
| **RFM Segmentation** | Classifying customers into Champions, Loyal, At Risk, Lost, etc. |
| **Customer Lifetime Value** | Estimating CLV per customer and by segment |
| **SQL queries** | 10 business queries covering KPIs, rankings, and window functions |

---

## 🗂️ Project Structure

```
ecommerce-analytics/
├── data/
│   ├── generate_data.py      # Generates synthetic CSV + SQLite DB
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   └── order_items.csv
├── sql/
│   └── analysis_queries.sql  # 10 SQL queries with comments
├── notebooks/
│   └── ecommerce_analysis.ipynb  # Main analysis notebook
├── outputs/                  # Saved charts
├── requirements.txt
└── README.md
```

---

## 🚀 Getting Started

### 1. Clone the repo
```bash
git clone https://github.com/YOUR_USERNAME/ecommerce-analytics.git
cd ecommerce-analytics
```

### 2. Install dependencies
```bash
pip install -r requirements.txt
```

### 3. Generate the dataset
```bash
python data/generate_data.py
```

### 4. Open the notebook
```bash
jupyter notebook notebooks/ecommerce_analysis.ipynb
```

---

## 🔍 Key Findings

- **Paid Search** drives the highest revenue but Social Media shows strong growth in H2
- **Champions** (top RFM tier) account for ~20% of customers but over 40% of revenue
- **At Risk** customers have high historical spend — ideal targets for re-engagement campaigns
- **Electronics** leads all categories in revenue; **Beauty** has the highest return rate
- New customers show strong purchase frequency in the first 60 days → onboarding is critical

---

## 🛠️ Tech Stack

- **Python 3.10+** — Pandas, NumPy, Matplotlib, Seaborn
- **SQLite** — relational database with 4 normalized tables
- **Jupyter Notebook** — interactive analysis and storytelling
- **SQL** — window functions, CTEs, aggregations

---

## 📁 Dataset

Synthetic data generated with Python (`numpy.random`, `faker`-style logic).
500 customers · 50 products · 2,000 orders · ~3,500 line items.
No real personal data is used.

---

## 👤 Author

**Your Name**  
[LinkedIn](https://linkedin.com/in/yourprofile) · [GitHub](https://github.com/yourusername)
