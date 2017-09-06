#' Reads included JavaScript functions and returns them as a string for pasting into a webpage
#'
#' @keywords Internal
#'
getD3 <- function(){

  d3.js <- readLines(system.file("d3.v3.min.js", package = "gginteractive"), warn = FALSE)
  paste(
    paste("<script type=\"text/javascript\" charset=\"utf-8\">", paste(d3.js, collapse = "\n"), "</script>"),
    sep = "\n")


}


is.ggmesh <- function(x) {

  inherits(x, "ggmesh")

}




