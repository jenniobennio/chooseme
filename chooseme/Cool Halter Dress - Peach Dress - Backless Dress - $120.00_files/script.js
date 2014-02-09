/* Listak LLC Business Intelligence (c)  */
/* Build Date 2/4/2014 3:17:33 PM */
/* Version v1 - Tue, 04 Feb 2014 15:15:00 GMT */

var _protocol = ("https:" == document.location.protocol) ? "https://" : "http://";



(function() {
	if (!window.jQuery) {
		var jq = document.createElement('script');
		jq.src = _protocol + 'ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js';
		jq.onload = jq.onreadystatechange = function() { if(window.jQuery && typeof (jq) !== 'undefined' && (!jq.readyState || /loaded|complete/.test(jq.readyState))) { jQuery.noConflict(); jq.onload = jq.readystatechange = null; jq=undefined; } };
		document.documentElement.children[0].appendChild(jq);
	}
})();


LTK.prototype.cookie=function(key,value,options){return"";};LTK.prototype.cookiesEnabled=function(){var _dt=new Date();_dt.setSeconds(_dt.getSeconds()+180);var _enabled=(this.cookie("checkCookies","enabled",{expires:_dt,path:"/"})&&this.cookie("checkCookies")=="enabled");if(_enabled)
this.cookie("checkCookies","deleted",{expires:new Date(1970,1,1,0,0,0),path:"/"});return _enabled;};var _ltgsi=setInterval(function(){if(!window.jQuery){return;}
clearInterval(_ltgsi);;(function(factory){if(typeof define==='function'&&define.amd){define(['jquery'],factory);}else{factory(jQuery);}}
(function($){LTK.prototype.cookie=function(key,value,options){if(arguments.length>1&&String(value)!=="[object Object]"){options=jQuery.extend({},options);if(value===null||value===undefined){options.expires=-1;}
if(typeof options.expires==='number'){var days=options.expires,t=options.expires=new Date();t.setDate(t.getDate()+days);}
value=String(value);return(document.cookie=[encodeURIComponent(key),'=',options.raw?value:encodeURIComponent(value),options.expires?'; expires='+options.expires.toUTCString():'',options.path?'; path='+options.path:'',options.domain?'; domain='+options.domain:'',options.secure?'; secure':''].join(''));}
options=value||{};var result,decode=options.raw?function(s){return s;}:decodeURIComponent;return(result=new RegExp('(?:^|; )'+encodeURIComponent(key)+'=([^;]*)').exec(document.cookie))?decode(result[1]):null;};}));},100);LTK.prototype.urlParam=function(name){name=name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");var regexS="[\\?&]"+name+"=([^&#]*)";var regex=new RegExp(regexS);var results=regex.exec(window.location.href);if(results==null)
return"";else
return results[1];}
LTK.prototype.isValidEmail=function(email){var watermarkFilter=new Array();var isWatermark=false;var emailFilter=/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;watermarkFilter=["user@example.com","email@example.com","customer@example.com","user@domain.com","email@domain.com","customer@domain.com"];for(var i=0;i<watermarkFilter.length;i++){if(watermarkFilter[i]===email)
isWatermark=true;}
if(!emailFilter.test(email)||isWatermark)
return false;else
return true;};if(!LTK.prototype.browser){ua=navigator.userAgent.toLowerCase();var match=/(chrome)[ \/]([\w.]+)/.exec(ua)||/(webkit)[ \/]([\w.]+)/.exec(ua)||/(opera)(?:.*version|)[ \/]([\w.]+)/.exec(ua)||/(msie) ([\w.]+)/.exec(ua)||ua.indexOf("compatible")<0&&/(mozilla)(?:.*? rv:([\w.]+)|)/.exec(ua)||[];matched={browser:match[1]||"",version:match[2]||"0"};browser={};if(matched.browser){browser[matched.browser]=true;browser.version=matched.version;}
if(browser.chrome){browser.webkit=true;}else if(browser.webkit){browser.safari=true;}
LTK.prototype.browser=browser;if(typeof _ltk!='undefined')
_ltk.browser=browser;}
if(!Array.prototype.indexOf){Array.prototype.indexOf=function(searchElement,fromIndex){var i,pivot=(fromIndex)?fromIndex:0,length;if(!this){throw new TypeError();}
length=this.length;if(length===0||pivot>=length){return-1;}
if(pivot<0){pivot=length-Math.abs(pivot);}
for(i=pivot;i<length;i++){if(this[i]===searchElement){return i;}}
return-1;};}
LTK.prototype.getCookie=function(c_name){if(document.cookie.length>0){c_start=document.cookie.indexOf(c_name+"=");if(c_start!=-1){c_start=c_start+c_name.length+1;c_end=document.cookie.indexOf(";",c_start);if(c_end==-1)c_end=document.cookie.length;return unescape(document.cookie.substring(c_start,c_end));}}
return"";}
LTK.prototype.getJSON=function(options,callback){options.url=options.url||location.href;options.data=options.data||null;callback=callback||function(){};options.type=options.type||'json';var url=options.url;if(options.type=='jsonp'){window.jsonCallback=callback;var $url=url.replace('callback=?','callback=jsonCallback');var script=document.createElement('script');script.src=$url;document.body.appendChild(script);}}




function AsyncManager(){this.Calls=[];AsyncManager.prototype.StartAsyncCall=function(callName,delegate,callsToWaitFor,timeoutInMilliseconds){try{var call=new AsyncCall(callName,delegate,callsToWaitFor,this);this.Calls.push(call);if(delegate===undefined){call.InProgress=true;}else{if(timeoutInMilliseconds!==undefined){var startTimeout=function(call){setTimeout(function(){if(!call.InProgress){call.InProgress=true;call.Delegate();call.Complete();}},timeoutInMilliseconds);};startTimeout(call);}
this.CheckWait(call);}
return call;}
catch(ex){_ltk.Exception.Submit(ex,'AsyncManager.StartAsyncCall');return null;}};AsyncManager.prototype.CallComplete=function(callName){try{for(var c=0;c<this.Calls.length;c++){if(this.Calls[c].Name==callName){this.Calls.splice(c,1);break;}}
if(document.dispatchEvent){var customEvent=document.createEvent('Event');customEvent.initEvent('AsyncCallComplete',false,false);document.dispatchEvent(customEvent);}else if(document.fireEvent){document.documentElement.ltkAsyncCallComplete+=1;}}
catch(ex){_ltk.Exception.Submit(ex,'AsyncManager.CallComplete');return null;}};AsyncManager.prototype.IsCallQueued=function(callName){for(var c=0;c<this.Calls.length;c++){if(this.Calls[c].Name==callName){return true;}}
return false;};AsyncManager.prototype.CheckWait=function(call){if(call.InProgress){return;}
var keepWaiting=false;for(var n=0;n<call.CallsToWaitFor.length;n++){if(this.IsCallQueued(call.CallsToWaitFor[n])){keepWaiting=true;break;}}
if(!keepWaiting){call.InProgress=true;var execute=function(call){setTimeout(function(){call.Delegate();call.Complete();},0);};execute(call);}};AsyncManager.prototype.CheckAllWaits=function(){for(var c=0;c<this.Calls.length;c++){this.CheckWait(this.Calls[c]);}};if(document.addEventListener){document.addEventListener('AsyncCallComplete',AsyncManager.CallCompleteHandler);}else if(document.attachEvent){document.documentElement.ltkAsyncCallComplete=0;document.documentElement.attachEvent("onpropertychange",function(event){if(event.propertyName=="ltkAsyncCallComplete"){AsyncManager.CallCompleteHandler();}});}}
AsyncManager.CallCompleteHandler=function(){_ltk.AsyncManager.CheckAllWaits();};function AsyncCall(callName,delegate,callsToWaitFor,manager){this.Name=callName;this.Delegate=delegate;this.CallsToWaitFor=callsToWaitFor;this.InProgress=false;AsyncCall.prototype.Complete=function(){manager.CallComplete(this.Name);};}


LTK.prototype.moduleList = ['PCO', 'SCA', 'PPE', 'LCG'];


function LTK(){this.SCA=new SessionTracker();this.Order=new _Order();this.Items=new Array();this.Products=new Array();this.Customer=new _Customer();this.Client=new _Client();this.TRKT=new _TRKT();this.Subscriber=new _LTKSubscriber();this.Assembler=new _Assembler();this.Click=new _LTKClick();this.Exception=new _LTKException();this.TransactionIDs=new Array();this.Activity=new _ActivityList();this.Alerts=new _Alerts();this.AsyncManager=new AsyncManager();

LTK.prototype.Submit=function(){try{this.TRKT.T=this.GetCookie("_trkt");this.TRKT.Event='t';this.Order.SetSessionID();this.PostData();}
catch(ex){this.Exception.Submit(ex,'Submit and Post Data');}}
LTK.prototype.PostData=function(uid){this.Assembler.QueryHeader="ctid="+this.Client.CTID+(this.Client.DebugMode?"&debugmode=true":"")+"&uid="+this.uuidCompact();this.Assembler.AddObject(this.Order);this.Assembler.AddObject(this.TRKT);this.Assembler.AddObject(this.Customer);this.Assembler.AddArrayObject(this.Items);this.Assembler.AddArrayObject(this.Products);this.Assembler.Flush();}
LTK.prototype.RandomString=function(length){var text="";var possible="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";for(var i=0;i<length;i++)
text+=possible.charAt(Math.floor(Math.random()*possible.length));return text;}
LTK.prototype.uuidCompact=function(){var id=this.generateUUID();try{this.TransactionIDs.push(id);}
catch(ex){}
return id;};LTK.prototype.generateUUID=function(){var id='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g,function(c){var r=Math.random()*16|0,v=c=='x'?r:(r&0x3|0x8);return v.toString(16);}).toUpperCase();return id;};LTK.prototype.GetCookie=function(sName){var sRE="(?:; )?"+sName+"=([^;]*);?";var oRE=new RegExp(sRE);if(oRE.test(document.cookie)){return decodeURIComponent(RegExp["$1"]);}else{return null;}}}
function _Order(){this._type='o';this.UID=null;this.OrderNumber=null;this.OrderTotal=null;this.TaxTotal=null;this.ShippingTotal=null;this.HandlingTotal=null;this.ItemTotal=null;this.Currency=null;this.Meta1=null;this.Meta2=null;this.Meta3=null;this.Meta4=null;this.Meta5=null;this.SessionID=null;this.Source=null;this._varmap={'_type':'_t','UID':'uid','OrderNumber':'on','OrderTotal':'ot','TaxTotal':'tt','ShippingTotal':'st','HandlingTotal':'ht','ItemTotal':'it','Currency':'c','Meta1':'m1','Meta2':'m2','Meta3':'m3','Meta4':'m4','Meta5':'m5','SessionID':'s','Source':'sr'};_Order.prototype.SetSessionID=function(){try{if(this.OrderNumber!=null)
this.SessionID=_ltk.SCA.sessionID;}
catch(ex){_ltk.Exception.Submit(ex,'OrderSetSession');}}
_Order.prototype.SetCustomer=function(email,firstname,lastname){_ltk.Customer.Email=email;_ltk.Customer.FirstName=firstname;_ltk.Customer.LastName=lastname;}
_Order.prototype.Submit=function(){_ltk.Submit();}
_Order.prototype.AddItem=function(id,quantity,price){try{var _item=new this.Item(id,quantity,price);_ltk.Items.push(_item);}
catch(ex){_ltk.Exception.Submit(ex,'Add Item');}}
_Order.prototype.AddItemEx=function(item){try{_ltk.Items.push(item);}
catch(ex){_ltk.Exception.Submit(ex,'Add Item Ex');}}
_Order.prototype.Item=function(id,quantity,price){this._type='i';this.UID=null;this.ID=id;this.Name=null;this.Quantity=quantity;this.Price=price;this.RowID=null;this.Meta1=null;this.Meta2=null;this.Meta3=null;this.Meta4=null;this.Meta5=null;this._varmap={'_type':'_t','UID':'uid','ID':'id','Name':'n','Quantity':'q','Price':'p','RowID':'ri','Meta1':'m1','Meta2':'m2','Meta3':'m3','Meta4':'m4','Meta5':'m5'};}}
function _TRKT(){this._type='tt';this.UID=null;this.T=null;this.Event=null;this._varmap={'_type':'_t','UID':'uid','T':'t','Event':'e'};}
function _Product(id,_name,price,imageUrl,itemUrl,description,masterSku,reviewProductID){this._type='p';this.UID=null;this.ID=id;this.Name=_name;this.Price=price;this.ImageUrl=imageUrl;this.ItemUrl=itemUrl;this.Description=description;this.Meta1=null;this.Meta2=null;this.Meta3=null;this.Meta4=null;this.Meta5=null;this.MasterSku=typeof masterSku=="undefined"?null:masterSku;this.ReviewProductID=typeof reviewProductID=="undefined"?null:reviewProductID;this.Discontinued=null;this._varmap={'_type':'_t','UID':'uid','ID':'id','Name':'n','Price':'p','ImageUrl':'imu','ItemUrl':'itu','Description':'d','Meta1':'m1','Meta2':'m2','Meta3':'m3','Meta4':'m4','Meta5':'m5','MasterSku':'ms','ReviewProductID':'rpi','Discontinued':'ds'};_Product.prototype.Add=function(){try{_ltk.Products.push(this);}
catch(ex){_ltk.Exception.Submit(ex,'Add Product');}}}
function _Customer(){this._type='c';this.UID=null;this.Email=null;this.FirstName=null;this.LastName=null;this.Meta1=null;this.Meta2=null;this.Meta3=null;this.Meta4=null;this.Meta5=null;this._varmap={'_type':'_t','UID':'uid','Email':'e','FirstName':'fn','LastName':'ln','Meta1':'m1','Meta2':'m2','Meta3':'m3','Meta4':'m4','Meta5':'m5'};}
function _Client(){this.CTID=null;this.DebugMode=false;}
function _Assembler(){this.QueryHeader=null;this.QueryMode=0;this.EndPointArray=['s1.listrakbi.com/t','s2.listrakbi.com/t'];this.EndPointPath='/T.ashx';this.EndPointIndex=0;this.EnumIndex=0;this.MaxLength=950;this.Query='';this._protocol=(("https:"==document.location.protocol)?"https://":"http://");_Assembler.prototype.Reset=function(){this.Query='';if(this.QueryMode==0){this.EnumIndex=0;}}
_Assembler.prototype.Append=function(obj){var q=this.BuildQuery(obj);var tq=this.Query+q;if(tq.length>this.MaxLength){this.Flush();q=this.BuildQuery(obj);}
this.Query+=q;if(this.QueryMode==0||obj._isIndexable){this.EnumIndex++;}}
_Assembler.prototype.Flush=function(){if(this.Query!=''){var src=this._protocol+this.EndPointArray[this.EndPointIndex]+this.EndPointPath+'?'+this.QueryHeader+this.Query;var img=new Image();img.height=1;img.width=1;img.src=src;this.IncrementEndPointIndex();this.Reset();}}
_Assembler.prototype.IncrementEndPointIndex=function(){this.EndPointIndex++;if(this.EndPointIndex==this.EndPointArray.length)
this.EndPointIndex=0;}
_Assembler.prototype.BuildQuery=function(obj){var i=-1;var query='';for(var key in obj){if(key=="_varmap"||typeof obj[key]=='function')continue;i++;if(typeof obj[key]=='undefined'||obj[key]==null||typeof obj._varmap[key]=='undefined')continue;query+="&"+obj._varmap[key]+(this.QueryMode==0||obj._isIndexable?"_"+this.EnumIndex:"")+"="+encodeURIComponent(obj[key]);}
return query;}
_Assembler.prototype.AddObject=function(obj){if(typeof obj=='undefined'||obj==null||!this.HasValue(obj)||typeof(obj._varmap)=='undefined')return;this.Append(obj);}
_Assembler.prototype.AddArrayObject=function(obj){if(typeof obj=='undefined'||obj==null)return;for(var k in obj){this.AddObject(obj[k]);}}
_Assembler.prototype.HasValue=function(obj){if(typeof obj=='undefined'||obj==null)return false;if(typeof obj._varmap=='undefined'||obj._varmap==null)return false;var valueFound=false;for(var key in obj){if(key=="_varmap"||typeof obj[key]=='function'||key=='_type')continue;if(typeof obj[key]=='undefined'||obj[key]==null||typeof obj._varmap[key]=='undefined')continue;valueFound=true;}
return valueFound;}}
function _LTKException(){_LTKException.prototype.Submit=function(ex,info){var _endpoint='s1.listrakbi.com/t';var _protocol=(("https:"==document.location.protocol)?"https://":"http://");if(ex==null)return;var src=_protocol+_endpoint+'/EX.ashx?'+
((_ltk.Client.CTID==null)?'':'ctid='+_ltk.Client.CTID+'&')+'uid='+_ltk.uuidCompact()+'&'+'n='+encodeURIComponent(ex.name)+'&'+'m='+encodeURIComponent(ex.message)+'&'+
((info==null)?'':'i='+encodeURIComponent(info)+'&')+'h='+encodeURIComponent(document.location.href);var img=new Image();img.height=1;img.width=1;img.src=src;}}


function _LTKClick(){this._endpoint='s1.listrakbi.com/t';this._protocol=(("https:"==document.location.protocol)?"https://":"http://");this._rootHost=null;_LTKClick.prototype.SetCookie=function(n,v,e,d,p,s){var exd=new Date();exd.setDate(exd.getDate()+e);document.cookie=n+"="+encodeURIComponent(v)+
((e==null)?"":"; expires="+exd.toGMTString())+
((d==null&&d!="")?"":"; domain="+d)+
((p==null)?"":"; path="+p)+
((s)?"; secure":"");}
_LTKClick.prototype.Submit=function(){try{var hRES=/([\.]*[^\.]+\.(co\.uk|com|net|biz|org|co\.nz|info|jp|edu|mx|com\.br|es|ca|pro|co|au|de)$)|(^localhost$)/gi;var hRE=new RegExp(hRES);var trkRES=/[?&]*trk_[^=&]+=/gi;var trkRE=new RegExp(trkRES);var hostfound=true;var hREMatch=document.location.host.match(hRE);var trkREMatch=document.location.search.match(trkRE);if(hREMatch){this._roothost=hREMatch[0];if(this._roothost.indexOf(".")!=0)this._roothost="."+this._roothost;}else hostfound=false;if(hostfound&&trkREMatch){this.SetCookie("_trkt",'0',365,this._roothost,"/",null);this.ScriptPostData(this._protocol+this._endpoint+'/CT.ashx?'+((_ltk.Client.CTID==null)?'':'ctid='+_ltk.Client.CTID+'&')+((_ltk.Client.DebugMode)?'debugmode=true&':'')+'uid='+_ltk.uuidCompact()+'&_t_0=cp&e_0=c&q_0='+encodeURIComponent(document.location.search)+'&_version=1');}}
catch(ex){_ltk.Exception.Submit(ex,'Submit Click');}}
_LTKClick.prototype.ScriptPostData=function(url){var script=document.createElement("script");script.setAttribute("src",url);script.setAttribute("type","text/javascript");document.body.appendChild(script);}
_LTKClick.prototype.CallBack=function(data){try{this.SetCookie("_trkt",data.token,365,this._roothost,"/",null);if(window.jQuery&&_ltk.browser.safari){jQuery("body").append('<iframe id="ctidf" name="ctidf" style="display:none;"></iframe><form id="ctidfr" enctype="application/x-www-form-urlencoded" action="'+this._protocol+this._endpoint+'/CTIDF.ashx" target="ctidf" action="post"><input type="hidden" name="trkt" id="trkt" value="'+data.token+'"/><input type="hidden" name="hctid" id="hctid" value="'+_ltk.Client.CTID+'"/></form>');jQuery("#ctidfr").submit();}}
catch(ex){_ltk.Exception.Submit(ex,'Click Callback');}}}


function _LTKSubscriber(){this.List=null;this.Settings=null;this.Email=null;this.UpdatedEmail=null;this.Profile=new _Profile();this._endpoint='s1.listrakbi.com/t';this._protocol=("https:"==document.location.protocol)?"https://":"http://";_LTKSubscriber.prototype.Submit=function(){var q='ctid='+_ltk.Client.CTID+'&uid='+_ltk.uuidCompact()+'&_t_0=s'+
(this.Email==null?'':'&e_0='+encodeURIComponent(this.Email))+
(this.UpdatedEmail==null?'':'&u_0='+encodeURIComponent(this.UpdatedEmail))+
(this.List==null?'':'&l_0='+encodeURIComponent(this.List))+
(this.Settings==null?'':'&s_0='+encodeURIComponent(this.Settings));if(this.Profile.Items.length>0){for(var i in this.Profile.Items){var p=this.Profile.Items[i];if(p.AttributeID!=null&&p.Value!=null){q+='&'+encodeURIComponent(p.AttributeID)+'_0='+encodeURIComponent(p.Value);}}}
var loc=this._protocol+this._endpoint+'/S.ashx?'+q;var img=new Image();img.width=1;img.height=1;img.src=loc;}}
function _Profile(){this.Items=new Array();_Profile.prototype.Add=function(attr_id,value){var p=new _ProfileItem();p.AttributeID=attr_id;p.Value=value;this.Items.push(p);}}
function _ProfileItem(){this.AttributeID=null;this.Value=null;}

var _ltkwmt = '';
function isWatermark(wmt) {
    if(!_ltkwmt || _ltkwmt.length == 0) {
        return false;
    }
    if(_ltkwmt.indexOf(wmt) >= 0) { 
        return true; 
    }
    else { return false; }
}


function SessionTracker(){this.Assembler=new _Assembler();this.userData=new UserData;this.items=new Array();this.domain=null;this.initialized=false;this.submitQueued=false;this.sessionID;this.tid;this.clearCart=false;this.debug=false;this.FirstName=null;this.LastName=null;this.Email=null;this.Stage=null;this.OrderNumber=null;this.Total=null;this.Meta1=null;this.Meta2=null;this.Token=null;this.CartLink=null;this.Source=null;this.trkt=null;this._varmap={'_type':'_st','Email':'e','FirstName':'fn','LastName':'ln','Meta1':'sm1','Meta2':'sm2','Stage':'st','OrderNumber':'on','Total':'tt','Token':'tk','Source':'sr','CartLink':'cl','NewCustomer':'nc','clearCart':'cc'};function UserData(){this._varmap={};}
SessionTracker.prototype.Load=function(trackerID){try{var sid=this.getCookie("STSID"+trackerID);this.tid=trackerID;if(sid){this.sessionID=sid;}
this.trkt=this.getCookie("_trkt");this.debug=this.getCookie("STSD"+trackerID)=="1"?true:false;if(location.search.indexOf('__std=1')>0){this.debug=true;}
else if(location.search.indexOf('__std=0')>0){this.debug=false;}
var _stli2=setInterval(function(){if(!window.jQuery){return;}
clearInterval(_stli2);var getTemplateAsyncCall=_ltk.AsyncManager.StartAsyncCall('scaGetTemplate');jQuery.getJSON(_protocol+"sca1.listrakbi.com/Handlers/GetTemplate.ashx?_sid="+sid+"&_tid="+trackerID+"&_t="+new Date().valueOf()+"&callback=?",function(data){try{_ltk.SCA.domain=getCookieDomain();_ltk.SCA.sessionID=data.sessionID;_ltk.SCA.setCookie("STSD"+trackerID,_ltk.SCA.debug?"1":"0",365,_ltk.SCA.domain);_ltk.SCA.setCookie("STSID"+trackerID,data.sessionID,365,_ltk.SCA.domain);_ltk.AsyncManager.CallComplete('scaGetTemplate');_ltk.SCA.initialized=true;if(_ltk.SCA.submitQueued){_ltk.SCA.submitQueued=false;_ltk.SCA.Submit();}
jQuery().ready(function(){try{if(_ltk.browser.safari){jQuery("body").append('<iframe id="ifscasidframe" name="ifscasidframe" style="display:none;"></iframe><form id="ifscasidform" enctype="application/x-www-form-urlencoded" action="'+_protocol+'sca1.listrakbi.com/Handlers/CTID.ashx" target="ifscasidframe" action="post"><input type="hidden" name="ifscasid" id="ifscasid" value="'+_ltk.SCA.sessionID+'"/><input type="hidden" name="a" id="a" value="s"/><input type="hidden" name="tid" id="tid" value="'+_ltk.SCA.tid+'"/></form>');jQuery("#ifscasidform").submit();}}
catch(ex){_ltk.Exception.Submit(ex,'ifscasid');}});}
catch(ex){_ltk.Exception.Submit(ex,'GetTemplate Callback');}});},100);}
catch(ex){_ltk.Exception.Submit(ex,'Load');}}
SessionTracker.prototype.SetCustomer=function(email,firstname,lastname){if(email){this.Email=email;}
if(firstname){this.FirstName=firstname;}
if(lastname){this.LastName=lastname;}}
SessionTracker.prototype.CaptureEmail=function(id){try{var _stsi1=setInterval(function(){if(!window.jQuery){return;}
clearInterval(_stsi1);if(typeof id=="undefined"||id==""){return;}
var _sl=jQuery("[id='"+id+"']");if(_sl.length==0){_sl=jQuery("input[name='"+id+"']");}
if(_sl.length){_sl.change(function(){if(jQuery(this).val().length>0&&!isWatermark(jQuery(this).val())&&_ltk.isValidEmail(jQuery(this).val())){_ltk.SCA.Update("email",jQuery(this).val());}});if(jQuery(_sl).val().length>0&&!isWatermark(jQuery(_sl).val())&&_ltk.isValidEmail(jQuery(_sl).val())){_ltk.SCA.Update("email",jQuery(_sl).val());}}},100);}
catch(ex){_ltk.Exception.Submit(ex,'CaptureEmail');}}
SessionTracker.prototype.AddItem=function(sku,quantity,price,name){this.items.push(new SCAItem(sku,quantity,price,name));}
SessionTracker.prototype.AddItemWithLinks=function(sku,quantity,price,name,imageurl,linkurl){try{var _ni=new SCAItem(sku,quantity,price,name);_ni.ImageUrl=imageurl;_ni.LinkUrl=linkurl;this.items.push(_ni);}
catch(ex){_ltk.Exception.Submit(ex,'Add Item With Links');}}
SessionTracker.prototype.AddItemEx=function(item){this.items.push(item);}
SessionTracker.prototype.Update=function(k,v){try{var _scuir=0;var _scui=setInterval(function(){if(!_ltk.SCA.sessionID&&_scuir<6){_scuir++;return;}
clearInterval(_scui);var _uimg=new Image();jQuery(_uimg).error(function(e){_ltk.Exception.Submit({name:"ex"},'Update Image');});_uimg.src=_protocol+'sca1.listrakbi.com/Handlers/Update.ashx?_sid='+_ltk.SCA.sessionID+'&_uid='+_ltk.uuidCompact()+'&_tid='+_ltk.SCA.tid+"&"+k+"="+v+"&_t="+new Date().valueOf();},500);}
catch(ex){_ltk.Exception.Submit(ex,'Update');}}
SessionTracker.prototype.SetData=function(k,v){if(v){this.userData[k.toLowerCase()]=v;if(!this.userData._varmap[k])this.userData._varmap[k]=k;}}
SessionTracker.prototype.ClearCart=function(){this.clearCart=true;this.Submit();}
SessionTracker.prototype.Submit=function(){try{if(!this.initialized){this.submitQueued=true;return;}
if(typeof this.sessionID=="undefined"){return;}
if(this.getCookie("_trkt")!=""){this.Token=this.getCookie("_trkt");}
this.Assembler=new _Assembler();this.Assembler.QueryMode=1;this.Assembler.EndPointArray=['sca1.listrakbi.com/','sca2.listrakbi.com/'];this.Assembler.EndPointPath='Handlers/Set.ashx';this.Assembler.QueryHeader='_sid='+this.sessionID+'&_tid='+this.tid+'&_uid='+_ltk.uuidCompact();this.Assembler.AddObject(this);if(this.OrderNumber==null){this.Assembler.AddArrayObject(this.items);}
if(this.userData){this.Assembler.AddObject(this.userData);}
this.Assembler.Flush();if(this.OrderNumber!=null){_ltk.SCA.setCookie("STSID"+this.tid,"",-1,this.domain);try{if(window.jQuery&&_ltk.browser.safari){jQuery("body").append('<iframe id="ifscasidframec" name="ifscasidframec" style="display:none;"></iframe><form id="ifscasidformc" enctype="application/x-www-form-urlencoded" action="'+_protocol+'sca1.listrakbi.com/Handlers/CTID.ashx" target="ifscasidframec" action="post"><input type="hidden" name="ifscasid" id="ifscasid" value="'+_ltk.SCA.sessionID+'"/><input type="hidden" name="a" id="a" value="c"/><input type="hidden" name="tid" id="tid" value="'+_ltk.SCA.tid+'"/></form>');jQuery("#ifscasidformc").submit();}}
catch(ex){_ltk.Exception.Submit(ex,'ifscasidc');}}
this.Reset();}
catch(ex){_ltk.Exception.Submit(ex,'Submit');}}
SessionTracker.prototype.getCookie=function(c_name){if(document.cookie.length>0){c_start=document.cookie.indexOf(c_name+"=");if(c_start!=-1){c_start=c_start+c_name.length+1;c_end=document.cookie.indexOf(";",c_start);if(c_end==-1)c_end=document.cookie.length;return unescape(document.cookie.substring(c_start,c_end));}}
return"";}
SessionTracker.prototype.setCookie=function(c_name,value,expiredays,domain){var exdate=new Date();exdate.setDate(exdate.getDate()+expiredays);document.cookie=c_name+"="+escape(value)+
((expiredays==null)?"":";expires="+exdate.toGMTString()+";domain="+domain+";path=/;");}
SessionTracker.prototype.Reset=function(){this.items=new Array();this.clearCart=false;}}
function SCAItem(sku,quantity,price,name){this.Sku=sku;this.Quantity=quantity;this.Price=price;this.Name=name;this.ImageUrl=null;this.LinkUrl=null;this.Size=null;this.Meta1=null;this.Meta2=null;this._isIndexable=true;this._varmap={'_type':'_i','Sku':'s','Quantity':'q','Price':'p','Name':'n','ImageUrl':'iu','LinkUrl':'lu','Size':'sz','Meta1':'m1','Meta2':'m2'};}
function getCookieDomain(){var rdhRESM=window.location.host.match(/([\.]*[^\.]+\.(co\.uk|com|net|biz|org|co\.nz|info|jp|edu|mx|com\.br|es|ca|pro|co|au|de)$)|(^localhost$)/gi);if(rdhRESM){if(rdhRESM[0].indexOf(".")!=0){return"."+rdhRESM[0];}
else{return rdhRESM[0];}}
else{return window.location.host;}}


function _ActivityList(){this.Assembler=new _Assembler();this.Activity=new Array();this.MerchantTrackingID=null;this.GlobalSessionID=null;this.SessionID=null;this.TrackingToken=null;this._varmap={'GlobalSessionID':'gsid','SessionID':'sid','TrackingToken':'trkt'};}
function Activity(){this._type='at';this._isIndexable=true;this.ActivityType='browse';this.Sku=null;this.Price=null;this.LinkURL=null;this.ImageURL=null;this.ActivityData=null;this.VisitedPage=getUrlParts(window.location).pathname;this._varmap={'_type':'_t','ActivityType':'t','Sku':'s','ActivityData':'d','VisitedPage':'pg'};}
_ActivityList.prototype.Load=function(){var TrackerID='397067';this.TrackingToken=_ltk.GetCookie("_trkt");this.MerchantTrackingID='PuJr8IyoDRkn';this.SessionID=_ltk.SCA.SessionID;if(this.SessionID==null)
this.SessionID=_ltk.GetCookie("STSID"+TrackerID);this.GlobalSessionID=_ltk.GetCookie("_gsid");if(this.GlobalSessionID==null){this.GetGSID();}}
_ActivityList.prototype.AddActivity=function(ActivityType,Sku){var _activity=new Activity;_activity.ActivityType=ActivityType;if(Sku!=undefined)
_activity.Sku=Sku;this.Activity.push(_activity);}
_ActivityList.prototype.AddActivityEx=function(Activity){this.Activity.push(Activity);}
_ActivityList.prototype.Submit=function(){this.Load();_ltk.AsyncManager.StartAsyncCall('submitActivity',function(){try{if(typeof _ltk.Activity.SessionID=="undefined"){return;}
_ltk.Activity.Assembler=new _Assembler();_ltk.Activity.Assembler.QueryMode=1;_ltk.Activity.Assembler.EndPointArray=new Array();_ltk.Activity.Assembler.EndPointArray.push('at1.listrakbi.com');_ltk.Activity.Assembler.EndPointPath='/Handlers/Set.ashx';_ltk.Activity.Assembler.QueryHeader='ctid='+_ltk.Activity.MerchantTrackingID+'&uid='+_ltk.uuidCompact();_ltk.Activity.Assembler.AddObject(_ltk.Activity);_ltk.Activity.Assembler.AddArrayObject(_ltk.Activity.Activity);_ltk.Activity.Assembler.Flush();_ltk.Activity.Activity.length=0;}
catch(ex){_ltk.Exception.Submit(ex,'Submit');}},['getGSID','clickSubmit','scaGetTemplate']);}
function getUrlParts(url){var a=document.createElement('a');a.href=url;return{href:a.href,host:a.host,hostname:a.hostname,port:a.port,pathname:a.pathname,protocol:a.protocol,hash:a.hash,search:a.search};}
_ActivityList.prototype.GetGSID=function(){var gsidAsyncCall=_ltk.AsyncManager.StartAsyncCall('getGSID');try{jQuery.getJSON(_protocol+"at1.listrakbi.com/Handlers/GetGSID.ashx?callback=?",function(data){try{_ltk.Activity.GlobalSessionID=data.gsid;_ltk.Click.SetCookie("_gsid",data.gsid,365,getCookieDomain(),"/",null);}
catch(ex){_ltk.Exception.Submit(ex,'GetGSID Callback');}
_ltk.AsyncManager.CallComplete('getGSID');});}
catch(ex){_ltk.Exception.Submit(ex,'GetGSID');gsidAsyncCall.Complete();}}


function _Alerts(){this.Assembler=new _Assembler();this.Alert=new Array();this.MerchantTrackingID='';this._varmap={};}
function Alert(){this._type='al';this._isIndexable=true;this.Email='';this.Sku='';this.AlertCode='';this._varmap={'_type':'_t','Email':'e','Sku':'s','AlertCode':'ac'};}
_Alerts.prototype.AddAlert=function(Email,Sku,AlertCode){var _alert=new Alert;_alert.Email=Email;_alert.Sku=Sku;_alert.AlertCode=AlertCode;this.Alert.push(_alert);}
_Alerts.prototype.AddAlertEx=function(Alert){this.Alert.push(Alert);}
_Alerts.prototype.Load=function(){this.MerchantTrackingID='PuJr8IyoDRkn';}
_Alerts.prototype.Submit=function(){try{this.Load();this.Assembler=new _Assembler();this.Assembler.QueryMode=1;this.Assembler.EndPointArray=new Array();this.Assembler.EndPointArray.push('al1.listrakbi.com');this.Assembler.EndPointPath='/Handlers/Set.ashx';this.Assembler.QueryHeader='ctid='+this.MerchantTrackingID+'&uid='+_ltk.uuidCompact();this.Assembler.AddObject(this);this.Assembler.AddArrayObject(this.Alert);this.Assembler.Flush();this.Alert.length=0;}
catch(ex){_ltk.Exception.Submit(ex,'Submit');}}

if(typeof _ltk == "undefined")
{
    var _ltk = new LTK();
    _ltk.Client.CTID = "PuJr8IyoDRkn";
    
    _ltk.SCA.Load("397067");
    
}

















if (document.dispatchEvent)
{
    var customEvent = document.createEvent('Event');
    customEvent.initEvent('ltkAsyncListener', false, false);
    document.dispatchEvent(customEvent);
}
else if (document.fireEvent)
{
    document.documentElement.ltkAsyncProperty += 1;
}

