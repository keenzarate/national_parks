CREATE TABLE nps_warehouse.raw.activities (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.alerts (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.amenities (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.campgrounds (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.events (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.feepassess (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.mapdata (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.parkinglots (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.places (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);
CREATE TABLE nps_warehouse.raw.parks (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.topics (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.thingstodo (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.roadevents (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.visitorcenters (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

CREATE TABLE nps_warehouse.raw.tours (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);

-- drop tables
DROP TABLE IF EXISTS nps_warehouse.raw.activities;
DROP TABLE IF EXISTS nps_warehouse.raw.alerts;
DROP TABLE IF EXISTS nps_warehouse.raw.amenities;
DROP TABLE IF EXISTS nps_warehouse.raw.campgrounds;
DROP TABLE IF EXISTS nps_warehouse.raw.events;
DROP TABLE IF EXISTS nps_warehouse.raw.feepassess;
DROP TABLE IF EXISTS nps_warehouse.raw.mapdata;
DROP TABLE IF EXISTS nps_warehouse.raw.parkinglots;
DROP TABLE IF EXISTS nps_warehouse.raw.places;
DROP TABLE IF EXISTS nps_warehouse.raw.parks;
DROP TABLE IF EXISTS nps_warehouse.raw.topics;
DROP TABLE IF EXISTS nps_warehouse.raw.thingstodo;
DROP TABLE IF EXISTS nps_warehouse.raw.roadevents;
DROP TABLE IF EXISTS nps_warehouse.raw.visitorcenters;
DROP TABLE IF EXISTS nps_warehouse.raw.tours;
