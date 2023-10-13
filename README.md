# Credit-Card-Detection-using-RLanguage
Explaination for code :
The code aims to balance the dataset, build decision tree models, and evaluate their performance for fraud detection. 

Data Import and Exploration:
Start by importing the credit card dataset from a CSV file and view its contents using the read.csv and View functions.
Then, inspect the structure of the dataset using str.
Convert the "Class" variable to a factor variable, which is typically used for categorical data.

Data Summary:
Use the summary function to get a summary of the dataset, which provides statistics for each variable.
The sum(is.na(Credit_card)) line counts missing values in the dataset.

Class Distribution Analysis:
Use table to count the number of fraud and legitimate (legit) transactions.
prop.table is used to calculate the percentage of fraud and legit transactions.
Create a pie chart to visualize the distribution of transactions.

Model Predictions:
Create an initial prediction vector with all values set to 0 (representing non-fraudulent transactions) using rep.int.
Install and load the caret and e1071 packages for model evaluation.
confusionMatrix is used to create a confusion matrix for the initial predictions.

Data Sampling and Visualization:
Install and load the dplyr package for data manipulation.
Sample 10% of the data for training and testing.
A scatter plot using ggplot2 is created to visualize the data with different colors for fraud and legit transactions.

Creating Training and Test Sets:
Install and load the caTools package.
Data is split into training and test sets using sample.split.

Random Over-Sampling (ROS):
Use the ROSE package for random over-sampling of the training data.
Visualizations are created to show the over-sampled data.

Random Under-Sampling (RUS):
Perform random under-sampling of the training data using ROSE.
Visualizations show the under-sampled data.

ROS and RUS Combined:
Perform both random over-sampling and random under-sampling on the training data.
Visualizations show the combined sampled data.

Using SMOTE for Balancing the Dataset:
Install and load the smotefamily package.
SMOTE (Synthetic Minority Over-sampling Technique) is applied to balance the dataset.
Class distribution plots are created.

Building Decision Tree Model:
Install and load the rpart and rpart.plot packages.
A decision tree model is built using the balanced dataset (with SMOTE).
Visualization of the decision tree is created using rpart.plot.

Model Evaluation:
The decision tree model is used to make predictions on the test data.
confusionMatrix is used to evaluate the model's performance.

Decision Tree without SMOTE:
Build a decision tree model without SMOTE using the original training data.
Visualization of the decision tree is created.
Model evaluation is performed on the test data.
