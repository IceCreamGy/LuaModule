/**
 * 该js已被 lishichao 修改，使用wendux/WebViewJavascriptBridge替换lzyzsd/JsBridge并对lzyzsd/JsBridge做了兼容
 * 丢失数据：https://github.com/lzyzsd/JsBridge
 * 不丢失数据(推荐)：https://github.com/wendux/WebViewJavascriptBridge
 */
(function () {
    if (window.WebViewJavascriptBridge) {
        return;
    }
    var messageHandlers = {};
    var responseCallbacks = {};
    var uniqueId = 1;
    var dispatchMessagesWithTimeoutSafety = true;
    var random = 1;

    function _doSend(message, responseCallback) {
        if (responseCallback) {
            var callbackId = 'cb_' + (uniqueId++) + '_' + new Date().getTime();
            responseCallbacks[callbackId] = responseCallback;
            message['callbackId'] = callbackId;
        }
        var msg = JSON.stringify(message || {});
        if (window.WVJBInterface) {
            console.log('bridge sendMessage by window.WVJBInterface');
            WVJBInterface.notice(msg);
        } else {
            console.log('bridge sendMessage by prompt');
            prompt("_wvjbxx", msg);
        }
    }

    var bridge = {
        /**
         * @兼容lzyzsd/JsBridge
         */
        init: function () {
        },

        registerHandler: function (handlerName, handler) {
            messageHandlers[handlerName] = handler;
        },

        callHandler: function (handlerName, data, responseCallback) {
            if (arguments.length == 2 && typeof data == 'function') {
                responseCallback = data;
                data = null;
            }
            _doSend({
                handlerName: handlerName,
                data: data
            }, responseCallback);
        },
        disableJavascriptAlertBoxSafetyTimeout: function (disable) {
            this.callHandler("_disableJavascriptAlertBoxSafetyTimeout", disable !== false)
        },
        _handleMessageFromJava: function (messageJSON) {
            _dispatchMessageFromJava(messageJSON);
        },
        hasNativeMethod: function (name, responseCallback) {
            this.callHandler('_hasNativeMethod', name, responseCallback);
        }
    };

    bridge.registerHandler('_hasJavascriptMethod', function (data, responseCallback) {
        responseCallback(!!messageHandlers[data])
    })

    function _dispatchMessageFromJava(message) {
        var messageHandler;
        var responseCallback;
        if (message.responseId) {
            responseCallback = responseCallbacks[message.responseId];
            if (!responseCallback) {
                return;
            }
            responseCallback(message.responseData);
            delete responseCallbacks[message.responseId];
        } else {
            if (message.callbackId) {
                var callbackResponseId = message.callbackId;
                responseCallback = function (responseData) {
                    _doSend({
                        handlerName: message.handlerName,
                        responseId: callbackResponseId,
                        responseData: responseData
                    });
                };
            }
            var handler = messageHandlers[message.handlerName];
            if (!handler) {
                console.log("WebViewJavascriptBridge: WARNING: no handler for message from java", message);
            } else {
                handler(message.data, responseCallback);
            }
        }
    }

    var callbacks = window.WVJBCallbacks;
    delete window.WVJBCallbacks;
    if (callbacks) {
        for (var i = 0; i < callbacks.length; i++) {
            callbacks[i](bridge);
        }
    }
    window.WebViewJavascriptBridge = bridge;

    window.close = function () {
        bridge.callHandler("_closePage")
    }

})();

/**
 * @兼容lzyzsd/JsBridge
 */
(function () {
    function setupWebViewJavascriptBridge(callback) {
        var bridge = window.WebViewJavascriptBridge || window.WKWebViewJavascriptBridge;
        if (bridge) {
            return callback(bridge);
        }
        var callbacks = window.WVJBCallbacks || window.WKWVJBCallbacks;
        if (callbacks) {
            return callbacks.push(callback);
        }

        window.WVJBCallbacks = window.WKWVJBCallbacks = [callback];
        if (window.WKWebViewJavascriptBridge) {
            window.webkit.messageHandlers.iOS_Native_InjectJavascript.postMessage(null)
        } else {
            var WVJBIframe = document.createElement('iframe');
            WVJBIframe.style.display = 'none';
            WVJBIframe.src = 'https://__bridge_loaded__';
            document.documentElement.appendChild(WVJBIframe);
            setTimeout(function () {
                document.documentElement.removeChild(WVJBIframe)
            }, 0)
        }
    }

    setupWebViewJavascriptBridge(function (bridge) {
        window.WebViewJavascriptBridge = bridge;
        // 这种用法存在兼容性问题，见 https://github.com/silviomoreto/bootstrap-select/issues/1678
        // document.dispatchEvent(new Event('WebViewJavascriptBridgeReady'));

        // 使用这种方式创建,不用上面的那种方式创建事件
        var event = document.createEvent('Event');
        // 定义事件名为'build'.
        event.initEvent('WebViewJavascriptBridgeReady');
        // 触发event
        document.dispatchEvent(event);
    })
})();