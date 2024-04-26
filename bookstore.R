#...............................Powell's books..................................

# TASK 2........................................................................
# Setting the working directory
setwd("/Users/Hp/Desktop/powell bookstore")

# Read the data into your data frames
customer_data <- read.csv("Customer Demographic Data.csv")
online_data <- read.csv("online sales data.csv")
inventory_data <- read.csv("Product Inventory Data.csv")
instore_data <- read.csv("In-Store Sales Data.csv")
marketing_data <- read.csv("Marketing Campaign Data.csv")

# View the first few rows of the data
head(customer_data)
head(online_data)
head(inventory_data)
head(instore_data)
head(marketing_data)

#TASK 3.........................................................................
#Customer Data:
#Check for missing values
summary(customer_data)
# Identify duplicate rows
duplicates <- duplicated(customer_data)

#online Data:
#Check for missing values
summary(online_data)
# Identify duplicate rows
duplicates <- duplicated(online_data)

#inventory Data:
#Check for missing values
summary(inventory_data)
# Identify duplicate rows
duplicates <- duplicated(inventory_data)

# Standardize formats 
inventory_data$SKU <- tolower(inventory_data$SKU)  # Convert SKU names to lowercase

#in store Data:
#Check for missing values
summary(instore_data)
# Identify duplicate rows
duplicates <- duplicated(instore_data)

#marketing Data:
#Check for missing values
summary(marketing_data)
# Identify duplicate rows
duplicates <- duplicated(marketing_data)

#TASK 4.........................................................................
# merged online with customer data
online_merged_data <- merge(online_data, customer_data, by = "Customer.ID")
head(online_merged_data)

# merged in store with customer data
instore_merged_data <- merge(instore_data, customer_data, by = "Customer.ID")
head(instore_merged_data)

#merge all sales
all_sales <- merge(instore_merged_data, online_merged_data, by = "Customer.ID", all = TRUE)
head(all_sales)

# Identify columns with .x and .y suffixes
x_cols <- grep("\\.x$", names(all_sales), value = TRUE)
y_cols <- grep("\\.y$", names(all_sales), value = TRUE)

# Combine corresponding .x and .y columns
for (col in x_cols) {
  y_col <- sub("\\.x$", ".y", col)
  if (y_col %in% names(all_sales)) {
    all_sales[[col]] <- ifelse(is.na(all_sales[[col]]), all_sales[[y_col]], all_sales[[col]])
    all_sales[[y_col]] <- NULL
    names(all_sales)[names(all_sales) == y_col] <- sub("\\.y$", "", y_col)
  }
}

# Display the modified data frame
head(all_sales)


#TASK 5.........................................................................
# Summary statistics
summary(all_sales)

# Visualizations
#Distribution of sales by gender
gender_sales <- table(all_sales$Gender)
barplot(gender_sales, main = "Distribution of Sales by Gender", xlab = "Gender", ylab = "Count", col = "red")

#Scatter plot of Sales Amount vs. Age
plot(all_sales$Age, all_sales$Sales.Amount, main = "Scatter plot of Sales Amount vs. Age", xlab = "Age", ylab = "Sales Amount", col = "blue", pch = 10)

# Calculate the count of sales by gender
gender_counts <- table(all_sales$Gender)

# Aggregate sales data by state
state_sales <- table(all_sales$State)

# Create a pie chart
barplot(state_sales, 
        main = "Distribution of Sales by State", 
        xlab = "State", 
        ylab = "Number of Sales",
        col = rainbow(length(state_sales)))


#TASK 6 .......................................................................
# Duplicate rows check
duplicate_rows <- all_sales[duplicated(all_sales), ]
if (nrow(duplicate_rows) > 0) {
  print("Duplicate rows found:")
  print(duplicate_rows)
}

# Data integrity checks
# Check numeric columns for out liers or invalid values
numeric_columns <- c("Age", "Sales.Amount")
for (col in numeric_columns) {
  invalid_values <- all_sales[!is.na(all_sales[[col]]) & !is.numeric(all_sales[[col]]), ]
  if (nrow(invalid_values) > 0) {
    print(paste("Invalid values found in column", col))
    print(invalid_values)
  }
}

# Check column consistency
expected_columns <- c("Customer.ID", "Age", "Gender")  # Define expected columns
if (!all(expected_columns %in% colnames(all_sales))) {
  print("Warning: Merged dataset columns do not match expectations.")
}


# Completeness check
missing_values <- colSums(is.na(all_sales))
if (any(missing_values > 0)) {
  print("Missing values found:")
  print(missing_values)
}











