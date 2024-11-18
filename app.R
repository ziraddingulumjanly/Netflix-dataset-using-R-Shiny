library(shiny)
library(ggplot2)
library(dplyr)

# Load Netflix dataset
netflix_data <- read.csv("netflix_titles_nov_2019.csv")

# Preprocess data
netflix_data$release_year <- as.numeric(netflix_data$release_year)
netflix_data$duration_num <- as.numeric(gsub(" min| Season.*", "", netflix_data$duration))

# UI
ui <- fluidPage(
  titlePanel("Explore Netflix Titles"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("type", "Select Type:", 
                  choices = c("All", unique(netflix_data$type)), 
                  selected = "All"),
      
      sliderInput("year", "Select Release Year Range:",
                  min = min(netflix_data$release_year, na.rm = TRUE),
                  max = max(netflix_data$release_year, na.rm = TRUE),
                  value = c(2000, 2020), step = 1),
      
      checkboxGroupInput("genres", "Select Genres:",
                         choices = unique(unlist(strsplit(as.character(netflix_data$listed_in), ", "))),
                         selected = c("International TV Shows")),
      
      sliderInput("duration", "Select Duration (Minutes):", # Moved duration slider here
                  min = min(netflix_data$duration_num, na.rm = TRUE),
                  max = max(netflix_data$duration_num, na.rm = TRUE),
                  value = c(min(netflix_data$duration_num, na.rm = TRUE), 
                            max(netflix_data$duration_num, na.rm = TRUE)),
                  step = 10)
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Release Trends", plotOutput("release_trend")),
        tabPanel("Genre Distribution", plotOutput("genre_dist")),
        tabPanel("Duration Analysis", plotOutput("duration_analysis"))
      )
    )
  )
)

# Server
server <- function(input, output) {
  # Filter data based on user inputs
  filtered_data <- reactive({
    data <- netflix_data
    
    # Filter by type
    if (input$type != "All") {
      data <- data %>% filter(type == input$type)
    }
    
    # Filter by year range
    data <- data %>% filter(release_year >= input$year[1] & release_year <= input$year[2])
    
    # Filter by genres
    if (!is.null(input$genres) && length(input$genres) > 0) {
      data <- data %>% filter(sapply(data$listed_in, function(x) any(input$genres %in% strsplit(as.character(x), ", ")[[1]])))
    }
    
    # Filter by duration
    data <- data %>% filter(duration_num >= input$duration[1] & duration_num <= input$duration[2])
    
    return(data)
  })
  
  # Release Trends Plot
  output$release_trend <- renderPlot({
    data <- filtered_data()
    ggplot(data, aes(x = release_year, fill = type)) +
      geom_bar(position = "dodge") +
      labs(title = "Number of Titles Released by Year", x = "Release Year", y = "Count") +
      theme_minimal()
  })
  
  # Genre Distribution Plot
  output$genre_dist <- renderPlot({
    data <- filtered_data()
    genres <- unlist(strsplit(paste(data$listed_in, collapse = ", "), ", "))
    genre_df <- as.data.frame(table(genres))
    genre_df <- genre_df[genre_df$genres %in% input$genres, ]  # Ensure only selected genres are shown
    ggplot(genre_df, aes(x = reorder(genres, -Freq), y = Freq, fill = genres)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Genre Distribution", x = "Genres", y = "Frequency") +
      theme_minimal()
  })
  
  # Duration Analysis Plot
  output$duration_analysis <- renderPlot({
    data <- filtered_data() %>% filter(!is.na(duration_num))
    ggplot(data, aes(x = duration_num, fill = type)) +
      geom_histogram(binwidth = 10, position = "dodge") +
      labs(title = "Distribution of Durations", x = "Duration (Minutes)", y = "Count") +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
