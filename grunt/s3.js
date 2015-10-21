module.exports = {
  options : {
    accessKeyId : '<%= accessKeyID %>',
    secretAccessKey : '<%= secretAccessKey %>',
    bucket : '<%= bucket %>'
  },
  keys : {
    options: {
      gzip: false
    },
    cwd: 'aws',
    src: ['terraform.tfvars'],
    dest: '.terraform/'
  }
}