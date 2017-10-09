var thispt = d3.select("[id^='geom_point.points.703.1.1']")

var curx = thispt.attr("x")
var cury = thispt.attr("y")
var count = 1

var move = setInterval(function(){
	
	if(count >= 10){
	    thispt.transition().duration(100)
	    .attr("x", curx)
	    .attr("y", cury);
		count = 1;
	} else {
	
  thispt.transition().duration(500)
  .attr("x", 210 + (.5 - Math.random()) * 200)
  .attr("y", 210 + (.5 - Math.random()) * 200);
 	count++
}
}, 1000);

