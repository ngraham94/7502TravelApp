\connect drupal

-- schemas
CREATE SCHEMA IF NOT EXISTS backend;
ALTER USER portaluser SET search_path TO backend,public;
GRANT ALL ON SCHEMA backend TO portaluser;
GRANT USAGE ON SCHEMA public TO portaluser;

-- tables
GRANT SELECT ON public.drupal_users TO portaluser;
GRANT SELECT ON public.drupal_users_field_data TO portaluser;
GRANT SELECT ON public.drupal_user__roles TO portaluser;
GRANT SELECT ON public.drupal_users_data TO portaluser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA backend TO portaluser;


-- client settings
SET default_transaction_read_only = off;
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

-- extensions

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- functions

CREATE OR REPLACE FUNCTION update_trips_time_close()
    RETURNS trigger AS
$$
BEGIN
    IF ((OLD.status = 'active' OR OLD.status = 'inactive')
        AND (NEW.status = 'sale' OR NEW.status = 'dud'))
    THEN
        UPDATE trips SET time_close = LOCALTIMESTAMP
            WHERE trip_uuid = OLD.trip_uuid;
    ELSIF ((OLD.status = 'sale' OR OLD.status = 'dud')
            AND (NEW.status = 'active' OR NEW.status = 'inactive'))
    THEN
        UPDATE trips SET time_close = NULL
            WHERE trip_uuid = OLD.trip_uuid;
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE
SECURITY DEFINER COST 1;

-- declarations

CREATE TYPE trip_status AS ENUM ('dud', 'inactive', 'active', 'sale');

