FROM postgres:9

LABEL author="Andrew Ray"
LABEL version="1.0.1"
LABEL description="Custom version of PostGreSQL that runs custom .SQL scripts"
LABEL vendor="Georgia Institute of Technology"

RUN mkdir /schemas
COPY schemas/drupal.sql /schemas/drupal.sql
COPY start.sh /docker-entrypoint-initdb.d/start.sh
RUN chmod +x /schemas/drupal.sql /docker-entrypoint-initdb.d/start.sh