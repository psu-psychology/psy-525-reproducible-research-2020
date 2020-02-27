# PSY 525 helper functions

render_subfolder <- function(sub_dir = "lectures") {
  fl <- list.files(path = sub_dir, pattern = "\\.Rmd$", full.names = TRUE)
  message(paste0("There are ", length(fl), " files to render."))
  if (length(fl) > 0) {
    message(paste0("Rendering."))
    purrr::map(fl, rmarkdown::render)
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
  clean_up()
}

launch_github <- function(repo_url = "https://github.com/psu-psychology/psy-525-reproducible-research-2020") {
  if (!is.character(repo_url)) {
    stop("'repo_url' must be a string.")
  }
  browseURL(repo_url)
}

clean_up <- function() {
  if (".databrary.RData" %in% list.files()) {
    databraryapi::logout_db()
    file.remove(".databrary.RData")
  }
  if (file.exists("docs/hw")) {
    unlink("docs/hw", recursive = TRUE)
  }
  if (file.exists("docs/psy-525-spring-2020.csv")) {
    file.remove("docs/psy-525-spring-2020.csv")
  }
  #launch_github()
}
