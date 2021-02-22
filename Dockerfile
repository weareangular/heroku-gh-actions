FROM node:15.8.0-alpine3.10

# Update distro
RUN apk update && apk upgrade && apk add bash curl

RUN curl https://cli-assets.heroku.com/install.sh | sh

# Set the timezone in docker
RUN apk --update add tzdata && cp /usr/share/zoneinfo/America/Bogota /etc/localtime && echo "America/Bogota" > /etc/timezone && apk del tzdata

# Switch Work Directory
WORKDIR /opt/heroku-gh-actions

# Copy files
COPY . .

# Start
ENTRYPOINT ["/bin/bash", "/opt/heroku-gh-actions/entrypoint.sh"]
CMD ["--h"]
