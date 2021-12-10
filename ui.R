library(shiny)
library(shinydashboard)

dashHeader <- dashboardHeader(
    title='Research System')

dashSidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem('HOME',
                 tabName = 'HomeTab',
                 icon=icon('home')
                 ),
        menuItem('TRIALS',
                 tabName = 'TrialTab',
                 icon=icon('notes-medical')
        )
    )
)

dashBody <- dashboardBody(
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "custom1.css")
    ),
    uiOutput("style"),

    tabItems(
        tabItem(tabName = 'HomeTab',
                h2('DMスタッフ'),
                p('Please set DM status.'),
                fluidRow(
                    column(10, uiOutput("dmList")),
                )
                ),
        tabItem(tabName = 'TrialTab',
                uiOutput("dropdown"),
                fluidRow(
                    style="padding-bottom: 20px;",
                    infoBoxOutput(width = 12, "PI")
                ),
                fluidRow(
                    style="padding-bottom: 20px;",
                    infoBoxOutput("majorDM"),
                    uiOutput("minorDMs")
                ),
                fluidRow(
                    box(
                        width = 12,
                        style = "padding: 20px 30px;",
                        solidHeader = TRUE,
                        h4(style="font-weight: bold;", textOutput("resID")),
                        h4(style="padding-bottom:25px;line-height:25px", textOutput("title")),
                        fluidRow(
                            column(width = 4,
                                   span(id = "status", class = "badge", textOutput("type")),
                                   p(textOutput("period")),
                                   p(textOutput("follow"))
                            ),
                            column(width = 4,
                                   uiOutput("progress")
                            )
                        )
                    )
                ),
                fluidRow(
                    box(
                        width = 12,
                        title="Email Template",
                        solidHeader = TRUE,
                        column(
                                width = 6,
                                p("To:", verbatimTextOutput('dmAddr')),
                                p("Cc:", verbatimTextOutput('cc'))
                        ),
                        column(
                                width = 6,
                                p("Body:", verbatimTextOutput('eBody'))
                        )
                    )
                )
        )
    )
)

dashboardPage(
    header=dashHeader,
    sidebar=dashSidebar,
    body=dashBody,
    title='Research System'
)
