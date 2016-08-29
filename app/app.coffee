#viz = parent.parent.tableau.VizManager.getVizs()[0]
#console.log viz

myChart = null

data = datasets: [ {
  label: 'First Dataset'
  data: [
    {
      x: 20
      y: 30
      r: 15
    }
    {
      x: 40
      y: 10
      r: 10
    }
  ]
  backgroundColor: '#FF6384'
  hoverBackgroundColor: '#FF6384'
} ]

initChart = ->
  ctx = document.getElementById("chart")
  myChart = new Chart(ctx,
    {
      type: "bubble"
      data: data
      options: {animation: {duration: 1000}}
    } )


@appApi = {
  initChart,
  myChart
}

