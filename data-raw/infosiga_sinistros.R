tempdir = tempdir()
path_zip = "data-raw/dados_infosiga.zip"
unzip(path_zip, exdir = tempdir)
path_sinistros = list.files(tempdir, pattern = "^sinistros", full.names = TRUE)

sinistros = readr::read_csv2(
    path_sinistros,
    locale = readr::locale(encoding = "latin1"),
    col_types = readr::cols(
        latitude = readr::col_character(),
        longitude = readr::col_character()
    )
)

unlink(tempdir, recursive = TRUE)

path_municipios = "data-raw/tb_municipio.csv"
municipios = readr::read_csv(path_municipios)

path_list_ibge = "data-raw/RELATORIO_DTB_BRASIL_MUNICIPIO.xls"
list_ibge = readxl::read_excel(path_list_ibge, skip = 6)

list_ibge_sp = list_ibge |>
    janitor::clean_names() |>
    dplyr::filter(nome_uf == "São Paulo") |>
    dplyr::select(cod_ibge = codigo_municipio_completo, nome_municipio)


infosiga_sinistros = sinistros |>
    dplyr::mutate(
        tipo_registro = dplyr::case_match(
            tipo_registro,
            "SINISTRO FATAL" ~ "Sinistro fatal",
            "SINISTRO NAO FATAL" ~ "Sinistro não fatal",
            "NOTIFICACAO" ~ "Notificação",
        ),
        data_sinistro = lubridate::dmy(data_sinistro),
        numero_logradouro = as.numeric(numero_logradouro),
        tipo_via = dplyr::case_match(
            tipo_via,
            "NAO DISPONIVEL" ~ NA,
            c(
                "RODOVIAS", "RURAL", "RURAL (COM CARACTERÍSTICA DE URBANA)"
            ) ~ "Rodovias",
            c("URBANA", "VIAS MUNICIPAIS") ~ "Vias municipais"
        ),
        longitude = stringr::str_replace_all(longitude, ",", "."),
        longitude = as.numeric(longitude),
        longitude = dplyr::if_else(
            longitude > -44.1 | longitude < -53.1,
            NA,
            longitude
        ),
        latitude = stringr::str_replace_all(latitude, ",", "."),
        latitude = as.numeric(latitude),
        latitude = dplyr::if_else(
            latitude > -19.7 | latitude < -25.3,
            NA,
            latitude
        ),
        dplyr::across(
            dplyr::starts_with("tp_veiculo"),
            ~dplyr::if_else(is.na(.x), 0, .x)
        ),
        dplyr::across(
            dplyr::starts_with("gravidade"),
            ~dplyr::if_else(is.na(.x), 0, .x)
        ),
        administracao_via = dplyr::case_match(
            administracao,
            c(
                "CONCESSIONÁRIA",
                "CONCESSIONÁRIA-ANTT",
                "CONCESSIONÁRIA-ARTESP"
            ) ~ "Concessionária",
            "NAO DISPONIVEL" ~ NA,
            "PREFEITURA" ~ "Prefeitura",
            .default = administracao
        ),
        jurisdicao_via = dplyr::case_match(
            jurisdicao,
            "ESTADUAL" ~ "Estadual",
            "MUNICIPAL" ~ "Municipal",
            "FEDERAL" ~ "Federal",
            "NAO DISPONIVEL" ~ NA
        ),
        tipo_sinistro_primario = dplyr::case_match(
            tipo_acidente_primario,
            "ATROPELAMENTO" ~ "Atropelamento",
            "COLISAO" ~ "Colisão",
            "CHOQUE" ~ "Choque",
            "NAO DISPONIVEL" ~ NA
        ),
        dplyr::across(
            dplyr::starts_with("tp_sinistro"),
            ~dplyr::case_when(
                .x == "S" ~ 1,
                is.na(.x) ~ 0
            )
        )
    ) |>
    dplyr::filter(
        tipo_registro %in% c("Sinistro fatal", "Sinistro não fatal")
    ) |>
    dplyr::left_join(
        y = municipios,
        by = c("municipio" = "s_ds_municipio")
    ) |>
    dplyr::mutate(cod_ibge = as.character(cod_ibge)) |>
    dplyr::left_join(list_ibge_sp, by = "cod_ibge") |>
    dplyr::select(
        id_sinistro, data_sinistro, hora_sinistro, cod_ibge, nome_municipio,
        logradouro, numero_logradouro, tipo_via,
        longitude, latitude, dplyr::starts_with("tp_veic"), tipo_registro,
        dplyr::starts_with("gravidade"), administracao_via, jurisdicao_via,
        tipo_sinistro_primario, dplyr::starts_with("tp_sinistro")
    )

infosiga_sinistros$tipo_registro <- enc2utf8(infosiga_sinistros$tipo_registro)
infosiga_sinistros$tipo_via <- enc2utf8(infosiga_sinistros$tipo_via)
infosiga_sinistros$administracao_via <- enc2utf8(
    infosiga_sinistros$administracao_via
)
infosiga_sinistros$jurisdicao_via <- enc2utf8(
    infosiga_sinistros$jurisdicao_via
)
infosiga_sinistros$tipo_sinistro_primario <- enc2utf8(
    infosiga_sinistros$tipo_sinistro_primario
)

usethis::use_data(infosiga_sinistros, overwrite = TRUE, version = 2)
