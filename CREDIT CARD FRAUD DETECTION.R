# Importing the dataset from respective folder folder
Credit_card <- read.csv("C:/Users/bharg/Downloads/creditcard.csv")

# Viewing the dataset
View(Credit_card)

# Glance at the structure of the dataset
str(Credit_card)

# Convert Class to a factor variable
Credit_card$Class <- factor(Credit_card$Class, level = c(0 , 1))
str(Credit_card)

# Get the summary of the data 
summary(Credit_card)

# Count the missing values
sum(is.na(Credit_card))

#-------------------------------------------------------------------------

# Get the distribution of fraud and legit transaction in the dataset (legitment transaction = legit)
table(Credit_card$Class)

# Get the percentage of fraud and legit transactions in the dataset
prop.table(table(Credit_card$Class))


# Pie chart of credit card transactions
labels <- c("legit", "fraud")
labels <- paste(labels, round(100*prop.table(table(Credit_card$Class)),2))
labels <- paste0(labels, "%")
labels

pie(table(Credit_card$Class), labels, col = c("Yellow" , "Green"),main = "pie chart of credit card transactions")


#-------------------------------------------------------------------------
# NO model predictions
nrow(Credit_card)  
predictions <- rep.int(0, nrow(Credit_card))
predictions <- factor(predictions, levels = c(0 , 1))
predictions


# Install.packages('caret')
install.packages("caret")
library(caret)
install.packages("e1071" , dep = TRUE)
library(e1071)
confusionMatrix(data = predictions, reference = Credit_card$Class)

#-------------------------------------------------------------------------
install.packages("dplyr")
library("dplyr")



set.seed(1)
Credit_card <- Credit_card %>% sample_frac(0.1)

table(Credit_card$Class)

library(ggplot2)

ggplot(data = Credit_card, aes(x = V1, y = V2, col=Class)) + geom_point() + theme_bw() + scale_color_manual(values=c('blue','red'))

#-------------------------------------------------------------------------
# Creating training and Test sets for Fraud Detection Model

# Install.packages('caTools')
install.packages('caTools')
library(caTools)

set.seed(123)

data_sample = sample.split(Credit_card$Class,SplitRatio=0.80)


train_data = subset(Credit_card,data_sample==TRUE)

test_data = subset(Credit_card,data_sample==FALSE)

data_sample

dim(train_data)
dim(test_data)


#-------------------------------------------------------------------------

# Random Over -Sampling(ROS)

table(train_data$Class)

n_legit <- 22750
new_frac_legit <- 0.50
new_n_total <- n_legit/new_frac_legit   # = 22750/0.50
new_n_total 

# Install.packages('ROSE')
install.packages('ROSE')
library(ROSE) 
oversampling_result <- ovun.sample(Class ~ . , data = train_data,method = "over", N = new_n_total,seed = 2019)

oversampled_credit <- oversampling_result$data

table(oversampled_credit$Class)

ggplot(data = oversampled_credit, aes(x = V1 , y = V2 , col = Class)) + 
  geom_point(position = position_jitter(width = 0.2)) + 
  theme_bw()+
  scale_color_manual(values = c('blue' , 'red'))

#-------------------------------------------------------------------------

# Random Under-Sampling(RUS)


table(train_data$Class)

n_fraud <- 35
new_frac_fraud <- 0.50
new_n_total <- n_fraud/new_frac_fraud          # = 35/0.50
new_n_total

# Library(ROSE)
undersampling_result <- ovun.sample(Class ~ . , data = train_data, method = "under", N = new_n_total, seed = 2019)

undersampled_credit <- undersampling_result$data

table(undersampled_credit$Class)


ggplot(data = undersampled_credit , aes (x = V1 , y= V2, col= Class)) +
    geom_point() +
    theme_bw() +
    scale_color_manual(values = c('blue' , 'red'))


#-------------------------------------------------------------------------

# ROS and RUS

n_new <- nrow(train_data)     # = 22785
fraction_fraud_new <- 0.50

sampling_result <- ovun.sample(Class ~ . ,data = train_data,method = "both", N = n_new, p = fraction_fraud_new, seed = 2019)

sampled_credit <- sampling_result$data

table(sampled_credit$Class)


ggplot(data = sampled_credit, aes (x = V1 , y = V2 , col = Class)) +
  geom_point(position = position_jitter(width = 0.2)) +
  theme_bw() +
  scale_color_manual(values = c('blue', 'red'))

#-------------------------------------------------------------------------

# Using SMOTE to balance the dataset

# Install.packages("smotefamily")
install.packages("smotefamily")
library(smotefamily)

table(train_data$Class)

# Set the number of fraud and legitmate cases, and the dessired percentage of legitmate cases
n0 <- 22750
n1 <- 35
r0 <- 0.6

# Calculate the value for the dup_size parameter of SMOTE
ntimes <- ((1 - r0) / r0)* (n0 / n1) - 1
ntimes

smote_output = SMOTE(X =train_data[, - c (1,31)],
             target = train_data$Class,
             K = 5,
             dup_size = ntimes)



credit_smote <- smote_output$data

colnames(credit_smote)[30] <- "Class"

prop.table(table(credit_smote$Class))

# Class distribution for over-sampled dataset using SMOTE
ggplot(credit_smote, aes(x = V1 , y= V2 , col = Class))+
    geom_point()+
    scale_color_manual(values = c('blue', 'red'))
  
#-------------------------------------------------------------------------

# Install.packages('rpart')
# Install.packages('rpart.plot')

install.packages('rpart')
library(rpart)
install.packages('rpart.plot')
library(rpart.plot)


CART_model <- rpart(Class ~ . , credit_smote)

rpart.plot(CART_model, extra=0, type=5, tweak=1.2)

# Predict fraud Classes
predicted_val <- predict(CART_model, test_data, type= 'class')

# Build Confus Matrix
library(caret)
confusionMatrix(predicted_val, test_data$Class)

#-------------------------------------------------------------------------

predicted_val <- predict(CART_model, Credit_card [ ,-1], type = "class")
confusionMatrix(predicted_val, Credit_card$Class)

#-------------------------------------------------------------------------
# Decision Tree without SMOTE

CART_model <- rpart(Class ~ . , train_data[,-1])

rpart.plot(CART_model , extra = 0, type =5, tweak = 1.2)


# Predict fraud classes
predicted_val <- predict(CART_model, test_data[-1], type='class')

library(caret)
confusionMatrix(predicted_val , test_data$Class)

#-------------------------------------------------------------------------

predicted_val <- predict(CART_model, Credit_card [ ,-1], type = "class")
confusionMatrix(predicted_val, Credit_card$Class)

#-------------------------------------------------------------------------






