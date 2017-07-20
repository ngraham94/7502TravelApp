# Off On Vacation Delivery Documentation
A multi-purpose Content Management System for Off On Vacation,
complete with user-facing website through Drupal.

This has been written as part of Georgia Tech's CS Junior Design class,
part 2.

<!-- TOC -->

## Installation Guide

- [7502TravelApp](#7502travelapp)
    - [Setup Testing Environment](#setup-testing-environment)
        - [Getting the Right Tools](#getting-the-right-tools)
        - [Double Check your install](#double-check-your-install)
        - [Setting up the Repository Files](#setting-up-the-repository-files)
            - [Manual setup of Environment Variables](#manual-setup-of-environment-variables)
    - [Troubleshooting](#troubleshooting)

<!-- /TOC -->

## Setup Testing Environment

**Note: This repository depends on external, 3rd party git repositories.
  You must clone this repository recursively!**

Run the following command to clone this repository recursively:

```
    git clone --recursive https://github.com/ngraham94/7502TravelApp.git
```

**Note:** If you've forgotten to clone recursively, you can always initialize
the submodules later, by running the following command:

```
    git submodule update --init --recursive
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
| Python (Optional) | 2.7.12 |

* **Windows:** Must use [Docker Toolbox](https://www.docker.com/products/docker-toolbox)
* **MacOS:** Must use [Docker Toolbox](https://www.docker.com/products/docker-toolbox)
* [Linux (Ubuntu) Setup Here](https://docs.docker.com/engine/installation/linux/ubuntu/)
  * Note: Does not come with Docker Compose.
    [Install from here.](https://docs.docker.com/compose/install/)

**Note: On Linux systems, sometimes it's necessary to add your user to the `docker` group.
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
will not work on Python 3).

### Setting up the Repository Files

**NOTE: If you use Docker Toolbox, then replace any mention of `localhost` with
        the IP address of your virtual machine**

1. Clone this repository recursively, as stated above.
   The directory this project will be downloaded to will be referred to
   as the Git Root.
3. Create a Data directory to host persistent files in any directory. If you use
    `setup.py`, the default directory will be the Git Root.
   * For whichever data directory you've chosen, four empty subdirectories have
      to be present within this directory:
      `profiles`, `libraries`, `themes`, `modules`.
4. Setup environment variables. There are two ways of doing this.
   You can do this manually, or with the assistance of `setup.py`.
   Detailed instructions on doing this manually will be listed below.
   * **Notes for passwords**:
      1. `PG_PASSWORD` can be set to anything
      2. `SMTP_PASSWORD` isn't used at all on local testing environments, so
          its value is entirely arbitrary. It is vestigial for a reason:
          allowing access to a production SMTP server on a testing
          environment is irresponsible.
5. In your Docker Command Line Interface, to the Docker service directory
   (found in ${GIT ROOT}/docker/vacation), run
    ```
    $ docker-compose up --build
    ```
    * Expect it to take a while on the first run,
      especially in virtualized environments (like Docker Toolbox)
7. In your web browser, navigate to `localhost` to see the site.

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

## Troubleshooting

* Does it fail to build?
  * Do you have permission to run Docker commands? Are you in the right user group?
  * Does `docker-compose` have permission to execute?
  * Run it through `setup.py` again, and double check all of your input.
* Does `setup.py` still not give you the right results?
  * This project was intended to run on a specific platform, so running the
    project in Linux will give you the best results.
  * Make sure you aren't missing the `profiles`, `libraries`, `themes`,
    and `modules` directories, and make sure that they are in the right location.
    These directories are not made automatically, because this is purely a matter
    of preference.
  * If all else fails, do the following to start back from scratch:
    * Bring the `docker-compose` service down, by running `$ docker-compose down`
      from the `(GIT_ROOT)/docker/vacation` subdirectory
    * Delete any docker volumes associated with the project:
      ```
      $ docker volume rm \
        vacation_dot_caddy \
        vacation_locks \
        vacation_pg_data \
        vacation_pg_logs \
        vacation_redis_data
      ```
    * Delete all of the contents from the `sites` subdirectory. Some of the
      files are made read-only, so `sudo` access might be required to
      properly delete the contents of `sites`. Be careful not to delete the
      `sites` subdirectory itself.
    * Rebuild, and re-run:
    ```
    $ docker-compose up --build
    ```
* Does the carousel not appear, and does Drupal's Status Report page complain
  about missing libraries?
  * This means that you didn't clone recursively. Please, refer to the material
    above to solve this issue.
* Nothing (or at least something else) is showing up under `http://localhost`
  * If you are running in Docker Toolbox, did you replace all mention of `localhost`
    with the IP address of your local virtual machine?
  * Make sure you don't have another service running on that port.
  * Stop that service, and re-run `$ docker-compose up --build`
