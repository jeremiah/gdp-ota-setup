# Genivi Delivery

# Deployment

## Repo

https://github.com/advancedtelematic/infra-cookbooks

Cookbook: gdp

Role: gdp

# GDP Image

## Repo

https://github.com/advancedtelematic/meta-genivi-dev, branch: feat/add-swm

To build, follow the instructions [here](https://github.com/advancedtelematic/meta-genivi-dev#building-the-genivi-development-platform-gdp), making sure that the `meta-genivi-dev` layer is on the branch `feat/add-swm`.

Note that the genivi_swm is currently a externalsrc recipe, so from the root of the meta-genivi-dev dir in the poky dir, you should be able to run `ls meta-genivi-dev/recipes-sota/genivi-swm/../../../../../../../work/genivi_swm` to find the dir (it makes sense on my machine, promise)

# Software Loading Manager

## Repo

https://github.com/advancedtelematic/genivi_swm, branch: feat/remove-gtk

This is the fork of the genivi_swm, with changes to let it run on yocto. The forked meta-genivi-dev repo above pulls from here.
