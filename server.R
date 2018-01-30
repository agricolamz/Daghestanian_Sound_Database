library(shiny)
library(DT)
library(lingtypology)
library(dplyr)
library(markdown)
library(leaflet)

function(input, output) {
# by sound ------------------------------------------------------------      
  database <- read.csv("database.csv", sep = "\t", stringsAsFactors = FALSE)
  final_sound <- unique(database[, c(1, 2, 5)])
  final_sound$segments <- "—"
  
  output$sound_map <- renderLeaflet({
    database[,-7] %>%
      distinct() %>% 
      group_by(language) %>% 
      filter(segments_IPA %in% input$sound_search_without) %>% 
      count() %>% 
      filter(n == length(input$sound_search_without)) %>% 
      select(language) ->
      remove_languages
    
    database[,-7] %>%
      distinct() %>% 
      group_by(language) %>%
      filter(segments_IPA %in% input$sound_search) %>%
      arrange(segments_IPA) %>% 
      mutate(segments = paste(segments_IPA, collapse = ", ")) %>% 
      count(language, segments, source, branch) %>% 
      full_join(., anti_join(final_sound, ., by = "language")) %>% 
      select(-n) %>% 
      anti_join(., remove_languages) ->
      final_sound
    
    table <- final_sound
    table$language <- lingtypology::url.lang(table$language)
    output$sound_table <- DT::renderDataTable(
        table,
        filter = 'top',
        rownames = FALSE,
        options = list(pageLength = 7, autoWidth = FALSE, dom = 'tip'),
        escape = FALSE)
    map.feature(final_sound$language,
                features = final_sound$branch,
                stroke.features = final_sound$segments,
                stroke.color = "Set2",
                label = final_sound$language,
                popup = paste(final_sound$source),
                label.hide = T)
    })

# by feature ------------------------------------------------------------      
  database <- read.csv("database.csv", sep = "\t", stringsAsFactors = FALSE)
  final_features <- unique(database[, c(1, 2, 5)])
  final_features$features <- "—"
  
  output$feature_map <- renderLeaflet({
    database %>% 
      distinct(segments_IPA, features) %>% 
      group_by(segments_IPA) %>% 
      filter(features %in% input$feature_search_without) %>% 
      count() %>% 
      filter(n == length(input$feature_search_without)) %>% 
      select(segments_IPA) ->
      remove_segments
    
    
    database %>%
      filter(features %in% input$feature_search) %>%
      distinct(language, segments_IPA, source, features, branch) %>% 
      arrange(features) %>% 
      mutate(features = paste(unique(features), collapse = ", ")) %>% 
      count(language, segments_IPA, features, source, branch) %>%
      filter(n == length(input$feature_search)) %>% 
      full_join(., anti_join(final_features, ., by = "language")) %>% 
      select(-n) %>% 
      anti_join(., remove_segments) ->
      final_features

    table <- final_features
    table$language <- lingtypology::url.lang(table$language)

    output$feature_table <- DT::renderDataTable(
      table,
      filter = 'top',
      rownames = FALSE,
      options = list(pageLength = 7, autoWidth = FALSE, dom = 'tip'),
      escape = FALSE)
    map.feature(final_features$language,
                features = final_features$branch,
                stroke.features = final_features$features,
                stroke.color = "Set2",
                label = final_features$language,
                popup = paste(final_features$source),
                label.hide = T)
  })  

# bibliography ------------------------------------------------------------    
  bibliography <- read.csv("bibliography.csv", sep = "\t", stringsAsFactors = FALSE)
  bibliography$language <- lingtypology::url.lang(bibliography$language)
  bibliography$language
  output$bibliography <- DT::renderDataTable(
    bibliography,
    filter = 'top',
    rownames = FALSE,
    options = list(pageLength = 7, autoWidth = FALSE, dom = 'tip'),
    escape = FALSE
    )
}
