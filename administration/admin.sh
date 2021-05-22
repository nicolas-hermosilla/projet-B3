#!/bin/bash

WORKDIR=$PWD

docker-compose down --remove-orphans &&
docker-compose --project-directory $WORKDIR \
 	up -d
