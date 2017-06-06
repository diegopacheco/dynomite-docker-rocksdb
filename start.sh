#!/bin/bash

cd /ardb/src/
/ardb/src/ardb-server >> ardb.log &

mkdir /var/log/dynomite/
cd /dynomite-$DYNOMITE_VERSION/dynomite/
/dynomite-$DYNOMITE_VERSION/dynomite/src/dynomite --conf-file=/dynomite/conf/rocksdb_cluster_$DYNOMITE_NODE.yml -v11 -M 200000 -o /var/log/dynomite/dynomite_log.txt
