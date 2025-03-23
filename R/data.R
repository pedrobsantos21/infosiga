#' Road Crashes in São Paulo
#'
#' This dataset contains detailed information about road crashes that
#' occurred in the state of São Paulo, sourced from Infosiga.SP.
#'
#' @format ## `infosiga_sinistros`
#' A `tibble` with 807,096 observations and 36 variables:
#' \describe{
#'   \item{id_sinistro}{Unique identifier for the occurrence. (numeric)}
#'   \item{data_sinistro}{Date of the road crash. (class `Date`)}
#'   \item{hora_sinistro}{Time of the road crash. (class `hms`)}
#'   \item{cod_ibge}{IBGE code of the municipality where the road crash occurred. (numeric)}
#'   \item{nome_municipio}{Name of the municipality where the road crash occurred. (character)}
#'   \item{logradouro}{Street where the road crash occurred. (character)}
#'   \item{numero_logradouro}{Street number where the road crash occurred. (numeric)}
#'   \item{tipo_via}{Type of road where the road crash occurred. (character)}
#'   \item{longitude}{Longitude of the road crash location. (numeric)}
#'   \item{latitude}{Latitude of the road crash location. (numeric)}
#'   \item{tp_veiculo_bicicleta}{Number of bicycles involved in the road crash. (numeric)}
#'   \item{tp_veiculo_caminhao}{Number of trucks involved in the road crash. (numeric)}
#'   \item{tp_veiculo_motocicleta}{Number of motorcycles involved in the road crash. (numeric)}
#'   \item{tp_veiculo_nao_disponivel}{Number of vehicles with unavailable classification. (numeric)}
#'   \item{tp_veiculo_onibus}{Number of buses involved in the road crash. (numeric)}
#'   \item{tp_veiculo_outros}{Number of other types of vehicles involved. (numeric)}
#'   \item{tp_veiculo_automovel}{Number of cars involved in the road crash. (numeric)}
#'   \item{tipo_registro}{Type of road crash based on the occurrence of fatalities (character)}
#'   \item{gravidade_nao_disponivel}{Road crashes with unknown severity. (numeric)}
#'   \item{gravidade_leve}{Road crashes with minor injuries. (numeric)}
#'   \item{gravidade_fatal}{Fatal road crashes. (numeric)}
#'   \item{gravidade_ileso}{Road crashes where individuals were uninjured. (numeric)}
#'   \item{gravidade_grave}{Road crashes with serious injuries. (numeric)}
#'   \item{administracao_via}{Entity responsible for road administration. (character)}
#'   \item{jurisdicao_via}{Jurisdiction of the road where the road crash occurred. (character)}
#'   \item{tipo_sinistro_primario}{Primary type of road crash. (character)}
#'   \item{tp_sinistro_atropelamento}{Pedestrian-related crashes. (numeric)}
#'   \item{tp_sinistro_colisao_frontal}{Head-on collisions. (numeric)}
#'   \item{tp_sinistro_colisao_traseira}{Rear-end collisions. (numeric)}
#'   \item{tp_sinistro_colisao_lateral}{Side collisions. (numeric)}
#'   \item{tp_sinistro_colisao_transversal}{Cross collisions. (numeric)}
#'   \item{tp_sinistro_colisao_outros}{Other types of collisions. (numeric)}
#'   \item{tp_sinistro_choque}{Shock-related crashes. (numeric)}
#'   \item{tp_sinistro_capotamento}{Rollover crashes. (numeric)}
#'   \item{tp_sinistro_engavetamento}{Pile-up crashes. (numeric)}
#'   \item{tp_sinistro_tombamento}{Overturn crashes. (numeric)}
#'   \item{tp_sinistro_outros}{Other types of crashes. (numeric)}
#'   \item{tp_sinistro_nao_disponivel}{Crashes with an unspecified type. (numeric)}
#' }
#'
#' @source Infosiga.SP
#' @references \url{https://www.infosiga.sp.gov.br/}
"infosiga_sinistros"

#' Road Crash Victims in São Paulo
#'
#' This dataset contains information about individuals involved
#' in road crashes in the state of São Paulo, including their demographics,
#' injury severity, and vehicle type.
#'
#' @format ## `infosiga_vitimas`
#' A `tibble` with 1,618,002 observations and 9 variables:
#' \describe{
#'   \item{id_sinistro}{Unique identifier for the road crash. (numeric)}
#'   \item{data_sinistro}{Date of the road crash. (class `Date`)}
#'   \item{data_obito}{Date of death, if applicable. (class `Date`)}
#'   \item{sexo}{Gender of the victim. (character)}
#'   \item{idade}{Age of the victim. (numeric)}
#'   \item{tipo_vitima}{Type of victim (character)}
#'   \item{faixa_etaria}{Age group of the victim.}
#'   \item{tipo_veiculo_vitima}{Type of vehicle the victim was using (character)}
#'   \item{gravidade_lesao}{Injury severity (character)}
#' }
#'
#' @source Infosiga.SP
#' @references \url{https://www.infosiga.sp.gov.br/}
"infosiga_vitimas"

#' Vehicles Involved in Road Crashes in São Paulo
#'
#' This dataset contains information about vehicles involved in road crashes
#' in São Paulo, including their manufacturing year, model year,
#' color, and type.
#'
#' @format A `tibble` with 1,379,997 observations and 5 variables:
#' \describe{
#'   \item{id_sinistro}{Unique identifier for the road crash. (numeric)}
#'   \item{ano_fabricacao}{Year the vehicle was manufactured. (numeric)}
#'   \item{ano_modelo}{Model year of the vehicle. (numeric)}
#'   \item{cor_veiculo}{Color of the vehicle. (character)}
#'   \item{tipo_veiculo}{Type of vehicle (character)}
#' }
#'
#' @source Infosiga.SP
#' @references \url{https://www.infosiga.sp.gov.br/}
"infosiga_veiculos"

