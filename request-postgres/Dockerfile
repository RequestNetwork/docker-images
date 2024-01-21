FROM postgres:alpine

ENV DOCKER_USER=docker
ENV DOCKER_PASS=let-me-in
ENV DOCKER_DB=sepolia

ENV POSTGRES_USER=
ENV POSTGRES_PASSWORD=

ARG INIT_DIR="/docker-entrypoint-initdb.d/"

COPY init.sh ${INIT_DIR}/init.sh
RUN chmod +x ${INIT_DIR}/*.sh
