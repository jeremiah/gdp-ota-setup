# GDP Sota Server

## Bootstrap

```
  knife bootstrap -x at --sudo -r 'role[gdp]' -N gdp-server -A 38.101.164.230
```

## Provision

GPD instance does not expose it's public network interface directly to the internet
which requires explicit SSH Gateway parameter to connect chef-server to the instnace.

```
  knife ssh 'role:gdp' -x at -G 38.101.164.230 -A 'sudo chef-client'

```
