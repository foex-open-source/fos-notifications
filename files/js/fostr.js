

/*
 * RTL support should be done in css only. class u-RTL exists on the body when apex is in RTL mode.
 * Note that this should only affect elements within the notification, not the positioning of the actual notification.
 * This is taken care of by a plug-in settings.
 *
 */

/*
 * Fostr
 * Copyright 2020
 * Authors: Stefan Dobre
 *
 * Credits for the base version go to: https://github.com/CodeSeven/toastr
 * Original Authors: John Papa, Hans Fjällemark, and Tim Ferrell.
 * ARIA Support: Greta Krafsig
 *
 * All Rights Reserved.
 * Use, reproduction, distribution, and modification of this code is subject to the terms and
 * conditions of the MIT license, available at http://www.opensource.org/licenses/mit-license.php
 *
 * Project: https://github.com/foex-open-source/fostr
 */
window.fostr = (function() {

    var toastType = {
        success: 'success',
        info: 'info',
        warning: 'warning',
        error: 'error'
    };

    var iconClasses = {
        success: "fa-check-circle",
        info: "fa-info-circle",
        warning: "fa-exclamation-triangle",
        error: "fa-times-circle"
    };

    var containers = {};
    var previousToast = {};

    function notifyType(type, message, title) {
        if (typeof message === 'string') {
            if (!title) {
                title = message;
                message = undefined;
            }
            return notify({
                type: type,
                message: message,
                title: title
            });
        } else if (typeof message === 'object') {
            message.type = type;
            return notify(message);
        } else {
            console.error('fostr notification "message" parameter type not supported, must be a string or object');
        }
    }

    function success(message, title) {
        notifyType(toastType.success, message, title);
    }

    function warning(message, title) {
        notifyType(toastType.warning, message, title);
    }

    function info(message, title) {
        notifyType(toastType.info, message, title);
    }

    function error(message, title) {
        notifyType(toastType.error, message, title);
    }

    function clearAll() {
        $('.' + getContainerClass()).children().remove();
    }

    // internal functions

    function getContainerClass() {
        return 'fostr-container';
    }

    function getContainer(position) {

        function createContainer(position) {
            var $container = $('<div/>').addClass('fostr-' + position).addClass(getContainerClass());
            $('body').append($container);
            containers[position] = $container;
            return $container;
        }

        return containers[position] || createContainer(position);
    }

    function getDefaults() {
        return {
            dismiss: ['onClick', 'onButton'], // when to dismiss the notification
            dismissAfter: null, // a number in milliseconds after which the notification should be automatically removed. hovering or clicking the notification stops this event
            newestOnTop: true, // add to the top of the list
            preventDuplicates: false, // do not show the notification if it has the same title and message as the last one and if the last one is still visible
            escapeHtml: true, // whether to escape the title and message
            position: 'top-right', // one of 6: [top|bottom]-[right|center|left]
            iconClass: null, // when left to null, it will be defaulted to the corresponding icon from iconClasses
            clearAll: false // true to clear all notifications first
        };
    }

    function getOptions() {
        return $.extend({}, getDefaults(), fostr.options);
    }

    function notify(map) {

        var options = $.extend({}, getOptions(), map);
        var $container = getContainer(options.position);

        var dismissOnClick = options.dismiss.includes('onClick');
        var dismissOnButton = options.dismiss.includes('onButton');

        /*
        <div class="fos-Alert fos-Alert--horizontal fos-Alert--page fos-Alert--success" role="alert">
            <div class="fos-Alert-wrap">
                <div class="fos-Alert-icon">
                    <span class="t-Icon fa fa-check-circle"></span>
                </div>
                <div class="fos-Alert-content">
                    <h2 class="fos-Alert-title"></h2>
                    <div class="fos-Alert-body"></div>
                </div>
                <div class="fos-Alert-buttons">
                    <button class="t-Button t-Button--noUI t-Button--icon t-Button--closeAlert" type="button" title="Close Notification"><span class="t-Icon icon-close"></span></button>
                </div>
            </div>
        </div>
        */

        var typeClass = {
            "success": "fos-Alert--success",
            "error": "fos-Alert--danger",
            "warning": "fos-Alert--warning",
            "info": "fos-Alert--info"
        };

        var $toastElement = $('<div class="fos-Alert fos-Alert--horizontal fos-Alert--page ' + typeClass[options.type] + '" role="alert"></div>');
        var $toastWrap = $('<div class="fos-Alert-wrap">');
        var $iconWrap = $('<div class="fos-Alert-icon"></div>');
        var $iconElem = $('<span class="t-Icon fa ' + (options.iconClass || iconClasses[options.type]) + '"></span>');
        var $contentElem = $('<div class="fos-Alert-content"></div>');
        var $titleElement = $('<h2 class="fos-Alert-title"></h2>');
        var $messageElement = $('<div class="fos-Alert-body"></div>');
        var $buttonWrapper = $('<div class="fos-Alert-buttons"></div>');
        var $closeElement;

        if (dismissOnButton) {
            $closeElement = $('<button class="t-Button t-Button--noUI t-Button--icon t-Button--closeAlert" type="button" title="Close Notification"><span class="t-Icon icon-close"></span></button>');
        }

        $toastElement.append($toastWrap);
        $toastWrap.append($iconWrap);
        $iconWrap.append($iconElem);
        $toastWrap.append($contentElem);
        $contentElem.append($titleElement);
        $contentElem.append($messageElement);
        $toastWrap.append($buttonWrapper);

        if (dismissOnButton) {
            $buttonWrapper.append($closeElement);
        }

        // setting the title
        var title = options.title;
        if (title) {
            if (options.escapeHtml) {
                title = apex.util.escapeHTML(title);
            }
            $titleElement.append(title);
        }

        //setting the message
        var message = options.message;
        if (message) {
            if (options.escapeHtml) {
                message = apex.util.escapeHTML(message);
            }
            $messageElement.append(message);
        }

        // avoiding duplicates, but only consecutive ones
        if (options.preventDuplicates && previousToast && previousToast.$elem && previousToast.$elem.is(':visible')) {
            if (previousToast.title == title && previousToast.message == message) {
                return;
            }
        }

        previousToast = {
            $elem: $toastElement,
            title: title,
            message: message
        };

        // optionally clear all messages first
        if (options.clearAll) {
            clearAll();
        }
        // adds the notification to the container
        if (options.newestOnTop) {
            $container.prepend($toastElement);
        } else {
            $container.append($toastElement);
        }

        // setting the correct ARIA value
        var ariaValue;
        switch (options.type) {
            case 'success':
            case 'info':
                ariaValue = 'polite';
                break;
            default:
                ariaValue = 'assertive';
        }
        $toastElement.attr('aria-live', ariaValue);

        //setting timer and progress bar
        var $progressElement = $('<div/>');
        if (options.dismissAfter > 0) {
            $progressElement.addClass('fostr-progress');
            $toastElement.append($progressElement);

            var timeoutId = setTimeout(function() {
                $toastElement.remove();
            }, options.dismissAfter);
            var progressStartAnimDelay = 100;

            $progressElement.css({
                'width': '100%',
                'transition': 'width ' + ((options.dismissAfter - progressStartAnimDelay)/1000) + 's linear'
            });
            setTimeout(function(){
                $progressElement.css('width', '0');
            }, progressStartAnimDelay);

            // on hover or click, remove the timer and progress bar
            $toastElement.on('mouseover click', function() {
                clearTimeout(timeoutId);
                $progressElement.remove();
            });
        }

        //handling any events
        if (dismissOnClick) {
            $toastElement.on('click', function() {
                // only remove if it contains no active selection
                var selection = window.getSelection();
                if( selection &&
                    selection.type == 'Range' &&
                    selection.anchorNode &&
                    $(selection.anchorNode, $toastElement).length > 0){

                    return;
                }
                $toastElement.remove();
            });
        }

        if (dismissOnButton) {
            $closeElement.on('click', function() {
                $toastElement.remove();
            });
        }

        // perhaps the developer wants to do something additionally when the notification is clicked
        if (typeof options.onclick === 'function') {
            $toastElement.on('click', options.onclick);
            if (dismissOnButton) $closeElement.on('click', options.onclick);
        }

        return $toastElement;
    }

    return {
        success: success,
        info: info,
        warning: warning,
        error: error,
        clearAll: clearAll,
        version: '20.1.1'
    };

})();



