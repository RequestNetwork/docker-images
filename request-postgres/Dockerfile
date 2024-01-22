FROM debian:12-slim

# install dependencies
WORKDIR /tmp

COPY .resources/apt.txt .

RUN apt-get update >/dev/null \
    && apt-get install -y --no-install-recommends `cat apt.txt | tr "\n" " "` \
    #&>/dev/null && \
    && apt-get clean

# runtime envs
ENV DB_USER=
ENV DB_PASS=
ENV DB_ROLE=
ENV DB_NAME=
ENV DB_ENCODING=UTF8
ENV DB_LOCALE=C

ENV PG_USER=postgres
ENV PG_PASS=
ENV PG_HOST=
ENV PG_PORT=5432
ENV PG_DROP=

ENV KEEP_ALIVE=

# install runtime script
WORKDIR /opt/app

COPY *.sh .

RUN chmod +x *.sh

# start
ENTRYPOINT [ "./entrypoint.sh" ]
