
//
//  KLTNativeBridge.js
//  UIWebView-Call-ObjC and Javascript
//
//  Created by Klueze on 02/09/15.
//  Copyright 2015 KLT. All rights reserved.
//
var KLTNativeBridge = new function () {
    //iOS 
    this.KLTIOSFramework = new function () {
        var _callbacksCount = 1;
        var _callbacks = {};
        //调用回调
        this.resultForCallback = function (callbackId, resultArray) {
            try {
                var callback = _callbacks[callbackId];
                if (!callback) return;

                callback.apply(null, resultArray);
            } catch (e) { alert(e) }
        }
        this.call = function (functionName, args, callback) {
            var hasCallback = callback && typeof callback == "function";
            var callbackId = hasCallback ? _callbacksCount++ : 0;

            if (hasCallback)
                _callbacks[callbackId] = callback;

            var iframe = document.createElement("IFRAME");
            iframe.setAttribute("src", "NEFinace://" + functionName + ":" + callbackId + ":" + encodeURIComponent(JSON.stringify(args)));
            document.documentElement.appendChild(iframe);
            iframe.parentNode.removeChild(iframe);
            iframe = null;
        }
    }

    //判断是否是Android
    var _isAndroid = function () {
        if (window.seabuy || window.seabuy1) {
            return true;
        }
        return false;
    }

    this.isAPP =function(){
        return (navigator.userAgent.indexOf('NEFinance')>0);
    }
    //注册Push 
    //userID 用户ID
    //callback 回调
    this.RegisterJPush = function (userID, callback) {
        userID=userID-'';
        if (_isAndroid()) {
            if (window.seabuy1.RegisterJPush(userID)) {
                if(callback){
                    callback();
                }
            }
        } else {
            KLTNativeBridge.KLTIOSFramework.call('registerJPush', [userID], callback);
        }
    }

    //调用扫描二维码
    this.CallQRCode = function () {
        if (_isAndroid()) {
            seabuy.CallQRCode();
        } else {
            KLTNativeBridge.KLTIOSFramework.call('callQRCode');
        }
    }

} 