# Determinants of Regional Entrepreneurial Activity in Poland (Cross-Sectional Analysis 2024)

## Project Overview
[cite_start]This repository contains an econometric analysis focusing on the factors driving the emergence of new business entities across 380 counties (*powiaty*) in Poland using data from 2024[cite: 19, 27]. [cite_start]The project shifts the analytical focus from company survival (traditionally analyzed using survival analysis techniques) to the **creation phase**, seeking to understand why certain regions foster higher entrepreneurial activity than others[cite: 13, 15].

[cite_start]The dataset was sourced from the **Local Data Bank of the Central Statistical Office of Poland (GUS - BDL)**[cite: 27].

---

## Theoretical Background & Inspiration
[cite_start]The study is conceptually inspired by the work of **Iwona Markowicz (2015)** on corporate lifespans and cohort behavior[cite: 13, 251]. [cite_start]In regional economics, **agglomeration effects** play a vital role: highly urbanized and densely populated areas offer better market demand, wider networks, and qualified labor pools, lowering entry costs for new firms[cite: 12, 154].

### Research Questions:
1. [cite_start]Are local housing conditions and development linked to business creation[cite: 21]?
2. [cite_start]Do infrastructure developments (e.g., road density) and urbanization strengthen regional entrepreneurial activity[cite: 22]?
3. [cite_start]Is there a positive agglomeration loop between existing enterprises and new business registrations[cite: 23]?
4. [cite_start]Do urban density and existing market size dominate over pure physical infrastructure when explaining where new firms emerge[cite: 24]?

---

## Variables Specification

* [cite_start]**Dependent Variable ($Y$):** Number of newly registered entities in the REGON register per 10,000 inhabitants (a proxy for active local entrepreneurship)[cite: 30].

* **Independent Variables ($X$):**
  * [cite_start]**$X_1$:** Dwellings completed per 10,000 inhabitants (local housing market and development proxy)[cite: 31].
  * **$X_2$:** Average monthly gross salary in PLN (proxy for regional purchasing power and economic attractiveness)[cite: 32].
  * **$X_3$:** Population density (population per 1 $\text{km}^2$ – proxy for urbanization and local demand)[cite: 33].
  * **$X_4$:** Hard-surfaced municipal and county roads per 10,000 inhabitants (proxy for infrastructural accessibility)[cite: 34].
  * **$X_5$:** Existing entities registered in REGON per 10,000 inhabitants (proxy for the density of the established business ecosystem)[cite: 35].

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
Initial inspection revealed that the dependent variable ($Y$) exhibits a unimodal, right-skewed distribution ($\text{Skewness} = 2.36$, $\text{Kurtosis} = 11.88$)[cite: 72, 92]. This suggests strong spatial disparities where a few major urban centers pull up the national average[cite: 95]. Pearson correlation showed that $X_5$ (existing businesses) is the strongest linear predictor ($r = 0.894$)[cite: 101].

### 2. Base Model Estimation (OLS)
An initial multiple linear regression model was built using the Ordinary Least Squares (OLS) method[cite: 59]:
$$Y = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \beta_3 X_3 + \beta_4 X_4 + \beta_5 X_5 + \varepsilon$$

### 3. Backward Elimination & Refinement
The variable $X_2$ (Average Salary) was found to be statistically insignificant ($p = 0.158$) and was removed via backward elimination ($\alpha = 0.05$)[cite: 162, 172, 173]. Interestingly, while $X_3$ (Population Density) was borderline insignificant in the base model, it became statistically significant after dropping $X_2$ ($p = 0.045$) and was thus retained[cite: 174, 175, 178].

### 4. Diagnostic Testing
* [cite_start]**Normality of Residuals:** Rejected by the **Jarque-Bera Test** ($p < 0.05$), indicating asymptotic behavior common in regional cross-sectional data[cite: 66, 67, 215].
* [cite_start]**Autocorrelation:** The **Durbin-Watson Test** yielded $p = 0.0648$, showing no severe positive autocorrelation at standard levels[cite: 215].
* **Heteroskedasticity:** The **Goldfeld-Quandt Test** and residual-vs-fitted plots confirmed non-constant variance (heteroskedasticity)[cite: 63, 213, 215]. 
* [cite_start]**Robustness Check:** Due to heteroskedasticity, **White’s robust standard errors (HC1)** were computed[cite: 216]. [cite_start]While $X_3$ lost significance under HC1, a **Nested Model F-Test (ANOVA)** proved that keeping $X_3$ significantly improves model fit ($F = 4.037, p = 0.045$)[cite: 217, 218].

---

## Key Findings & Final Model Results

[cite_start]The final optimized model explains **83.5%** of the variance in new business registrations ($\text{Adjusted } R^2 = 0.8355, F = 482.1, p < 0.0001$)[cite: 184, 185, 186].

| Variable | Coefficient ($\hat{\beta}$) | Std. Error | t-value | p-value | Interpretation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **(Intercept)** | -1.7086 | 3.0177 | -0.566 | 0.5716 | [cite_start]Baseline constant. |
| **$X_1$ (Housing)** | 0.2125 | 0.0245 | 8.684 | $< 0.0001$ | An increase of 1 dwelling per 10k inhabitants increases $Y$ by ~0.21[cite: 178, 188, 189]. |
| **$X_3$ (Density)** | 0.0021 | 0.0011 | 2.009 | 0.0452 | [cite_start]Higher population density moderately increases $Y$[cite: 178, 190]. |
| **$X_4$ (Roads)** | 0.0481 | 0.0126 | 3.816 | 0.0001 | [cite_start]Better road infrastructure correlates with an increase in $Y$[cite: 178, 193, 194]. |
| **$X_5$ (Eco-System)**| 0.0579 | 0.0022 | 26.431 | $< 0.0001$ | [cite_start]Crucial driver; every additional existing firm brings an extra 0.058 new firms[cite: 178, 191, 192]. |

### Main Conclusions:
* [cite_start]**Agglomeration Loops Dictate Entrepreneurship:** The strongest predictor by far is the size of the existing business ecosystem ($X_5$)[cite: 192, 232]. [cite_start]New companies emerge where there is already a high concentration of markets, suppliers, and business networks (the "scale effect")[cite: 154, 229].
* **Housing as a Catalyst:** The local real estate boom ($X_1$) strongly attracts new micro-enterprises (renovation, services, local trade) to newly developed neighborhoods[cite: 38, 39].
* [cite_start]**Market Concentration > Infrastructure:** Urban density and market volume take precedence over physical road infrastructure ($X_4$) in explaining where companies choose to register[cite: 231, 233].

---
[cite_start]*Developed as part of the Econometrics Course curriculum (2026).* [cite: 4, 5]
