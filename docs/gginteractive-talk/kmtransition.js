var pline = d3.select("[id='km2GRID.polyline.465.1.1']");
var panel = d3.select("[id='km2panel.background.rect.471.1.1']");
var newy1 = d3.select("[id='km2GRID.polyline.465.1']").attr("tipy1").split(",");
var newx1 = d3.select("[id='km2GRID.polyline.465.1']").attr("tipx1").split(",");
var newy2 = d3.select("[id='km2GRID.polyline.465.1']").attr("tipy2").split(",");
var newx2 = d3.select("[id='km2GRID.polyline.465.1']").attr("tipx2").split(",");

var y = d3.scale.linear()
		.domain([-.05, 1.05])
		.range([panel.attr("y"), Number(panel.attr("y")) + Number(panel.attr("height"))]);
var x = d3.scale.linear()
		.domain([-51.1, 1073.1])
		.range([panel.attr("x"), Number(panel.attr("x")) + Number(panel.attr("width"))]);

var npoints1 = "";
var npoints2 = "";
for(var i=0; i<newy1.length; i++){

	npoints1 = npoints1 + " " + x(newx1[i]) + "," + y(newy1[i]);
	npoints2 = npoints2 + " " + x(newx2[i]) + "," + y(newy2[i]);

}

var opoints = pline.attr("points");

d3.selectAll('input[name="sex"]').on("click", function() {
	if(this.value == "overall"){
		pline.transition(150).attr("points", opoints).attr("stroke", "rgb(0, 0, 0)")
	}
	if(this.value == "male"){
		pline.transition(150).attr("points", npoints1).attr("stroke", "rgb(248, 118, 109)")
	}
	if(this.value == "female"){
		pline.transition(150).attr("points", npoints2).attr("stroke", "rgb(0, 191, 196)")
	}
})



