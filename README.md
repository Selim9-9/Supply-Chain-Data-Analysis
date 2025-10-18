# Supply Chain Data Analysis 📊

## DataCo Supply Chain Analysis Project

### 📋 Project Plan
**[→ View Interactive Project Plan (Notion)](https://garrulous-cake-5cd.notion.site/Supply-Chain-Analysis-Project-Plan-eaf8285b7a0c4c9ab311f08658e064c3)**

> **Timeline**: 8-week project  
> **Team Size**: 4 members  
> **Goal**: Analyze dataset to identify bottlenecks, forecast demand, optimize costs, and recommend actionable strategies

---

### 📊 Dataset Information

**DataCo Global** is a multinational e-commerce company managing a complex supply chain involving customer orders, product distribution, shipping, and global logistics.

- **Records**: 180,000+ unique orders (2015–2018)
- **Features**: 50+ supply chain attributes
- **Size**: ~180MB
- **Includes**: Customer profiles, product details, order status, delivery metrics, and financials

#### Dataset Source
- **Original Dataset**: [DataCo Smart Supply Chain for Big Data Analysis](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)
- **Platform**: Kaggle

---

### 🚨 Dataset Not Included in Repository

Due to GitHub's file size limitations, the dataset is **NOT** included in this repository. Please follow the setup instructions below to download and prepare the data.

---

### 🔧 Setup Instructions

#### Step 1: Download the Dataset

1. Go to [Kaggle DataCo Dataset Page](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)
2. Click "Download" (requires free Kaggle account)
3. Extract the downloaded ZIP file
4. You should have 3 CSV files:
   - `DataCoSupplyChainDataset.csv`
   - `DescriptionDataCoSupplyChain.csv`
   - `tokenized_access_logs.csv`

#### Step 2: Place Files in Repository

```bash
# Create data directory if it doesn't exist
mkdir -p data

# Move the extracted CSV files to the data directory
mv DataCoSupplyChainDataset.csv data/
mv DescriptionDataCoSupplyChain.csv data/
mv tokenized_access_logs.csv data/
```

#### Step 3: Install Dependencies

```bash
# Create virtual environment (recommended)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install required packages
pip install -r requirements.txt
```

---

### 📁 Project Structure

```
Supply-Chain-Data-Analysis/
├── data/                          # Data files (not tracked by git)
│   ├── DataCoSupplyChainDataset.csv
│   ├── DescriptionDataCoSupplyChain.csv
│   └── tokenized_access_logs.csv
├── notebooks/                     # Jupyter notebooks for analysis
├── scripts/                       # Python scripts
├── visualizations/                # Charts and dashboards
├── Data Warehouse/
│   └── Docs/
│       └── project-plan.html     # Embedded Notion plan
├── requirements.txt              # Python dependencies
└── README.md                     # This file
```

---

### 🎯 Project Objectives

- **Identify Bottlenecks**: Analyze delivery delays and supply chain inefficiencies
- **Demand Forecasting**: Predict future order patterns and trends
- **Cost Optimization**: Find opportunities to reduce shipping and operational costs
- **Strategic Recommendations**: Provide actionable insights for supply chain improvement

---

### 📈 Analysis Components

1. **Exploratory Data Analysis (EDA)**
   - Data quality assessment
   - Distribution analysis
   - Correlation studies

2. **Delivery Performance Analysis**
   - On-time delivery rates
   - Shipping method efficiency
   - Geographic performance patterns

3. **Financial Analysis**
   - Revenue trends
   - Profit margins by product/region
   - Cost structure analysis

4. **Predictive Modeling**
   - Demand forecasting
   - Delivery time predictions
   - Risk assessment

---

### 🔗 Resources

- **[📋 Full Project Plan (Notion)](https://garrulous-cake-5cd.notion.site/Supply-Chain-Analysis-Project-Plan-eaf8285b7a0c4c9ab311f08658e064c3)** - Detailed timeline and milestones
- **[🌐 Project Website](https://selim9-9.github.io/Supply-Chain-Data-Analysis/)** - View embedded project plan
- **[💾 Dataset (Kaggle)](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)** - Download original data

---

### 👤 Author

**Saleem Khaled**  
Freelance Data Analyst | Excel Specialist

- 🔗 [LinkedIn](https://www.linkedin.com/in/saleem-khaled-a502b3253/)
- 💻 [GitHub](https://github.com/Selim9-9)
- 📊 [Freelancer Profile](https://www.freelancer.com)

---

### 📝 License

This project is available for educational and portfolio purposes.

---

### 🤝 Contributing

This is a portfolio project, but feedback and suggestions are welcome! Feel free to open an issue or submit a pull request.
