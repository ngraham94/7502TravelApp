#!/bin/bash
touch /locks/db.lock
if [ ! -e /locks/initialized.status ]; then
    psql -f /schemas/drupal.sql postgres
    psql -U postgres -v ON_ERROR_STOP=1 -c \
        "ALTER USER $POSTGRES_USER WITH NOSUPERUSER \
        PASSWORD '$POSTGRES_PASSWORD';"
    psql -f /schemas/portaluser.sql drupal
    psql -U portaluser -f /schemas/portal.sql drupal
    psql -U postgres drupal -v ON_ERROR_STOP=1 -c \
        "ALTER USER portaluser WITH NOSUPERUSER;"
    dd if=/dev/urandom of=/schemas/drupal.sql bs=1M count=16
    dd if=/dev/urandom of=/schemas/portal.sql bs=1M count=2
    dd if=/dev/urandom of=/schemas/portaluser.sql bs=1M count=1
    rm -rf /schemas/*
fi;

rm /locks/db.lock
touch /locks/initialized.status
