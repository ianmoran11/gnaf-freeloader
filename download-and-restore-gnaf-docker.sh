#!/bin/bash

sudo docker exec 8a317e048258 /bin/sh -c 'touch .pgpass'
sudo docker exec 8a317e048258 /bin/sh -c 'echo "localhost:5432:gis:docker:docker" >> .pgpass'
sudo docker exec 8a317e048258 /bin/sh -c 'chmod 600 .pgpass'

sudo docker exec 8a317e048258 /bin/sh -c 'touch .pgpassgeo' 
sudo docker exec 8a317e048258 /bin/sh -c 'echo "localhost:5432:geo:docker:docker" >> .pgpassgeo'
sudo docker exec 8a317e048258 /bin/sh -c 'chmod 600 .pgpassgeo'


sudo docker exec 8a317e048258 /bin/sh -c 'PGPASSFILE=.pgpass psql -h localhost -U docker -d gis -c "CREATE DATABASE geo;"'

sudo docker exec 8a317e048258 /bin/sh -c 'PGPASSFILE=.pgpassgeo psql -U docker -p 5432 -h localhost -d geo -c "CREATE EXTENSION IF NOT EXISTS postgis;"'

sudo docker exec 8a317e048258 /bin/sh -c 'wget http://minus34.com/opendata/psma-201905/admin-bdys-201905.dmp'
sudo docker exec 8a317e048258 /bin/sh -c 'wget http://minus34.com/opendata/psma-201905/gnaf-201905.dmp'


sudo docker exec 8a317e048258 /bin/sh -c 'PGPASSFILE=.pgpassgeo pg_restore -Fc -d geo -p 5432 -h localhost -U docker  gnaf-201905.dmp'
sudo docker exec 8a317e048258 /bin/sh -c 'PGPASSFILE=.pgpassgeo pg_restore -Fc -d geo -p 5432 -h localhost -U docker  admin-bdys-201905.dmp'


