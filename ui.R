library(leaflet)
navbarPage("Pollution explorer", id="nav",
           
           tabPanel("",
                    div(class="outer",
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        leafletOutput("map", width="100%", height="100%"),
                        
                        # Shiny versions prior to 0.11 should use class="modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 330, height = "auto",
                                      
                                      h2("Select polutants"),
                                      #HTML("<br><br>"),
                                      #h4("Select pollutants to display"),
                                      HTML('<br>'),
                                      checkboxInput("chk_NO2", label = "Nitrogen dioxide", value = FALSE),
                                      checkboxInput("chk_SO2", label = "Sulphur dioxide", value = FALSE),
                                      checkboxInput("chk_O3", label = "Ozone", value = FALSE),
                                      checkboxInput("chk_PM10", label = "Paticulates < 10 µM", value = FALSE),
                                      checkboxInput("chk_PM25", label = "Paticulates < 25 µM", value = FALSE),
                                      h5('Radiuses of the pollution circles correspond to the sensor readings.')
                                      #actionButton("reset", "Reset overlay")
                        ),
                        tags$div(id="cite",
                                 'Data collected from the OpenAQ air quality API:', tags$a("https://openaq.org/", href="https://openaq.org/")
                        )
                    )
           )
)
