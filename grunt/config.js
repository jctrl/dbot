module.exports = function(grunt) {
  var cwd = process.cwd(),
      aws = grunt.file.readJSON(cwd + '/config/aws.json');

  grunt.registerTask('config', '', function() {
    grunt.log.writeln('TERRAFORM_AWS_ACCESS_KEY', aws.TERRAFORM_AWS_ACCESS_KEY);
    grunt.log.writeln('TERRAFORM_AWS_SECRET_KEY', aws.TERRAFORM_AWS_SECRET_KEY);

    grunt.config.set('accessKeyID', aws.TERRAFORM_AWS_ACCESS_KEY);
    grunt.config.set('secretAccessKey', aws.TERRAFORM_AWS_SECRET_KEY);
    grunt.config.set('bucket', 'dla-dbot');
  });
};