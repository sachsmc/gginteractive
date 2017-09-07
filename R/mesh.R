
#' @export

mesh_blank <- function(object) {

  if(!inherits(object, "gg")) stop(paste("cannot add mesh to object of class ", class(object), collapse = ","))
  class(object) <- c("ggmesh", class(object))
  object

}


#' @export
#'

unmesh <- function(object) {

  if(inherits(object, "ggmesh")) {

    class(object) <- class(object)[-which(class(object) == "ggmesh")]

  }
  object

}



mesh_alpha <- function(object, geom, variable, on = NULL, ...) {

  class(object) <- c("ggmesh", class(object))

  existing_geoms <- lapply(object$layers, function(x) ggplot2:::snakeize(class(x$geom)))
  stopifnot(grepl(geom, existing_geoms))

  gridGeom <- geom_lookup(geom)

  togarnish <- list(variable)
  names(togarnish) <- gridGeom

  controls <- list(on(object, variable, id = paste0(variable, "form"), ...))
  names(controls) <- variable

  object$interactive <- list(togarnish = togarnish, controls = controls)

  object

}


radio <- function(x, variable, id, ...) {

  values <- sort(unique(as.character(x$data[[variable]])))
  values <- c(values, "Any")
  as.character(tags$form(id = id,
                         lapply(values,
                                function(x) list(tags$input(type = "radio", name = variable, value = x), x)
                         )))

}



geom_lookup <- function(geom) {

  c(point = "geom_point.points")[geom]

}



get_changeSubgroup <- function(variable, meshed_geom){

jsString <- "
<script type='text/javascript'>
function changeSubgroup(idsr, year, duration) {

  if(year == 'Any') {
    d3.selectAll(\"[id^='\" + idsr + \".1.']\").transition().duration(duration).attr(\"opacity\", 1)
  } else {
   d3.selectAll(\"[id^='\" + idsr + \".1.']\").transition().duration(1).attr(\"opacity\", 0)
   d3.selectAll(\"[id^='\" + idsr + \".1.'][%s='\" + year + \"']\").transition()
     .duration(duration).attr(\"opacity\", 1)
  }

}

d3.selectAll(\"input[name='%s']\").on(\"click\", function() {

  changeSubgroup(\"%s\", this.value, 100)

})
</script>
"

sprintf(jsString, variable, variable, meshed_geom)

}



