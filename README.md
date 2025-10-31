# Supply Chain Data Analysis - Team Project 📊

## DataCo Global Supply Chain Analysis

## Dataset Overview
- 180,000+ order records from 2015-2018.
- 50+ features covering customer orders, products, shipping, delivery, and financials.
- 30,000+ unique customers and 10,000+ products.
- Key data includes: Order ID, customer details, product categories, shipping modes, delivery status, costs, and late delivery risk indicators.

## Business Goals 
#### Primary Goals - 8 Week Timeline
- Delivery Performance Analysis: Create actionable insights to improve the current 41% on-time delivery rate toward industry benchmark of 95%
- Cost Optimization: Identify 10-15% cost reduction opportunities through data-driven shipping and operational analysis
- Customer Segmentation: Develop practical customer segments for retention strategies
- Interactive Dashboards: Build executive and operational dashboards for ongoing monitoring


### 📋 Project Plan

**Click the preview below to view the complete interactive project plan:**

[![Project Plan Preview](./Data%20Warehouse/Docs/Notion_photo.png)](https://garrulous-cake-5cd.notion.site/Supply-Chain-Analysis-Project-Plan-eaf8285b7a0c4c9ab311f08658e064c3)

> 👆 **Click to open the full project plan in Notion** | [Alternative text link →](https://garrulous-cake-5cd.notion.site/Supply-Chain-Analysis-Project-Plan-eaf8285b7a0c4c9ab311f08658e064c3)

---

### Data Files

- `DataCoSupplyChainDataset.csv` - Main transactional dataset
- `DescriptionDataCoSupplyChain.csv` - Data dictionary and metadata
- `tokenized_access_logs.csv` - System access logs

> ⚠️ **Important**: Data files are NOT included in this repository due to size limitations. Follow setup instructions below to download.

---

## 👥 Team Structure

**Project Timeline**: 8 weeks  
**Team Size**: 4 members  
**Organization**: Role-based division of responsibilities

### Team Roles

| Role | Responsibility | Team Member | Status |
|------|---------------|-------------|---------|
| **Data Warehouse Engineer** | Data management, ETL pipeline, dimensional modeling | Saleem Khaled | ✅ In Progress |
| **Business Analyst** |Excel-based financial analysis | Mohamed Mostafa | ✅ In Progress |
| **Data Scientist** | Python-based analytics, modeling, and automation | Mohammed Sameer | ✅ In Progress |
| **Business Intelligence Analyst** |  dashboard design, development, and reporting | Abdelrahman Mohamed | ✅ In Progress |


---

## 📖 Project Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](./Data%20Warehouse/Docs/data_architecture.png)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---

## 🚀 Project Deliverables

1. Data Infrastructure (cleaned dataset, database schema)
2. Analysis Reports (performance, costs, risks)
3. Financial Models (Excel-based scenarios)
4. Visual Dashboards (Tableau workbooks)
5. Predictive Insights (Python forecasts)
6. Recommendations Deck (executive presentation)
7. Documentation (technical specs, setup guides)

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

**Specialization**: Excel dashboards, data warehousing, ETL pipeline development, database management

---

## 📧 Contact

For questions about the data warehouse or data access:
- Open a GitHub Issue
- Contact Saleem Khaled via LinkedIn

For general project inquiries, refer to the [Notion Project Plan](https://garrulous-cake-5cd.notion.site/Supply-Chain-Analysis-Project-Plan-eaf8285b7a0c4c9ab311f08658e064c3).
