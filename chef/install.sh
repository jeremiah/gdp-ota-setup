#!/bin/bash

chef_binary=$(which chef-solo)

if ! test -f "$chef_binary"; then
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q chef
fi
