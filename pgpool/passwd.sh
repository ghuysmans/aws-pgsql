#!/bin/sh
set -e

aws s3 cp s3://$CONFIG/$APP_PROFILE/$1 config
eval `cat config` #beware, shell-incompatible substitutions aren't processed
pg_md5 -u $DB_USER --md5auth "$DB_PASSWORD"
