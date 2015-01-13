var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    bindEvents: function() {
        document.getElementById('qq-login').addEventListener('click',function(){
            qqLogin.ssoLogin(function(res){
                alert('uid:'+res.uid+'  token:'+res.token);
            },function(){
                alert('error');
            });

        },false);

        document.getElementById('weibo-login').addEventListener('click',function(){
            weiboLogin.ssoLogin(function(res){
                alert('uid:'+res.uid+'  token:'+res.token);
            },function(){
                alert('error');
            });

        },false);
        document.getElementById('renren-login').addEventListener('click',function(){
            renrenLogin.ssoLogin(function(res){
                alert('uid:'+res.uid+'  token:'+res.token);
            },function(){
                alert('error');
            });

        },false);


    }


};
document.addEventListener('deviceready', function(){

    app.initialize();

}, false);
