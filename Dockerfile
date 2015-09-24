FROM ubuntu

RUN apt-get update
RUN apt-get -y install expect redis-server nodejs npm
RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install -g coffee-script
RUN npm install -g yo generator-hubot

RUN useradd -d /hubot -m -s /bin/bash -U hubot
USER hubot
WORKDIR /hubot

RUN yo hubot --owner="mike.dyer@deutschinc.com" --name="dbot" --description="Donuts. Lots of donuts." --defaults

RUN npm install hubot-slack --save && npm install
RUN npm install hubot-standup-alarm --save && npm install
RUN npm install hubot-auth --save && npm install
RUN npm install hubot-youtube --save && npm install
RUN npm install hubot-s3-brain --save && npm install

ADD hubot/hubot-scripts.json /hubot/
ADD hubot/external-scripts.json /hubot/

CMD ["/bin/sh", "-c", "aws s3 cp s3://dla-dbot/env.sh .; . ./env.sh; bin/hubot --adapter slack"]