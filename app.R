library(shiny)
library(shinythemes)
library(aws.s3)




ui <- fluidPage(title="#eLopped 2017 - RSVP", theme=shinytheme("flatly"),
                textInput("lastname", label="Last Name:"),
                textInput("firstname", label="First Name:"),
                numericInput("guests", label="Number of Guests:",value=0),
                textInput("dietres", label="Any dietary restrictions? (Gluten free, vegeterian, etc)"),
                textInput("email", label="Email address"),
                textInput("phone", label="Phone number, format ###-###-####"),
                actionButton("submit", "Submit"),
                textOutput("confirmed")
                )

server <- function(input,output) {
  output$confirmed <- renderText({
    if (input$submit) "RSVP Confirmed!" else "Please Enter Information and Click Submit"
  })
  
  observeEvent(input$submit,{
            s3load(object="rsvplist.Rdata", bucket=get_bucket("elopped"))
            delete_object(object="rsvplist.Rdata", bucket=get_bucket("elopped"))
    
               data <- data.frame(
                 lastname=input$lastname,
                 firstname=input$firstname,
                 guests = input$guests,
                 dietres = input$dietres,
                 email = input$email,
                 phone=input$phone
               )
               
               rsvplist <- rbind(rsvplist, data)
               save(rsvplist, file = "rsvplist.Rdata")
               put_object("rsvplist.Rdata", bucket=get_bucket("elopped"))
               
    })
  
}

shinyApp(ui=ui, server=server)