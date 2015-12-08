gulp           = require('gulp')
del            = require('del')
sass           = require('gulp-sass')
minifycss      = require('gulp-minify-css')
webpack        = require('gulp-webpack')
coffee         = require('gulp-cjsx')
uglify         = require('gulp-uglify')
concat         = require('gulp-concat')
copy           = require('gulp-copy')
connect        = require('gulp-connect')
shell          = require('gulp-shell')

gulp.task 'clean', ->
  del(['dist/**/*'])

gulp.task 'scss', ->
  gulp.src('scss/**/*.scss')
    .pipe(sass())
    .pipe(concat('production.min.css'))
    .pipe(minifycss())
    .pipe(gulp.dest('dist'))

gulp.task 'webpack', ->
  gulp.src('coffee/router.coffee')
    .pipe(webpack(
      module:
        loaders: [
          {
            test: /\.coffee$/
            loaders: ['coffee', 'cjsx']
          }
        ]
    ))
    .pipe(uglify())
    .pipe(concat('production.min.js'))
    .pipe(gulp.dest('dist'))

gulp.task 'copy', ->
  gulp.src([
    'index.html'
    'fonts/*'
    'img/*'
  ]).pipe(copy('dist'))

gulp.task 'watch', ->
  gulp.watch [
    'scss/**/*.scss'
    'coffee/**/*.coffee'
  ], (event) ->
    gulp.src(event.path).pipe connect.reload()

  gulp.watch 'scss/**/*.scss', ['scss']
  gulp.watch 'coffee/**/*.coffee', ['webpack']

gulp.task 'connect', ->
  connect.server
    root: [ 'dist' ]
    port: 9010
    livereload: 
      port: 32834
    connect: 
      redirect: false

gulp.task 'firebase', ['default'], shell.task(['node_modules/.bin/firebase deploy'])

gulp.task 'default', [
  'clean'
  'scss'
  'webpack'
  'copy'
]

gulp.task 'serve', [
  'default'
  'connect'
  'watch'
]

gulp.task 'deploy', [
  'default'
  'firebase'
]