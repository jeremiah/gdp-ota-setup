# Genivi Delivery

# Deployment

Deployment is done using [Chef](https://docs.chef.io/).

The cookbook is at `chef/cookbooks/gdp`, and the role is in `chef/roles/gdp.rb`.

To deploy the genivi server, all you need to do is:

```
cd ~/gdp-ota-setup/chef
./deploy.sh
```

If you need to provision a new server from scratch, do the following:

- Clone this repo to the server: `git clone git@github.com:advancedtelematic/gdp-ota-setup.git --recursive`
- `cd gdp-ota-setup/chef`
- `./install.sh`
- `./deploy.sh`

# Configure LDAP

The file files/gdp-environment with default local LDAP configurarion is written to /etc/gdp-   environment on the server. There the credentials must be added for the LDAP server.

# Building The GDP Image

The changes to the GDP image are in the `recipes-sota` dir of a forked meta-genivi-dev layer.

It can be found here:

https://github.com/advancedtelematic/meta-genivi-dev, branch: gdp-integration

To build, follow the instructions [here](https://github.com/advancedtelematic/gdp-ota-setup/tree/master/doc#build-gdp-with-sota-support) and in the [genivi-dev-platform README](https://github.com/genivi/genivi-dev-platform/).


# End to end test

Follow the [Quickstart doc](https://github.com/advancedtelematic/gdp-ota-setup/tree/master/doc) from beginning to end. Currently, an RVI bug prevents the successful download of updates, but the steps up until then should work.


# Sample install package

From the genivi_swm project run:
```
sh create_update_image.sh -d libats -o libats.upd
```

The rpm package inside that was created with the command `bitbake libats` from the `gdp-src-build` dir. It is created from the recipe at `meta-genivi-dev/meta-genivi-dev/recipes-sota/libats`.
