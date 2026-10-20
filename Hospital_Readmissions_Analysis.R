
# ==========================================================
# HOSPITAL READMISSIONS PERFORMANCE ANALYSIS
# CMS Hospital Readmissions Reduction Program
# ==========================================================
#
# Project Goal:
# Analyze hospital readmission performance across six
# medical conditions and procedures using publicly
# available CMS data.
#
# Tools: R and RStudio
# Methods: Data cleaning, descriptive statistics,
# grouped comparisons, ranking, threshold analysis,
# and data visualization.
#
# ==========================================================


# ==========================================================
# 1. IMPORT DATASET
# ==========================================================

hospital_data <- read.csv(
  file.choose(),
  header = TRUE
)
 
# ==========================================================
# 2. EXPLORE DATASET
# ==========================================================

# View the first six records.
head(hospital_data)

# Check the number of rows and columns.
dim(hospital_data)

# View variable names.
names(hospital_data)

# Examine variable types.
str(hospital_data)

# Review descriptive statistics.
summary(hospital_data)

# ==========================================================
# 3. CLEAN DATA
# ==========================================================

hospital_clean <- hospital_data

# Identify columns that should contain numeric values.
numeric_columns <- c(
  "Number.of.Discharges",
  "Excess.Readmission.Ratio",
  "Predicted.Readmission.Rate",
  "Expected.Readmission.Rate",
  "Number.of.Readmissions"
)

# Convert selected columns to numeric format.
# Non-numeric entries become NA.
hospital_clean[numeric_columns] <- lapply(
  hospital_clean[numeric_columns],
  function(x) suppressWarnings(as.numeric(x))
)

# Check the updated variable types.
str(hospital_clean)


# ==========================================================
# 4. ASSESS MISSING VALUES
# ==========================================================

colSums(is.na(hospital_clean))

# Some CMS records do not report all readmission measures.
# Missing values are retained in the cleaned dataset.

# ==========================================================
# 5. PREPARE ANALYSIS DATASET
# ==========================================================

# Keep records with an available excess readmission ratio.
hospital_analysis <- subset(
  hospital_clean,
  !is.na(Excess.Readmission.Ratio)
)

# Check the dimensions of the analysis dataset.
dim(hospital_analysis)

# Examine the distribution of excess readmission ratios.
summary(hospital_analysis$Excess.Readmission.Ratio)

# Interpretation of ERR:
# ERR < 1.0: Lower-than-expected readmissions
# ERR = 1.0: Readmissions consistent with expectations
# ERR > 1.0: Higher-than-expected readmissions

# ERR is a risk-adjusted performance ratio.
# It is not the percentage of patients readmitted.

# ==========================================================
# RESEARCH QUESTION 1
# Which medical conditions have the highest percentage
# of hospital records with above-expected readmissions?
# ==========================================================


# ----------------------------------------------------------
# 1.1 CALCULATE RESULTS
# ----------------------------------------------------------

# Identify records with ERR greater than 1.0.
hospital_analysis$Above.Expected <-
  hospital_analysis$Excess.Readmission.Ratio > 1

# Calculate the proportion above expected by condition.
condition_results <- aggregate(
  Above.Expected ~ Measure.Name,
  data = hospital_analysis,
  FUN = mean
)

# Convert proportions to percentages.
condition_results$Above.Expected <-
  condition_results$Above.Expected * 100

# Sort from highest to lowest.
condition_results <- condition_results[
  order(-condition_results$Above.Expected),
]


# ----------------------------------------------------------
# 1.2 DISPLAY RESULTS
# ----------------------------------------------------------

print(condition_results)

# Display counts above and below expected.
table(
  hospital_analysis$Measure.Name,
  hospital_analysis$Above.Expected
)


# ----------------------------------------------------------
# 1.3 CREATE VISUALIZATION
# ----------------------------------------------------------

measure_labels <- c(
  "READM-30-CABG-HRRP" = "CABG",
  "READM-30-AMI-HRRP" = "AMI",
  "READM-30-HF-HRRP" = "Heart Failure",
  "READM-30-HIP-KNEE-HRRP" = "Hip/Knee",
  "READM-30-COPD-HRRP" = "COPD",
  "READM-30-PN-HRRP" = "Pneumonia"
)

# Match labels to the results.
condition_names <- measure_labels[
  condition_results$Measure.Name
]

