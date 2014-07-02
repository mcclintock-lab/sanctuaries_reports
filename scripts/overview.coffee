ReportTab = require 'reportTab'
templates = require '../templates/templates.js'

_partials = require '../node_modules/seasketch-reporting-api/templates/templates.js'
partials = []
for key, val of _partials
  partials[key.replace('node_modules/seasketch-reporting-api/', '')] = val

class OverviewTab extends ReportTab
  name: 'Overview'
  className: 'overview'
  template: templates.overview
  timeout: 120000
  dependencies: [
    'Size'
    'PortionInWaters'
  ]

  render: () ->
    if window.d3
      d3IsPresent = true
    else
      d3IsPresent = false

    attributes = @model.getAttributes()
    console.log("FOOOOOOOO")
    try
      size = @recordSet("Size", "Size").float('SIZE_SQMI')
      state_waters = @recordSet("PortionInWaters", "PortionsInWaters").float('ST_SQMI')
      fed_waters = @recordSet("PortionInWaters", "PortionsInWaters").float('FED_SQMI')

    catch e
      console.log("error: ", e)

    context =
      sketch: @model.forTemplate()
      sketchClass: @sketchClass.forTemplate()
      attributes: @model.getAttributes()
      anyAttributes: @model.getAttributes().length > 0
      admin: @project.isAdmin window.user
      size: size
      state_waters: state_waters
      fed_waters: fed_waters
      d3IsPresent: d3IsPresent

    @$el.html @template.render(context, partials)
    @enableLayerTogglers()

module.exports = OverviewTab