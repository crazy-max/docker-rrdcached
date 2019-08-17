#!/bin/sh

TZ=${TZ:-UTC}

# Timezone
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# RRDcached init
echo "Initializing RRDcached..."
mkdir -p /data/db /data/journal
chown rrdcached. /data /data/db /data/journal

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
