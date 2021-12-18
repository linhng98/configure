USER=$1
PASSWORD=`tr -dc A-Za-z0-9 </dev/urandom | head -c 32 ; echo ''`
CONNECTION="postgres://root:RandomStronkPassword@10.255.16.3:5432/postgres"

psql ${CONNECTION} -c "CREATE USER ${USER} WITH PASSWORD '${PASSWORD}';"
psql ${CONNECTION} -c "CREATE DATABASE ${USER};"
psql ${CONNECTION} -c "GRANT ALL PRIVILEGES ON DATABASE ${USER} TO ${USER};"

echo "postgres://${USER}:${PASSWORD}"
