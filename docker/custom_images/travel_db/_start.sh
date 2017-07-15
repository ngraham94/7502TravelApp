#!/bin/bash
touch /locks/db.lock
if [ ! -e /locks/initialized.status ]; then
    psql -f /schemas/drupal.sql postgres
    pass="PASSWORD '$POSTGRES_PASSWORD'"
    psql -U postgres -v ON_ERROR_STOP=1 -c \
        "ALTER USER $POSTGRES_USER WITH NOSUPERUSER $pass;"
    unset pass
    psql -f /schemas/portaluser.sql drupal
    psql -U portaluser -f /schemas/portal.sql drupal
    psql -U postgres -v ON_ERROR_STOP=1 -c \
        "ALTER ROLE portaluser WITH NOSUPERUSER;"
fi;

rm /locks/db.lock
touch /locks/initialized.status