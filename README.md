# Genivi Delivery

# Deployment

Deployment is done using [Chef](https://docs.chef.io/).

The cookbook is at `chef/cookbooks/gdp`, and the role is in `chef/roles/gdp.rb`.

Instructions on some basic chef commands are in the file `chef/cookbooks/gdp/README.md`

# Building The GDP Image

The changes to the GDP image are in the `recipes-sota` dir of a forked meta-genivi-dev layer.

It can be found here:

https://github.com/advancedtelematic/meta-genivi-dev, branch: gdp-challenge

To build, follow the instructions [here](https://github.com/advancedtelematic/meta-genivi-dev#building-the-genivi-development-platform-gdp)

You'll need to make sure a few layers are at different branches:

- `meta-genivi-dev` layer is on the branch `genivi-challenge` from the ats fork.
- `meta-rust` is on the commit `4eb46035c535dd6fc1626d08757ddfb72eb796f2` from https://github.com/meta-rust/meta-rust 

When that is set up, you can use `bitbake genivi-dev-platform` as per the afore mentioned instructions to build the image.

# Software Loading Manager

Several changes were made to the Software Loading Manager so that it would run on GDP. They can be found here:

https://github.com/advancedtelematic/genivi_swm, branch: genivi-challenge

# Starting the GDP image

You have two options: you can build an image from source, or use a prebuilt image.

Let's take them one at a time:

## from source

First, follow the above instructions above at the heading Building The GDP Image.

When you have a successful build, copy the `run-qemu-net-source` script from this repo to your `gdp-src-build` directory

Then start the image with `./run-qemu-net-source genivi-dev-platform`

## using the prebuilt image

First up, download the prebuilt image and its kernal. Assuming you have HTTPie installed, you can run the following:

```
http https://s3.eu-central-1.amazonaws.com/openivi-releases/gdp-11-01-2016-r1.ext4 -d
http https://s3.eu-central-1.amazonaws.com/openivi-releases/gdp-11-01-2016.bzImage -d
```

Then you can start it with the following command:

```
./run-qemu-net-prebuilt gdp-11-01-2016-r1.ext4 gdp-11-01-2016.bzImage
```

# End to end test

- go to https://sota.genivi.org
- log in with your GENIVI ldap credentials
- click 'Vehicles' on the left column to go to https://sota.genivi.org/#/vehicles
- click 'NEW VIN', enter a name, and click 'Add Vehicle'
- click on the newly created vehicle from the list below
- copy its UUID from the URL bar, you'll need this later
- now, IF you are building from source, you'll need to add the uuid to the following files
  - `meta-genivi-dev/recipes-sota/rvi/device_id`, update so it is `genivi.org/device/YOUR_UUID`
  - `meta-genivi-dev/recipes-sota/sota-client-append/sota.toml`, update the field `uuid = "YOUR_UUID"`
  - rebuild the image by running `bitbake genivi-dev-platform` from your `gdp-src-build` directory
  - start image as per the instructions above
- ssh into it with `ssh root@127.0.0.1 -p 2223`, the password is `root`
- IF you didn't build from source with uuid added:
  - start the prebuilt image as per the instructions above
  - you'll have to edit two files
  - `/etc/opt/rvi/device_id`, update so it is `genivi.org/device/YOUR_UUID`
  - `/etc/sota.toml`, update the field `uuid = "YOUR_UUID"`
  - run the command `systemctl restart rvi sota_client` (it takes about a minute)
  - once this exits you can check that both processes are started with `systemctl status rvi sota_client`
- run `cat /etc/example.configfile` to show there is `No such file or directory`
- check the logs of both `journalctl -fu sota_client -u software_loading_manager`, and keep this running.
- back on https://sota.genivi.org click 'Packages' on the left column
- click 'NEW PACKAGE'
- fill in the form with 'package name'=`libats`, 'version'=`2.0.0`, and as the Package Binary choose `libats.upd` from the genivi_swm repo. (More info on this package below under the heading 'Sample install package')
- click 'Add PACKAGE' to create the package
- click packages on the left column
- click 'Create Campaign' from the row of the package 'libats 2.0.0'
- fill in the form with 'Update Priorty'=`1`, 'Update Signiture'=`1`
- click 'Generate Update Id'
- click 'Create Update' to create and start the update
- you should now see lots of logs in the terminal where you ran `journalctl -fu sota_client -u software_loading_manager`
- when it stops, ideally without error messages, run the command `cat /etc/example.configfile` again, and you should see the output:

```
FOO=bar
VERSION=2.0.0
```

- a package was successfully installed!


# Sample install package

From the genivi_swm project run:
```
sh create_update_image.sh -d libats -o libats.upd
```

The rpm package inside that was created with the command `bitbake libats` from the `gdp-src-build` dir. It is created from the recipe at `meta-genivi-dev/meta-genivi-dev/recipes-sota/libats`.
