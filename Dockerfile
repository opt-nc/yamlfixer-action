# Container image that runs your code
FROM optnc/yamlfixer:0.6.9

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN apk update
RUN apk add git
RUN apk add curl
RUN apk add patch

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
