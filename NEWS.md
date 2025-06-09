# infosiga 0.4.4

# infosiga 0.4.3

* Fix values from wrong release date.

# infosiga 0.4.2

* Fix missing values in `infosiga_sinistros`: `gravidade_grave` and `gravidade_leve`

* Fix missing values in `infosiga_vitimas`: `gravidade_lesao` now have proper values of "Grave" and "Leve:

# infosiga 0.4.1

* Add new variable to `infosiga_sinistros`: `regiao_administrativa`

* Update data to 2025-04

# infosiga 0.4.0

* Add new variable to `infosiga_vitimas`: `tipo_modo_vitima`

* Change `tipo_via` entries.

# infosiga 0.3.1

* Change repo url

# infosiga 0.3.0

* Add option to load raw infosiga data (#40)

* Add cache functionality to `load_infosiga`

* Add new function to clear cache: `clear_infosiga_cache` 

# infosiga 0.2.3

* Add status messages in `load_infosiga` (#39)

# infosiga 0.2.2

* Update data to 2025-03 (#33)

* Fix wrong data (#35)

* Use `{httr}` to download data (#36)

# infosiga 0.2.1

* Write tests (#29)

* Remove release workflow (#30)

* Transform output class to `tibble` (#31)

# infosiga 0.2.0

* Create function `load_infosiga` (#27)

* Remove local files from pkg (#27)

* Insert "Notificação" in the `infosiga_sinistros` dataset (#26)

# infosiga 0.1.5

* Update data to 2025-02 (#23)

# infosiga 0.1.4

* Fix city names in `municipio` (#21)
* Change `municipio` to `nome_municipio` in `infosiga_sinistros` (#21)

# infosiga 0.1.3

* Add new variables: `logradouro` and `tipo_registro` (#17, #18)

# infosiga 0.1.2

* Fix missing values of `faixa_etaria` in `infosiga_vitimas` (#16)

# infosiga 0.1.1

* Fix wrong values in `tipo_veiculo_vitima` (#14)

# infosiga 0.1.0

* Initial release.
