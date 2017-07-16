-- user creation
CREATE ROLE portaluser PASSWORD 'md50ae14adc4a6f5495be892698907a730e';
ALTER ROLE portaluser WITH SUPERUSER NOINHERIT
    NOCREATEROLE NOCREATEDB LOGIN NOBYPASSRLS;

-- permissions
-- access to drupal db
GRANT CONNECT ON DATABASE drupal TO portaluser;