# GDP Sota Server

## Bootstrap

```
knife bootstrap sota.genivi.org --sudo -r 'role[gdp]' -x at -A
```

## Provision

```
knife ssh 'role:gdp' -x at -A 'sudo chef-client'
```

## Update cookbook

```
knife cookbook upload gdp
```

## Revoke credentials

```
knife ssh 'role:gdp' -x at -A 'sudo rm /etc/chef/*'
knife node delete sota.genivi.org
knife client delete sota.genivi.org
```

## Configure LDAP

The file `files/gdp-environment` with default local LDAP configurarion is written to `/etc/gdp-environment` on the server. There the credentials must be added for the LDAP server.
