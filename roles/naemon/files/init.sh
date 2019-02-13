#!/bin/bash

# undo init.bash symlinks temporarily

source /data_dirs.env

for datadir in "${DATA_DIRS[@]}"; do
  rm ${datadir}
  mv ${datadir}-template ${datadir}
done

# upgrade Naemon and Thruk to latest version

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get --purge autoremove -y naemon thruk
DEBIAN_FRONTEND=noninteractive apt-get install -y naemon

# rerun init.bash

for datadir in "${DATA_DIRS[@]}"; do
  mv ${datadir} ${datadir}-template
  ln -s /data/${datadir#/*} ${datadir}
done
