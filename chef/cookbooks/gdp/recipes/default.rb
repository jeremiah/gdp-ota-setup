include_recipe 'apt'

# Install Prerequisites
%w(tcpdump iotop htop strace nmap tree vim
  dnsutils traceroute ngrep iptraf-ng dstat
  sysstat multitail inotify-tools apt-transport-https
  jq apt-transport-https ca-certificates).each do |pkg|
  package pkg do
    action :install
    options "--force-yes"
  end
end

# Install Docker
execute 'Add docker keyserver' do
  command "apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D"
end

execute 'Add docker apt repository' do
  command "echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > /etc/apt/sources.list.d/docker.list"
end

execute 'Update apt listings' do
  command "apt-get update"
end

package "docker-engine" do
  options "--force-yes"
  action [:install]
end

# Install Docker Compose
execute 'install docker-compose' do
  command "wget https://github.com/docker/compose/releases/download/#{node['docker-compose'][:version]}/docker-compose-`uname -s`-`uname -m` -O #{node['docker-compose'][:path]}"
  not_if { ::File.exists?("#{node['docker-compose'][:path]}")}
end

file node['docker-compose'][:path] do
  user 'root'
  group 'root'
  mode '777'
end

user = node[:gdp][:user]
home_dir = "/home/#{user}"
data_dir = node[:gdp][:data_dir]
compose_file = "#{home_dir}/rvi_sota_server/deploy/docker-compose/docker-compose.yml"
rvi_compose_file = "#{home_dir}/rvi_sota_server/deploy/docker-compose/core-rvi.yml"
webserver_compose_file = "#{home_dir}/rvi_sota_server/deploy/docker-compose/webserver-overrides.yml"
mariadb_compose_file = "#{home_dir}/rvi_sota_server/deploy/docker-compose/mariadb-volume.yml"
gdp_env_file = '/etc/gdp-environment'
additional_groups = node[:gdp][:additional_groups]

additional_groups.each do |grp|
  group grp do
    action :modify
    members user
    append true
  end
end

# Add rvi sota server
git "#{home_dir}/rvi_sota_server" do
  repository 'https://github.com/advancedtelematic/rvi_sota_server.git'
  revision 'master'
  action :sync
  user user
end

# add docker-compose ldap overrides
cookbook_file "#{webserver_compose_file}" do
  source 'webserver-overrides.yml'
  user user
  group user
  mode '700'
end

template '/lib/systemd/system/gdp.service' do
  source 'lib/systemd/system/gdp.service.erb'
  variables({
    compose_file: compose_file,
    rvi_compose_file: rvi_compose_file,
    webserver_compose_file: webserver_compose_file,
    mariadb_compose_file: mariadb_compose_file,
    gdp_env_file: gdp_env_file
  })
  mode '700'
end

# add ldap env vars example
cookbook_file gdp_env_file do
  source 'gdp-environment'
  user 'root'
  group 'root'
  mode '700'
  not_if { ::File.exists?(gdp_env_file)}
end

# add mariadb volume
template mariadb_compose_file do
  source 'mariadb-volume.yml.erb'
  variables({
    data_dir: data_dir
  })
  mode '700'
end

directory data_dir do
  owner user
  group user
  recursive true
  mode '0755'
  action :create
end

# Start service
service 'gdp' do
  action [:enable, :start]
end
