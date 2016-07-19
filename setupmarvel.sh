#!/bin/bash

# Install marvel-agent (and license) on all nodes in example cluster.
# This assumes that you have started the es-demo-cluster project via
# docker-compose.  You can get teh es-demo-cluster here:
# git@github.com:mcascallares/es-demo-cluster.git

# You need to run this script in that repository.

docker exec -it elasticsearch bin/plugin install license
docker exec -it elasticsearch bin/plugin install mobz/elasticsearch-head
echo y | docker exec -i elasticsearch bin/plugin install marvel-agent

for i in $(seq 1 3); do
  host=$(printf "master%.2d\n" $i)
  echo $host
  docker exec -it ${host} bin/plugin install license
  docker exec -it ${host} bin/plugin install mobz/elasticsearch-head
  echo y | docker exec -i ${host} bin/plugin install marvel-agent
  echo ${host} done
done

for i in $(seq 1 5); do
  host=$(printf "data%.2d\n" $i)
  echo ${host}
  docker exec -it ${host} bin/plugin install license
  docker exec -it ${host} bin/plugin install mobz/elasticsearch-head
  echo y | docker exec -i ${host} bin/plugin install marvel-agent
  echo ${host} done
done

# Install marvel on kibana
docker exec -it kibana /opt/kibana/bin/kibana plugin --install elasticsearch/marvel

docker-compose restart

