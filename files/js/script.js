// Namespace Setup
window.FOS = window.FOS || {};
window.FOS.utils = window.FOS.utils || {};
window.FOS.utils.isRTL = window.FOS.utils.isRTL || function () { return $('body').attr('dir') === "rtl" };

/**
 * A dynamic action to easily create notification messages in APEX. It is based on the Toastr open source jQuery plugin
 *
 * @param {Object}   daContext                      Dynamic Action context as passed in by APEX
 * @param {Object}   config                         Configuration object holding the notification settings
 * @param {string}   config.type                    The notification type e.g. success, error, warning, info
 * @param {function} initFn                         JS initialization function which will allow you to override settings right before the notificaton is sent
 */
FOS.utils.notification = function (daContext, config, initFn) {
    var message, title, defaults, positionClass;

    // parameter checks
    daContext = daContext || this;
    config = config || {};
    config.type = config.type || 'info';

    apex.debug.info('FOS - Notifications', config);

    // default options if we call this function directly in Javascript code
    defaults = {
        closeButton: true,
        debug: false,
        newestOnTop: true,
        progressBar: true,
        positionClass: 'toast-top-right',
        preventDuplicates: false,
        escapeHtml: true,
        showDuration: 500,
        hideDuration: 1000,
        timeOut: 5000,
        extendedTimeOut: 5000,
        rtl: FOS.utils.isRTL()
    }

    // define our message details which may dynamically come from a Javascript call
    if (config.message instanceof Function) {
        message = config.message.call(daContext, config);
    } else {
        message = config.message;
    }

    if (config.title instanceof Function) {
        title = config.title.call(daContext, config);
    } else {
        title = config.title;
    }

    // we will not perform a notification if our message body is null/empty string
    if (!message) return;

    //  Replacing substitution strings
    if (config.substituteValues) {
        //  We don't escape the message by default. We let the developer decide whether to escape
        //  the whole message, or just invidual page items via &PAGE_ITEM!HTML.
        if (title) {
            title = apex.util.applyTemplate(title, {
                defaultEscapeFilter: null
            });
        }
        message = apex.util.applyTemplate(message, {
            defaultEscapeFilter: null
        });
        // we will not perform a notification if our message body is null/empty string
        if (!message) return;
    }

    // we will not perform a notification if our message body is null/empty string
    if (!message) return;

    // Define our notification settings
    toastr.options = $.extend(defaults, config.options);

    // Allow the developer to perform any last (centralized) changes using Javascript Initialization Code setting
    if (initFn instanceof Function) {
        initFn.call(daContext, toastr.options);
    }

    // we need to manually swap our position class in RTL mode as the developer may have enabled it
    if (toastr.options.rtl) {
        positionClass = toastr.options.positionClass;
        if (positionClass.indexOf('right') > -1) {
            toastr.options.positionClass = positionClass.replace(/right/, 'left');
        } else if (positionClass.indexOf('left') > -1) {
            toastr.options.positionClass = positionClass.replace(/left/, 'right');
        }
    }

    // Optionally remove all notifications first
    if (config.removeToasts) {
        toastr.remove(); // without animation
        //toastr.clear(); // with animation
    }

    // asscoaite any inline page item errors
    if (config.inlineItemErrors && config.inlinePageItems) {
        config.inlinePageItems.split(',').forEach(function(pageItem) {
            // Show our APEX error message
            apex.message.showErrors({
                type: 'error',
                location: 'inline',
                pageItem: pageItem,
                message: message,
                //any escaping is assumed to have been done by now
                unsafe: false
            });
        });
    }

    // Perform the actual notification
    toastr[config.type](message, title);

};


