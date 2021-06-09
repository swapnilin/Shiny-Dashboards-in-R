#Install and load all the libraries
library(readr)
library(dplyr)
library(caret)
library(lime)



#load the csv file as data frame
data <-  as.data.frame(read_csv('/Users/swapnil/Desktop/Model Agnostic/Loan/Dataset/Credit_Data.csv'))
head(data,2)

#check for any nulls
sum(is.na(data))


#Drop Loan_ID column
data <- data[-c(1)]

head(data,2)



#check data type of the variables
str(data)



#Change all charater to factor
data=data%>% mutate_if(is.character, as.factor)

str(data)




#**for a single column transformation, use**
data$Eligible <- as.factor(data$Eligible)

#split the dataset with the help of caret
split <- createDataPartition(data$Eligible, p=0.80, list=FALSE)
train <-data[split,]
test <- data[-split,]
head(test,2)



#train the model
##extract rf package manualy from cra-cran if it gives error in the studio
set.seed(13)
library("randomForest")



##fit the model
rf <- randomForest(Eligible ~ Gender_Male+Married+Dependents+Graduate+Self_Employed+ApplicantIncome+CoapplicantIncome+
                     LoanAmount+Loan_Amount_Term+Credit_History+Property_Area, data=train, ntree=103, mtry=6, importance=TRUE)



##Model summary
rf
plot(rf)


#predict. Convert it to dataframe to read the resuts easily later.
pred <-  data.frame(predict(rf, test, type="prob"))

#Evaluate with trinaing data by running rf and calculating the accuracy.
head(pred, 2)
pred


#Model Interpretability with LIME

##For global explainations
#**which represents the mean decrease in node impurity (and not the mean decrease in accuracy).**
varImpPlot(rf, type=2)


##Let's do some local interpretations

##This is to inform the explainer that we are doing classification

rf <- as_classifier(rf, labels = NULL)


#create explainer
explainer <- lime(train, rf)

summary(explainer)

#explain individual predictions
explaination <-  lime::explain( 
  x = train[2,],
  explainer,
  n_features = 15,
  n_labels = 2
)

plot_features(explaination)


#Confusion Matrix
cfmatrix <- as.table(rf$confusion[,1:2])
cfmatrix2 <- rf$confusion[,1:2]

#this part is for the dashboards
acc <- (1- mean(rf$err.rate[,1]))*100
acc


Predicted <- factor(c(0, 0, 1, 1))
Actual <- factor(c(0, 1, 0, 1))
Y      <- c(cfmatrix2)
df <- data.frame(Actual, Predicted, Y)


library(ggplot2)
cf <- ggplot(data =  df, mapping = aes(x = Actual, y = Predicted)) +
  geom_tile(aes(fill = Y), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f", Y)), vjust = 1) +
  scale_fill_gradient(low = "light blue", high = "orange") +
  theme_bw() + theme(legend.position = "none")+
  ggtitle("Confusion Matrix") 
  
