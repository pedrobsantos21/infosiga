#' Load data from Infosiga.SP
#'
#' Downloads and loads a `.parquet` dataset (sinistros, vítimas ou veículos).
#'
#' @param type One of `"sinistros"`, `"vitimas"`, or `"veiculos"`. Determines
#'   which dataset to load.
#' @param raw Logical. If TRUE, loads the raw version of the dataset.
#' @param use_cache Logical. If TRUE (default), uses a cached version
#'   if available.
#'
#' @return A `tibble` with the selected dataset.
#'
#' @examples
#' \dontrun{
#' df <- load_infosiga("sinistros")
#' }
#'
#' @export
load_infosiga <- function(
    type = c("sinistros", "vitimas", "veiculos"),
    raw = FALSE,
    use_cache = TRUE
) {
    type <- match.arg(type)

    if (raw) {
        type <- paste0(type, "_raw")
    }

    file_name <- paste0("infosiga_", type, ".parquet")
    cache_dir <- get_cache_dir()
    cache_file <- file.path(cache_dir, file_name)

    if (use_cache && file.exists(cache_file)) {
        cli::cli_alert_info("Using cached file: {cache_file}")
        return(nanoparquet::read_parquet(cache_file))
    }

    file_url <- paste0(
        "https://github.com/pabsantos/infosiga/releases/download/v",
        utils::packageVersion("infosiga"),
        "/",
        file_name
    )

    cli::cli_alert_info("Downloading {type}:")

    # Set up error handling to clean invalid cache
    cleanup <- function() {
        if (file.exists(cache_file)) {
            unlink(cache_file)
            cli::cli_alert_warning("Corrupted cache deleted: {cache_file}")
        }
    }

    response <- httr::GET(
        file_url,
        httr::progress(),
        httr::write_disk(cache_file, overwrite = TRUE)
    )

    status <- httr::status_code(response)

    if (status != 200) {
        cli::cli_alert_danger("Download failed with status code: {status}")
        cleanup()
        stop()
    }

    cli::cli_alert_success(
        "Download completed and saved to cache: {cache_file}"
    )

    return(nanoparquet::read_parquet(cache_file))
}


#' Get Infosiga Cache Directory
#'
#' Returns the path to the user-specific cache directory used to store
#' downloaded Infosiga dataset files.
#'
#' @param package Character. Name of the package. Defaults to "infosiga".
#'
#' @return A character string with the path to the cache directory.
#'
#' @examples
#' \dontrun{
#' # Get the path to the cache directory
#' get_cache_dir()
#' }
#'
#' @export
get_cache_dir <- function(package = "infosiga") {
    dir <- tools::R_user_dir(package, which = "cache")
    if (!dir.exists(dir)) {
        dir.create(dir, recursive = TRUE, showWarnings = FALSE)
    }
    return(dir)
}

#' Clear Infosiga Cache
#'
#' Deletes all cached Infosiga dataset files from the user cache directory.
#'
#' @param confirm Logical. If TRUE (default), asks for user confirmation
#'   before deleting the files.
#'
#' @return Invisibly returns NULL.
#'
#' @examples
#' \dontrun{
#' # Clear cache with confirmation
#' clear_infosiga_cache()
#'
#' # Clear cache without confirmation
#' clear_infosiga_cache(confirm = FALSE)
#' }
#'
#' @export
clear_infosiga_cache <- function(confirm = TRUE) {
    cache_dir <- get_cache_dir()

    if (!dir.exists(cache_dir)) {
        cli::cli_alert_info("No cache directory found. Nothing to clean.")
        return(invisible(NULL))
    }

    cached_files <- list.files(cache_dir, full.names = TRUE)

    if (length(cached_files) == 0) {
        cli::cli_alert_info("Cache is already empty.")
        return(invisible(NULL))
    }

    if (confirm) {
        answer <- readline(
            paste0(
                "Are you sure you want to delete ",
                length(cached_files),
                " cached file(s)? [y/N]: "
            )
        )
        if (tolower(answer) != "y") {
            cli::cli_alert_info("Cache cleaning aborted by user.")
            return(invisible(NULL))
        }
    }

    unlink(cached_files)
    cli::cli_alert_success("Cache cleared successfully.")
    return(invisible(NULL))
}
