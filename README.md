# Genivi Delivery

# Deployment

Deployment is done using [Chef](https://docs.chef.io/).

The cookbook is at `chef/cookbooks/gdp`, and the role is in `chef/roles/gdp.rb`.

Instructions on some basic chef commands are in the file `chef/cookbooks/gdp/README.md`

# GDP Image

## Repo

https://github.com/advancedtelematic/meta-genivi-dev, branch: genivi-challenge

To build, follow the instructions [here](https://github.com/advancedtelematic/meta-genivi-dev#building-the-genivi-development-platform-gdp)

You'll need to make sure a few layers are at different branches:

- `meta-genivi-dev` layer is on the branch `genivi-challenge` from the ats fork.
- `meta-rust` is on the latest from https://github.com/meta-rust/meta-rust

Also of interest, the rvi recipe is of the AUTOREV type, so it always gets the latest changes.

A prebuilt image can be found here: https://s3.eu-central-1.amazonaws.com/openivi-releases/gdp/genivi-dev-platform-qemux86-64.ext4

# Software Loading Manager

## Repo

https://github.com/advancedtelematic/genivi_swm, branch: genivi-challenge

This is the fork of the genivi_swm, with changes to let it run on yocto. The forked meta-genivi-dev repo above pulls from here.

# End to end test

- copy the `run-qemu-net` script from this repo to your bitbake build dir (something like `genivi-dev-platform/gdp-src-build`)
- start image with `./run-qemu-net genivi-dev-platform`
- ssh into it with `ssh root@127.0.0.1 -p 2223`, the password is `root`
- start swm with `cd /usr/lib/genivi-swm/ && ./start-yocto.sh`

# Current status

The admin interface is available at https://sota.genivi.org

The LDAP integration is complete but not tested. In theory you can log in with internal Genivi LDAP credentials (different to Genivi Crowd credentials), but I haven't been able to test that as I don't have test credentials yet (they are in progress).

And on the server side, you can ssh in and run `docker ps` to see what services are up, and `docker logs` to see their logs.

On the GDP image you can check if rvi and sota_client are running using `systemctl`:

```
systemctl status rvi
systemctl status sota_client
```

The image is configued with the UUID of a test vehicle on https://sota.genivi.org. You can create a campaign for a package and send it to that vehicle. `sota_client` on the GDP image receives the campaign, but currently fails to install it.

The campaign gets as far as the sota-client, and from there there is an issue connecting to genivi-swm over dbus. I believe it is failing to communicate to the genivi-swm over dbus. The genivi-swm has a dependency the library [storm](https://pypi.python.org/pypi/storm) and falls over without it, so it probably doesn't have the necessary dbus interfaces. Currently working on how to solve this also.
