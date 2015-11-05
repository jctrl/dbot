FROM ubuntu

RUN apt-get update
RUN apt-get -y install expect redis-server nodejs npm python-pip git
RUN pip install awscli
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install -g coffee-script yo generator-hubot grunt-cli

ADD id_rsa ./tmp/
RUN echo "IdentityFile ./tmp/id_rsa" >> /etc/ssh/ssh_config

RUN useradd -d /hubot -m -s /bin/bash -U hubot

ADD server.js /hubot
USER hubot
WORKDIR /hubot

RUN yo hubot --owner="listenrightmeow <mdyer@n9nemedia.net>" --name="dbot" --description="Meow." --defaults

RUN npm install pubnub
RUN npm install hubot-slack --save && npm install
RUN npm install hubot-s3-brain --save && npm install
RUN npm install hubot-auth --save && npm install
RUN npm install hubot-standup-alarm --save && npm install
RUN npm install hubot-youtube --save && npm install
RUN npm install hubot-business-cat --save && npm install
RUN npm install hubot-voting --save && npm install

ADD hubot/hubot-scripts.json /hubot/
ADD hubot/external-scripts.json /hubot/