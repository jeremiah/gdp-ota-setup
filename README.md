# Genivi Delivery

# Deployment

## Repo

https://github.com/advancedtelematic/infra-cookbooks

Cookbook: gdp

Role: gdp

# GDP Image

## Repo

https://github.com/advancedtelematic/meta-genivi-dev, branch: feat/add-swm

To build, follow the instructions [here](https://github.com/advancedtelematic/meta-genivi-dev#building-the-genivi-development-platform-gdp)

You'll need to make sure a few layers are at different branches:

- `meta-genivi-dev` layer is on the branch `feat/add-swm` from the ats fork.
- `meta-rust` is on the latest from https://github.com/meta-rust/meta-rust

Note that the genivi_swm is currently an externalsrc recipe, so from the root of the meta-genivi-dev dir in the genivi-dev-platform dir, you should be able to run `ls meta-genivi-dev/recipes-sota/genivi-swm/../../../../../../../work/genivi_swm` to find the dir (it makes sense on my machine, promise)

Also of interest, the rvi recipe is of the AUTOREV type, so it always gets the latest changes.

# Software Loading Manager

## Repo

https://github.com/advancedtelematic/genivi_swm, branch: feat/remove-gtk

This is the fork of the genivi_swm, with changes to let it run on yocto. The forked meta-genivi-dev repo above pulls from here.

# End to end test

- copy the `run-qemu-net` script from this repo to your bitbake build dir (something like `genivi-dev-platform/gdp-src-build`)
- start image with `./run-qemu-net genivi-dev-platform`
- ssh into it with `ssh root@127.0.0.1 -p 2223`, the password is `root`
- kill rvi with `systemctl stop rvi`
- start rvi with `RVI_MYIP=$(/sbin/ip route | /usr/bin/awk '/default/ { print $3 }') RVI_PORT=8900 RVI_BACKEND=38.101.164.230 CONFIG=/etc/opt/rvi/rvi.config RVI_BACKEND=38.101.164.230 /opt/rvi_core/rvi_ctl -c /etc/opt/rvi/rvi.config console`
- restart sota client with `systemctl restart sota_client`
- start swm with `cd /usr/lib/genivi-swm/ && ./start-yocto.sh`
