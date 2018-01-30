navbarPage("Nakh-Daghestanian Sound Database",
           tabPanel("About",
                    "Here will be a long nice text."),
           tabPanel("Search by sound",
                    fluidRow(
                      column(6,
                             selectInput('sound_search', 'languages with...', 
                                unique(read.csv("database.csv", sep = "\t", stringsAsFactors = FALSE)$segments_IPA),
                                multiple=TRUE, selectize=TRUE)
                             ),
                      column(6,
                             selectInput('sound_search_without', 'languages without...', 
                                unique(read.csv("database.csv", sep = "\t", stringsAsFactors = FALSE)$segments_IPA),
                                multiple=TRUE, selectize=TRUE)
                             )
                    ),
                    fluidRow(
                      column(6,
                             DT::dataTableOutput("sound_table")),
                      column(6,
                             leaflet::leafletOutput("sound_map"))
                    )
                    ),
           tabPanel("Search by feature",
             fluidRow(
               column(6,
                      selectInput('feature_search', 'sounds with folowing features:', 
                                  unique(read.csv("database.csv", sep = "\t", stringsAsFactors = FALSE)$features),
                                  multiple=TRUE, selectize=TRUE)
               ),
               column(6,
                      selectInput('feature_search_without', 'sounds without folowing features:', 
                                  unique(read.csv("database.csv", sep = "\t", stringsAsFactors = FALSE)$features),
                                  multiple=TRUE, selectize=TRUE)
               )
             ),
             fluidRow(
               column(6,
                      DT::dataTableOutput("feature_table")),
               column(6,
                      leaflet::leafletOutput("feature_map"))
             )
             ),
           tabPanel("References",
                    DT::dataTableOutput("bibliography"))
)
