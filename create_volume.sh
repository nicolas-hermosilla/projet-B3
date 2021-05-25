#!/bin/bash

cmd='docker volume create'

$cmd grafana-storage
$cmd prometheus_data
$cmd registry_data
$cmd portainer_data
$cmd jenkins_data

cp prometheus/prometheus.yml /var/lib/docker/volumes/prometheus_data/_data/
