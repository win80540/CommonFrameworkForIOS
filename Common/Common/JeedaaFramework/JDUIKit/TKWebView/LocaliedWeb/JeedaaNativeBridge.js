//
//  JeedaaNativeBridge.js
//  UIWebView-Call-ObjC and Java
//
//  Created by �￭ on 02/09/15.
//  Copyright 2015 Jeedaa. All rights reserved.
//
var JeedaaNativeBridge = new function () {
    //IOS ����ʵ�� 
    this.JeedaaIOSFramework = new function () {
        var _callbacksCount = 1;
        var _callbacks = {};
        // �ص�
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
            iframe.setAttribute("src", "jeedaa-objc://" + functionName + ":" + callbackId + ":" + encodeURIComponent(JSON.stringify(args)));
            document.documentElement.appendChild(iframe);
            iframe.parentNode.removeChild(iframe);
            iframe = null;
        }
    }

    //�ж��Ƿ���ANDROID�豸
    var _isAndroid = function () {
        if (window.seabuy || window.seabuy1) {
            return true;
        }
        return false;
    }

    this.isAPP =function(){
        return (navigator.userAgent.indexOf('seabuyapp')>0);
    }
    //ע��JPush 
    //userID �û�ID
    //callback �ص�����
    this.RegisterJPush = function (userID, callback) {
        userID=userID-'';
        if (_isAndroid()) {
            if (window.seabuy1.RegisterJPush(userID)) {
                if(callback){
                    callback();
                }
            }
        } else {
            JeedaaNativeBridge.JeedaaIOSFramework.call('registerJPush', [userID], callback);
        }
    }

    //����ɨ���ά��
    this.CallQRCode = function () {
        if (_isAndroid()) {
            seabuy.CallQRCode();
        } else {
            JeedaaNativeBridge.JeedaaIOSFramework.call('callQRCode');
        }
    }

} 