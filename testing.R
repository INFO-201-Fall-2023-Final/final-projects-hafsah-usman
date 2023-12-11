library(dplyr)
library(tidyr)

# Read data
df <- read.csv("unified_and_cleaned_data.csv")

# Print structure of the original data frame
str(df)

# Pivot the data wider
reshaped_data <- pivot_wider(
  data = df,
  id_cols = MonthYear,
  names_from = Indicator,
  values_from = c(Average_Percentage_per_Condition, Average_New_Cases, Cumulative_Cases_EndOfMonth)
)

# Print the reshaped data
print(reshaped_data)

# Rename columns
colnames(reshaped_data) <- c("MonthYear", 
                             paste("avg_", unique(df$Indicator), sep = ""),
                             paste("new_cases_", unique(df$Indicator), sep = ""),
                             paste("cumulative_", unique(df$Indicator), sep = "")
)

# Print the final reshaped data with updated column names
print(reshaped_data)
