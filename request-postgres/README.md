# Request Postgres

## Description
This image provides a means to provision (or remove) a database in a postgres instance via a container job

## Configuration

database
```bash
ENV DB_USER=            # set the user name 
ENV DB_PASS=            # set the user password
ENV DB_ROLE=            # set the user role
ENV DB_NAME=            # set the database name
ENV DB_DROP=            # options=0 or 1 (where 1 drops the database and quits)
```
postgres instance
```bash
ENV PG_USER=postgres    # set the postgres master username    
ENV PG_PASS=            # set the postgres password
ENV PG_HOST=            # set the postgres instance host
ENV PG_PORT=5432        # set the postgres instance port
```

```bash
ENV KEEP_ALIVE=         # options=0 or 1 (where 1 keeps the container alive)
```
