#!/bin/sh
set -e

sh config.sh >/etc/pgpool.conf
exec pgpool -n -D -d
