

/* globals apex,fostr,$ */

var FOS = window.FOS || {};
FOS.util =FOS.util || {};

FOS.util.isRTL = FOS.util.isRTL || function () { return $('body').attr('dir') === "rtl"; };

/**
 * A dynamic action to easily create notification messages in APEX. It is based on the Toastr open source jQuery plugin
 *
 * @param {object}   daContext      Dynamic Action context as passed in by APEX
 * @param {object}   config         Configuration object holding the notification settings
 * @param {string}   config.type    The notification type e.g. success, error, warning, info
 * @param {function} [initFn]       JS initialization function which will allow you to override settings right before the notificaton is sent
 */
FOS.util.notification = function (daContext, config, initFn) {
    var message, title, defaults, positionClass;

    // parameter checks
    daContext = daContext || this;
    config = config || {};
    config.type = config.type || 'info';

    apex.debug.info('FOS - Notifications', config);

    // early exit if we are jsut clearing the notifications
    if (config.type === 'clear-all') {
        apex.message.clearErrors();
        return fostr.clearAll();
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
    if (!message && !title) return;

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
        // we will not perform a notification if our message body is null/empty string after
        // substitutions are made and the message is empty
        if (!message && !title) return;
    }

    // Define our notification settings
    fostr.options = $.extend({}, config.options);

    // Allow the developer to perform any last (centralized) changes using Javascript Initialization Code setting
    if (initFn instanceof Function) {
        initFn.call(daContext, fostr.options);
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
    fostr[config.type](message, title);
};




