
library(htmltools)

# Generate HTML for a 4-wide bootstrap thumbnail
thumbnail <- function(img) {
  div(class = "col-sm-4",
        img(src = img),
  )
}

# Generate HTML for several rows of 4-wide bootstrap thumbnails 
thumbnails <- function(thumbs) {
  
  # capture arguments and setup rows to return
  numThumbs <- length(thumbs)
  fullRows <- numThumbs / 3
  rows <- tagList()
  
  # add a row of thumbnails
  addRow <- function(first, last) {
    rows <<- tagAppendChild(rows, div(class = "row", thumbs[first:last]))
  }
  
  # handle full rows
  for (i in 1:fullRows) {
    last <- i * 3
    first <- last-2
    addRow(first, last)
  }
  
  # check for leftovers
  leftover <- numThumbs %% 3
  if (leftover > 0) {
    last <- numThumbs
    first <- last - leftover + 1
    addRow(first, last)
  }
  
  # return the rows!
  rows
}

# Generate HTML for examples
examples <- function(category) {
  
  # read examples into data frame (so we can easily sort/filter/etc)
  examples <- yaml::yaml.load_file("pics.yml")
  examples <- plyr::ldply(examples[[category]], data.frame, stringsAsFactors=FALSE)
  
  # convert to list for thumbnail generation
  examples <- apply(examples, 1, function(r) { 
    list(img = r["img"])
  })
  
  thumbnails(lapply(examples, function(x) {
    thumbnail(title = x$title, 
              img = x$img, 
              caption = FALSE)
  }))
}

