FROM debian:12-slim

# install dependencies
WORKDIR /tmp

COPY .resources/apt.txt .

RUN apt-get update >/dev/null \
    && apt-get install -y --no-install-recommends `cat apt.txt | tr "\n" " "` \
    #&>/dev/null && \
    && apt-get clean

# runtime envs
ENV DOCKER_USER=docker
ENV DOCKER_PASS=let-me-in
ENV DOCKER_DB=sepolia

ENV PG_USER=postgres
ENV PG_PASS=1234

ENV PG_HOST=172.17.0.2
ENV PG_PORT=5432

ENV PG_DROP=1

ENV KEEP_ALIVE=0

# install runtime script
WORKDIR /opt/app

COPY *.sh .

RUN chmod +x *.sh

# start
ENTRYPOINT [ "./entrypoint.sh" ]
