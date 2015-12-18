gulp           = require('gulp')
del            = require('del')
sass           = require('gulp-sass')
minifycss      = require('gulp-minify-css')
webpack        = require('webpack-stream')
coffee         = require('gulp-cjsx')
uglify         = require('gulp-uglify')
concat         = require('gulp-concat')
copy           = require('gulp-copy')
rename         = require('gulp-rename')
minifyHTML     = require('gulp-minify-html')
minifyImg      = require('gulp-imagemin')
rev            = require('gulp-rev')
revReplace     = require('gulp-rev-replace')
connect        = require('gulp-connect')
shell          = require('gulp-shell')

gulp.task 'clean', ->
  del(['dist/**/*'])

gulp.task 'scss', ['clean'], ->
  gulp.src('scss/**/*.scss')
    .pipe(sass())
    .pipe(concat('production.min.css'))
    .pipe(gulp.dest('dist'))

gulp.task 'scssProd', ['clean'], ->
  gulp.src('scss/**/*.scss')
    .pipe(sass())
    .pipe(concat('production.min.css'))
    .pipe(minifycss())
    .pipe(rev())
    .pipe(gulp.dest('dist'))
    .pipe(rev.manifest())
    .pipe(rename('css-manifest.json'))
    .pipe(gulp.dest('node_modules/rev'))

gulp.task 'webpack', ['clean'], ->
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
    .pipe(concat('production.min.js'))
    .pipe(gulp.dest('dist'))

gulp.task 'webpackProd', ['clean'], ->
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
    .pipe(rev())
    .pipe(gulp.dest('dist'))
    .pipe(rev.manifest())
    .pipe(rename('js-manifest.json'))
    .pipe(gulp.dest('node_modules/rev'))

gulp.task 'copy', ['clean'], ->
  gulp.src([
    'index.html'
    'fonts/*'
    'img/*'
  ]).pipe(copy('dist'))

gulp.task 'copyProd', ['clean'], ->
  gulp.src([
    'fonts/*'
  ]).pipe(copy('dist'))

gulp.task 'minifyHTML', ['scssProd', 'webpackProd'], ->
  manifest = gulp.src(['node_modules/rev/js-manifest.json', 'node_modules/rev/css-manifest.json'])

  gulp.src('index.html')
    .pipe(revReplace({manifest: manifest}))
    .pipe(minifyHTML())
    .pipe(gulp.dest('dist'))

gulp.task 'duplicateProd', ['minifyHTML'], ->
  gulp.src('dist/index.html')
    .pipe(rename('404.html'))
    .pipe(gulp.dest('dist'))

gulp.task 'minifyImg', ['clean'], ->
  gulp.src('img/*')
    .pipe(minifyImg())
    .pipe(gulp.dest('dist/img'))

gulp.task 'watch', ->
  gulp.watch [
    'scss/**/*.scss'
    'coffee/**/*.coffee'
  ], (event) ->
    gulp.src(event.path).pipe connect.reload()

  gulp.watch 'scss/**/*.scss', ['default']
  gulp.watch 'coffee/**/*.coffee', ['default']

gulp.task 'connect', ->
  connect.server
    root: [ 'dist' ]
    fallback: 'index.html'
    port: 9010
    livereload:
      port: 32834
    connect:
      redirect: false

gulp.task 'firebase', ['build'], shell.task(['node_modules/.bin/firebase deploy'])

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

gulp.task 'build', [
  'clean'
  'scssProd'
  'webpackProd'
  'copyProd'
  'minifyHTML'
  'duplicateProd'
  'minifyImg'
]

gulp.task 'deploy', [
  'build'
  'firebase'
]
