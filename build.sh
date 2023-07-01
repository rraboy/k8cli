#!/bin/bash

version=`date +%Y%m%d%H`
docker build --pull -t rraboy/k8cli:latest -t rraboy/k8cli:$version --progress plain .
