docker container rm -f $(docker container ls -aq)
docker volume rm -f $(docker volume ls -q)
docker image rm -f $(docker images -q)
docker system prune -f
