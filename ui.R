library(shiny)
library(shinydashboard)

shinyUI(
  
  dashboardPage(
    
  dashboardHeader(title='Model Evaluation and Predictions Dashboard', titleWidth = 350),
  
  dashboardSidebar(width = 350,
                   sidebarMenu(menuItem("Explolatory Data Analysis", tabName ="graph", icon = icon('chart-bar'))),
                   sidebarMenu(menuItem("Predictions", tabName = "pred", icon = icon('search'))),
                   sidebarMenu(menuItem("Model Results", tabName = "mod", icon = icon('envelope-open-text')))
                   ),
  
  dashboardBody(tabItems(
                         #Graphs tab content
                         tabItem('graph', 
                         #Histogram filter
                         box(status = 'primary', title = 'Histogram plot for numerical variables', 
                             selectInput('num', "Numerical variables:", c('Applicant Income ($ per month)', 'Coapplicant Income ($ per month)', 'Loan Amount (x $1000)', 'Loan Amount Term (months)')),
                             footer = ''),
                         #Frequency plot filter
                         box(status = 'primary', title = 'Frequency plot for categorical variables',
                             selectInput('cat', 'Categorical variables:', c('Gender', 'Married', 'Self_Employed', 'Credit_History', 'Dependents', 'Graduate', 'Property_Area', 'Eligible')),
                             footer = ''),
                         #Boxes to display the plots
                         box(plotOutput('histPlot')),
                         box(plotOutput('freqPlot'))
                         ),
                         
                         #Mod tab content
                         tabItem('mod',
                         box(status = 'primary', title = 'Model Results', width = 2),
                         box(plotOutput('cf'))
                         #verbatimTextOutput("cf", placeholder = TRUE)
                         ),
                         
                         tabItem('pred',
                         #Filters for categorical variables
                         box(title = 'Categorical variables', 
                            status = 'primary', width = 12, 
                            splitLayout(
                              tags$head(tags$style(HTML(".shiny-split-layout > div {overflow: visible;}"))),
                              cellWidths = c('0%', '12%'),
                              radioButtons( 'p_gender', 'Gender', c("Male", "Female")),
                              div(),
                              radioButtons( 'p_married', 'Married', c('Yes', 'No')),
                              div(),
                              radioButtons( 'p_employed', 'Self_Employed', c('Yes', 'No')),
                              div(),
                              radioButtons( 'p_credit', 'Credit_History', c('1', '0')),
                              div(),
                              selectInput( 'p_dependent', 'Dependents', c('0', '1', '2', '3+')),
                              div(),
                              selectInput( 'p_graduate', 'Graduate', c('Graduate','Not Graduate')),
                              div(),
                              selectInput( 'p_area', 'Property_Area', c('Rural', 'Urban', 'Semiurban')))),
                         
                         #Filters for numeric variables
                         box(title = 'Numerical variables',
                            status = 'primary', width = 12,
                            splitLayout(cellWidths = c('22%', '4%','21%', '4%', '21%', '4%', '21%'),
                                        numericInput( 'p_Aincome', 'Applicant Income ($ per month)',0),
                                        div(),
                                        numericInput( 'p_Coincome', 'Coapplicant Income ($ per month)', 0),
                                        div(),
                                        numericInput( 'p_loanamt', 'Loan Amount (x $1000)', 0),
                                        div(),
                                        numericInput( 'p_term', 'Loan Amount Term (months)', 0))),
                         
                         #Box to display the prediction results
                         box(title = 'Prediction',
                            status = 'success', 
                            solidHeader = TRUE, 
                            width = 4, height = 260,
                            div(h5('Eligible:')),
                            verbatimTextOutput("prediction", placeholder = TRUE),
                            div(h5('Probability:')),
                            verbatimTextOutput("probability", placeholder = TRUE),
                            actionButton('cal','Calculate', icon = icon('calculator')))
                         
                         
                
                        
                        )))))

