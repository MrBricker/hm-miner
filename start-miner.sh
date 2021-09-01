#!/bin/sh

if [ "$(df -h /var/data/ | tail -1 | awk '{print $5}' | tr -d '%')" -ge 80 ]; then
  rm -rf /var/data/* 
fi

wget \
    -O /opt/miner/releases/2021.08.31.1_GA/sys.config \
    "${OVERRIDE_CONFIG_URL:=https://helium-assets.nebra.com/docker.config}"

if ! PUBLIC_KEYS=$(/opt/miner/bin/miner print_keys)
then
  exit 1
else
  echo "$PUBLIC_KEYS" > /var/data/public_keys
fi

/opt/miner/gen-region.sh &

/opt/miner/bin/miner foreground
