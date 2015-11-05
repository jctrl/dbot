var cwd = process.cwd();
var cluster = require('cluster');
var exec = require('child_process').exec;

var pull = function(callback) {
  exec('git pull origin master', function(err, stdout, stderr) {
    !err && callback();
  });
};

var start = function() {
  var pubnub = require('pubnub')({
    ssl: true,
    subscribe_key: process.env.PUBNUB_SUBSCRIBE
  });

  pubnub.subscribe({
    channel: 'update',
    callback: function(message) {
      pull(function() {
        process.exit(1);
      });
    }
  });

  exec('bin/hubot --adapter slack', function(err, stdout, stderr) {
    console.log(stdout);

    !!err && console.log(err);
  });
};

if (cluster.isMaster) {
  cluster.fork();

  cluster.on('exit', function(worker) {
    cluster.fork();
  });
}

!!cluster.isWorker && start();