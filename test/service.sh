#!/bin/sh
set -eu

s6-svwait -u -t 30000 /run/service/rrdcached

test "$(s6-svstat -o up,wantedup /run/service/rrdcached)" = "true true"
pid=$(s6-svstat -o pid /run/service/rrdcached)
grep -Eq "^Uid:[[:space:]]+${PUID}[[:space:]]" "/proc/${pid}/status"
grep -Eq "^Gid:[[:space:]]+${PGID}[[:space:]]" "/proc/${pid}/status"
printf 'PING\nQUIT\n' | nc -w 5 127.0.0.1 42217 | grep PONG
