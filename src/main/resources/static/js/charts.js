
function pieChartFunction(data,elementId){
	 google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
      
      var options = {
        legend: 'none',
        pieSliceText: 'label',
        title: 'Task Status',
        pieStartAngle: 100,
		width:360,
		height:230,
      };

        var chart = new google.visualization.PieChart(document.getElementById(elementId));
        chart.draw(data, options);
      }
}

function barChatFunction(data,elementId,title){
	 google.charts.load("current", {packages:['corechart']});
    google.charts.setOnLoadCallback(drawChart);
    function drawChart() {
      var view = new google.visualization.DataView(data);
      view.setColumns([0, 1,
                       { calc: "stringify",
                         sourceColumn: 1,
                         type: "string",
                         role: "annotation" },
                       2]);

      var options = {
        title: title,
        width: 250,
        height: 230,
        bar: {groupWidth: "95%"},
        legend: { position: "none" },
      };
      var chart = new google.visualization.ColumnChart(document.getElementById(elementId));
      chart.draw(view, options);
}
}

function combochartFunction(combodata,elementId) {
    	  google.charts.load('current', {'packages':['corechart']});
          google.charts.setOnLoadCallback(drawVisualization);
          function drawVisualization() {
            // Some raw data (not necessarily accurate)
          

            var options = {
              title : 'User Assignment Status',
              vAxis: {title: 'Tasks'},
              hAxis: {title: 'User'},
              seriesType: 'bars',
              series: {5: {type: 'line'}},
			  width: 1080,
		      height: 230,
            };

            var chart = new google.visualization.ComboChart(document.getElementById(elementId));
            chart.draw(combodata, options);
          }
	}