var gui = require('nw.gui');
var win = gui.Window.get();
var isMac = require('os').platform() === 'darwin';
win.showDevTools(); // uncomment if you want to debug

if(isMac) {
    document.title = '\u3000'; // to get around https://github.com/nwjs/nw.js/issues/3645
}

// don't let clippy.js add any handlers
$.fn.on = function(){};

// show clippy
clippy.load('Clippy', function(agent){
    agent.show();
    var intiialSpeechTimeoutId = setTimeout(function() {
        agent.speak("Need some help closing me? Try double-clicking...");
    }, 20000);

    var windowX = null;
    var windowY = null;
    setTimeout(function(){
        windowX = win.x;
        windowY = win.y;
    }, 250);

    // to be safe: use focus as a click handler kinda, to trigger animations. Blur when done so every click triggers
    // an animation
    win.on('focus', function(){
        agent.animate();
        win.blur();
    });

    // In case the OS doesn't support blurring, we'll just call animate every now and again anyway
    setInterval(function(){
        agent.animate();
    }, 12000);

    // Since double-clicking draggable areas triggers maximizing on some platforms, when tell the user double-clicking
    // closes clippy but actually we'll hide the window, unmaximize, resize back to the normal size and show again
    // with a speech bubble
    win.on('maximize', function(){
        document.body.classList.add('hidden');
        win.hide();
        if(intiialSpeechTimeoutId) {
            clearTimeout(intiialSpeechTimeoutId);
            intiialSpeechTimeoutId = null;
        }

        setTimeout(function(){
            win.unmaximize();
            win.resizeTo(gui.App.manifest.window.width, gui.App.manifest.window.height);
            win.moveTo(windowX, windowY);
        }, 250);

        setTimeout(function(){
            win.show();
            document.body.classList.remove('hidden');
            setTimeout(function(){
                agent.speak("Need some help?");
            }, 500);
        }, 2000);
    });
});