#select image base
FROM ubuntu:latest

ENV USER=mostapha
ENV PASSWORD=password
ENV WORKDIR=/app
ENV PORT=3000
ENV VOLUME=/webapp/logs

#changing password for root to root
#console logs for checking the current user
RUN echo "current user: $(whoami)"
#Set to root user
#this is redundant but it prevents some problems (the re-build of existing image)
USER root 
RUN echo 'root:root' | chpasswd
RUN echo "User ID: $(whoami)" 

# installing dependencies and setting configs
RUN apt-get update
RUN apt-get -y install sudo
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get -y install nodejs
RUN apt-get -y install openssh-server
RUN npm i -g forever
RUN mkdir -p ~/.ssh
RUN chmod 700 ~/.ssh
RUN touch ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys
RUN /etc/init.d/ssh start

#new user
#Add new user *only if it doesn't exist*
COPY ./addUser.sh /
RUN chmod +x /addUser.sh
RUN echo $(/addUser.sh $USER $PASSWORD)

# set user
USER $USER
# setting work dir
WORKDIR $WORKDIR

RUN chown $USER $WORKDIR

COPY package.json .

#volume
VOLUME ["$VOLUME"]

RUN echo $PASSWORD | sudo -S npm install

# copying project files into container
COPY . .

# expose port
EXPOSE $PORT

# main entry app entrypoint
ENTRYPOINT [ "sudo", "npm" ]

# command run the service
CMD [ "start" ]