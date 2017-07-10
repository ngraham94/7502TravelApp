FROM postgres:9

LABEL author="Andrew Ray"
LABEL version="1.0.1"
LABEL description="Custom version of PostGreSQL that runs custom .SQL scripts"
LABEL vendor="Georgia Institute of Technology"

COPY schemas/drupal.sql /docker-entrypoint-initdb.d/drupal.sql
RUN chmod +x /docker-entrypoint-initdb.d/drupal.sql