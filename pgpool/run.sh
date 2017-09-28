#!/bin/sh
set -e

sh config.sh >/etc/pgpool.conf
sh passwd.sh variables
sh passwd.sh variables.old 2>/dev/null || true
exec pgpool -n -D
