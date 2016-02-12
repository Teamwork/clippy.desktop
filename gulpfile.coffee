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


zip = (directoryName, callback) ->
    gulp.src "./dist/clippy.desktop/#{directoryName}/**/*"
        .pipe $.zip "clippy.desktop-#{directoryName}.zip"
        .pipe gulp.dest './dist'
        .on 'end', callback
    return


gulp.task 'release', ['zip-win32', 'zip-win64', 'zip-osx32', 'zip-osx64', 'zip-linux32', 'zip-linux64']

gulp.task 'zip-win32', ['build'], (done) -> zip 'win32', done
gulp.task 'zip-win64', ['build'], (done) -> zip 'win64', done
gulp.task 'zip-osx32', ['build'], (done) -> zip 'osx32', done
gulp.task 'zip-osx64', ['build'], (done) -> zip 'osx64', done
gulp.task 'zip-linux32', ['build'], (done) -> zip 'linux32', done
gulp.task 'zip-linux64', ['build'], (done) -> zip 'linux64', done

gulp.task 'build', ['compile'], ->
    return new NwBuilder(
        appName: 'clippy.desktop'
        files: ['./app/**/*'],
        platforms: ['osx32', 'osx64', 'win32', 'win64', 'linux32', 'linux64'],
        version: '0.12.3',
        buildDir: 'dist'
    ).build()