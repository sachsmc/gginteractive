
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
#'
mesh_geom <- function(object, geom, control, ...) {

  class(object) <- c("ggmesh", class(object))

  existing_geoms <- lapply(object$layers, function(x) ggplot2:::snakeize(class(x$geom)))
  stopifnot(any(grepl(geom, existing_geoms)))

  controls <- list(control)


  jsfuncs <- list(testJS)

  object$interactive <- list(controls = controls, jsfuncs = jsfuncs)
  object

}

#' @export

radio0 <- function(x, variable, id, prefix, ...) {

  values <- sort(unique(as.character(x$data[[variable]])))
  values <- c(values, "Any")
  as.character(tags$form(id = id,
                         lapply(values,
                                function(x) list(tags$input(type = "radio",
                                                            name = paste0(prefix, variable), value = x), x)
                         )))

}


#' @export

radio <- function(mylist) {


  if(is.null(names(mylist))) names.l <- letters[length(mylist)] else {

    names.l <- names(mylist)

  }

  function(radname) radio2(mylist, names.l, paste0(radname, "radio"))



}


radio2 <- function(values, names, radname) {

  stopifnot(length(values) == length(names))
  innlist <- vector("list", length = length(values))
  for(i in 1:length(values)) {

    innlist[[i]] <- c(values[i], names[i])

  }

  as.character(tags$form(lapply(innlist, function(x) list(tags$input(type = "radio",
                                              name = radname,
                                              value = x[1]), x[2]))
  ))

}


geom_lookup <- function(geom) {

  c(point = "geom_point.points",
    line = "GRID.polyline",
    bar = "geom_rect.rect",
    smooth = "GRID.polyline")[geom]

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


testJS <- function(radionames, geomnames) {
instr <- "
<script type='text/javascript'>
d3.selectAll(\"input[name='%s']\").on(\"click\", function() {

  posib = []
  d3.selectAll(\"[id^='%s']\").each(function(){
    posib.push(d3.select(this).attr(\"id\"))
    })

              if(this.value == '0') {
                d3.selectAll(\"[id^='%s']\").transition().attr(\"opacity\", 0)
              } else {
                d3.selectAll(\"[id^='%s']\").transition().attr(\"opacity\", 0)
                d3.selectAll(\"[id='\" + posib[this.value - 1] + \"']\").transition()
                  .duration(100).attr(\"opacity\", 1)
              }

              })
</script>
"
  sprintf(instr, radionames, geomnames, geomnames, geomnames)

}
