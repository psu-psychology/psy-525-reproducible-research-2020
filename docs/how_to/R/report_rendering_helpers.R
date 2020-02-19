render_my_report <- function(fn, out_dir = "html") {
  if (!file.exists(fn)) {
    stop("File '", fn, "' not found.")
    }
  if (!dir.exists(out_dir)) {
    dir.create(out_dir)
  }
  
  # Create output file name
  report_fn <- paste0(fn, ".html")
  
  rmarkdown::render(input = "report-template.Rmd", 
                    output_file = report_fn,
                    output_dir = "html", 
                    params = list(data_file_path = fn))
}

render_all_reports <- function(data_dir = "csv") {
  if (!dir.exists(data_dir)) {
    stop(paste0("Data directory '", data_dir, "' not found."))
  }
  fl <- list.files(data_dir, pattern = "p_[1-9]", full.names = TRUE)
  purrr::map(fl, render_my_report)
}
