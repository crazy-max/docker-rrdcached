#!/bin/sh

# RRDcached config
echo "Creating RRDcached configuration..."
cat > /etc/rrdcached/rrdcached.conf <<EOL
LOG_LEVEL=${LOG_LEVEL:-LOG_INFO}
WRITE_TIMEOUT=${WRITE_TIMEOUT:-300}
WRITE_JITTER=${WRITE_JITTER:-0}
WRITE_THREADS=${WRITE_THREADS:-4}
FLUSH_DEAD_DATA_INTERVAL=${FLUSH_DEAD_DATA_INTERVAL:-3600}
EOL

exec "$@"
