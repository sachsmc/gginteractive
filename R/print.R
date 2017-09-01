print.ggmesh <- function(x, ..., file = NULL, prefix = "a", cssString = NULL, jsString = NULL, omit.js = FALSE) {



  wd <- dev.size(units = "px")
  cat(wd, "\n")

  sinkPlot <- tempfile(fileext= ".png")
  grDevices::png(sinkPlot, width = wd[1] - 32, height = wd[2] - 32)

  ggplot2:::print.ggplot(x)
  grid::grid.force()

  objnames <- grid::grid.ls(print = FALSE)$name

  tmpFile <- tempfile()
  svgString <- gridSVG::grid.export(name = tmpFile, prefix = prefix)$svg

  grDevices::dev.off()
  grDevices::dev.off()

  svgString <- paste(readLines(tmpFile, warn = FALSE), collapse = "\n")

  unlink(sinkPlot)

  if(omit.js){
    finstr <- c(cssString, svgString, jsString)
  } else {
    d3String <- getD3()
    finstr <- c(cssString, d3String, svgString, jsString)
  }

  body <- paste(finstr, collapse = "\n\n")

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
