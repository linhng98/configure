docker container rm -f $(docker container ls -aq)
docker image rm -f $(docker images -q)
docker volume rm -f $(docker volume ls -q)
