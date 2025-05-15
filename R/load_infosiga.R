#' Load data from Infosiga.SP
#'
#' Downloads and loads a `.parquet` dataset (sinistros, vítimas ou veículos).
#'
#' @param type One of `"sinistros"`, `"vitimas"`, or `"veiculos"`. Determines which dataset to load.
#' @param raw Boolean. Determines if the data is processed or in raw format. Default value: FALSE
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
    raw = FALSE
) {
    type <- match.arg(type)

    if (raw) {
        type <- paste0(type, "_raw")
    }

    file_url <- paste0(
        "https://github.com/pabsantos/infosiga/releases/download/v",
        utils::packageVersion("infosiga"),
        "/infosiga_",
        type,
        ".parquet"
    )

    temp <- tempfile(fileext = ".parquet")
    on.exit(unlink(temp), add = TRUE)

    message("Starting download...")
    response <- httr::GET(
        file_url,
        httr::progress(),
        httr::write_disk(temp, overwrite = TRUE)
    )

    status <- httr::status_code(response)

    if (status == 200) {
        message("Download completed successfully: ", type)
    } else {
        stop("Download failed with status code: ", status)
    }

    df <- nanoparquet::read_parquet(temp)

    return(df)
}
