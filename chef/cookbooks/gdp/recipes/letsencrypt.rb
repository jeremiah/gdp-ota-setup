# largely taken from:
# https://www.nginx.com/blog/free-certificates-lets-encrypt-and-nginx/

include_recipe 'apt'

package "nginx" do
  action [:install]
end

git "/opt/letsencrypt" do
  repository 'https://github.com/certbot/certbot'
  revision 'master'
  action :sync
  user user
end

directory '/var/www/letsencrypt' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
end

letsencrypt_config_path = node[:gdp][:letsencrypt][:config_path]

directory letsencrypt_config_path do
  owner 'www-data'
  group 'www-data'
  recursive true
  mode '0755'
  action :create
end

directory '/etc/nginx/conf.d/' do
  owner 'www-data'
  group 'www-data'
  recursive true
  mode '0755'
  action :create
end

cookbook_file "#{letsencrypt_config_path}/sota.genivi.org.conf" do
  source 'sota.genivi.org.conf'
  user 'www-data'
  group 'www-data'
  mode '700'
end

cookbook_file "/etc/nginx/sites-available/default" do
  source 'default'
  user 'www-data'
  group 'www-data'
  mode '700'
end

service 'nginx' do
  action [:enable, :start]
end

letsencrypt_path = node[:gdp][:letsencrypt][:bin_path]

# Get letsencrypt cert
execute 'Request letsencrypt cert' do
  command "#{letsencrypt_path} --agree-tos -n --config /etc/letsencrypt/configs/sota.genivi.org.conf certonly"
end

# Systemd unit for letsencrypt renewal
template '/lib/systemd/system/renew-letsencrypt.service' do
  source 'lib/systemd/system/renew-letsencrypt.service.erb'
  variables({
    letsencrypt_path: letsencrypt_path,
  })
  mode '700'
end

cookbook_file '/lib/systemd/system/renew-letsencrypt.timer' do
  source 'renew-letsencrypt.timer'
  mode '700'
end

service 'renew-letsencrypt' do
  action [:enable, :start]
end

execute 'start renew-letsencrypt timer' do
  command 'systemctl start renew-letsencrypt.timer'
end
execute 'enable renew-letsencrypt timer' do
  command 'systemctl enable renew-letsencrypt.timer'
end

