# phonegap-social-sso

I think people who will use this plugin should be Chinese, so I'll use Chinese in following content. YOOOOOOOO!

这是phonegap plugin，用来做第三方平台登录的，目前有qq、微博、人人三个平台


## qq登录

首先要在[qq互联](http://connect.qq.com/)，创建移动应用，获取appId神马的

然后搭建环境，[ios环境搭建看这里](http://wiki.connect.qq.com/ios_sdk%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA)，[android的在这里](http://wiki.connect.qq.com/%E5%88%9B%E5%BB%BA%E5%B9%B6%E9%85%8D%E7%BD%AE%E5%B7%A5%E7%A8%8B_android_sdk)

环境配好了，Next，就是写代码了，直接把`.java`和`.m` `.h`文件copy到工程里，然后把`www/plugins`下的`qqLogin.js`拷贝到对应的`www/plugins`目录下

还有一步，在工程的`cordova_plugins.js`和`config.xml`里增加对应plugin的说明

ios版
```html
<feature name="QQLogin">
    <param name="ios-package" value="QQLogin" />
</feature>

```


android版
```html
<feature name="QQLogin">
    <param name="android-package" value="com.example.cordova.qqLogin.QQLogin" />
</feature>
```


注意，android版`value`对应的是`QQLogin.java`这个文件所在的路径


最后在对应的js里写上登录按钮的点击事件，比如

```javascript
$('#qq-login').click(function() {
    qqLogin.ssoLogin(function(res) {
        alert('uid:'+res.uid+' token:'+res.token);
    }, function() {
        alert('授权失败');
    });

});
```

另外，ios的`AppDelegate.m`，`openURL`里要加上如下所示代码，当然还要import对应的`.h`文件：
```objective-c

// this happens while we are running ( in the background, or from within our own app )
// only valid if Filpped-Info.plist specifies a protocol to handle
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    if (!url) {
        return NO;
    }

    // calls into javascript global function 'handleOpenURL'
    NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];
    [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];

    // all plugins will get the notification, and their handlers will be called
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];
    // weiboLogin
    WeiboLogin *weiboPlugin = [self.viewController.pluginObjects objectForKey:@"WeiboLogin"];
    [WeiboSDK handleOpenURL:url delegate:weiboPlugin];
    
    // renrenLogin
    RenrenLogin *renrenPlugin = [self.viewController.pluginObjects objectForKey:@"RenrenLogin"];
    [RennClient handleOpenURL:url];
    [TencentOAuth HandleOpenURL:url ];
    QQLogin *qqPlugin = [self.viewController.pluginObjects objectForKey:@"QQLogin"];

    [QQApiInterface handleOpenURL:url delegate:qqPlugin];
    


    
    return YES;
}
```




## 微博登录

和qq基本一致，微博的文档po主放在doc目录下了





## 人人登录

人人文档在这里，[ios版](http://wiki.dev.renren.com/wiki/V2/sdk/objectivec_sdk)，[android](http://wiki.dev.renren.com/wiki/V2/sdk/android_sdk)

步骤和前面的一致



# Update

加上了ios的demo

也有同学问为哈不写成phonegap标准的插件，这样可以命令行安装

因为涉及到第三方的library和配置，所以命令行一键安装不大可行，为了方便大家，准备写第三方登录的demo

# notice

demo里涉及到第三方的appId或者appSecret，大家自己去注册一个吧，demo里由于appId的原因，微博登录是失败滴


# to do

那啥，po主还写了微博、人人、qq、微信分享

等稍微空点写个完整能跑的demo出来

希望能帮到同样挣扎在phonegap这个大坑里的童鞋们

po主真是活雷锋有木有！！（～￣▽￣～）



