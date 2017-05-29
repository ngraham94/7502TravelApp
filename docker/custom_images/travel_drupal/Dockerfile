FROM drupal:8.3.2-apache

LABEL author="Andrew Ray"
LABEL version="1.0.0"
LABEL php_version="7.1"
LABEL description="version for Drupal 8 with uploadprogress PHP module"
LABEL vendor="Georgia Institute of Technology"

ENV APT_REQS git
ENV REPO https://github.com/Jan-E/uploadprogress
ENV REPO_DIR uploadprogress
ENV LISTS /var/lib/apt/lists/*

# Install Git
RUN apt-get update \
    && apt-get install -y \
       --no-install-recommends $APT_REQS

# Get `uploadprogress` library (PHP 7)
RUN mkdir /builds \
    && cd /builds \
    && git clone $REPO $REPO_DIR \
    && cd $REPO_DIR \
    && phpize \
    && ./configure \
    && make\
    && make install \
    && docker-php-ext-enable uploadprogress

# Clean Up Installation
RUN rm -rf /builds \
    && apt-get remove --purge -y git \
    && apt-get autoremove -y \
    && rm -rf $LISTS