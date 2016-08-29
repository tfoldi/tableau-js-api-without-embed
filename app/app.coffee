# Keep the current chart so we can manip it later
myChart = null

# Quick accessors for accessing the tableau bits on the parent page
getTableau = ()-> parent.parent.tableau
getCurrentViz = ()-> getTableau().VizManager.getVizs()[0]
# Returns the current worksheet.
# The path to access the sheet is hardcoded for now.
getCurrentWorksheet = ()-> getCurrentViz().getWorkbook().getActiveSheet().getWorksheets()[0]

# Because handlers in promises swallow errors and
# the error callbacks for Promises/A are flaky,
# we simply use this function to wrap calls
errorWrapped = (context, fn)->
  (args...)->
    try
      fn(args...)
    catch err
      console.error "Got error during '", context, "' : ", err


# Helper fn that creates a new chart with the required data
updateChartWithData = (data)->
  ctx = document.getElementById("chart")
  myChart = new Chart ctx,
      type: "bubble"
      data: datasets: [{
        label: 'Tableau Data'
        data: data
        backgroundColor: '#ff6384'
        hoverBackgroundColor: '#ff6355'
      }]
      options: animation: duration: 1000



initChart = ->
  # Get the tableau bits from the parent.
  tableau = getTableau()

  # Error handler in case getting the data fails in the Promise
  onDataLoadError = (err)->
    console.err("Error during Tableau Async request:", err)

  # Handler for loading and converting the tableau data to chart data
  onDataLoadOk = errorWrapped "Getting data from Tableau", (table)->
      # Create a column name -> idx map
      colIdxMaps = {}
      colIdxMaps[c.getFieldName()] = c.getIndex() for c in table.getColumns()

      # Decompose the ids
      {Sales, Profit} = colIdxMaps

      # map the tableau table data to chart data
      graphData = for d in table.getData()
        {x: parseFloat(d[Sales].value), y: parseFloat(d[Profit].value), r: 15}


      # Call the updater function to fill the chart
      errorWrapped("Updating the chart", updateChartWithData)(graphData)

  # Handler that gets the selected data from tableau and sends it to the chart
  # display function
  updateChart = ()->
    getCurrentWorksheet()
      .getUnderlyingDataAsync({maxRows: 0, ignoreSelection: false, includeAllColumns: true, ignoreAliases: true})
      .then(onDataLoadOk, onDataLoadError )

  # Add an event listener for marks change events that simply loads the
  # selected data to the chart
  getCurrentViz().addEventListener( tableau.TableauEventName.MARKS_SELECTION,  updateChart)



@appApi = {
  initChart,
  myChart
}

