gulp = require('gulp')
coffee = require('gulp-coffee')
gutil = require('gulp-util')
mocha = require('gulp-mocha')

gulp.task('default', ['coffee'], ->
  # place code for your default task here
)

gulp.task('coffee', ->
  gulp.src('./src/*.coffee')
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest('./dist/'))
)

gulp.task('test', ->
  return gulp.src(['test/test*.coffee'], { read: false })
    .pipe(coffee().on('error', gutil.log))
    .pipe(mocha({
      reporter: 'spec',
      useColors: false
      globals: {
        should: require('should')
      }
    }))
)
