gulp        = require 'gulp'
$           = require('gulp-load-plugins')()
NwBuilder   = require 'node-webkit-builder'

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

gulp.task 'release', ['compile'], ->
    return new NwBuilder(
        files: ['./app/**/*'],
        platforms: ['osx32', 'osx64', 'win32', 'win64', 'linux32', 'linux64'],
        version: '0.12.3',
        buildDir: 'dist'
    ).build()
