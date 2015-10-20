FROM ubuntu

RUN apt-get update
RUN apt-get -y install expect redis-server nodejs npm python-pip
RUN pip install awscli
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install -g hubot coffee-script yo generator-hubot

RUN useradd -d /hubot -m -s /bin/bash -U hubot
USER hubot
WORKDIR /hubot

RUN yo hubot --owner="mike.dyer@deutschinc.com" --name="dbot" --description="Donuts. Lots of donuts." --defaults

RUN npm install hubot-slack --save && npm install
RUN npm install hubot-s3-brain --save && npm install
RUN npm install hubot-auth --save && npm install
RUN npm install hubot-standup-alarm --save && npm install
RUN npm install hubot-youtube --save && npm install
RUN npm install hubot-business-cat --save

ADD hubot/hubot-scripts.json /hubot/
ADD hubot/external-scripts.json /hubot/

CMD ["/bin/sh", "-c", "bin/hubot --adapter slack"]