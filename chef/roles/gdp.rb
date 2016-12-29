name 'gdp'
description 'setup GDP RVI Sota Server'
run_list [
  'recipe[gdp]',
  'recipe[gdp::letsencrypt]'
]
