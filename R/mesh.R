
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

#' @export

mesh_alpha <- function(object, geom, variable, on = NULL, ...) {

  class(object) <- c("ggmesh", class(object))

  existing_geoms <- lapply(object$layers, function(x) ggplot2:::snakeize(class(x$geom)))
  stopifnot(grepl(geom, existing_geoms))

  gridGeom <- geom_lookup(geom)

  togarnish <- list(variable)
  names(togarnish) <- gridGeom

  controls <- list(function(prefix) on(object, variable, id = paste0(variable, "form"), prefix, ...))
  names(controls) <- variable

  object$interactive <- list(togarnish = togarnish, controls = controls)

  object

}


#' @export

radio <- function(x, variable, id, prefix, ...) {

  values <- sort(unique(as.character(x$data[[variable]])))
  values <- c(values, "Any")
  as.character(tags$form(id = id,
                         lapply(values,
                                function(x) list(tags$input(type = "radio",
                                                            name = paste0(prefix, variable), value = x), x)
                         )))

}



geom_lookup <- function(geom) {

  c(point = "geom_point.points",
    line = "GRID.polyline",
    bar = "geom_rect.rect")[geom]

}



get_changeSubgroup <- function(variable, meshed_geom, prefix){

jsString <- "
<script type='text/javascript'>

d3.selectAll(\"input[name='%s']\").on(\"click\", function() {

  if(this.value == 'Any') {
    d3.selectAll(\"[id^='%s.1.']\").transition().duration(100).attr(\"opacity\", 1)
  } else {
    d3.selectAll(\"[id^='%s.1.']\").transition().duration(1).attr(\"opacity\", 0)
    d3.selectAll(\"[id^='%s.1.'][%s='\" + this.value + \"']\").transition()
      .duration(100).attr(\"opacity\", 1)
  }

})
</script>
"

sprintf(jsString, paste0(prefix, variable), meshed_geom,  meshed_geom,  meshed_geom, variable)

}



