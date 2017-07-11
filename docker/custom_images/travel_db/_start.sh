#!/bin/bash
psql -f /schemas/drupal.sql postgres
psql -f /schemas/portaluser.sql drupal
psql -U portaluser -f /schemas/portal.sql drupal
psql -U postgres -v ON_ERROR_STOP=1 <<-EOSQL
    ALTER ROLE portaluser WITH NOSUPERUSER;
EOSQL