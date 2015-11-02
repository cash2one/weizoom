
// 获得get查询参数
var getParam = function (name) {
    var search = document.location.search;
    var pattern = new RegExp("[?&]" + name + "\=([^&]+)", "g");
    var matcher = pattern.exec(search);
    var items = null;
    if (null != matcher) {
        try {
            items = decodeURIComponent(decodeURIComponent(matcher[1]));
        } catch (e) {
            try {
                items = decodeURIComponent(matcher[1]);
            } catch (e) {
                items = matcher[1];
            }
        }
    }
    return items;
};

// 深拷贝JSON
var deepCopyJSON = function(obj){
    return JSON.parse(JSON.stringify(obj));
};

// 创建createdAt属性，为1970 年 1 月 1 日至今的毫秒数
var setCreatedAt = function(obj){
    now = new Date();
    obj.createdAt = now.getTime();
    return obj;
};
//var getLocalStorageJsonList = function (name) {
//    var list = localStorage.name;
//    list = list.split('|');
//
//};

//*********** weapp部分 **********

var getWoid = function(){
    return getParam('woid')
};


var urlFilter = function(url){
	return url.replace(/&/g, '%26')
};


var getRedirectUrlQueryString = function(){
    var woid = getWoid();
    // 入口是图文
    var sign = getParam('sign');
    if(sign == 'material_news'){
        return 'woid='+woid+'&module=mall&model=address&action=list&sign=material_news';
    }

    // 参数中包含
    var redirect_url_query_string = getParam('redirect_url_query_string');
    if(redirect_url_query_string){
        if(redirect_url_query_string.indexOf('user_center')>0){
            return 'woid='+woid+'&module=mall&model=address&action=list&sign=material_news';
        }
        return redirect_url_query_string;
    }

    // 当前页面的参数
    if(getParam('product_ids')||getParam('product_id')){
        return window.location.search;
    }

    // 前一页的参数
    strs = document.referrer.split("/?");
    if(strs.length>1){
        return strs[1]
    }

    return '#'
};


var initShipInofs = function(){
    localStorage.removeItem('ship_infos');

    W.getApi().call({
        app: 'webapp',
        api: 'project_api/call',
        method: 'get',
        args: {
            woid: W.webappOwnerId,
            module: 'mall',
            target_api: 'address/list',
        },
        success: function(data) {
            ship_infos = data.ship_infos;
            infos = {};
            for(i in ship_infos){
                infos[ship_infos[i].ship_id] = ship_infos[i]
            }
            localStorage.ship_infos=JSON.stringify(infos);
        },
        error: function(resp) {
        }
    });
};

