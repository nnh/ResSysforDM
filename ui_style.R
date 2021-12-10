output$style <- renderUI({
  tags$style(
    type = 'text/css',
'
.bg-aqua {
  background-color: #e4bc62!important;
}

.bg-purple {
  background-color: #666!important;
}

.progress #acc.progress-bar {
  background-color: #dfb3ae;
}

.progress {
  margin-top: 5px;
  height: 15px;
  border-radius: 10px;
}

#status.badge {
  font-weight: 600;
  padding: 5px 10px;
  border-radius: 5px;
  background-color: #666;
}

.info-box-number #PI-address {
  display: inline-block;
  padding-left: 15px;
  font-weight: normal;
  font-size: 16px;
}

#PI .info-box .info-box-content p {
  margin: 7px 0;
}

.info-box-content {
  overflow-wrap: break-word;
}

.info-box-content p {
  line-height: 12px;
}

.progress {
  background-color: #ddded9;
}

'
  )
})

