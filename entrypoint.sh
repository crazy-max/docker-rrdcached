#!/bin/sh

if [ -n "${PGID}" ] && [ "${PGID}" != "$(id -g rrdcached)" ]; then
  echo "Switching to PGID ${PGID}..."
  sed -i -e "s/^rrdcached:\([^:]*\):[0-9]*/rrdcached:\1:${PGID}/" /etc/group
  sed -i -e "s/^rrdcached:\([^:]*\):\([0-9]*\):[0-9]*/rrdcached:\1:\2:${PGID}/" /etc/passwd
fi
if [ -n "${PUID}" ] && [ "${PUID}" != "$(id -u rrdcached)" ]; then
  echo "Switching to PUID ${PUID}..."
  sed -i -e "s/^rrdcached:\([^:]*\):[0-9]*:\([0-9]*\)/rrdcached:\1:${PUID}:\2/" /etc/passwd
fi

echo "Creating configuration..."
cat > /etc/rrdcached/rrdcached.conf <<EOL
LOG_LEVEL=${LOG_LEVEL:-LOG_INFO}
WRITE_TIMEOUT=${WRITE_TIMEOUT:-300}
WRITE_JITTER=${WRITE_JITTER:-0}
WRITE_THREADS=${WRITE_THREADS:-4}
FLUSH_DEAD_DATA_INTERVAL=${FLUSH_DEAD_DATA_INTERVAL:-3600}
EOL

echo "Fixing perms..."
chown -R rrdcached:rrdcached /etc/rrdcached /var/run/rrdcached
chown rrdcached:rrdcached /data /data/db /data/journal

exec su-exec rrdcached:rrdcached "$@"
