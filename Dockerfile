# Container image that runs your code
FROM python:3.11.0a3-alpine

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY yamlfixer /yamlfixer
COPY requirements.txt /requirements.txt

RUN chmod +x entrypoint.sh
RUN chmod +x yamlfixer

RUN pip install -r requirements.txt
RUN apk update
RUN apk add git
RUN apk add curl
RUN apk sed

# Répertoire contenant le source de l'application
VOLUME ./../app /app

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
