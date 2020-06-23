#!bin/bash

docker stop $(docker ps -a -q)

docker rmi -f $(docker images -a -q)

docker rm -f $(docker ps -a -q)

docker rmi -f $(docker images -a -q)

docker rm -f $(docker ps -a -q)

docker ps -a && docker images

docker build -t ft_server .

docker run -d -p 80:80 -p 443:443 ft_server
