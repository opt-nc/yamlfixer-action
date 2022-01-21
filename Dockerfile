# Container image that runs your code
FROM yamlfixer:latest

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

RUN apk update
RUN apk add git
RUN apk add curl

# Répertoire contenant le source de l'application
VOLUME ./../app /app

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
