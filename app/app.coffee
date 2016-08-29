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

DATASET_COLORS =
  "Furniture": "#f28e2b"
  Technology: "#4e79a7"
  "Office Supplies": "#e15759"



# set both colors for the dataset
addColorToDataset = (d, color)->
  d.backgroundColor = color
  d.hoverBackgroundColor = color

# Helper fn that creates a new chart with the required data
updateChartWithData = (datasets)->

  # At this point we should only have datasets that are not empty
  addColorToDataset(d, DATASET_COLORS[d.data[0].category]) for d in datasets

  if myChart
    # Update the chart data sets by only updating the data.
    # This way we'll have transition animations
    for d,i in datasets
      _.extend( myChart.data.datasets[i], d )
    myChart.update()

  else
    myChart = new Chart document.getElementById("chart"),
        type: "bubble"
        data:
          datasets: datasets
          xLabels: ["Sales"]
          yLabels: ["Profit"]
        options:
          animation: { duration: 1000}
          responsive: true
          maintainAspectRatio: false
          scales:
            yAxes: [{
              scaleLabel: { display: true, labelString: "Profit" }
            }]
            xAxes: [{
              scaleLabel: { display: true, labelString: "Sales" }
            }]


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
      {Category, Sales, Profit} = colIdxMaps

      # converts a Tableau Table row into a JSChart data entry
      toChartEntry = (d)->
        x: parseFloat(d[Sales].value).toFixed(2)
        y: parseFloat(d[Profit].value).toFixed(2)
        category: d[Category].value
        r: 5

      # group by the category
      graphDataByCategory = _.chain(table.getData())
        .map(toChartEntry)
        .groupBy("category")
        .map (data, label)-> {label: label, data: data}
        .value()

      # Call the updater function to fill the chart
      errorWrapped("Updating the chart", updateChartWithData)(graphDataByCategory)

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

