FROM debian:12-slim

# shell
SHELL ["/bin/bash", "-c"]

# build-start
WORKDIR /tmp

# install build dependencies
COPY .resources/apt.txt .

RUN apt-get update >/dev/null \
    && apt-get install -y --no-install-recommends `cat apt.txt | tr "\n" " "` &>/dev/null \
    && apt-get clean

# download resources
COPY .resources/wget.txt .

RUN wget -i wget.txt

# install node
RUN tar xf node-*.gz \
    && cd `ls -d */ | grep node` \
    && for d in `ls -d */`; do cp -R $d /usr/local; done

# install yarn
RUN npm i -g yarn

# build web app
ARG WORK_DIR=/opt
ARG APP_NAME=web-app

WORKDIR ${WORK_DIR}

COPY ${APP_NAME}/ ./${APP_NAME}

RUN cd ${APP_NAME} \
    && npm i \
    && npm run build

COPY *.sh .

RUN chmod +x *.sh

ENTRYPOINT [ "./entrypoint.sh" ]
# run web app
#ENTRYPOINT [ "bash", "-c", "node */build" ]
