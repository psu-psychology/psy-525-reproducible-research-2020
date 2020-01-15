# PSY 525 helper functions

render_subfolder <- function(sub_dir = "lectures") {
  fl <- list.files(path = sub_dir, pattern = "\\.Rmd$", full.names = TRUE)
  message(paste0("There are ", length(fl), " files to render."))
  if (length(fl) > 0) {
    message(paste0("Rendering."))
    lapply(fl, rmarkdown::render)
  } else {
    message(paste0("No files to render. Exiting."))
  }
  # return list of files
  fl
}

render_all <- function() {
  render_subfolder("lectures")
  render_subfolder("how_to")
  rmarkdown::render_site()
}
