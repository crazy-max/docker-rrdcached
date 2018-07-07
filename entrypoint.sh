#!/bin/sh

TZ=${TZ:-"UTC"}
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# Timezone
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# Change rtorrent UID / GID
echo "Checking if rrdcached UID / GID has changed..."
if [ $(id -u rrdcached) != ${PUID} ]; then
  usermod -u ${PUID} rrdcached
fi
if [ $(id -g rrdcached) != ${PGID} ]; then
  groupmod -g ${PGID} rrdcached
fi

# Init files and folders
echo "Initializing LibreNMS files / folders..."
mkdir -p /data/db /data/journal

# RRDcached config
echo "Creating RRDcached configuration..."
cat > /etc/rrdcached.conf <<EOL
LOG_LEVEL=${LOG_LEVEL:-"LOG_INFO"}
WRITE_TIMEOUT=${WRITE_TIMEOUT:-"300"}
WRITE_JITTER=${WRITE_JITTER:-"0"}
WRITE_THREADS=${WRITE_THREADS:-"4"}
FLUSH_DEAD_DATA_INTERVAL=${FLUSH_DEAD_DATA_INTERVAL:-"3600"}
EOL

# Fix perms
echo "Fixing permissions..."
chown -R rrdcached. /data

exec "$@"
