# Zomato Bangalore Restaurant Market Analysis

An end-to-end data engineering and business intelligence pipeline analyzing **41,000+ active culinary outlets** in Bangalore to discover market segments, customer satisfaction vectors, and high-ROI investment zones.

## 🚀 Project Overview
This project establishes a robust 3-tier data pipeline designed to transform raw, noisy food market data into actionable executive insights. By integrating relational storage, programmatic feature engineering, and advanced semantic modeling, the project isolates the operational drivers behind successful restaurant placement in a hyper-competitive ecosystem.

## 🛠️ Tech Stack
* **Database Layer:** MySQL Workbench (Relational schema modeling, CTEs, Production Views)
* **Data Engineering & EDA:** Python 3 (Pandas, NumPy, Matplotlib, Seaborn)
* **Database Connectivity:** SQLAlchemy Engine
* **Business Intelligence Layer:** Power BI Desktop (DAX Measures, High-Density Canvas Design)

## 📈 Data Pipeline Architecture
1. **Data Ingestion & SQL Optimization:** Bulk-loaded raw datasets into MySQL. Engineered case-driven logic to clean string-based fractional ratings and deployed production views (`v_market_analysis_base`) to optimize BI reporting performance.
2. **Programmatic Transformation (Python):** Established live server extraction via SQLAlchemy. Handled granular alphanumeric text cleaning, extracted cuisine metrics, and binned records into standard economic and operational groups.
3. **Executive Semantic Layer (Power BI):** Designed a clean, horizontal-aligned dashboard emphasizing whitespace, removing chart clutter, and mapping performance metrics across geographic and financial coordinates.

## 🔍 Core Insights & Features
* **The Financial Sweet Spot:** Data reveals that customer engagement (votes) peaks sharply alongside stable, high ratings in the **₹300 to ₹1000 price bracket** (Mid-Range to early Premium).
* **Menu Diversity Rule:** Focused operations maintaining a **Medium (3-5) cuisine count** deliver consistent, stable ratings. Hyper-expanded menus exhibit high performance variance due to operational overhead.
* **Hidden Gems Identification:** Deployed algorithmic categorization to automatically isolate low-visibility, high-performing outlets ready for digital scaling.

## 📊 Dashboard Visuals
*Look at the layout placeholders inside the repository to attach your live dashboard screenshots:*
* **Top KPI Panel:** Total Active Outlets (42K), Average Rating (3.70/5.00), Digital Ordering Adoption Rate.
* **Analytics Canvas:** Regional Matrix Heatmaps, Operational Format Distribution, and Budget Segment Ribbon Charts.

## ⚙️ How to Setup & Run
1. **Database Deployment:** Import the `Zomato_db.sql` script into your local MySQL instance to set up the clean reporting view.
2. **Python Environment:** Execute the Jupyter Notebook `zomato_sales.ipynb` to run the feature engineering pipeline and generate distribution plots.
3. **Power BI Dashboard:** Open the dashboard file, refresh the semantic model via your local MySQL gateway connection, and interact with the canvas.
