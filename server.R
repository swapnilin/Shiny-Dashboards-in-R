library(shiny)
library(shinydashboard)

shinyServer(function(input,output){
  
  #Univariate analysis
  output$histPlot <- renderPlot({
    #Column name variable
    num_val = ifelse(input$num == 'Applicant Income ($ per month)', 'ApplicantIncome',
                     ifelse(input$num == 'Coapplicant Income ($ per month)', 'CoapplicantIncome',
                            ifelse(input$num == 'Loan Amount (x $1000)', 'LoanAmount',
                                   ifelse(input$num == 'Loan Amount Term (months)', 'Loan_Amount_Term', 'total'))))
    
    #Histogram plot
    ggplot (data, aes(x = .data[[num_val]])) + 
      geom_histogram(stat = "bin", fill = 'steelblue3', color = 'lightgrey') +
      theme(axis.text = element_text(size = 12),
            axis.title = element_text(size = 14),
            plot.title = element_text(size = 16, face = 'bold')) +
      labs(title = sprintf('Histogram plot of the variable %s', num_val), x = sprintf('%s', input$num), y = 'Frequency') +
      stat_bin(geom = 'text', aes(label = ifelse(..count.. == max(..count..), as.character(max(..count..)), '')), vjust = -0.6)
  })
  
 
  
  #Column name variable
  output$freqPlot <- renderPlot({
    
  cat_val = ifelse(input$cat == 'Gender', 'Gender_Male',
                   ifelse(input$cat == 'Married', 'Married',
                          ifelse(input$cat == 'Self Employed', 'Self_Employed',
                                 ifelse(input$cat == 'Credit History', 'Credit_History',
                                        ifelse(input$cat == 'Dependents', 'Dependents',
                                               ifelse(input$cat == 'Graduate', 'Graduate',
                                                      ifelse(input$cat == 'Property Area', 'Property_Area','Eligible')))))))
  
  #Frequency plot
  ggplot(data , aes(x = .data[[cat_val]]))+ geom_bar(stat = 'count', fill = 'mediumseagreen', width = 0.5) +
    stat_count(geom = 'text', size = 4, aes(label = ..count..), position = position_stack(vjust = 1.03)) +
    theme(axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text = element_text(size = 12),
          axis.title = element_text(size = 14),
          plot.title = element_text(size = 16, face="bold")) +
    labs(title = sprintf('Frecuency plot of the variable %s', cat_val),
         x = sprintf('%s', input$cat), y = 'Count')
  })

  output$cf <- renderPlot(cf)
  
  
  #Prediction model
  #React value when using the action button
  a <- reactiveValues(result = NULL)
  b <- reactiveValues(result = NULL)
  
  
  observeEvent(input$cal, {
    #Copy of the test data without the dependent variable
    test_pred <- test[-12]
    test[-12]
    
    
    #Dataframe for the single prediction
    values = data.frame(Gender_Male = input$p_gender, 
                        Married = input$p_married,
                        Dependents = input$p_dependent,
                        Graduate = input$p_graduate,
                        Self_Employed = input$p_employed,
                        ApplicantIncome = input$p_Aincome,
                        CoapplicantIncome = input$p_Coincome, 
                        LoanAmount = input$p_loanamt, 
                        Loan_Amount_Term = input$p_term,
                        Credit_History=input$p_credit,
                        Property_Area=input$p_area
                        )
    #Include the values into the new data
    test_pred <- rbind(test_pred,values)
    
    #Single prediction using the randomforest (rf) model
    a$result <-  predict(rf, newdata = test_pred[nrow(test_pred),])
    
    b$result <-  round(predict(rf, type="prob",newdata = test_pred[nrow(test_pred),]),digits=3)
    
  
    })
                   
                      
  
    #Display the prediction value
    output$prediction <- renderText({ paste(a$result) })
    
    #Display the prediction probability
    output$probability <- renderText({ paste(b$result) })
    
  
   })

