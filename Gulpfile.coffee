###
# Initialize gulp.
#
# Tasks in this file should be placed in ALPHABETICAL ORDER. Special tasks should
# be placed at the top of the tasks list. All watch tasks should be placed after
# the other tasks.
###
gulp = require 'gulp';

###
# Initialize all required gulp plugins
#
# Only searches the package.json's devDependencies scope for plugins that match
# the patterns in the config below. Any matching plugins are stored within the
# plugins object.
###
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
gutil = require 'gulp-util'

###
# Default task. Runs production environment task.
###
gulp.task 'default', [
  'env:production'
]

###
# Environment: dev.
###
gulp.task 'env:dev', [
  'coffee'
  'copy'
]

###
# Environment: production.
###
gulp.task 'env:production', [
  'coffee'
  'copy'
]

###
# Coffee-script to Javascript compiler.
#
# Compiles *.coffee files into the dist directory.
###
gulp.task 'coffee', ->
  gulp.src 'src/**/*.coffee'
    .pipe(coffee(bare: true).on 'error', gutil.log)
    .pipe gulp.dest('dist')

###
# Move static files (images, config...) to dist directory.
###
gulp.task 'copy', ->
  gulp.src [
      'src/**/*.*'
      '!src/**/*.coffee'
    ]
    .pipe gulp.dest('dist')

###
# Lint files for errors.
###
gulp.task 'lint', ->
  gulp.src 'src/**/*.coffee'
    .pipe coffeelint()
    .pipe coffeelint.reporter(require 'coffeelint-stylish')

###
# Watch for changes and execute specific tasks.
###
gulp.task 'watch', [
  'watch:coffee'
  'watch:copy'
]

gulp.task 'watch:coffee', ->
  gulp.watch 'src/**/*.coffee', [
    'coffee'
  ]

gulp.task 'watch:copy', ->
  gulp.watch [
    'src/**/*.*'
    '!src/**/*.coffee'
  ], [
    'copy'
  ]
