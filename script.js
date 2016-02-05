var originalOn = $.fn.on;
var win = require('nw.gui').Window.get();
var isMac = require('os').platform() === 'darwin';
win.showDevTools(); // uncomment if you want to debug

if(isMac) {
    document.title = '\u3000'; // to get around https://github.com/nwjs/nw.js/issues/3645
    var hasInterceptedClickHandlerBinding = false;
}

$.fn.on = function(event, callback){
    // ignore dragging of clippy within the window since the window is draggable itself
    if(event === 'mousedown'){
        return;
    }

    var args = arguments;

    // Map the typical double-click actions to single clicks instead
    if(event === 'dblclick'){
        args[0] = 'click';

        // To workaround https://github.com/nwjs/nw.js/issues/2387
        // Long story -> short: first click = focus window, second click = click
        // So now the click callback is called when the app is focused too
        if(isMac && !hasInterceptedClickHandlerBinding) {
            hasInterceptedClickHandlerBinding = true;
            win.on('focus', callback);
        }
    }

    return originalOn.apply(this, args);
};


// show clippy
clippy.load('Clippy', function(agent){
    agent.show();
    agent.speak("Need some help closing me? Try double-clicking...");
});

// The 'hidden' class is being toggled to use opacity to hide flash / glitch when showing again
//
// Note: the .desktopClippy namespace here prevents this callback from being mapped to the focus
// event above
$(window).on('dblclick.desktopClippy', function(){
    win.hide();
    document.body.classList.add('hidden');

    setTimeout(function(){
        win.show();
        document.body.classList.remove('hidden');
    }, 2000);
});