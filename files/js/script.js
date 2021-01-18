/* globals apex,fostr,$ */

var FOS = window.FOS || {};
FOS.utils = FOS.utils || {};

/**
 * Converts the native APEX notifications to FOS notifications
 */
FOS.utils.convertNativeNotifications = function(options){

    // replacing any success notification which is already part of the dom on page load
    // error messages are never part of the page on page load
    var successNotifElem$ = $('#APEX_SUCCESS_MESSAGE');

    if(successNotifElem$.is(':visible')){
        fostr['success']($('.t-Alert-title', successNotifElem$).text(), null, options);
        apex.message.hidePageSuccess();
    }

    // replacing any subsequent notifications
    apex.message.setThemeHooks({
        beforeShow: function( pMsgType, pElement$ ){
            if ( pMsgType === apex.message.TYPE.SUCCESS ) {
                var messageElem$ = $('.t-Alert-title', pElement$);
                var message = messageElem$.text();
                fostr['success'](message, null, options);
                // ensures APEX notification doesn't show
                return false;
            } else if (pMsgType === apex.message.TYPE.ERROR){
                var title = $('.a-Notification-title', pElement$).text();
                var messageElem$ = $('.a-Notification-list', pElement$).clone();

                var toastrElem$ = fostr[options.replaceErrorsWith](messageElem$, title, options);

                // very often APEX native notifications have built-in links to navigate to the erroneous item
                // or a button to show more info on the error (when coming from the server)
                // the event handlers on these elements are quite tricky and not part of the element that we just cloned.
                // the following passes back such click events into their original elements
                // which are actually still on the page, just hidden
                var allNotificationLinks$ = toastrElem$.find('.a-Notification-link');
                allNotificationLinks$.on('click', function(event){
                    var index = allNotificationLinks$.index($(this));
                    $('.a-Notification-link', $('#APEX_ERROR_MESSAGE'))[index].trigger('click');
                });

                var allDetailButtons$ = toastrElem$.find('.js-showDetails');
                allDetailButtons$.on('click', function(event){
                    var index = allDetailButtons$.index($(this));
                    $('.js-showDetails', $('#APEX_ERROR_MESSAGE'))[index].trigger('click');
                });

                // ensures APEX notification doesn't show
                return false;
            }
        },
        beforeHide: function(a,b){
            // by default, APEX will clear all previous notifications when showing a new one
            // we will respect that, and also clear the FOS notifications
            fostr.clearAll();
        }
    });
}

/**
 * A dynamic action to easily create notification messages in APEX. It is based on the Toastr open source jQuery plugin
 *
 * @param {object}   daContext      Dynamic Action context as passed in by APEX
 * @param {object}   config         Configuration object holding the notification settings
 * @param {string}   config.type    The type of action to be taken. [success|error|warning|info|clear-all|convert]
 * @param {function} [initFn]       JS initialization function which will allow you to override settings right before the notificaton is sent
 */
FOS.utils.notification = function (daContext, config, initFn) {
    var message, title;

    // parameter checks
    daContext = daContext || this;
    config = config || {};
    config.type = config.type || 'info';

    apex.debug.info('FOS - Notifications', config);

    // early exit if we are just clearing the notifications
    if (config.type === 'clear-all') {
        apex.message.clearErrors();
        return fostr.clearAll();
    }

    // early exit if we are just converting the APEX notifications
    if (config.type === 'convert'){
        FOS.utils.convertNativeNotifications(config.options);
        return;
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
        if (message) {
            message = apex.util.applyTemplate(message, {
                defaultEscapeFilter: null
            });
        }
        // we will not perform a notification if our message body is null/empty string after
        // substitutions are made and the message is empty
        if (!message && !title) return;
    }

    // Define our notification settings
    var fostrOptions = $.extend({}, config.options);

    // Allow the developer to perform any last (centralized) changes using Javascript Initialization Code setting
    if (initFn instanceof Function) {
        initFn.call(daContext, fostrOptions);
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
    fostr[config.type](message, title, fostrOptions);
};


