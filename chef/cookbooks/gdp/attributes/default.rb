default[:gdp][:user] = "at"
default[:gdp][:additional_groups] = %w(docker root)
default[:gdp][:data_dir] = '/opt/gdp/data'

default[:gdp][:letsencrypt][:config_path] = "/etc/letsencrypt/configs/"
default[:gdp][:letsencrypt][:bin_path] = "/opt/letsencrypt/certbot-auto"

default[:docker][:version] = "1.12.3-0"

default['docker-compose'][:version] = "1.8.1"
default['docker-compose'][:path] = "/usr/local/bin/docker-compose"
default[:gdp][:sota_version] = "0.2.83"
