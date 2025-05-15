tempdir = tempdir()
path_zip = "data-raw/dados_infosiga.zip"
unzip(path_zip, exdir = tempdir)
path_veiculos = list.files(tempdir, pattern = "^veiculos", full.names = TRUE)

veiculos = readr::read_csv2(
    path_veiculos,
    locale = readr::locale(encoding = "latin1")
)

unlink(tempdir, recursive = TRUE)

nanoparquet::write_parquet(
    veiculos,
    "data-raw/infosiga_veiculos_raw.parquet"
)


infosiga_veiculos = veiculos |>
    dplyr::select(
        id_sinistro,
        ano_fabricacao = ano_fab,
        ano_modelo,
        cor_veiculo,
        tipo_veiculo
    ) |>
    dplyr::mutate(
        tipo_veiculo = dplyr::case_match(
            tipo_veiculo,
            "AUTOMOVEL" ~ "Automóvel",
            "MOTOCICLETA" ~ "Motocicleta",
            "CAMINHAO" ~ "Caminhão",
            "ONIBUS" ~ "Ônibus",
            "OUTROS" ~ "Outros",
            "BICICLETA" ~ "Bicicleta",
            "NAO DISPONIVEL" ~ NA
        )
    )

infosiga_veiculos$tipo_veiculo = enc2utf8(infosiga_veiculos$tipo_veiculo)

infosiga_veiculos = tibble::as_tibble(infosiga_veiculos)

nanoparquet::write_parquet(
    infosiga_veiculos,
    "data-raw/infosiga_veiculos.parquet"
)
