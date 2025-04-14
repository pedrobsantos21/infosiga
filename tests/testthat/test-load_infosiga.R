library(testthat)
library(infosiga)
library(mockery)

test_that("load_infosiga builds correct URL and reads file for valid types", {
    fake_df <- tibble::tibble(x = 1:3)

    stub(load_infosiga, "utils::packageVersion", function(pkg) "1.0.0")
    stub(load_infosiga, "utils::download.file", function(url, destfile) {
        # Check if correct URL format is generated
        expect_match(url, "https://github.com/pabsantos/infosiga/releases/download/v1.0.0/infosiga_.*\\.parquet")
        writeLines("FAKE", destfile)  # fake file so read_parquet works if needed
        invisible(0)
    })
    stub(load_infosiga, "nanoparquet::read_parquet", function(path) {
        expect_match(path, "\\.parquet$")
        fake_df
    })

    expect_equal(load_infosiga("sinistros"), fake_df)
    expect_equal(load_infosiga("vitimas"), fake_df)
    expect_equal(load_infosiga("veiculos"), fake_df)
})

test_that("load_infosiga throws error for invalid type", {
    expect_error(load_infosiga("acidentes"), regexp = "should be one of")
})

test_that("load_infosiga returns a tibble", {
    fake_df <- tibble::tibble(a = 1)

    stub(load_infosiga, "utils::packageVersion", function(pkg) "1.0.0")
    stub(load_infosiga, "utils::download.file", function(...) invisible(0))
    stub(load_infosiga, "nanoparquet::read_parquet", function(...) fake_df)

    result <- load_infosiga("sinistros")
    expect_s3_class(result, "tbl_df")
})

test_that("download.file failure triggers error", {
    stub(
        load_infosiga, 
        "utils::packageVersion", 
        function(pkg) "1.0.0"
    )
    stub(
        load_infosiga, 
        "utils::download.file", 
        function(...) stop("Download failed")
    )

    expect_error(load_infosiga("sinistros"), regexp = "Download failed")
})
