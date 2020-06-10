# Import libraries ----
#install.packages('rsconnect')
#install.packages("devtools")
library(rsconnect)
library(dplyr)
library(shiny)
library(shinythemes)
library(googleway)
library(DT)
library(leaflet)
library(ggmap)
library(deldir)
library(r2d3)

# Connection to shinyapps.io----
rsconnect::setAccountInfo(name='abinayam-coder', token='C3F5DB5187A066E3AF32F6041F4DB34C', secret='5++ST20AC4nVKaLUujZjpiGGR9wbp7Om+ICwkCNp')
rsconnect::deployApp('C:\\Users\\Abinaya MATHIBALA\\Desktop\\Internship_Quito_Business_Activity')

# Connection to github----
devtools::install_github(AbinayaM-coder/Internship_Quito_Business_Activity)


# API Key----
api_key <- 'AIzaSyB9R18HmJvEXxu8FOaxJ4Hix2rUkDQRukQ'


# User interface ----

ui <- fluidPage(theme = shinytheme("yeti"),
                
                navbarPage(
                  
                  title = "Urban Business Activity Mapping", 
                  
                  tabPanel("Search", icon = icon("search"),
                           sidebarPanel(
                            
                             
                             selectInput("business_type_choice", label = "Business type", 
                                         choices = list("restaurant" = "restaurant", 
                                                        "bar" = "bar", 
                                                        "store" = "store",
                                                        "accounting" = "accounting",
                                                        "airport" = "airport",
                                                        "amusement_park" = "amusement_park",
                                                        "aquarium" = "aquarium",
                                                        "art_gallery" = "art_gallery",
                                                        "atm" = "atm",
                                                        "bakery" = "bakery",
                                                        "bank" = "bank",
                                                        "beauty_salon" = "beauty_salon",
                                                        "bicycle_store" = "bicycle_store",
                                                        "book_store" = "book_store",
                                                        "bowling_alley" = "bowling_alley",
                                                        "cafe" = "cafe",
                                                        "campground" = "campground",
                                                        "car_dealer" = "car_dealer",
                                                        "car_rental" = "car_rental",
                                                        "car_repair" = "car_repair",
                                                        "car_wash" = "car_wash",
                                                        "casino" = "casino",
                                                        "city_hall" = "city_hall",
                                                        "clothing_store" = "clothing_store",
                                                        "convenience_store" = "convenience_store",
                                                        "department_store" = "department_store",
                                                        "drugstore" = "drugstore",
                                                        "doctor" = "doctor",
                                                        "electrician" = "electrician",
                                                        "electronics_store" = "electronics_store",
                                                        "florist" = "florist",
                                                        "furniture_store" = "furniture_store",
                                                        "gas_station" = "gas_station",
                                                        "gym" = "gym",
                                                        "hair_care" = "hair_care",
                                                        "hardware_store" = "hardware_store",
                                                        "home_goods_store" = "home_goods_store",
                                                        "hospital" = "hospital",
                                                        "insurance_agency" = "insurance_agency",
                                                        "jewelry_store" = "jewelry_store",
                                                        "laundry" = "laundry",
                                                        "lawyer" = "lawyer",
                                                        "library" = "library",
                                                        "liquor_store" = "liquor_store",
                                                        "meal_delivery" = "meal_delivery",
                                                        "meal_takeaway" = "meal_takeaway",
                                                        "movie_rental" = "movie_rental",
                                                        "movie_theater" = "movie_theater",
                                                        "moving_company" = "moving_company",
                                                        "museum" = "museum",
                                                        "night_club" = "night_club",
                                                        "painter" = "painter",
                                                        "pet_store" = "pet_store",
                                                        "pharmacy" = "pharmacy",
                                                        "plumber" = "plumber",
                                                        "post_office" = "post_office",
                                                        "real_estate_agency" = "real_estate_agency",
                                                        "roofing_contractor" = "roofing_contractor",
                                                        "shoe_store" = "shoe_store",
                                                        "shopping_mall" = "shopping_mall",
                                                        "spa" = "spa",
                                                        "supermarket" = "supermarket",
                                                        "taxi_stand" = "taxi_stand",
                                                        "tourist_attraction" = "tourist_attraction",
                                                        "travel_agency" = "travel_agency",
                                                        "veterinary_care" = "veterinary_care"), 
                                         selected = "restaurant"),
                             numericInput("latitude", "Latitude", -0.2201641, min = NA, max = NA, step = NA,
                                          width = NULL),
                             numericInput("longitude", "Longitude", -78.5123274, min = NA, max = NA, step = NA,
                                          width = NULL),
                             sliderInput("radius_choosen", "Radius (meters):",
                                         min = 5, max = 50000, value = 1000, step = 50),
                            
                             
                             actionButton(
                               inputId = "submitbutton", 
                               label = "Submit", 
                               class = "btn btn-primary")
                             
                           ), # sidebarPanel_fin
                           
                           mainPanel(
                             h4("Your search"),
                             verbatimTextOutput("notification"),
                             verbatimTextOutput("notification2"),
                             leafletOutput("bbmap_search", height="400")
                             
                           ) # mainPanel_fin
                           
                  ), # Informations_tabPanel_fin
                  
                  tabPanel("Data", icon = icon("table"),
                           
                          
                             actionButton(
                             inputId = "NextResultbutton", 
                             label = "Show more results", 
                             class = "btn btn-primary"),
                           
                              DTOutput(outputId = 'data1'), width = "100%", height = "auto"), 
                  
                  
                           
                  tabPanel("Voronoi polygon", icon = icon("draw-polygon"),

                           
                           sidebarPanel(
                           
                                  
                                  tags$hr(),  
                                  h4('Voronoi Creator'),
                                  tags$ol(
                                    tags$li('Click points on the map to add markers. When there are at least two markers, Voronoi diagram will appear.'),
                                    tags$li('Drag markers around to update the Voronoi.'),
                                    tags$li('Double-click markers to remove them (the Voronoi will update).')
                                          ), #tags_fin
                                  checkboxInput(
                                    inputId = 'geodesic',
                                    label   = 'Use geodesic lines (follow curve of earth, instead of straight lines on map)'
                                                ), #checkbox_geodesic_fin
                                  
                                  checkboxInput(
                                    inputId = 'radius_show',
                                    label   = 'Show studied area'
                                  ), #checkbox_radius_show
                                  
                                  
                                  actionButton(
                                    inputId = 'clear_all',
                                    label   = 'Clear all markers'
                                              ) #actionButton_fin
                           ), #SidePanel_fin
                           
                           mainPanel(
                                  
                                  div(id = 'map')
                                       
                                  
                           ), #mainPanel_fin
                                  
                          
                           includeScript('www/app.js'),
                           includeScript(sprintf('https://maps.googleapis.com/maps/api/js?key=%s', api_key)),
                           includeCSS('www/app.css')
                           
                           ), #Voronoi_polygon_fin
                  
                  
                   
                  
                          
                  
                  
                  tabPanel("About", icon = icon("info"),
                           tags$a(
                              tags$img(src = 'Logo_ecoles.png')
                                 ), #tag_fin
                           includeMarkdown("About.Rmd")
                           
                           )#About_fin
                  
                  
                ) # navbarPage_fin
) # fluidPage_fin






