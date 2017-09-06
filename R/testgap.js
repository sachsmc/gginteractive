
var div = d3.select("body").append("div")
    .attr("class", "tooltip")
    .style("opacity", 0);

d3.selectAll("[id^='ageom_point.points.19584.1.']")
  //.attr("opacity", 0)

  .on("mouseover", function(d, i) {

    ctry = d3.select(this).attr("country")
    div.transition()
                .duration(200)
                .style("opacity", .9)
                .style("position", "absolute")
                .style("background", "lightsteelblue");
            div	.html(ctry + "<br/>")
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY - 18) + "px");
            })
        .on("mouseout", function(d) {
            div.transition()
                .duration(500)
                .style("opacity", 0);
        });


function cycle(year) {

  d3.selectAll("[id^='ageom_point.points.19584.1.']").transition().duration(1).attr("opacity", 0)
  d3.selectAll("[id^='ageom_point.points.19584.1.'][year='" + year + "']").transition().duration(200).attr("opacity", 1)

}


thisyear = [1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997, 2002, 2007]
i = 0
cycleme = setInterval(function(){

  cycle(thisyear[i])
  if(i == 11) {
    i = 0
  } else {
    i++
  }

}, 2000)



function changeSubgroup(idsr, year) {

  d3.selectAll("[id^='" + idsr + ".1.']").transition().duration(1).attr("opacity", 0)
  d3.selectAll("[id^='" + idsr + ".1.'][year='" + year + "']").transition().duration(200).attr("opacity", 1)

}

d3.selectAll("input[name='year']").on("click", function() {

  changeSubgroup("ageom_point.points.21144", this.value)

})


