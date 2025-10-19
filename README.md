# Supply Chain Data Analysis - Team Project 📊

## DataCo Global Supply Chain Analysis

## 🎯 Project Overview

**Company**: DataCo Global - multinational e-commerce company  
**Domain**: Supply chain operations, logistics, and distribution  
**Objective**: Analyze supply chain data to identify bottlenecks, forecast demand, optimize costs, and recommend actionable strategies

### Business Goals

 - Improve Delivery Performance - Reduce late delivery rates by 20%
 - Optimize Costs - Cut shipping and operational costs by 15%
 - Enhance Customer Insights - Segment customers and predict behaviors
 - Support Strategic Decisions - Provide forecasting and risk assessment
 - Enable Data-Driven Reporting - Create accessible insights for executives

---

### 📋 Project Plan

**Click the preview below to view the complete interactive project plan:**

[![Project Plan Preview](Data Warehouse/Docs/Notion-photo.png)](https://garrulous-cake-5cd.notion.site/Supply-Chain-Analysis-Project-Plan-eaf8285b7a0c4c9ab311f08658e064c3?source=copy_link)

> 👆 **Click to open the full project plan in Notion** | [Alternative text link →](https://garrulous-cake-5cd.notion.site/Supply-Chain-Analysis-Project-Plan-eaf8285b7a0c4c9ab311f08658e064c3)

---

## 📊 Dataset Information

**Source**: [DataCo Smart Supply Chain for Big Data Analysis (Kaggle)](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)

### Dataset Characteristics

- **Records**: 180,000+ unique orders (2015–2018)
- **Attributes**: 50+ supply chain features
- **Size**: ~180MB (too large for GitHub)
- **Granularity**: Order-line level transactions
- **Scope**: Customer data, product catalog, orders, shipping, financials

### Data Files

- `DataCoSupplyChainDataset.csv` - Main transactional dataset
- `DescriptionDataCoSupplyChain.csv` - Data dictionary and metadata
- `tokenized_access_logs.csv` - System access logs

> ⚠️ **Important**: Data files are NOT included in this repository due to size limitations. Follow setup instructions below to download.

---



## 👥 Team Structure

**Project Timeline**: 10 weeks  
**Team Size**: 4 members  
**Organization**: Role-based division of responsibilities

### Team Roles

| Role | Responsibility | Team Member | Status |
|------|---------------|-------------|---------|
| **Data Warehouse Engineer** | Data management, ETL pipeline, dimensional modeling | Saleem Khaled | ✅ In Progress |
| **Data Analyst #1** | Exploratory analysis, business insights (Python) | TBD | 🔜 Pending |
| **Data Analyst #2** | Predictive modeling, forecasting (Python) | TBD | 🔜 Pending |
| **Data Analyst #3** | Visualization, reporting, dashboards (Python) | TBD | 🔜 Pending |

---


## 🏗️ Repository Structure

```
Supply-Chain-Data-Analysis/
│
├── Data Warehouse/              # 🔧 Data Engineering Work (Saleem)
│   ├── ETL/                     # Extract, Transform, Load scripts
│   ├── Models/                  # Dimensional models & schemas
│   ├── Data_Quality/            # Validation & cleansing
│   ├── SQL/                     # Database scripts
│   └── Docs/                    # Technical documentation
│
├── Analysis/                    # 📈 Python Analysis Work (Team)
│   ├── exploratory/             # EDA notebooks
│   ├── modeling/                # Predictive models
│   ├── visualizations/          # Charts and dashboards
│   └── reports/                 # Analysis findings
│
├── data/                        # Raw data files (git-ignored)
│   └── README.md                # Download instructions
│
├── images/                      # Project assets
│   └── notion-project-plan-preview.png
│
├── requirements.txt             # Python dependencies
├── .gitignore                   # Git ignore configuration
└── README.md                    # This file
```

---

## 🏗️ Project Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](docs/data_architecture.png)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Data Architecture Resposibilities

This Role involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.
---

## 📈 Analysis Team Responsibilities

The analysis team will use the prepared data warehouse to perform Python-based analysis:

### Analyst #1: Exploratory Data Analysis
- Data profiling and statistical analysis
- Identify patterns and trends
- Customer segmentation
- Product performance analysis

### Analyst #2: Predictive Modeling
- Demand forecasting models
- Delivery time predictions
- Cost optimization algorithms
- Risk assessment models

### Analyst #3: Visualization & Reporting
- Interactive dashboards
- Business intelligence reports
- Data storytelling
- Presentation materials

---

## 🚀 Setup Instructions

### Prerequisites

- Python 3.8+
- SQL database (SQL Server recommended)
- Git
- Kaggle account (free)

### For Data Engineering Work

#### Step 1: Clone Repository

```bash
git clone https://github.com/Selim9-9/Supply-Chain-Data-Analysis.git
cd Supply-Chain-Data-Analysis
```

#### Step 2: Download Dataset

1. Go to [Kaggle Dataset Page](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)
2. Click **Download** (sign in required)
3. Extract ZIP file
4. Place CSV files in `data/` folder:

```bash
mkdir -p data
mv ~/Downloads/DataCoSupplyChainDataset.csv data/
mv ~/Downloads/DescriptionDataCoSupplyChain.csv data/
mv ~/Downloads/tokenized_access_logs.csv data/
```

#### Step 3: Set Up Environment

```bash
# Create virtual environment
python -m venv venv

# Activate environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

#### Step 4: Configure Database

Create `.env` file in project root:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=dataco_warehouse
DB_USER=your_username
DB_PASSWORD=your_password
```

#### Step 5: Initialize Data Warehouse

```bash
# Navigate to Data Warehouse folder
cd "Data Warehouse"

# Run setup scripts
python ETL/initialize_warehouse.py
```

### For Analysis Team

Once the data warehouse is ready:

1. Connect to the prepared data warehouse
2. Access dimension and fact tables
3. Use provided SQL views for analysis
4. Refer to data dictionary in `Data Warehouse/Docs/`

---

## 📚 Data Warehouse Documentation

Detailed technical documentation is available in the `Data Warehouse/Docs/` folder:

- **Data Dictionary**: Complete field definitions and descriptions
- **ETL Documentation**: Process flows and transformation logic
- **Data Model**: ER diagrams and schema design
- **SQL Guide**: Query examples and best practices

---



## 👤 Project Lead - Data Engineering

**Saleem Khaled**  
Data Warehouse Engineer | Data Management Specialist

- 🔗 [LinkedIn](https://www.linkedin.com/in/saleem-khaled-a502b3253/)
- 💻 [GitHub](https://github.com/Selim9-9)
- 📊 Freelancer Platform: Freelancer.com

**Specialization**: Excel dashboards, data warehousing, ETL pipeline development, database management

---

## 🤝 Collaboration Guidelines

### For Team Members

- **Data Requests**: Contact Saleem for data warehouse access
- **New Data Needs**: Submit requests through GitHub Issues
- **Bug Reports**: Use issue tracker for data quality concerns
- **Documentation**: Check `Data Warehouse/Docs/` before asking questions

### Branching Strategy

- `main` - Production-ready code
- `dev-warehouse` - Data engineering development (Saleem)
- `dev-analysis` - Analysis team development
- Feature branches: `feature/your-feature-name`

---

## 📝 License

This project is for educational and portfolio purposes.

---

## 📧 Contact

For questions about the data warehouse or data access:
- Open a GitHub Issue
- Contact Saleem Khaled via LinkedIn

For general project inquiries, refer to the [Notion Project Plan](https://garrulous-cake-5cd.notion.site/Supply-Chain-Analysis-Project-Plan-eaf8285b7a0c4c9ab311f08658e064c3).
