#' Load data from Infosiga.SP
#'
#' Downloads and loads a `.parquet` dataset (sinistros, vítimas ou veículos).
#'
#' @param type One of `"sinistros"`, `"vitimas"`, or `"veiculos"`. Determines which dataset to load.
#'
#' @return A `tibble` with the selected dataset.
#'
#' @examples
#' \dontrun{
#' df <- load_infosiga("sinistros")
#' }
#'
#' @export
load_infosiga <- function(type = c("sinistros", "vitimas", "veiculos")) {
    type <- match.arg(type)

    file_url = paste0(
        "https://github.com/pabsantos/infosiga/releases/download/v",
        utils::packageVersion("infosiga"),
        "/infosiga_",
        type,
        ".parquet"
    )

    temp = tempfile(fileext = ".parquet")
    on.exit(unlink(temp), add = TRUE)

    httr::GET(file_url, httr::write_disk(temp, overwrite = TRUE))
    df = nanoparquet::read_parquet(temp)

    return(df)
}
