#select image base
FROM ubuntu:latest

ENV USER=mostapha
ENV PASSWORD=password
ENV WORKDIR=/app
ENV PORT=3000
ENV VOLUME=/webapp/logs
ENV ROOTPASSWORD=root

#changing password for root to root
#console logs for checking the current user
RUN echo "current user: $(whoami)"
#Set to root user
#this is redundant but it prevents some problems (the re-build of existing image)
USER root 
RUN echo "$ROOTPASSWORD\n$ROOTPASSWORD\n" | passwd "root"
RUN echo "User ID: $(whoami)" 

# installing dependencies and setting configs
RUN apt-get update
RUN apt-get -y install \
        sudo curl gnupg openssh-server net-tools \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get -y install nodejs \
    && npm i -g forever \
    && mkdir -p ~/.ssh \
    && chmod 700 ~/.ssh \
    && touch ~/.ssh/authorized_keys \
    && chmod 600 ~/.ssh/authorized_keys \
    && /etc/init.d/ssh start

#new user
#Add new user *only if it doesn't exist*
COPY ./addUser.sh /
RUN chmod +x /addUser.sh
RUN echo $(/addUser.sh $USER $PASSWORD)&& \
    mkdir $WORKDIR && \
    chown $USER $WORKDIR

# set user
USER $USER
# setting work dir
WORKDIR $WORKDIR

#RUN (echo "$ROOTPASSWORD\n" | sudo -S su) && chown $USER $WORKDIR && exit

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