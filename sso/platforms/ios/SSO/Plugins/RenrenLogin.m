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
    int loginType;
    
}
@property (nonatomic, strong) CDVInvokedUrlCommand *pendingCommand;


@end

@implementation RenrenLogin

- (void)ssoLogin:(CDVInvokedUrlCommand*)command
{
    NSLog(@"登录");
    [RennClient initWithAppId:@"270043" apiKey:@"f89255bf41c1454193454f53055c2e85" secretKey:@"2e31e1b7bb044e16bc36776d4c0cfbbe"];
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



- (void)share:(CDVInvokedUrlCommand*)command{
    self.pendingCommand = command;
    
    if (![RennClient isLogin]) {
        loginType=1;
        [RennClient initWithAppId:@"270043" apiKey:@"f89255bf41c1454193454f53055c2e85" secretKey:@"2e31e1b7bb044e16bc36776d4c0cfbbe"];
        
        [RennClient loginWithDelegate:self];
    }else{
        [self shareLink];
    }
    
    
    
}
- (void)shareLink{
    NSString *title = [self parseStringFromJS:self.pendingCommand.arguments keyFromJS:@"title"];
    NSString *description = [self parseStringFromJS:self.pendingCommand.arguments keyFromJS:@"desc"];
    NSString *url = [self parseStringFromJS:self.pendingCommand.arguments keyFromJS:@"url"];
    
    PutShareUrlParam *param = [[[PutShareUrlParam alloc] init] autorelease];
    param.comment = description;
    param.url = url;
    [RennClient sendAsynRequest:param delegate:self];
    
    
}



- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    NSLog(@"requestSuccessWithResponse:%@", [response description]);
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result
                                callbackId:self.pendingCommand.callbackId];
    
    
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    NSLog(@"requestFailWithError:%@", [error description]);
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    [self.commandDelegate sendPluginResult:result
                                callbackId:self.pendingCommand.callbackId];
    
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
    if(loginType!=1){
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
        
        [self.commandDelegate sendPluginResult:result
                                    callbackId:self.pendingCommand.callbackId];
        self.pendingCommand = nil;
    }else{
        [self shareLink];
        
        
    }
    
    
    
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


- (BOOL)existCommandArguments:(NSArray*)comArguments{
    NSMutableArray *commandArguments=[[NSMutableArray alloc] initWithArray:comArguments];
    if (commandArguments && commandArguments.count > 0) {
        return TRUE;
    }else{
        return FALSE;
    }
}

- (NSString*)parseStringFromJS:(NSArray*)commandArguments keyFromJS:(NSString*)key{
    if([self existCommandArguments:commandArguments]){
        NSString *value = [[commandArguments objectAtIndex:0] valueForKey:key];
        if(value){
            return [NSString stringWithFormat:@"%@",value];
        }else{
            return @"";
        }
    }else{
        return @"";
    }
}







@end
