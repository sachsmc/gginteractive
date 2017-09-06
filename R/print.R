print.ggmesh <- function(x, ..., file = NULL, prefix = "a",
                         cssString = NULL, jsString = NULL,
                         htmlString = NULL, omit.js = FALSE) {



  wd <- dev.size(units = "px")

  sinkPlot <- tempfile(fileext= ".png")
  grDevices::png(sinkPlot, width = wd[1] - 32, height = wd[2] - 32)

  ggplot2:::print.ggplot(x)
  grid::grid.force()

  objnames <- grid::grid.ls(print = FALSE)$name

  ## call any garnish functions in x$interactive

  if(!is.null(x$interactive$togarnish)) {
    pts <- sapply(names(x$interactive$togarnish), function(nm) {
      grep(nm, objnames, value = TRUE)
    })

    for(i in 1:length(pts)) {

      garnishparams <- list(pts, x$data[[x$interactive$togarnish[[i]]]], FALSE)
      names(garnishparams) <- c("path", x$interactive$togarnish[[i]], "group")
      do.call(gridSVG::grid.garnish, garnishparams)

    }
  }

  tmpFile <- tempfile()
  svgString <- gridSVG::grid.export(name = tmpFile, prefix = prefix, strict = FALSE)$svg

  grDevices::dev.off()
  grDevices::dev.off()

  svgString <- paste(readLines(tmpFile, warn = FALSE), collapse = "\n")

  unlink(sinkPlot)



  htmlString <- as.character(tags$form(id = "yearform",
    lapply(sort(unique(x$data$year)), function(x) list(tags$input(type = "radio", name = "year", value = x), x)
  )))



  if(omit.js){
    finstr <- c(cssString, svgString, htmlString, jsString)
  } else {
    d3String <- getD3()
    finstr <- c(cssString, d3String, svgString, htmlString, jsString)
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