barplot(
  condition_results$Above.Expected,
  names.arg = condition_names,
  main = "Hospital Readmission Performance by Condition",
  xlab = "Medical Condition",
  ylab = "Records Above Expected (%)",
  col = "steelblue",
  ylim = c(0, 60),
  cex.names = 0.85
)


# ----------------------------------------------------------
# 1.4 INTERPRETATION
# ----------------------------------------------------------

# Coronary artery bypass grafting (CABG) had the highest
# percentage of records with above-expected readmissions
# at 49.89%, followed by acute myocardial infarction (AMI)
# at 49.65% and heart failure at 48.91%.
#
# Pneumonia had the lowest percentage at 46.81%.
# The difference between the highest and lowest categories
# was approximately 3.07 percentage points.
#
# These results suggest relatively similar proportions
# of above-expected records across all six categories.
# These percentages do not represent patient readmission rates.


# ==========================================================
# RESEARCH QUESTION 2
# Which medical conditions have the highest average
# excess readmission ratios?
# ==========================================================


# ----------------------------------------------------------
# 2.1 CALCULATE RESULTS
# ----------------------------------------------------------

average_results <- aggregate(
  Excess.Readmission.Ratio ~ Measure.Name,
  data = hospital_analysis,
  FUN = mean
)

# Sort from highest to lowest average ERR.
average_results <- average_results[
  order(-average_results$Excess.Readmission.Ratio),
]


# ----------------------------------------------------------
# 2.2 DISPLAY RESULTS
# ----------------------------------------------------------

print(average_results)


# ----------------------------------------------------------
# 2.3 CREATE VISUALIZATION
# ----------------------------------------------------------

# Match labels to the measure names.
average_labels <- measure_labels[
  average_results$Measure.Name
]

dotchart(
  average_results$Excess.Readmission.Ratio,
  labels = average_labels,
  main = "Average Excess Readmission Ratio by Condition",
  xlab = "Average Excess Readmission Ratio",
  pch = 19,
  col = "steelblue",
  xlim = c(0.99, 1.01)
)

# Add a benchmark line representing expected performance.
abline(
  v = 1,
  col = "red",
  lty = 2
)


# ----------------------------------------------------------
# 2.4 INTERPRETATION
# ----------------------------------------------------------

# Hip/knee replacement had the highest average ERR
# at approximately 1.003985.
#
# CABG followed at 1.001789, and AMI at 1.001755.
# COPD had the lowest average ERR at 1.001133.
#
# All six averages were extremely close to 1.0,
# indicating that the unweighted category averages
# were similar to the expected-performance benchmark.
#
# Importantly, CABG had the highest percentage of records
# above expected in Question 1, while hip/knee replacement
# had the highest average ERR in Question 2.
#
# This demonstrates why multiple performance measures
# should be examined rather than relying on averages alone.


# ==========================================================
# RESEARCH QUESTION 3
# Which hospital-measure records have the highest
# excess readmission ratios?
# ==========================================================


# ----------------------------------------------------------
# 3.1 CALCULATE RESULTS
# ----------------------------------------------------------

# Sort hospital-measure records by ERR, highest first.
hospital_rankings <- hospital_analysis[
  order(-hospital_analysis$Excess.Readmission.Ratio),
]

# Select the 10 records with the highest ERR.
top_hospitals <- hospital_rankings[
  1:10,
  c(
    "Facility.Name",
    "State",
    "Measure.Name",
    "Excess.Readmission.Ratio",
    "Number.of.Discharges",
    "Number.of.Readmissions"
  )
]


# ----------------------------------------------------------
# 3.2 DISPLAY RESULTS
# ----------------------------------------------------------

print(top_hospitals)


# ----------------------------------------------------------
# 3.3 CREATE VISUALIZATION
# ----------------------------------------------------------

# Create abbreviated hospital names for the chart.
hospital_labels <- c(
  "Fairfield Medical",
  "Carle BroMenn",
  "Holy Family",
  "Morton Hospital",
  "Great Plains Regional",
  "Saint Francis Muskogee",
  "HCA Oak Hill",
  "St Mary's",
  "Good Samaritan",
  "ECU Health"
)

# Save current plot settings.
old_par <- par(no.readonly = TRUE)

# Increase left margin to display hospital labels.
par(mar = c(5, 10, 4, 2))

