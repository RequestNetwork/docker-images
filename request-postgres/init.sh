#!/bin/bash

italic() {
    echo -e "\e[3m${1}\e[0m"
}

sql() {
    local query=$1
    echo -n "Running SQL: "
    italic "$query"
    psql \
        -q \
        -U "$POSTGRES_USER" \
        -c "$query"
}

exists() {
    local db=$1
    local col=$2
    local val=$3
    sql "SELECT 1 FROM ${db} WHERE ${col}='${val}'" | tail -n +4 | grep -q 1 && echo 1
}

user() {
    local user=$1
    echo
    echo "User, name: ${user}..."
    [[ $(exists pg_roles rolname "$user") -eq 1 ]] || sql "CREATE USER $user"
}

database() {
    local db=$1
    local user=$2
    echo
    echo "Database, name: ${db}, user: ${user}..."
    [[ $(exists pg_database datname "$db") -eq 1 ]] || {
        sql "CREATE DATABASE ${db}"
        sql "GRANT ALL PRIVILEGES ON DATABASE ${db} TO ${user}"
    }
}

# main
user "$DOCKER_USER" \
    && database "$DOCKER_DB" "$DOCKER_USER"
