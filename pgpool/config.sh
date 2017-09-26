#!/bin/sh


#header
cat << EOF
#Auto-generated by pgpool/config.sh, do not modify
listen_addresses = '*'
port = 5432
pcp_port = 9898
pcp_socket_dir = '/tmp'
insert_lock = off
load_balance_mode = on
master_slave_mode = on
master_slave_sub_mode = 'stream'
allow_sql_comments = on

EOF


#gets a text value related to a particular RDS instance
#arguments: instance ID, path below the DBInstance
dbi() { #instance, query
	#we directly print the result since functions can't return anything
	aws rds describe-db-instances \
		--region eu-west-1 \
		--db-instance-identifier $1 \
		--output text \
		--query "DBInstances[0].$2"
}

(
	echo $APP_PROFILE; #the read/write server
	dbi $APP_PROFILE ReadReplicaDBInstanceIdentifiers
) | while read -r id; do #no indentation, otherwise `<< EOF` doesn't work
#for each server,
#first generate a sequence number
if [ -z "$i" ]; then
	i=0
	flags=,ALWAYS_MASTER
else
	i=$((i+1))
	flags=
fi
#then fetch its FQDN
server=`dbi $id Endpoint.Address`
#finally emit the configuration stanza
cat << EOF

backend_hostname$i = '$server'
backend_port$i = 5432
backend_weight$i = 1
backend_flag$i = 'ALLOW_TO_FAILOVER$flags'
EOF
done
