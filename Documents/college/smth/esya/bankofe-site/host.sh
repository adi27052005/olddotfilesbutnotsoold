#!/bin/bash

docker build . -t start-site
docker run -it -d -p 80:80 start-site:latest
