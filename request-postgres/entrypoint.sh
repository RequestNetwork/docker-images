#!/bin/bash

echo_italic() {
    echo -e "\e[3m${1}\e[0m"
}

env_check() {
    local envs=(
        PG_USER
        PG_PASS
        PG_HOST
        PG_PORT
        DOCKER_USER
        DOCKER_PASS
        DOCKER_DB
    )
    for env in "${envs[@]}"; do
        [[ -n ${!env} ]] || error "Empty $env ENV!"
    done
}


error() {
    echo "$1"
    exit 1
}

sql_db_exists() {
    local db=$1
    [[ $(sql_exists pg_database datname "$db") -eq 1 ]] && echo 1
}

sql_database() {
    local db=$1
    local user=$2
    [[ $(sql_db_exists "$db") -eq 1 ]] || {
        sql_query "CREATE DATABASE ${db}"
        sql_query "GRANT ALL PRIVILEGES ON DATABASE ${db} TO ${user}"
    }
}

sql_drop() {
    local db=$1
    [[ $(sql_db_exists "$db") ]] && {
        echo "dropdb: $1..."
        dropdb \
            -U "$PG_USER" \
            -h "$PG_HOST" \
            -p "$PG_PORT" \
            "$db"

        }
}

sql_exists() {
    local db=$1
    local col=$2
    local val=$3
    sql_query "SELECT 1 FROM ${db} WHERE ${col}='${val}'" | tail -n +4 | grep -q 1 && echo 1
}

sql_query() {
    local query=$1
    local db="postgres"
    echo -n "Running SQL: "
    echo_italic "$query"
    psql \
        -q \
        -U "$PG_USER" \
        -h "$PG_HOST" \
        -p "$PG_PORT" \
        -d $db \
        -c "$query"
}

sql_user() {
    local user=$1
    [[ $(sql_exists pg_roles rolname "$user") -eq 1 ]] || sql_query "CREATE USER $user"
}

complete() {
    
}

# main
echo "psql: $(psql --version)"
echo "connection: postgres://${PG_USER}:<PG_PASS>@${PG_HOST}:${PG_PORT}/postgres"

export PGPASSWORD=$PG_PASS

if [[ $PG_DROP -eq 1 ]]; then
    sql_drop "$DOCKER_DB"
    exit
else
    sql_user "$DOCKER_USER" \
        && sql_database "$DOCKER_DB" "$DOCKER_USER"
fi
