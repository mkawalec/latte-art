var gulp       = require('gulp'),
    coffee     = require('gulp-coffee'),
    concat     = require('gulp-concat'),
    uglify     = require('gulp-uglify'),
    sourcemaps = require('gulp-sourcemaps'),
    del        = require('del'),
    karma      = require('karma').server;

var paths = {
  scripts: ['source/**/*.coffee']
};

gulp.task('clean', function (cb) {
  del(['build'], cb);
});

// Compiles coffee to js
gulp.task('scripts', ['clean'], function () {
  return gulp.src(paths.scripts)
    .pipe(sourcemaps.init())
    .pipe(coffee({bare: true}))
    //.pipe(uglify())
    .pipe(concat('all.min.js'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('build'));
});

gulp.task('watch', function () {
  gulp.watch(paths.scripts, ['scripts']);
});

// Run test once and exit
gulp.task('test', function (done) {
  karma.start({
    configFile: __dirname + '/karma.conf.js',
    singleRun: true
  }, done);
});

// Watch for file changes and re-run tests on each change
gulp.task('tdd', function (done) {
  karma.start({
    configFile: __dirname + '/karma.conf.js'
  }, done);
});

gulp.task('default', ['tdd']);

