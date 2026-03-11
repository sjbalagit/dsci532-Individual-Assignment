library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)
library(bslib)

# Import dataset
processed_data <- read.csv("data/processed/housing_with_county.csv")

# Define UI
ui <- page_fillable(
  title = "California Housing",
  theme = bs_theme(version = 5),
  
  tags$style(HTML("
    .footer {
      font-size: 0.75rem;
      color: #6c757d;
      text-align: center;
      padding: 4px 0;
      margin: 0;
    }
  ")),
  
  h1("California Housing Dashboard (1990)", style = "text-align: left; margin-bottom: 1.5rem;"),
  
  layout_sidebar(
    # Sidebar inputs
    sidebar = sidebar(
      actionButton("reset_button", "Reset Filters"),
      
      sliderInput(
        inputId = "price_slider",
        label = "Median House Value:",
        min = min(processed_data$median_house_value, na.rm = TRUE),
        max = max(processed_data$median_house_value, na.rm = TRUE),
        value = c(min(processed_data$median_house_value, na.rm = TRUE), 
                  max(processed_data$median_house_value, na.rm = TRUE))
      ),
      
      selectizeInput(
        inputId = "county_select",
        label = "Select County:",
        choices = sort(unique(na.omit(processed_data$county))),
        multiple = TRUE,
        options = list(placeholder = "All counties")
      ),
      
      width = 300
    ),
    
    # Main content
    layout_columns(
      # Value Boxes
      layout_column_wrap(
        uiOutput("median_house"),
        uiOutput("median_income"),
        width = 1/2,
        heights_equal = "all",
        fill = TRUE
      ),
      
      # Density Plot
      card(
        card_header("Distribution of Median House Values"),
        plotOutput("density_plot", height = "400px")
      ),
      
      col_widths = 12
    )
  ),
  
  # Footer
  div(
    "Simplified California Housing Dashboard  |  ",
    "Data from 1990  |  ",
    a("GitHub Repository",
      href = "https://github.com/sjbalagit/dsci532-Individual-Assignment",
      target = "_blank"),
    class = "footer"
  )
)

# Define server
server <- function(input, output, session) {
  
  # Reset button functionality
  observeEvent(input$reset_button, {
    updateSliderInput(session, "price_slider", 
                     value = c(min(processed_data$median_house_value, na.rm = TRUE), 
                               max(processed_data$median_house_value, na.rm = TRUE)))
    updateSelectizeInput(session, "county_select", selected = character(0))
  })
  
  # Filter dataset reactively based on price and county
  filtered_data <- reactive({
    df <- processed_data %>%
      filter(
        median_house_value >= input$price_slider[1],
        median_house_value <= input$price_slider[2]
      )
    
    # Filter by county if selected
    if (length(input$county_select) > 0) {
      df <- df %>% filter(county %in% input$county_select)
    }
    
    return(df)
  })
  
  # Median House Value Box
  output$median_house <- renderUI({
    filt_value <- median(filtered_data()$median_house_value, na.rm = TRUE)
    state_value <- median(processed_data$median_house_value, na.rm = TRUE)
    
    diff <- round(((filt_value - state_value) / state_value) * 100, 1)
    arrow <- if (diff > 0) "↑" else if (diff < 0) "↓" else ""
    
    percent_text <- if (arrow != "") {
      sprintf("%s %s%% from state median", arrow, abs(diff))
    } else {
      sprintf("%s%% from state median", diff)
    }
    
    div(
      h3("Median House Value"),
      h2(sprintf("$%s", format(as.integer(filt_value), big.mark = ","))),
      p(percent_text, style = "font-size: 0.85rem;")
    )
  })
  
  # Median Income Box
  output$median_income <- renderUI({
    filt_value <- median(filtered_data()$median_income, na.rm = TRUE) * 10000
    state_value <- median(processed_data$median_income, na.rm = TRUE) * 10000
    
    diff <- round(((filt_value - state_value) / state_value) * 100, 1)
    arrow <- if (diff > 0) "↑" else if (diff < 0) "↓" else ""
    
    percent_text <- if (arrow != "") {
      sprintf("%s %s%% from state median", arrow, abs(diff))
    } else {
      sprintf("%s%% from state median", diff)
    }
    
    div(
      h3("Median Income"),
      h2(sprintf("$%s", format(as.integer(filt_value), big.mark = ","))),
      p(percent_text, style = "font-size: 0.85rem;")
    )
  })
  
  # Density Plot with State Comparison
  output$density_plot <- renderPlot({
    df <- filtered_data()
    
    if (nrow(df) == 0) {
      ggplot() +
        annotate("text", x = 0.5, y = 0.5, label = "No data for current filters",
                size = 5) +
        theme_void()
    } else {
      # Prepare data for comparison
      selected_vals <- na.omit(df$median_house_value)
      state_vals <- na.omit(processed_data$median_house_value)
      
      plot_data <- bind_rows(
        tibble(value = selected_vals, group = "Selected"),
        tibble(value = state_vals, group = "State")
      )
      
      ggplot(plot_data, aes(x = value, fill = group, color = group)) +
        geom_density(alpha = 0.4, linewidth = 1) +
        scale_fill_manual(
          values = c("Selected" = "#4e79a7", "State" = "#8e6bbd"),
          name = NULL
        ) +
        scale_color_manual(
          values = c("Selected" = "#2d5282", "State" = "#5a4a7a"),
          name = NULL
        ) +
        labs(
          title = "Distribution of Median House Values: Selected vs State",
          x = "Median House Value ($)",
          y = "Density"
        ) +
        theme_minimal() +
        theme(
          plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
          axis.text = element_text(size = 10),
          axis.title = element_text(size = 11),
          legend.position = "bottom",
          legend.text = element_text(size = 10),
          panel.grid.minor = element_blank()
        )
    }
  })
  
}

# Run the app
shinyApp(ui, server)
