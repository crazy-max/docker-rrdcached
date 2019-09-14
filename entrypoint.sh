#!/bin/sh

TZ=${TZ:-UTC}

USER=rrdcached
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# Timezone
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# Change rrdcached UID / GID
echo "Checking if rrdcached UID / GID has changed..."
if [ -n "${PGID}" ] && [ "${PGID}" != "`id -g ${USER}`" ]; then
  sed -i -e "s/^${USER}:\([^:]*\):[0-9]*/${USER}:\1:${PGID}/" /etc/group
  sed -i -e "s/^${USER}:\([^:]*\):\([0-9]*\):[0-9]*/${USER}:\1:\2:${PGID}/" /etc/passwd
fi
if [ -n "${PUID}" ] && [ "${PUID}" != "`id -u ${USER}`" ]; then
  sed -i -e "s/^${USER}:\([^:]*\):[0-9]*:\([0-9]*\)/${USER}:\1:${PUID}:\2/" /etc/passwd
fi

# RRDcached init
echo "Initializing RRDcached..."
mkdir -p /data/db /data/journal
chown ${USER}. /data /data/db /data/journal

# RRDcached config
echo "Creating RRDcached configuration..."
cat > /etc/rrdcached.conf <<EOL
LOG_LEVEL=${LOG_LEVEL:-LOG_INFO}
WRITE_TIMEOUT=${WRITE_TIMEOUT:-300}
WRITE_JITTER=${WRITE_JITTER:-0}
WRITE_THREADS=${WRITE_THREADS:-4}
FLUSH_DEAD_DATA_INTERVAL=${FLUSH_DEAD_DATA_INTERVAL:-3600}
EOL

exec "$@"
