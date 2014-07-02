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
    'DistanceToCities'
  ]

  render: () ->
    if window.d3
      d3IsPresent = true
    else
      d3IsPresent = false

    attributes = @model.getAttributes()
    try
      size = @recordSet("Size", "Size").float('SIZE_SQMI', 1)
      state_waters = @recordSet("PortionInWaters", "PortionsInWaters").float('ST_SQMI',1)
      fed_waters = @recordSet("PortionInWaters", "PortionsInWaters").float('FED_SQMI',1)
      distance = @recordSet("DistanceToCities", "Distance").float('DIST_MI',1)
      closest_city = @recordSet("DistanceToCities", "Distance").raw('CITY')
      has_close_city = false
      if closest_city
        if closest_city.indexOf("No city within") == 0
          has_close_city = false
        else
          has_close_city = true

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
      has_close_city: has_close_city
      distance: distance
      closest_city: closest_city
      d3IsPresent: d3IsPresent

    @$el.html @template.render(context, partials)
    @enableLayerTogglers()

module.exports = OverviewTab