library(shiny)
library(shinythemes)
library(aws.s3)
library(DT)



ui <- fluidPage(title="#eLopped 2017 - RSVP", theme=shinytheme("flatly"),
                h5("Return to Main Site:", a("#eLopped", href="https://slopp.github.io/elopped")),
                sidebarPanel(
                textInput("lastname", label="Last Name:"),
                textInput("firstname", label="First Name:"),
                numericInput("guests", label="Number of Guests:",value=0),
                textInput("dietres", label="Any dietary restrictions? (Gluten free, vegeterian, etc)"),
                textInput("email", label="Email address"),
                textInput("phone", label="Phone number, format ###-###-####"),
                actionButton("submit", "Submit"),
                textOutput("confirmed")
                ),
                mainPanel(
                p("Current RSVPs"),
                dataTableOutput("rsvped")
                )
)

server <- function(input,output) {
  output$confirmed <- renderText({
    if (input$submit) "RSVP Confirmed! Close and return to site: sloppo.github.io/elopped" else "Please Enter Information and Click Submit"
  })
  
  observeEvent(input$submit,{
            s3load(object="rsvplist.Rdata", bucket=get_bucket("elopped"))
            #delete_object(object="rsvplist.Rdata", bucket=get_bucket("elopped"))
    
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
    output$rsvped <- renderDataTable({
      input$submit
      s3load(object="rsvplist.Rdata", bucket=get_bucket("elopped"))
      DT::datatable(rsvplist)
    })
  
}

shinyApp(ui=ui, server=server)