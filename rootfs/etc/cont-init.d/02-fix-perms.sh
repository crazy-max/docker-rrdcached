#!/usr/bin/with-contenv sh
echo "Fixing perms..."
mkdir -p /data/db /data/journal /var/run/rrdcached
chown ${PUID:-1000}:${PGID:-1000} /data/db /data/journal
chown -R ${PUID:-1000}:${PGID:-1000} /var/run/rrdcached
