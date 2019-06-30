#!/bin/bash


if [ -f './admin-bdys-201905.dmp' ]; then
   echo "./admin-bdys-201905.dmp exists."
else
   echo "./admin-bdys-201905.dmp does not exist. Downloading......"
   sudo wget http://minus34.com/opendata/psma-201905/admin-bdys-201905.dmp

fi


if [ -f './gnaf-201905.dmp' ]; then
   echo "./gnaf-201905.dmp exists."
else
   echo "./gnaf-201905.dmp does not exist. Downloading......"
   sudo wget http://minus34.com/opendata/psma-201905/gnaf-201905.dmp
fi


sudo docker volume create gnaf_data
sudo docker run -it -d --name=gnaf_postgis -p 5433:5432 -v gnaf_data:/var/lib/postgresql  kartoza/postgis

sudo docker cp gnaf-201905.dmp gnaf_postgis:/gnaf-201905.dmp
sudo docker cp admin-bdys-201905.dmp gnaf_postgis:/admin-bdys-201905.dmp

sudo docker exec gnaf_postgis /bin/sh -c 'touch .pgpass'
sudo docker exec gnaf_postgis /bin/sh -c 'echo "localhost:5432:gis:docker:docker" >> .pgpass'
sudo docker exec gnaf_postgis /bin/sh -c 'chmod 600 .pgpass'

sudo docker exec gnaf_postgis /bin/sh -c 'touch .pgpassgeo' 
sudo docker exec gnaf_postgis /bin/sh -c 'echo "localhost:5432:geo:docker:docker" >> .pgpassgeo'
sudo docker exec gnaf_postgis /bin/sh -c 'chmod 600 .pgpassgeo'

sudo docker exec gnaf_postgis /bin/sh -c 'PGPASSFILE=.pgpass psql -h localhost -U docker -d gis -c "CREATE DATABASE geo;"'
sudo docker exec gnaf_postgis /bin/sh -c 'PGPASSFILE=.pgpassgeo psql -U docker -p 5432 -h localhost -d geo -c "CREATE EXTENSION IF NOT EXISTS postgis;"'

sudo docker exec gnaf_postgis /bin/sh -c 'wget http://minus34.com/opendata/psma-201905/admin-bdys-201905.dmp'
sudo docker exec gnaf_postgis /bin/sh -c 'wget http://minus34.com/opendata/psma-201905/gnaf-201905.dmp'

sudo docker exec gnaf_postgis /bin/sh -c 'PGPASSFILE=.pgpassgeo pg_restore -Fc -d geo -p 5432 -h localhost -U docker  gnaf-201905.dmp'
sudo docker exec gnaf_postgis /bin/sh -c 'PGPASSFILE=.pgpassgeo pg_restore -Fc -d geo -p 5432 -h localhost -U docker  admin-bdys-201905.dmp'


