/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#include <sys/types.h>
#include <sys/sysctl.h>

#import <Cordova/CDV.h>
#import <Cordova/CDVViewController.h>
#import <TencentOpenAPI/QQApiInterface.h>


#import "QQLogin.h"


@interface QQLogin () {
    
    
}
@property (nonatomic, strong) CDVInvokedUrlCommand *pendingCommand;

@end

@implementation QQLogin

- (void)ssoLogin:(CDVInvokedUrlCommand*)command
{
    NSLog(@"登录");
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"123456789" andDelegate:self];
    _permissions = [[NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_SHARE,
                      nil] retain];
	

    [_tencentOAuth authorize:_permissions inSafari:NO];


    self.pendingCommand = command;
    
    
    
    
}

/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin {
	// 登录成功
    NSLog(@"登录完成");

    
    if (_tencentOAuth.accessToken
        && 0 != [_tencentOAuth.accessToken length])
    {
        NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:_tencentOAuth.openId,@"uid",_tencentOAuth.accessToken,@"token" , nil];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
        NSLog(_tencentOAuth.openId);
        NSLog(_tencentOAuth.accessToken);
        [self.commandDelegate sendPluginResult:result
                                    callbackId:self.pendingCommand.callbackId];
        self.pendingCommand = nil;

        
     }
    else
    {
         NSLog(@"登录失败 没有获取accesstoken");
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:result
                                    callbackId:self.pendingCommand.callbackId];
        self.pendingCommand = nil;


    }
    
  
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
	if (cancelled){
        NSLog(@"用户取消登录");

	}
	else {
         NSLog(@"登录失败");

	}
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    [self.commandDelegate sendPluginResult:result
                                callbackId:self.pendingCommand.callbackId];
    self.pendingCommand = nil;

	
}

/**
 * Called when the notNewWork.
 */
-(void)tencentDidNotNetWork
{
     NSLog(@"无网络连接，请设置网络");
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    [self.commandDelegate sendPluginResult:result
                                callbackId:self.pendingCommand.callbackId];
    self.pendingCommand = nil;


}

/**
 * Called when the logout.
 */
-(void)tencentDidLogout
{
     NSLog(@"退出登录成功，请重新登录");
    
}





@end
