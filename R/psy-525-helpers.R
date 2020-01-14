# PSY 525 helper functions

render_lectures <- function(lecture_dir = "lectures") {
  fl <- list.files(path = lecture_dir, pattern = "\\.Rmd$", full.names = TRUE)
  message(paste0("There are ", length(fl), " files to render."))
  if (fl > 0) {
    message(paste0("Rendering."))
    lapply(fl, rmarkdown::render)
  } else {
    message(paste0("No files to render. Exiting."))
  }
  # return list of files
  fl
}

render_all <- function() {
  render_lectures()
  rmarkdown::render_site()
}
