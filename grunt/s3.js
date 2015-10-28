module.exports = {
  options : {
    accessKeyId : '<%= accessKeyID %>',
    secretAccessKey : '<%= secretAccessKey %>',
    bucket : '<%= bucket %>'
  },
  brosephs : {
    options: {
      gzip: false
    },
    cwd: 'terraform/modules/bots/brosephs',
    src: ['terraform.tfvars'],
    dest: '.terraform/brosephs'
  },
  deutsch : {
    options: {
      gzip: false
    },
    cwd: 'terraform/modules/bots/deutsch',
    src: ['terraform.tfvars'],
    dest: '.terraform/deutsch'
  }
}