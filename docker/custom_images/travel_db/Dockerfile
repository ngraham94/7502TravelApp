FROM postgres:9

LABEL author="Andrew Ray"
LABEL version="1.0.1"
LABEL description="Custom version of PostGreSQL that runs custom .SQL scripts"
LABEL vendor="Georgia Institute of Technology"

RUN mkdir /schemas
COPY schemas/drupal.sql /schemas/drupal.sql
COPY schemas/portal.sql /schemas/portal.sql
COPY schemas/portaluser.sql /schemas/portaluser.sql
COPY _start.sh /docker-entrypoint-initdb.d/_start.sh
RUN chmod +x /schemas/* /docker-entrypoint-initdb.d/_start.sh

RUN mkdir /locks
RUN chown -R root:root /locks
RUN touch /locks/db.lock
RUN chmod -R 1666 /locks
RUN chmod 777 /locks
VOLUME "/locks"