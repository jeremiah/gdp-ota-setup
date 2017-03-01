# GDP Sota Server

## dependencies

For chef-solo, the dependencies are checked out as submodules in the `chef/cookbooks` directory. Cloning the repo with the `--recursive` flag should give you the correct versions, but if for some reason it doesn't, you'll need the following:

apt: 2.9.2 https://github.com/chef-cookbooks/apt/releases/tag/v2.9.2
sudo: 2.9.0 https://github.com/chef-cookbooks/sudo/releases/tag/v2.9.0

## Configure LDAP

The file `files/gdp-environment` with default local LDAP configurarion is written to `/etc/gdp-environment` on the server. There the credentials must be added for the LDAP server.
