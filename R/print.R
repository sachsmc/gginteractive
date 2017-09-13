#' @export

print.ggmesh <- function(x, ..., file = NULL, prefix = "a",
                         cssString = NULL, jsString = NULL,
                         htmlString = NULL, omit.js = FALSE, wd = NULL) {



  if(is.null(wd)) wd <- dev.size(units = "px")

  body <- assemble_html_body(x, ..., file = file, prefix = prefix,
                                 cssString = cssString, jsString = jsString,
                                 htmlString = htmlString, omit.js = omit.js, wd = wd)


  if(is.null(file)){

    tmpDir <- tempdir()
    tmpPlot <- tempfile(tmpdir = tmpDir, fileext = ".html")

  } else {
    tmpPlot <- ifelse(length(grep(".html", file)) > 0, file, paste(file, "html", sep = "."))
    tmpDir <- dirname(file)
  }


  cat(body, file = tmpPlot, append = TRUE)

  ## open in browswer if possible

  viewer <- getOption("viewer")
  if (!is.null(viewer)) {
    viewerFunc <- function(url) {

      # get the requested pane height (it defaults to NULL)
      paneHeight <- x$sizingPolicy$viewer$paneHeight

      # convert maximize to -1 for compatibility with older versions of rstudio
      # (newer versions convert 'maximize' to -1 interally, older versions
      # will simply ignore the height if it's less than zero)
      if (identical(paneHeight, "maximize"))
        paneHeight <- -1

      # call the viewer
      viewer(url, height = paneHeight)
    }
  } else {
    viewerFunc <- utils::browseURL
  }


  viewerFunc(tmpPlot)
  #html_print(HTML(body), viewer = viewerFunc)

  invisible(x)

}


#' @export
#' @importFrom knitr knit_print
#' @importFrom magrittr %>%
#' @export %>%
#'
knit_print.ggmesh <- function(x, ..., options = NULL) {


  body <- assemble_html_body(x, file = NULL, prefix = paste(sample(letters[1:5], 3, replace = TRUE), collapse = ""),
                             cssString = NULL, jsString = NULL,
                             htmlString = NULL, omit.js = FALSE,
                             wd = c(options$fig.width * options$dpi, options$fig.height * options$dpi))

  cat(body)

}


assemble_html_body <- function(x, ..., file = NULL, prefix = "a",
                               cssString = NULL, jsString = NULL,
                               htmlString = NULL, omit.js = FALSE, wd){

  sinkPlot <- tempfile(fileext= ".png")
  grDevices::png(sinkPlot, width = wd[1] - 32, height = wd[2] - 32)

  ggplot2:::print.ggplot(x)
  grid::grid.force()

  objnames <- grid::grid.ls(print = FALSE)$name

  mapped_data <- ggplot2::ggplot_build(x)$data[[1]]

  if(!is.unsorted(mapped_data$x)) {
    indata <- x$data[do.call(order, x$data[, as.character(x$mapping[c("x", "y")])]), ]

  } else {

    indata <- x$data
  }
  ## call any garnish functions in x$interactive

  if(!is.null(x$interactive$togarnish)) {
    pts <- sapply(names(x$interactive$togarnish), function(nm) {
      grep(nm, objnames, value = TRUE)
    })

    for(i in 1:length(pts)) {

      garnishdata <- as.character(indata[[x$interactive$togarnish[[i]]]])
      garnishparams <- list(pts, garnishdata, FALSE)
      names(garnishparams) <- c("path", x$interactive$togarnish[[i]], "group")
      do.call(gridSVG::grid.garnish, garnishparams)

    }
  }

  tmpFile <- tempfile()
  svgString <- gridSVG::grid.export(name = tmpFile, prefix = prefix, strict = FALSE)$svg

  grDevices::dev.off()
  #grDevices::dev.off()

  svgString <- paste(readLines(tmpFile, warn = FALSE), collapse = "\n")

  unlink(sinkPlot)

  meshed_var <- names(x$interactive$controls)[1]

  if(!is.null(x$interactive$controls)) {
   htmlString <- x$interactive$controls[[1]](prefix)
  }
  meshed_geom <- names(x$interactive$togarnish)[which(x$interactive$togarnish == meshed_var)]
  meshed_geom_num <- paste0(prefix, grep(paste0("^", meshed_geom), objnames, value = TRUE))

  radioname <- paste0(prefix, "radio")
  selectors <- paste0(prefix, "geom_smooth")
  jsString <- x$interactive$jsfuncs[[1]](radioname, selectors)
  #jsString <- get_changeSubgroup(meshed_var, meshed_geom_num, prefix)


  if(omit.js){
    finstr <- c(cssString, svgString, htmlString, jsString)
  } else {
    d3String <- getD3()
    finstr <- c(cssString, d3String, svgString, htmlString, jsString)
  }

  body <- paste(finstr, collapse = "\n\n")



}
