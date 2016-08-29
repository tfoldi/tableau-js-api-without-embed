gulp          = require 'gulp'
parameters    = require '../config/parameters.coffee'

coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
gutil   = require 'gulp-util'
serve  = require 'gulp-serve'


gulp.task 'coffee', ->
  gulp.src parameters.app_path+'/**/*.coffee'
  .pipe coffee bare: true
  .pipe concat parameters.app_main_file
  .pipe gulp.dest parameters.web_path+'/js'
  .on 'error', gutil.log

gulp.task 'watch',
[],
->
  gulp.watch parameters.app_path + '/**/*.coffee', ['coffee' ]
  gulp.watch parameters.assets_path, ['assets']
  gulp.watch 'bower.json', ['vendors']

gulp.task 'serve', ['coffee'], serve parameters.web_path

