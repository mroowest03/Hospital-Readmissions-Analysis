# Hospital Readmissions Performance Analysis
##Analyzing Hospital Readmission Trends Using R##

## Project Overview

Hospital readmissions are an important indicator of healthcare quality and operational performance. Unplanned readmissions can increase healthcare costs, place additional pressure on hospital resources, and affect patient outcomes.

The purpose of this project was to analyze hospital readmission performance across six medical conditions and procedures using publicly available data from the Centers for Medicare & Medicaid Services (CMS).

My goal was to identify patterns in hospital performance, investigate differences across medical categories, and determine which areas may warrant further investigation by healthcare leadership.

## Dataset

##Source:## [CMS FY 2026 Hospital Readmissions Reduction Program](https://data.cms.gov/provider-data/dataset/9n3s-kdb3#overview)

The original dataset contained 18,330 hospital-measure records and 12 variables, including hospital names, states, medical conditions, discharge counts, readmission counts, and excess readmission ratios.

After importing the data into R, I examined the dataset's structure, identified missing values, and converted relevant variables into numeric formats. For the primary analysis, I retained 11,720 records with available excess readmission ratios.

### Understanding the Excess Readmission Ratio

The excess readmission ratio (ERR) is a CMS risk-adjusted performance measure comparing predicted readmissions with expected readmissions.

- ##ERR below 1.0: Lower-than-expected readmissions
- ##ERR equal to 1.0: Readmissions consistent with expectations
- ##ERR above 1.0: Higher-than-expected readmissions

The ERR is not the percentage of patients who were readmitted.

## Tools and Methods

##Tools: R, RStudio

##Analytical techniques:##
- Data cleaning and numeric conversion
- Missing-value assessment
- Descriptive statistics
- Grouped comparisons and aggregation
- Hospital-measure ranking
- Threshold-based analysis
- Data visualization

The analysis focused on four business questions.

## Question 1: Which Medical Conditions Have the Highest Percentage of Above-Expected Readmissions?

I calculated the percentage of reported hospital-measure records with an ERR greater than 1.0 for each medical condition.

| Medical Condition | Records Above Expected |
|      ---          |            ---         |
| Coronary artery bypass grafting (CABG) | 49.89% |
| Acute myocardial infarction (heart attack) | 49.65% |
| Heart failure | 48.91% |
| Hip/Knee replacement | 47.89% |
| Chronic obstructive pulmonary disease (COPD) | 47.22% |
| Pneumonia | 46.81% |

**Key finding:** CABG had the highest proportion of records above expected, while pneumonia had the lowest. However, the difference between the two was only approximately 3.07 percentage points, indicating relatively similar proportions across all six categories.

## Question 2: Which Medical Conditions Have the Highest Average Excess Readmission Ratios?

I calculated the average ERR for each medical category to determine whether certain conditions demonstrated greater average deviations from expected readmission performance.

| Medical Condition | Average ERR |
|        ---        |     ---    |
| Hip/Knee replacement | 1.003985 |
| CABG | 1.001789 |
| Heart attack | 1.001755 |
| Pneumonia | 1.001486 |
| Heart failure | 1.001439 |
| COPD | 1.001133 |

**Key finding:** Hip/knee replacement had the highest average ERR, but all six averages were extremely close to the benchmark of 1.0.
This finding demonstrated that average performance alone might not reveal meaningful differences in the distribution of hospital readmission ratios.

## Question 3: Which Hospitals Have the Highest Excess Readmission Ratios?

I ranked hospital-measure records by their reported ERR values to identify the 10 highest observations.

**Key finding:** All 10 highest reported ERR values were associated with hip and knee replacement procedures. Fairfield Medical Center in Ohio had the highest ratio at 1.6297, followed by Carle BroMenn Medical Center in Illinois at 1.5827. These ratios indicate predicted readmissions approximately 62.97% and 58.27% higher than expected, respectively, under the CMS risk-adjustment methodology. This analysis highlighted differences between individual hospital-measure records that were not apparent from the overall category averages.

## Question 4: Are Substantially Elevated Readmission Ratios More Common Among Hip/Knee Replacement Procedures?

To investigate whether the elevated hip/knee ratios represented a broader pattern, I calculated the number and percentage of records with an ERR greater than 1.20. The 1.20 threshold was selected for exploratory analysis and is not an official CMS performance classification.

| Medical Condition | Records with ERR Above 1.20 | Percentage |
|       ---         |              ---            |    ---     |
| Hip/Knee replacement | 150 | 10.37% |
| CABG | 29 | 3.30% |
| Heart failure | 13 | 0.50% |
| Heart attack | 8 | 0.46% |
| Pneumonia | 12 | 0.44% |
| COPD | 1 | 0.04% |

**Key finding:** Hip/knee replacement had the highest proportion of substantially elevated ratios, at 10.37%, compared with 3.30% for CABG. This suggests that hip/knee replacement has a more pronounced upper tail of reported ERR values than the other categories, despite the similarity of their average ratios.

## Business Insights and Recommendations

The most important takeaway from this analysis is that average performance metrics can conceal meaningful differences between individual observations. Although average excess readmission ratios were similar across all six medical categories, the analysis of unusually elevated ratios revealed a notable concentration among hip and knee replacement records.

Based on these findings, I recommend that healthcare leadership:

1. Investigate facilities reporting substantially elevated hip/knee readmission ratios to better understand potential contributing factors.
2. Examine postoperative discharge planning, rehabilitation coordination, and follow-up care as potential areas for further evaluation.
3. Use multiple performance indicators rather than relying solely on averages when evaluating hospital performance.
4. Consider reporting completeness, patient populations, and risk-adjustment methodology before making operational decisions.

These recommendations identify opportunities for further investigation rather than establishing causes of readmissions.

## Limitations

This analysis has several limitations:

First, the dataset contains hospital-level performance measures rather than individual patient records. Therefore, the findings cannot identify specific patient characteristics or establish the causes of readmissions.

Second, some discharge counts, readmission counts, and ERR values were unavailable. The primary analysis excluded records without reported ERR values, which may affect how representative the findings are.

Third, comparisons across medical categories should be interpreted cautiously because CMS uses condition-specific risk-adjustment models.

Finally, the analyses were descriptive. No statistical significance testing or causal analysis was performed.

## Conclusion

This project strengthened my ability to transform raw data into meaningful business insights using R. By moving beyond overall averages and examining the frequency and magnitude of elevated readmission ratios, I identified patterns that would not have been apparent through summary statistics alone. The project reinforced the importance of asking focused analytical questions, understanding the limitations of a dataset, and communicating findings in a way that can support informed business decisions.
