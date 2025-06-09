tempdir = tempdir()
path_zip = "data-raw/dados_infosiga.zip"
unzip(path_zip, exdir = tempdir)
path_pessoas = list.files(tempdir, pattern = "^pessoas", full.names = TRUE)

pessoas = readr::read_csv2(
    path_pessoas,
    locale = readr::locale(encoding = "latin1")
)

unlink(tempdir, recursive = TRUE)

nanoparquet::write_parquet(
    pessoas,
    "data-raw/infosiga_vitimas_raw.parquet"
)

infosiga_vitimas = pessoas |>
    dplyr::mutate(
        sexo = dplyr::case_match(
            sexo,
            "MASCULINO" ~ "Masculino",
            "FEMININO" ~ "Feminino",
            "NAO DISPONIVEL" ~ NA
        ),
        data_obito = lubridate::dmy(data_obito),
        `tipo_de vítima` = dplyr::case_match(
            `tipo_de vítima`,
            "CONDUTOR" ~ "Condutor",
            "PASSAGEIRO" ~ "Passageiro",
            "PEDESTRE" ~ "Pedestre",
            "NAO DISPONIVEL" ~ NA
        ),
        tipo_veiculo_vitima = dplyr::case_match(
            tipo_veiculo_vitima,
            c("PEDESTRE", "Pedestre") ~ "A pé",
            "MOTOCICLETA" ~ "Motocicleta",
            "AUTOMOVEL" ~ "Automóvel",
            "NAO DISPONIVEL" ~ NA,
            "OUTROS" ~ "Outros",
            "BICICLETA" ~ "Bicicleta",
            "CAMINHAO" ~ "Caminhão",
            "ONIBUS" ~ "Ônibus",
            .default = tipo_veiculo_vitima
        ),
        tipo_modo_vitima = dplyr::case_match(
            tipo_veiculo_vitima,
            "A pé" ~ "Pedestre",
            "Motocicleta" ~ "Ocupante de motocicleta",
            "Automóvel" ~ "Ocupante de automóvel",
            "Bicicleta" ~ "Ciclista",
            "Caminhão" ~ "Ocupante de caminhão",
            "Ônibus" ~ "Ocupante de ônibus",
            'Outros' ~ "Outros",
            .default = NA
        ),
        gravidade_lesao = dplyr::case_match(
            gravidade_lesao,
            "FATAL" ~ "Fatal",
            "NAO DISPONIVEL" ~ NA,
            "LEVE" ~ "Leve",
            "GRAVE" ~ "Grave"
        ),
        faixa_etaria_demografica = dplyr::case_match(
            faixa_etaria_demografica,
            "NAO DISPONIVEL" ~ NA,
            "90 e +" ~ "90+",
            .default = faixa_etaria_demografica
        ),
        faixa_etaria_demografica = factor(
            faixa_etaria_demografica,
            levels = c(
                "00 a 04",
                "05 a 09",
                "10 a 14",
                "15 a 19",
                "20 a 24",
                "25 a 29",
                "30 a 34",
                "35 a 39",
                "40 a 44",
                "45 a 49",
                "50 a 54",
                "55 a 59",
                "60 a 64",
                "65 a 69",
                "70 a 74",
                "75 a 79",
                "80 a 84",
                "85 a 89",
                "90+"
            )
        ),
        data_sinistro = lubridate::dmy(data_sinistro)
    ) |>
    dplyr::rename(
        tipo_vitima = `tipo_de vítima`,
        faixa_etaria = faixa_etaria_demografica,
    ) |>
    dplyr::select(
        id_sinistro,
        data_sinistro,
        data_obito,
        sexo,
        idade,
        tipo_vitima,
        faixa_etaria,
        tipo_veiculo_vitima,
        tipo_modo_vitima,
        gravidade_lesao
    )

infosiga_vitimas$tipo_veiculo_vitima = enc2utf8(
    infosiga_vitimas$tipo_veiculo_vitima
)

infosiga_vitimas = tibble::as_tibble(infosiga_vitimas)

nanoparquet::write_parquet(
    infosiga_vitimas,
    "data-raw/infosiga_vitimas.parquet"
)