# Server ----
server <- function(input, output, session) {
  

  # When the button "submit" is press----
  
  
  
  observe({
    req(input$submitbutton)
    
    
    # Submit Button (Search page) <> Import Data from Google Maps
    
    location_choosen <- c(input$latitude, input$longitude)
    
    
    
    
    res <-google_places(search_string = NULL, location = location_choosen, radius = input$radius_choosen, 
                  rankby = input$rankby_choosen, keyword = NULL, language = NULL, name = NULL,
                  place_type = input$business_type_choice, price_range = NULL, open_now = NULL,
                  page_token = NULL, simplify = TRUE, curl_proxy = NULL,
                  key = api_key, radar = NULL)
    
    
    
    output$data1 = renderDT(res$results)
    
 
    #Notification
    output$notification <- renderText({paste("There are",length(res$results$name),"results on the map.")})
    if(length(res$results$name)==20){
      output$notification2 <- renderText({paste("WARNING: All area's results may not on the map. Please reduce the radius for an accurate result.")})
    }else{
      output$notification2 <- renderText({paste("All results are on the map.")})
    }
    
    
    
    
    
    
    
    #Next Result Button
    observe({
      req(input$NextResultbutton)
      
      res2 <-google_places(search_string = NULL, location = location_choosen, radius = input$radius_choosen, 
                           rankby = input$rankby_choosen, keyword = NULL, language = NULL, name = NULL,
                           place_type = input$business_type_choice, price_range = NULL, open_now = NULL,
                           page_token = res$next_page_token, simplify = TRUE, curl_proxy = NULL,
                           key = api_key, radar = NULL)
      
      rownames(res2$results) <- c(21:40)
      
      output$data1 = renderDT(res2$results)
      
    })
    
    
    
    
    
    
    
    
    #write.csv(res$results$name,"C:\\Users\\Abinaya MATHIBALA\\Desktop\\Internship_Quito_Business_Activity\\\\res.csv", row.names = FALSE)
    
    
    # Submit Button (Search page) <> Map 
    points <- data.frame(longitudes = res$results$geometry$location$lng,
                         latitudes = res$results$geometry$location$lat,
                         labels = res$results$name)
    
    
    map_search = leaflet(points) %>%
      addTiles() %>%
      setView(lng = input$longitude, lat = input$latitude, zoom = (14.245+input$radius_choosen*-2.448979592*10^-4))  %>%
      addMarkers(lng = res$results$geometry$location$lng, lat = ~latitudes, popup = ~labels)
      output$bbmap_search = renderLeaflet(map_search)
    
    
    
    
    
    
    
    # Submit Button (Search page) <> Create Voronoi polygons----
    
    #markers <- reactiveValues(
      #label = numeric(0),
      #lat = numeric(0),
      #lng = numeric(0)
    #)
    
    markers <- reactiveValues(
      label = numeric(0),
      lat = res$results$geometry$location$lat,
      lng = res$results$geometry$location$lng
    )
    
    observe({
      req(input$add_point)
      
      message(' -- adding point')
      
      markers$lat <- isolate(c(markers$lat, input$add_point$lat))
      markers$lng <- isolate(c(markers$lng, input$add_point$lng))
      markers$label <- isolate(c(markers$label, input$add_point$label))
    })
    
    observe({
      req(input$update_point)
      
      message(' -- updating point')
      
      index <- which(isolate(markers$label) == input$update_point$label)
      
      markers$lat[index] <- input$update_point$lat
      markers$lng[index] <- input$update_point$lng
    })
    
    observe({
      req(input$remove_point)
      
      message(' -- removing point')
      
      index <- which(isolate(markers$label) == input$remove_point$label)
      
      markers$lat <- isolate(markers$lat[-index])
      markers$lng <- isolate(markers$lng[-index])
      markers$label <- isolate(markers$label[-index])
    })
    
    observe({
      if (length(markers$lat) >= 2) {
        
        message(' -- drawing voronoi')
        
        voronoi <- deldir::deldir(markers$lng, markers$lat)
        
        point_arrays <- voronoi$dirsgs[c('x1', 'y1', 'x2', 'y2')]
        
        session$sendCustomMessage('draw_voronoi', message = list(
          points = point_arrays,
          geodesic = input$geodesic
        ))
      }
    })
    
    observeEvent(input$clear_all, {
      
      message(' -- clearing all markers')
      
      session$sendCustomMessage('clear_all', message = TRUE)
      
      markers$lat <- numeric(0)
      markers$lng <- numeric(0)
      markers$label <- numeric(0)
    })
    
    
    
    
    #Send data to javascript
    observe({
      
      
      session$sendCustomMessage('set maps', message = list(
        lat_center = input$latitude,
        lng_center = input$longitude,
        zoom_center = 14.245+input$radius_choosen*-2.448979592*10^-4,
        radius_choosen = input$radius_choosen,
        res_names = res$results$name,
        res_lat = res$results$geometry$location$lat,
        res_lng = res$results$geometry$location$lng,
        radius_show = input$radius_show
      ))
    })
    
    
   
   
    
    
  })#submitButton_fin
  
 
  
}#Serveur_fin

    

# Create the shiny app ----  
shinyApp(ui, server)



