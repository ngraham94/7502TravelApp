# 7502TravelApp
A multi-purpose Content Management System for Off On Vacation,
complete with user-facing website through Drupal, along
with a custom-written set of Drupal modules to manage Vacation
requests.

This has been written as part of Georgia Tech's CS Junior Design class,
part 2.

<!-- TOC -->

- [7502TravelApp](#7502travelapp)
    - [Table of Contents](#table-of-contents)
    - [Setup Testing Environment](#setup-testing-environment)
        - [Getting the Right Tools](#getting-the-right-tools)
        - [Double Check your install](#double-check-your-install)
        - [Setting up the Repository Files](#setting-up-the-repository-files)
            - [Manual setup of Environment Variables](#manual-setup-of-environment-variables)
            - [Common Issues](#common-issues)

<!-- /TOC -->

## Setup Testing Environment

**Note: This repository depends on external, 3rd party git repositories.
  You must clone this repository recursively!**

Run the following command to clone this repository recursively:

```
    git clone --recursive https://github.com/ngraham94/7502TravelApp.git
```

If you want an environment to play around with and get to know this CMS better,
then you must complete the steps listed below:

### Getting the Right Tools

Installing the development environment requires Docker and Docker Compose

Optionally, you can also install Python 2 to run the setup script that
automates the initial setup procedure.

Installation Links for Docker:

Versions Required:
| Program | Version # |
|---------|-----------|
| Docker | 17.03.1-ce |
| Docker Compose | 1.13.0 |
| (Optional) Python | 2.7.12 |

* [Windows](https://docs.docker.com/docker-for-windows/install/)
* [MacOS](https://docs.docker.com/docker-for-mac/install/)
* (For Windows and MacOS) Having trouble installing it?
  Use [Docker Toolbox](https://www.docker.com/products/docker-toolbox)
  instead.
* [Linux (Ubuntu)](https://docs.docker.com/engine/installation/linux/ubuntu/)
  * Note: Does not come with Docker Compose.
    [Install from here.](https://docs.docker.com/compose/install/)

**Note: On Linux (and maybe MacOS) systems, sometimes it's necessary to add your user to the `docker` group.
Do so with the command**

`# usermod -a -G docker $(whoami)`

### Double Check your install

Check if your version numbers match by executing the below commands:

```
  $ docker -v
  $ docker-compose -v
  $ python --version (Optional)
```

All of the returned version numbers should be at least as high as the table above stipulates.
Higher versions should also be fine (Note: Python 3 is not the same as Python 2. The `setup.py` script
was not tested on Python 3).

### Setting up the Repository Files

1. Clone this repository.
   The directory this project will be downloaded to will be referred to
   as the Git Root.
2. Git-Checkout the `dockerize` branch
3. Create a Data directory to host persistent files in any directory except
   the project's Git Root.
   1. Three empty subdirectories have to be made within this directory:
      `profiles`, `themes`, `modules`.
   2. Extract the contents of `default_sites.tar.gz` into the data directory.
      This should give you a fourth subdirectory called `sites`.
4. Setup environment variables. There are two ways of doing this.
   You can do this manually, or with the assistance of the setup script.
   Detailed instructions on doing this will be listed below
5. In your Docker Command Line Interface, to the Docker service directory
   (found in ${GIT ROOT}/docker/vacation)
6. Run `docker-compose up --build`
7. In your web browser, navigate to `localhost:80` and follow the prompts

#### Manual setup of Environment Variables

   * All commands below are relative to the `docker/vacation` directory
   * Duplicate the `.env.template` file, and call it `.env`
     * This is best done from within the Terminal/Command Prompt.
       Unix Instruction is `$ cp .env.template .env`
   * Edit the key-value pairs to your liking, according to the instructions
     from within the file itself.
     * Most importantly, fill in the `PG_PASSWORD` and `DIR_STORAGE` variables.
       * No spaces in the Values
       * No quotes around strings in the Values
       * There cannot be any space between the operands and the equal sign.
         * Acceptable: KEY=VALUE
         * Unacceptable: KEY = VALUE
         * Unacceptable: KEY= VALUE
         * Unacceptable: KEY =VALUE
         * Unacceptable: KEY=
       * `DIR_STORAGE` is the trickiest one to fill out, as a special notation
         is required. This will be the location of a **directory**. There cannot
         be any leading slashes at the end of the directory name
         * Acceptable: /some/data/dir
         * Unacceptable: /some/data/dir/
         * Unacceptable: /some/data dir/

#### Common Issues

* Something else is showing up in my `localhost:80`
  * Stop that service, and re-run `$ docker-compose up --build`