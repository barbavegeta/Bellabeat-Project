# Bellabeat Fitbit Data Analysis Portfolio

Welcome to my portfolio showcasing a comprehensive case study for Bellabeat, using Fitbit data. This repository contains all the materials—data, analysis code, visualizations, and the final presentation—to demonstrate my end-to-end analytics workflow.

---

## 📁 Repository Structure

```
Bellabeat-Portfolio/
├── data/                       # Cleaned CSVs and raw datasets
│   ├── user_summary_readr.csv
│   ├── daily_activity.csv
│   ├── minute_mets.csv
│   └── ...                     # other summary and raw files
├── code/                       # Analysis scripts
│   ├── analysis.R              # R script combining all summaries
│   ├── charts.R                # R scripts for ggplot2 charts
│   └── export_activity_long.R  # R script reshaping data for Tableau
├── tableau/                    # Tableau workbook and exports
│   ├── Bellabeat_Dashboard.twbx
│   └── activity_minutes_long.csv
├── presentation/               # Final presentation
│   └── Bellabeat_Case_Study_Insights.pptx
├── images/                     # Exported charts for README or PPT
│   ├── met_vs_weight.png
│   ├── intensity_vs_mets.png
│   ├── activity_vs_hr.png
│   └── activity_profiles.png
└── README.md                   # This document
```

---

## 🚀 Getting Started

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/Bellabeat-Portfolio.git
   cd Bellabeat-Portfolio
   ```

2. **Explore the data** in `data/` (CSV files).

3. **Run the analysis**:

   ```r
   source("code/analysis.R")
   ```

4. **Visualize in R** by sourcing `code/charts.R` or open `tableau/Bellabeat_Dashboard.twbx` in Tableau.

5. **Review the presentation** in `presentation/Bellabeat_Case_Study_Insights.pptx`.

---

## 📊 Key Insights

* **METs vs Weight Change**: Each +1 MET correlates with \~0.23% weight loss (R²=0.29).
* **Activity Intensity vs METs**: Very-active minutes explain \~60% of MET variation (p<0.0001).
* **Activity vs Resting HR**: No single intensity bucket strongly predicts resting heart rate.
* **User Segmentation**: Users grouped into High, Moderate, Low intensity for targeted recommendations.

---

## 🎯 Recommendations

* Highlight "Very Active" streaks in the Bellabeat app.
* Send light-activity reminders to boost overall METs.
* Create combined active-minute dashboards linking to resting HR trends.
* Introduce MET-based fitness challenges in marketing campaigns.

---

## 📂 Additional Resources

* **Data Sources**: Original Kaggle Fitbit dataset (CC0 Public Domain).
* **R Code**: Modular scripts in `code/` folder.
* **Tableau**: Dashboard workbook in `tableau/`.
* **Presentation**: Final slide deck in `presentation/`.

---
