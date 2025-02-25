tempdir = tempdir()
path_zip = "data-raw/dados_infosiga.zip"
unzip(path_zip, exdir = tempdir)
path_veiculos = list.files(tempdir, pattern = "^veiculos", full.names = TRUE)

veiculos = readr::read_csv2(
    path_veiculos,
    locale = readr::locale(encoding = "latin1")
)

unlink(tempdir, recursive = TRUE)


usethis::use_data(infosiga_veiculos, overwrite = TRUE)
