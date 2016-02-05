gulp = require 'gulp'
$ = require('gulp-load-plugins')()

appDirectory = './app'

gulp.task 'default', ['compile']
gulp.task 'compile', ['copy', 'third-party-scripts']

gulp.task 'copy', (done) ->
    gulp.src [
        './package.json'
        './index.html'
        './script.js'
        './node_modules/clippy.js/build/clippy.css'
        './style.css'
    ]
        .pipe gulp.dest appDirectory
        .on 'end', done
    return

gulp.task 'third-party-scripts', (done) ->
    gulp.src [
        './node_modules/jquery/dist/jquery.js'
        './node_modules/clippy.js/build/clippy.js'
    ]
        .pipe $.concat 'third-party.js'
        .pipe gulp.dest appDirectory
    .on 'end', done
    return