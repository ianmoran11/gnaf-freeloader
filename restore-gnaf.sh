#!/bin/bash

cd /home

touch .pgpass
echo "localhost:5432:gis:docker:docker" >> .pgpass
chmod 600 .pgpass

touch .pgpassgeo 
echo "localhost:5432:geo:docker:docker" >> .pgpassgeo
chmod 600 .pgpassgeo


PGPASSFILE=.pgpass psql -h localhost -U docker -d gis -c "CREATE DATABASE geo;"

PGPASSFILE=.pgpassgeo psql -U docker -p 5432 -h localhost -d geo -c "CREATE EXTENSION IF NOT EXISTS postgis;"


PGPASSFILE=.pgpassgeo pg_restore -Fc -d geo -p 5432 -h localhost -U docker  gnaf-201905.dmp
PGPASSFILE=.pgpassgeo pg_restore -Fc -d geo -p 5432 -h localhost -U docker  admin-bdys-201905.dmp


