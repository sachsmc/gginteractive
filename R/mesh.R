
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



mesh_alpha <- function(object, variable, on = NULL) {

  class(object) <- c("ggmesh", class(object))




  object

}


