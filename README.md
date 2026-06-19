# Determinants of Regional Entrepreneurial Activity in Poland (Cross-Sectional Analysis 2024)

## Project Overview
This repository contains an econometric analysis focusing on the factors driving the emergence of new business entities across 380 counties (*powiaty*) in Poland using data from 2024. The project shifts the analytical focus from company survival (traditionally analyzed using survival analysis techniques) to the **creation phase**, seeking to understand why certain regions foster higher entrepreneurial activity than others.

The dataset was sourced from the **Local Data Bank of the Central Statistical Office of Poland (GUS - BDL)**.

---

## Theoretical Background & Inspiration
The study is conceptually inspired by the work of **Iwona Markowicz (2015)** on corporate lifespans and cohort behavior. In regional economics, **agglomeration effects** play a vital role: highly urbanized and densely populated areas offer better market demand, wider networks, and qualified labor pools, lowering entry costs for new firms.

### Research Questions:
1. Are local housing conditions and development linked to business creation?
2. Do infrastructure developments (e.g., road density) and urbanization strengthen regional entrepreneurial activity?
3. Is there a positive agglomeration loop between existing enterprises and new business registrations?
4. Do urban density and existing market size dominate over pure physical infrastructure when explaining where new firms emerge?

---

## Variables Specification

* **Dependent Variable ($Y$):** Number of newly registered entities in the REGON register per 10,000 inhabitants (a proxy for active local entrepreneurship).

* **Independent Variables ($X$):**
  * **$X_1$:** Dwellings completed per 10,000 inhabitants (local housing market and development proxy).
  * **$X_2$:** Average monthly gross salary in PLN (proxy for regional purchasing power and economic attractiveness).
  * **$X_3$:** Population density (population per 1 $\text{km}^2$ – proxy for urbanization and local demand).
  * **$X_4$:** Hard-surfaced municipal and county roads per 10,000 inhabitants (proxy for infrastructural accessibility).
  * **$X_5$:** Existing entities registered in REGON per 10,000 inhabitants (proxy for the density of the established business ecosystem).

---

## Tech Stack & Packages
The analysis was performed entirely in **R (RStudio)** utilizing the following packages:
* `readxl` – Data ingestion
* `dplyr` – Data manipulation
* `car`, `lmtest`, `sandwich` – Econometric modeling and diagnostic testing
* `tseries`, `moments` – Distribution and normality analysis
* `corrplot` – Matrix correlation visualization

---

## Methodology & Modeling Workflow

### 1. Exploratory Data Analysis (EDA)
Initial inspection revealed that the dependent variable ($Y$) exhibits a unimodal, right-skewed distribution ($\text{Skewness} = 2.36$, $\text{Kurtosis} = 11.88$). This suggests strong spatial disparities where a few major urban centers pull up the national average. Pearson correlation showed that $X_5$ (existing businesses) is the strongest linear predictor ($r = 0.894$).

### 2. Base Model Estimation (OLS)
An initial multiple linear regression model was built using the Ordinary Least Squares (OLS) method:
$$Y = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \beta_3 X_3 + \beta_4 X_4 + \beta_5 X_5 + \varepsilon$$

### 3. Backward Elimination & Refinement
The variable $X_2$ (Average Salary) was found to be statistically insignificant ($p = 0.158$) and was removed via backward elimination ($\alpha = 0.05$). Interestingly, while $X_3$ (Population Density) was borderline insignificant in the base model, it became
