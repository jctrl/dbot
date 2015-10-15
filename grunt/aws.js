module.exports = function(grunt) {
  var cwd = process.cwd(),
      config = grunt.file.readJSON(cwd + '/config/aws.json');

  return {
    accessKeyID : config.TERRAFORM_AWS_ACCESS_KEY,
    secretAccessKey : config.TERRAFORM_AWS_SECRET_KEY
  }
}