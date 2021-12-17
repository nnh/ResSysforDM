library(shiny)
library(tidyverse)
library(shinyWidgets)

resType <- function(x) {
  switch(x,
         "1_Preparing" = "準備中 Preparing",
         "2_Recruiting" = "募集中 Recruiting",
         "3_Active" = "継続中 Active",
         "4_Completed" = "完了 Completed",
         "5_Discontinued" = "継続不可 Discontinued",
         "6_Uncertain" = "不明 Uncertain",
         "7_NoSupport" = "支援外 NoSupport",
  )
}

getEmail <- function(dm) {
  if (is.na(dm)) { return("")}
  member %>% filter(name == dm) %>% pull(email)
}

getDCaccount <- function(dm) {
  if (is.na(dm)) { return("")}
  has_account <- member %>% filter(name == dm) %>% pull(datacenter)
  return(ifelse(has_account, "DC", ""))
}

getStatus <- function(member, dm) {
  if (is.na(dm)) { return("")}
  is_remote <- member %>% filter(name == dm) %>% pull(remote)
  return(ifelse(is_remote, "Home", ""))
}

source('server_import.R', local = TRUE, encoding = "UTF-8")

shinyServer(function(input, output, session)
{
  source('ui_style.R', local = TRUE)

  output$dropdown <- renderUI ({
    tags$div(
      style="padding-top:10px; padding-bottom:10px",
      selectInput(inputId = 'trialName',
                  label = 'Trial Name',
                  choices = trials$resID,
                  selected = ""
      )
    )
  })

  df <- eventReactive(input$trialName, {
    df <- trials %>% filter(resID == input$trialName[1])
    return(df)
  })

  output$dmList <- renderUI({
    checkboxGroupInput("DMmember",
                       label = h3("在宅ワーク中"),
                       choices = dm_list
                       )
  })

  output$resID <- renderText({ df()$プロトコルID })
  output$type <- renderText({ df()$研究種別 })
  output$title <- renderText({ df()$試験名 })
  output$period <- renderText({ paste0("登録期間：", df()$登録開始, " ~ ", df()$登録終了) })
  output$follow <- renderText({ paste0("追跡期間：", " ~ ", df()$追跡終了) })

  output$dmAddr <- renderText({
    dmNames <- df() %>% select(主担1 | starts_with("副担")) %>% unlist %>% na.omit
    member %>% filter(name %in% dmNames) %>% pull(email) %>% str_flatten(collapse = ";")
  })
  output$cc <- renderText({ 'datacenter@nnh.go.jp' })
  output$eBody <- renderText({
    paste0(input$trialName[1],
           "ご担当者様\n\nお疲れ様です。XXです。\n下記メール転送します。\nどうぞよろしくお願い申し上げます。\n")
  })

  output$majorDM <- renderInfoBox({
    member$remote[as.numeric(input$DMmember)] <- TRUE
    infoBox(
      "主担当",
      tags$div(
        df()$主担1, span(id = "dc-account", getDCaccount(df()$主担1)), span(
          style="margin-bottom:3px; margin-left:10px; background-color:#e4bc62",
          class = "badge",
          getStatus(member, df()$主担1)
          )
      ),
      getEmail(df()$主担1),
      icon = icon("user-check")
    )
  })

  lapply(1:3, function(i){
    output[[paste0("minorDM", i)]] <- renderInfoBox({
      member$remote[as.numeric(input$DMmember)] <- TRUE
      dm <- paste0("副担", i)
      infoBox(
        paste0("副担当", i),
        tags$div(
          df()[,dm], span(id = "dc-account", getDCaccount(df()[,dm])), span(
            style="margin-bottom:3px; margin-left:10px; background-color:#e4bc62",
            class = "badge",
            getStatus(member, df()[,dm])
            )
        ),
        getEmail(df()[,dm]),
        icon = icon("user"),
        color = "purple"
      )
    })
  })

  output$minorDMs <- renderUI({
    df <- df() %>% select(starts_with("副担"))
    n <- length(df[,!is.na(df)])
    lapply(1:n, function(i){
      infoBoxOutput(paste0("minorDM", i))
    })
  })

  output$PI <- renderInfoBox({
    infoBox(
      "PI",
      tags$div(paste0(df()$PI), span(id = "PI-member", "")),
      paste0(df()$PI所属機関, " ", df()$PI所属科),
      icon = icon("user-md"),
      color = "navy"
    )
  })

  output$progress <- renderUI({
    if (is.na(df()$目標数) || is.na(df()$登録数)) {
      prog <- progressBar(id = "acc", title = resType(df()$Status), value = 0)
    } else {
      prog <- progressBar(id = "acc", title = resType(df()$Status), total = as.numeric(df()$目標数), value = as.numeric(df()$登録数))
    }
    tags$div(id="regist",
             prog
    )
  })


})
