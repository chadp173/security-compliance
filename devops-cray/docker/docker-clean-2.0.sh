#!/bin/sh -e

echo "clean up on ..."
docker rm -f $(docker ps -aq)
docker container rm -f $(docker ps -aq)
docker image rm $(docker image ls -f dangling=true -q)
docker image rm $(docker image ls -q)
docker volume rm $(docker volume ls -q)

echo "pruning all"
docker image prune
docker volume prune
docker builder prune
docker system prune
docker system df

# # Remove all containers
# docker stop $(docker ps -aq)
# docker rm $(docker ps -aq)
# docker rmi -f $(docker images -a -q)
# docker volume rm $(docker volume ls -qf dangling=true)
# docker volume rm $(docker volume ls -q) # volumes
# docker system df
#
# # Fail safe if simple commands fail.
# # Delete all stopped containers (including data-only containers).
# # docker images ps -aq --no-trunc --filter=reference="status=exited" | xargs --no-run-if-empty docker rm
#
# # Delete all tagged images more than a month old # (will fail to remove images still used).
# # docker images --no-trunc --format '{{.ID}} {{.CreatedSince}}' | grep ' months' | awk '{ print $1 }' | xargs --no-run-if-empty docker rmi || true
#
# # Delete all 'untagged/dangling' (<none>) images
# # Those are used for Docker caching mechanism.
# # docker images -q --no-trunc --filter dangling=true | xargs --no-run-if-empty docker rmi
#
# # Delete all dangling volumes.
# # docker volume ls -qf dangling=true | xargs --no-run-if-empty docker volume rm
