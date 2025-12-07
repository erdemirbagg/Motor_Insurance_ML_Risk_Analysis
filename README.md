# Motor_Insurance_ML_Risk_Analysis

In this project I analyse the classic **freMTPL2freq** French motor insurance portfolio and
build a small end-to-end risk analytics pipeline:

- Load the data into **Google BigQuery Sandbox**
- Explore claim frequencies in **SQL**
- Train a simple claim frequency model with **BigQuery ML**
- Visualise portfolio and model results in **Looker Studio**

The goal is to demonstrate cloud-based insurance analytics for an insurtech / data role.

## Data

- Source: Kaggle – *French Motor Claims Datasets (freMTPL2freq)*
- Unit of observation: policy–year exposure
- Key variables: `ClaimNb`, `Exposure`, `DrivAge`, `VehAge`, `BonusMalus`,
  `Area`, `Region`, `VehBrand`, `VehGas`, `Density`

I use rows with `Exposure > 0` and define the main target as:

> `ClaimFrequency = ClaimNb / Exposure`

## BigQuery pipeline

1. **Upload to BigQuery**
   - Create dataset `motor_claims` (EU region, BigQuery Sandbox)
   - Upload `freMTPL2freq.csv` as table `freMTPL2freq`

2. **Exploratory analysis in SQL**
   - Portfolio-level summary (rows, policies, total exposure, total claims, overall frequency)
   - Claim frequency by:
     - `Region` → table `freq_by_region`
     - `Area` (A–F) → table `freq_by_area`
     - 5-year driver age bands → table `freq_by_age_band`

3. **Claim frequency model with BigQuery ML**
   - Model: `claimfreq_reg` (linear regression)
   - Label: `ClaimFrequency`
   - Features: driver age, vehicle age & power, bonus–malus, density,
     region, area, vehicle brand and fuel type
   - Training data: all policies with `Exposure > 0`
   - Evaluation via `ML.EVALUATE` (MSE, MAE, R², explained variance)

4. **Predictions for BI**
   - Row-level predictions: `predictions_rowlevel`
   - Aggregated by age band: `predictions_by_age_band`  
     → used for comparing **actual vs predicted** claim frequency by driver age.

5. **Looker Studio dashboard**
   - Bar chart: claim frequency & total exposure by **region**
   - Bar chart: claim frequency by **driver age band**
   - Combo chart: **actual vs predicted** frequency by age band  
     (bars = predicted, line = observed)

Screenshots of the dashboard live in the `img/` folder.

## Python script

The `Code` script contains an earlier local analysis of the same dataset in Python
(pandas / seaborn). The current focus of the project, however, is on the
**BigQuery + BigQuery ML + Looker Studio** cloud workflow.

## How to reproduce the BigQuery part

1. Create a BigQuery project (Sandbox is enough).
2. Create dataset `motor_claims` in the EU region.
3. Upload `freMTPL2freq.csv` as table `freMTPL2freq`.
4. Run the SQL scripts in `sql/` in numeric order.
5. Connect the resulting tables to Looker Studio and recreate the three charts
   shown in `img/`.

## What this project shows

- Working with **cloud data warehouses** (Google BigQuery)
- Using **SQL** for portfolio / risk analysis
- Training a basic **claim frequency model** in BigQuery ML
- Building a **BI dashboard** in Looker Studio for insurance risk insights
