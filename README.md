# Genivi Delivery

# Deployment

## Repo

https://github.com/advancedtelematic/infra-cookbooks

Cookbook: gdp
Role: gdp

# GDP Image

## Repo

git@github.com:advancedtelematic/meta-genivi-dev.git, branch: feat/add-swm

To build, follow the instructions [here](https://github.com/advancedtelematic/meta-genivi-dev#building-the-genivi-development-platform-gdp), making sure that the `meta-genivi-dev` layer is set on the branch `feat/add-swm`.

# Software Loading Manager

## Repo

https://github.com/advancedtelematic/genivi_swm, branch: feat/remove-gtk

This is the fork of the genivi_swm, with changes to let it run on yocto. The forked meta-genivi-dev repo above pulls from here.
