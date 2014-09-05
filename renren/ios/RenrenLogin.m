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

#import "RennSDK/RennSDK.h"

#import "RenrenLogin.h"


@interface RenrenLogin () {
    
    
}
@property (nonatomic, strong) CDVInvokedUrlCommand *pendingCommand;

@end

@implementation RenrenLogin

- (void)ssoLogin:(CDVInvokedUrlCommand*)command
{
    NSLog(@"登录");
    [RennClient initWithAppId:@"123456" apiKey:@"123456789" secretKey:@"123456789"];
    if ([RennClient isLogin]) {
        NSLog(@"已经登录");
        RennAccessToken *access = [RennClient accessToken];

        NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:[RennClient uid],@"uid",access.accessToken,@"token" , nil];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
        NSLog(@"renren tokenType = %@",access.tokenType);
        NSLog(@"renren accessToken = %@",access.accessToken);
        NSLog(@"renren uid = %@",[RennClient uid]);

 
    }else{
        [RennClient loginWithDelegate:self];

    }
    

     self.pendingCommand = command;
    
    
    
    
}

- (void)ssoLogout:(CDVInvokedUrlCommand*)command
{
    if ([RennClient isLogin]) {
        [RennClient logoutWithDelegate:self];

    }else{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
    }
    self.pendingCommand = command;



}


- (void)rennLoginSuccess
{
    RennAccessToken *access = [RennClient accessToken];

    NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:[RennClient uid],@"uid",access.accessToken,@"token" , nil];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];

    [self.commandDelegate sendPluginResult:result
                                callbackId:self.pendingCommand.callbackId];
    self.pendingCommand = nil;


    NSLog(@"登录成功");
    NSLog(@"renren tokenType = %@",access.tokenType);
    NSLog(@"renren accessToken = %@",access.accessToken);
    NSLog(@"renren uid = %@",[RennClient uid]);

 }

- (void)rennLogoutSuccess
{
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    [self.commandDelegate sendPluginResult:result
                                callbackId:self.pendingCommand.callbackId];
    self.pendingCommand = nil;
    
    

    NSLog(@"注销成功");
}








@end
