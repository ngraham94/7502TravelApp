#!/bin/bash
touch /locks/db.lock
if [ ! -e /locks/initialized.status ]; then
    psql -f /schemas/drupal.sql postgres
    psql -f /schemas/portaluser.sql drupal
    psql -U portaluser -f /schemas/portal.sql drupal
    psql -U postgres -v ON_ERROR_STOP=1 -c \
        "ALTER ROLE portaluser WITH NOSUPERUSER;"
fi;

rm /locks/db.lock
touch /locks/initialized.status