#!/bin/sh
set -e

sh config.sh >/etc/pgpool.conf
sh passwd.sh
exec pgpool -n -D
