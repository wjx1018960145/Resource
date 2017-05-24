(function(window,doc){
	Date.prototype.toJSON = function () { return this.getTime(); }
	if (!window.WebViewJS) {
		var WV_PROTOCOL_SCHEME = 'objc://';
		var WV_FRAME_ID = '_WEBVIEW_FRAME_';
		var uuid = 0;
		var wvhref;
		function createWVIframeIfNeed(url) {
			var ifr = document.getElementById(WV_FRAME_ID);
			if (!ifr) {
				ifr = doc.createElement('iframe');
				ifr.id = WV_FRAME_ID;
				ifr.name = WV_FRAME_ID;
				ifr.src = url;
				ifr.style.display = 'none';
				doc.documentElement.appendChild(ifr);
				wvhref = document.createElement('a');
                wvhref.style.display = 'none';
                wvhref.target = WV_FRAME_ID;
				doc.documentElement.appendChild(wvhref);
			} else {
				wvhref.href = url;
				wvhref.click();
			}
			return ifr;
		}


		window.WebViewJS = {
	    	call : function(handler, data, callback) {
	    		var callbackName = null;
	    		if (typeof callback == 'function') {
	    			callbackName = 'f'+uuid+(new Date().getTime());
	    			window[callbackName] = callback;
	    		} else if (typeof callback == 'string') {
	    			callbackName = callback;
	    		} else {
	    			callbackName = null;
	    		}
	    		var dataName = 'd'+uuid;
	    		WebViewJS.data[dataName] = JSON.stringify({data:data});
				var postData = handler + ':' + dataName + ':' + callbackName;
				uuid++;
				createWVIframeIfNeed(WV_PROTOCOL_SCHEME + postData);
	        }
	    }
	    window.WebViewJS.data = {};
	};
	
})(window,document);