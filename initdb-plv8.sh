#!/bin/sh
set -e

#Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

#update $POSTGRES_DB and template1 to enable plv8 as default module in new databases
for DB in template1 "$POSTGRES_DB"; do
	echo "Loading plv8 into $DB"
	"${psql[@]}" --dbname="$DB" <<-'EOSQL'
		CREATE EXTENSION IF NOT EXISTS plv8;
	EOSQL
done
