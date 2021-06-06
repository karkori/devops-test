#select image base
FROM node:16-alpine3.11

ENV USER=myuser
ENV GROUP=mygroup
ENV UID=1001
ENV GID=1001
ENV WORKDIR=/home/$USER/app
ENV AUTHOR_EMAIL="femtonet.email@gmail.com"
ENV AUTHOR_NAME="Mostapha Bourarach"
ENV PORT=3000
ENV VOLUME=/myvol/logs

LABEL author.name=$AUTHOR_NAME \
      author.email=$AUTHOR

# user: create a group and add a new user to this group
RUN addgroup -g $UID -S $GROUP
RUN adduser -u $GID -S $USER -G $GROUP

# update npm to fix error
RUN npm install -g npm@7.16.0

# set user
USER $USER

# setting work dir
RUN mkdir -p $WORKDIR
WORKDIR $WORKDIR
RUN mkdir /home/$USER/app/logs && touch access.log


COPY package.json .

#volume
VOLUME ["$VOLUME"]

RUN npm install

# copying project files into container
COPY . .

# expose port
EXPOSE $PORT

# main entry app entrypoint
CMD ["npm", "start"]

# command run the service in production with monitoring