barplot(
  rev(top_hospitals$Excess.Readmission.Ratio),
  names.arg = rev(hospital_labels),
  horiz = TRUE,
  las = 1,
  col = "steelblue",
  main = "Top 10 Highest Excess Readmission Ratios",
  xlab = "Excess Readmission Ratio",
  cex.names = 0.8,
  xlim = c(0, 1.8)
)

# Add the expected-performance benchmark.
abline(
  v = 1,
  col = "red",
  lty = 2
)

# Restore previous plot settings.
par(old_par)


# ----------------------------------------------------------
# 3.4 INTERPRETATION
# ----------------------------------------------------------

# All 10 hospital-measure records with the highest ERR
# were associated with hip/knee replacement procedures.
#
# Fairfield Medical Center in Ohio had the highest ERR
# at 1.6297, followed by Carle BroMenn Medical Center
# in Illinois at 1.5827.
#
# These values indicate predicted readmissions approximately
# 62.97% and 58.27% higher than expected, respectively,
# under the CMS risk-adjustment methodology.
#
# This finding highlights substantial variation among
# individual hospital-measure records that was not apparent
# when comparing average ERR values alone.


# ==========================================================
# RESEARCH QUESTION 4
# Are substantially elevated ERR values more common
# among hip/knee replacement records than other conditions?
# ==========================================================


# ----------------------------------------------------------
# 4.1 CALCULATE RESULTS
# ----------------------------------------------------------

# Define substantially elevated ERR as greater than 1.20.

hospital_analysis$High.ERR <-
  hospital_analysis$Excess.Readmission.Ratio > 1.20

# Count records exceeding the threshold by condition.
high_err_results <- aggregate(
  High.ERR ~ Measure.Name,
  data = hospital_analysis,
  FUN = sum
)

# Calculate the proportion exceeding the threshold.
high_err_percent <- aggregate(
  High.ERR ~ Measure.Name,
  data = hospital_analysis,
  FUN = mean
)

# Convert proportions to percentages.
high_err_percent$High.ERR <-
  high_err_percent$High.ERR * 100

# Sort percentage results from highest to lowest.
high_err_percent <- high_err_percent[
  order(-high_err_percent$High.ERR),
]


# ----------------------------------------------------------
# 4.2 DISPLAY RESULTS
# ----------------------------------------------------------

print(high_err_results)

print(high_err_percent)


# ----------------------------------------------------------
# 4.3 CREATE VISUALIZATION
# ----------------------------------------------------------

# Match labels to the results.
high_err_labels <- measure_labels[
  high_err_percent$Measure.Name
]

barplot(
  high_err_percent$High.ERR,
  names.arg = high_err_labels,
  main = "Hospital Records with ERR Above 1.20",
  xlab = "Medical Condition",
  ylab = "Records with ERR Above 1.20 (%)",
  col = "steelblue",
  ylim = c(0, 12),
  cex.names = 0.85
)


# ----------------------------------------------------------
# 4.4 INTERPRETATION
# ----------------------------------------------------------

# Hip/knee replacement had the highest percentage of
# substantially elevated ERR values at 10.37%,
# representing 150 hospital-measure records.
#
# CABG ranked second at 3.30%, representing 29 records.
#
# Heart failure, AMI, pneumonia, and COPD each had
# fewer than 1% of records exceeding the 1.20 threshold.
#
# Hip/knee replacement therefore had more than three
# times the percentage of substantially elevated ERR
# records compared with CABG.
#
# This suggests a more pronounced upper tail in the
# distribution of reported hip/knee replacement ERR values.
#
# Further investigation would be needed to understand
# possible contributing factors. These results do not
# establish the causes of elevated readmissions.


# ==========================================================
# 6. SUMMARY OF FINDINGS
# ==========================================================

# QUESTION 1:
# CABG had the highest percentage of records with ERR > 1.0
# at approximately 49.89%.

# QUESTION 2:
# Hip/knee replacement had the highest average ERR,
# although all six category averages were close to 1.0.

# QUESTION 3:
# All 10 highest individual hospital-measure ERR values
# were associated with hip/knee replacement procedures.

# QUESTION 4:
# Hip/knee replacement had the highest percentage of
# records with ERR > 1.20 at approximately 10.37%.

# ==========================================================
# END OF ANALYSIS
# ==========================================================
