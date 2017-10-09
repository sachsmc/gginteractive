 // extract data from points to bind
 var pdata = [];

  d3.selectAll("[id^='kmgeom_point.points.232.1.']").each(function(d, i){

	me = d3.select(this);
	pdata.push({"x": me.attr("x"),
				  "y": me.attr("y"),
				  "nrisk": me.attr("tip")});

  })


  var times = [];
  for(var i = 0; i < pdata.length; i++){

    if(i == pdata.length - 1){
      var wd = Math.max(0, pdata[i].x - pdata[i-1].x);
    } else {
      var wd = Math.max(0, pdata[i + 1].x - pdata[i].x);
    }

    var dots = [];
    for(var j = 0; j < pdata.length; j++){
      if(pdata[j].x == pdata[i].x){
        dots.push({"px": pdata[j].x,
        "py": pdata[j].y,
        "nrisk": pdata[j].nrisk});
      }
    }

    times.push({"xtran": pdata[i].x,
              "width": wd,
              "dots": dots});
  }


var svg = d3.select("g#kmgridSVG");

var rects = svg.append("g").attr("class", "rects").selectAll("g");

var rectEnter = rects.data(times).enter().append("g");

  rectEnter.append("rect").attr("class", "tess").attr("transform", function(d) { return "translate(" + d.xtran + ", 0)"; })
  .attr("width", function(d) { return d.width; })
  .attr("height", 720);

  var dotEnter = rectEnter.selectAll("circle").data(function(d){ return d.dots; }).enter();

  dotEnter.append("circle").attr("class", "dot")
.attr("r", 3.5)
.attr("cx", function(d) { return d.px; })
.attr("cy", function(d) { return d.py; });

dotEnter.append("g")
   .attr("transform", function(d){ return "translate(" + (d.px+20) + ", " + d.py + ")"; } )
    .append("text").attr("class", "hidetext").attr("transform", "scale(1, -1)").attr("dy", "-15px")
    .text(function(d) { return "n.risk: " + Math.round(d.nrisk*10)/10;  });
