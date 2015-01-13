cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [

 {
    "file": "plugins/com.example.cordova.weiboLogin/www/weiboLogin.js",
    "id": "com.example.cordova.weiboLogin",
    "clobbers": [
        "weiboLogin"
    ]
}, {
    "file": "plugins/com.example.cordova.renrenLogin/www/renrenLogin.js",
    "id": "com.example.cordova.renrenLogin",
    "clobbers": [
        "renrenLogin"
    ]
}, {
    "file": "plugins/com.example.cordova.qqLogin/www/qqLogin.js",
    "id": "com.example.cordova.qqLogin",
    "clobbers": [
        "qqLogin"
    ]
}


];
module.exports.metadata = 
// TOP OF METADATA
{}
// BOTTOM OF METADATA
});