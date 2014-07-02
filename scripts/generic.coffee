GenericAttributesTab = require '../node_modules/seasketch-reporting-api/scripts/genericAttributesTab.coffee'

window.app.registerReport (report) ->
  report.tabs [GenericzzzzAttributesTab]
  # path must be relative to dist/
  report.stylesheets ['./main.css']