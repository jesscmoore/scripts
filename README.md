# Scripts

**Utility scripts for everyday tasks used in an open source working environment.**

*Time-stamp: <Friday 2025-07-18 10:54:11 +1000 Jess Moore>*

*Authors: Jess Moore*

*License: GNU GPL V3*


## Install

*One script to bind them all*

For ease of use, the `add_script.sh [my_script]` script can be run to make `[my_script]` executable and add to `$USER/bin`.

    $ bash add_script.sh [script_name]

where `script_name` is the name of the script without the `.sh` suffix.

This allows scripts to be used as

    $ script_name $ARG

instead of

    $ bash script_name.sh $ARG

Alternatively, to install all scripts to `$USER/bin` use:

    $ cd support
    $ make install


## Examples

These examples assume each script has already been made executable and added to the `$PATH`.


### Create new repo

Create a private github repo. Currently, assumes user has created and navigated into a new directory for the project.

    $ mkdir repo_name
    $ cd repo_name
    $ create_repo here

*TODO:* add support for user to provide a new_project name and create folder and repo with that name.

### Create bash script

Create bash script `new_script.sh` with standard bash shebang, timestamp, user's name, provided description.

    $ `create_bash new_script.sh "Very brief description \n optional line 2"` -


### Create Jekyll blog post

Make a jekyll blog post markdown file for a how-to style post with front yaml, title, today's date, summary, procedure, references, and published set to false.

    $ create_post ubuntu_w_broadcom_wifi_adaptor "Ubuntu: how to connect to wifi with Broadcom Wireless Adaptor"

This creates jekyll markdown post

    $ _posts/%Y-%M-%d-ubuntu_w_broadcom_wifi_adaptor.md

with title "Ubuntu: how to connect to wifi with Broadcom Wireless Adaptor" and where %Y-%M-%d is today's date. The post will not be published when pushed to master, unless published is changed to `true`.


### Create markdown file for notes

Create a markdown file for note taking with standard header stub comprising title, date.

    $ create_md [filename.md] ["Notes"]

### Create meeting notes file

Create a markdown file for taking meeting notes. This has a header comprising title, date, attendees, place. Where known attendees are provided as a comma separated string.

    # create_mtg [filename.md] ["Meeting with XYZ"] ["Jane, Cam, Liz, Sam"]

## Create makefile

Create a generic makefile for recording make rules.

    $ create_mk