CREATE TABLE "clients" (
	"client_uuid" UUID NOT NULL DEFAULT uuid_generate_v4(),
	"email" TEXT NOT NULL UNIQUE,
	"password" TEXT NOT NULL,
	"salt" char(20) NOT NULL UNIQUE,
	"first_name" TEXT NOT NULL,
	"last_name" TEXT NOT NULL,
	"preferred_name" TEXT NOT NULL,
	"time_creation" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP,
	"flag_reset_password" bool NOT NULL DEFAULT TRUE,
    "flag_deleted" bool NOT NULL DEFAULT FALSE,
	CONSTRAINT clients_pk PRIMARY KEY ("client_uuid")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "phone_numbers" (
	"client_uuid" UUID NOT NULL,
	"phone_number" TEXT NOT NULL,
	CONSTRAINT phone_numbers_pk PRIMARY KEY ("client_uuid","phone_number")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "addresses" (
	"client_uuid" UUID NOT NULL,
	"address_id" int2 NOT NULL,
	"data" TEXT NOT NULL,
	CONSTRAINT addresses_pk PRIMARY KEY ("client_uuid","address_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "cards" (
	"client_uuid" UUID NOT NULL,
	"card_id" int2 NOT NULL,
	"data" TEXT NOT NULL,
	CONSTRAINT cards_pk PRIMARY KEY ("client_uuid","card_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "trips" (
	"trip_uuid" UUID NOT NULL DEFAULT uuid_generate_v4(),
	"client_uuid" UUID NOT NULL,
    "title" character varying(40) NOT NULL,
	"assignee" TEXT,
	"status" trip_status NOT NULL DEFAULT 'active',
	"occasion" character varying(40) NOT NULL,
	"start_date" DATE NOT NULL DEFAULT CURRENT_DATE,
	"end_date" DATE NOT NULL DEFAULT CURRENT_DATE,
	"tentative_budget" character varying(30) NOT NULL,
	"travel_group" TEXT NOT NULL,
	"is_disney" bool NOT NULL DEFAULT FALSE,
	"time_start" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP,
	"time_edit" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP,
	"time_close" TIMESTAMP,
    "flag_deleted" bool NOT NULL DEFAULT FALSE,
	CONSTRAINT trips_pk PRIMARY KEY ("trip_uuid")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "destinations" (
	"trip_uuid" UUID NOT NULL,
	"destination" character varying(50) NOT NULL,
	CONSTRAINT destinations_pk PRIMARY KEY ("trip_uuid","destination")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "travellers" (
	"traveller_id" int2 NOT NULL,
	"trip_uuid" UUID NOT NULL,
	"first_name" TEXT NOT NULL,
	"last_name" TEXT NOT NULL,
	"preferred_name" TEXT NOT NULL,
	"birthday" character varying(10) NOT NULL,
	"notes" TEXT NOT NULL,
	CONSTRAINT travellers_pk PRIMARY KEY ("traveller_id","trip_uuid")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "client_event_log" (
	"client_uuid" UUID NOT NULL,
	"time_event" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP,
	"description" TEXT NOT NULL,
	"ip_addr" cidr NOT NULL,
	"success" bool NOT NULL DEFAULT FALSE,
	CONSTRAINT client_event_log_pk PRIMARY KEY ("client_uuid","time_event")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "surveys" (
	"survey_uuid" UUID NOT NULL DEFAULT uuid_generate_v4(),
	"survey_type_id" int2 NOT NULL,
	"trip_uuid" UUID NOT NULL,
    "external_shareable" bool NOT NULL DEFAULT FALSE,
	"time_completed" TIMESTAMP DEFAULT LOCALTIMESTAMP,
	"time_edited" TIMESTAMP DEFAULT LOCALTIMESTAMP,
	CONSTRAINT surveys_pk PRIMARY KEY ("survey_uuid")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "travel_preferences" (
	"trip_uuid" UUID NOT NULL,
	"preference_id" int2 NOT NULL,
	"order" int2 NOT NULL,
	"description" TEXT NOT NULL,
	CONSTRAINT travel_preferences_pk PRIMARY KEY ("trip_uuid","preference_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "survey_types" (
	"survey_type_id" int2 NOT NULL,
	"survey_type_name" character varying(40) NOT NULL UNIQUE,
	"survey_type_description" character varying(128),
	CONSTRAINT survey_types_pk PRIMARY KEY ("survey_type_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "survey_fields" (
	"survey_type_id" int2 NOT NULL,
	"survey_field_key" character varying(40) NOT NULL UNIQUE,
	"survey_field_title" character varying(40) NOT NULL,
	"survey_field_desc" character varying(128) NOT NULL,
	"survey_field_type" character varying(40) NOT NULL,
	"survey_field_reqd" bool NOT NULL DEFAULT TRUE,
	"survey_field_enabled" bool NOT NULL DEFAULT TRUE,
	CONSTRAINT survey_fields_pk PRIMARY KEY ("survey_type_id","survey_field_key")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "survey_results" (
	"survey_uuid" UUID NOT NULL,
	"survey_field_key" character varying(40) NOT NULL,
	"survey_field_value" TEXT,
	CONSTRAINT survey_results_pk PRIMARY KEY ("survey_uuid","survey_field_key")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "trip_notes" (
	"trip_uuid" UUID NOT NULL,
	"note_id" int2 NOT NULL,
	"note" TEXT NOT NULL,
	"author" TEXT NOT NULL,
	"client_visible" bool NOT NULL DEFAULT FALSE,
	"time_created" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP,
	"time_edited" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP,
	"order" int2 NOT NULL DEFAULT '1',
	CONSTRAINT trip_notes_pk PRIMARY KEY ("trip_uuid","note_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "client_notes" (
	"client_uuid" UUID NOT NULL,
	"note_id" int2 NOT NULL,
	"note" TEXT NOT NULL,
	"author" TEXT NOT NULL,
	"client_visible" bool NOT NULL DEFAULT FALSE,
	"time_created" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP,
	"time_edited" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP,
	"order" int2 NOT NULL DEFAULT '1',
	CONSTRAINT client_notes_pk PRIMARY KEY ("client_uuid","note_id")
) WITH (
  OIDS=FALSE
);


-- created separate for better debugging, each constraint is named
-- tables are declared first, and then constraints are added later, 
-- as 3NF+ makes extensive use of foreign keys, and foreign keys are
-- best added later to avoid confusing and inconsistent table declarations

ALTER TABLE "phone_numbers" ADD CONSTRAINT "phone_numbers_fk0"
    FOREIGN KEY ("client_uuid") REFERENCES "clients"("client_uuid");

ALTER TABLE "addresses" ADD CONSTRAINT "addresses_fk0"
    FOREIGN KEY ("client_uuid") REFERENCES "clients"("client_uuid");

ALTER TABLE "cards" ADD CONSTRAINT "cards_fk0"
    FOREIGN KEY ("client_uuid") REFERENCES "clients"("client_uuid");

ALTER TABLE "trips" ADD CONSTRAINT "trips_fk0"
    FOREIGN KEY ("client_uuid") REFERENCES "clients"("client_uuid");

ALTER TABLE "destinations" ADD CONSTRAINT "destinations_fk0"
    FOREIGN KEY ("trip_uuid") REFERENCES "trips"("trip_uuid");

ALTER TABLE "travellers" ADD CONSTRAINT "travellers_fk0"
    FOREIGN KEY ("trip_uuid") REFERENCES "trips"("trip_uuid");

ALTER TABLE "client_event_log" ADD CONSTRAINT "client_event_log_fk0"
    FOREIGN KEY ("client_uuid") REFERENCES "clients"("client_uuid");

ALTER TABLE "surveys" ADD CONSTRAINT "surveys_fk0"
    FOREIGN KEY ("survey_type_id") REFERENCES "survey_types"("survey_type_id");

ALTER TABLE "surveys" ADD CONSTRAINT "surveys_fk1"
    FOREIGN KEY ("trip_uuid") REFERENCES "trips"("trip_uuid");

ALTER TABLE "travel_preferences" ADD CONSTRAINT "travel_preferences_fk0"
    FOREIGN KEY ("trip_uuid") REFERENCES "trips"("trip_uuid");


ALTER TABLE "survey_fields" ADD CONSTRAINT "survey_fields_fk0"
    FOREIGN KEY ("survey_type_id") REFERENCES "survey_types"("survey_type_id");

ALTER TABLE "survey_results" ADD CONSTRAINT "survey_results_fk0"
    FOREIGN KEY ("survey_uuid") REFERENCES "surveys"("survey_uuid");

ALTER TABLE "survey_results" ADD CONSTRAINT "survey_results_fk1"
    FOREIGN KEY ("survey_field_key")
    REFERENCES "survey_fields"("survey_field_key");

ALTER TABLE "trip_notes" ADD CONSTRAINT "trip_notes_fk0"
    FOREIGN KEY ("trip_uuid") REFERENCES "trips"("trip_uuid");

ALTER TABLE "client_notes" ADD CONSTRAINT "client_notes_fk0"
    FOREIGN KEY ("client_uuid") REFERENCES "clients"("client_uuid");

-- views
CREATE VIEW employee_roles AS
	SELECT uid, uuid, roles_target_id
	FROM (drupal_users
    	INNER JOIN drupal_user__roles ON
           (drupal_users.uid = drupal_user__roles.entity_id));

CREATE VIEW employee_form_details AS
	SELECT uid, name, pass AS password, mail AS email, status
	FROM drupal_users_field_data;
	
CREATE VIEW employees AS
    SELECT name, password, email, uuid, roles_target_id AS role, status
    FROM employee_roles NATURAL INNER JOIN employee_form_details;

-- triggers

CREATE TRIGGER update_trips_time_close_on_status_change
    AFTER UPDATE ON trips FOR EACH ROW
    EXECUTE PROCEDURE update_trips_time_close();
