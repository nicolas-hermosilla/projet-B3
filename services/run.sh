#!/bin/sh

WORKDIR=$PWD
CMD=docker-compose
$CMD down --remove-orphans
$CMD --project-directory $WORKDIR \
 	up -d
