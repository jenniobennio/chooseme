(function(){

	window.__bta = function(siteId) {
		var _ = {
			"baseUrl": (document.location.protocol == "https:" ? "https:" : "http:") + "//",
			"siteId": "",
			"host": "app.bm23.com",
			"hostTid": "app.bm23.com"
		};

		if (this instanceof __bta) {
			if (__bta.sharedInstance !== undefined) {
				return __bta.sharedInstance;
			} else {
				__bta.sharedInstance = this;
			}
		} else {
			return new __bta(siteId);
		}

		_.siteId = siteId;

		var load = function(url) {
			var head = document.getElementsByTagName("head")[0];
			var script = document.createElement("script");
			script.type = "text/javascript";
			script.async = true;
			script.src = url;
			head.appendChild(script);
		};

		var setCookie = function(name, value, exp) {
			document.cookie = name + "=" + escape(value) + ";path=/;" + exp;
		};

		var getCookie = function(name) {
			var crumbs = document.cookie.split(";");
			return getKeyValue(crumbs, name);
		};

		var getQueryParam = function(name) {
			var params = window.location.search.substring(1).split("&");
			return getKeyValue(params, name);
		};

		var tid = function() {
			var tid = getCookie("tid_" + _.siteId);
			if (!tid) {
				tid = getQueryParam("_bta_tid");
			}
			return tid ? encodeURIComponent(tid) : "";
		};

		var cid = function() {
			var cid = getCookie(_.siteId);
			if (!cid) {
				cid = getQueryParam("_bta_c");
			}
			return cid ? encodeURIComponent(cid) : "";
		};

		var getKeyValue = function(arr, name) {
			var y = arr.length;
			for (var x = 0; x < y; x++) {

				if (arr[x].indexOf("=", 0) != -1) {
					var pieces = arr[x].split("=", 2);
					var key = pieces[0].replace(/^\s*/, "");
					var value = pieces[1];

					if (key == name) {
						return decodeURIComponent(value);
					}
				}
			}
		};

		var postEvent = function(type, data) {
			data = encodeURIComponent(data) || "";
			var img = new Image(1, 1);
			var tidValue = tid();
			var hostValue = tidValue ? _.hostTid : _.host;
			img.src = _.baseUrl + hostValue + "/public/trackevent/process/?fn=Mail_TrackEvent&s=" + _.siteId + "&e=" + type + "&d=" + data + "&_bta_tid=" + tidValue + "&rnd=" + new Date().getTime();
		};

		this.setHostTid = function (hostTid) {
			_.hostTid = hostTid;
		};

		this.setHost = function (host) {
			_.host = host;
		};

		this.addConversion = function(data) {
			order = encodeURIComponent(data.order_id) || "";
			date = encodeURIComponent(data.date) || "";
			email = encodeURIComponent(data.email || "");
			contactId = encodeURIComponent(data.contact_id || "");
			items = "num=" + data.items.length;
			for(var x = 0; x < data.items.length; x++) {
				var num = x + 1;
				items += "&item" + num + "=" + (data.items[x].item_id || "");
				items += "&desc" + num + "=" + (data.items[x].desc || "");
				items += "&amount" + num + "=" + (data.items[x].amount || "");
				items += "&quantity" + num + "=" + (data.items[x].quantity || "");
				items += "&name" + num + "=" + (data.items[x].name || "");
				items += "&category" + num + "=" + (data.items[x].category || "");
				items += "&image" + num + "=" + (data.items[x].image || "");
				items += "&url" + num + "=" + (data.items[x].url || "");
			}
			items = encodeURIComponent(items);
			postEvent("adconv", "order=" + order + "&date=" + date + "&email=" + email + "&contactId=" + contactId + "&items=" + items);
		};
		
		this.addOrder = this.addConversion;

		this.addConversionLegacy = function (type, desc, money) {
			var img = new Image(1, 1);
			var tidValue = tid();
			var hostValue = tidValue ? _.hostTid : _.host;
			desc = encodeURIComponent(desc) || "";
			money = encodeURIComponent(money) || "";
			img.src = _.baseUrl + hostValue + "/public/?q=stream_conversion&fn=Mail_Conversion&id=" + _.siteId + "&type=" + type + "&description=" + desc + "&money=" + money + "&_bta_tid=" + tidValue + "&_bta_c=" + cid() + "&rnd=" + new Date().getTime();
		};

		_.tid = getQueryParam("_bta_tid");
		_.cid = getQueryParam("_bta_c");
		_.expire = new Date();
		_.expire.setFullYear(_.expire.getFullYear() + 20);

		if (_.tid) {
			setCookie("tid_" + _.siteId, _.tid, 'expires=' + _.expire.toUTCString());
		}

		if (_.cid) {
			setCookie(_.siteId, _.cid, 'expires=' + _.expire.toUTCString());
		}
	};

})(window);
