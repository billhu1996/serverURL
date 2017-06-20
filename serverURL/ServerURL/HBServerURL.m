//
//  HBServerURL.m
//  serverURL
//
//  Created by Bill Hu on 2017/6/16.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "HBServerURL.h"

@implementation HBServerURL

+ (NSString *)getWithBundleIDandURL:(NSString *)URL
                             apikey:(NSString *)apikey {
    NSString *appBundleID = [[NSBundle mainBundle] bundleIdentifier];
    return [self getWithNickname:appBundleID URL:URL apikey:apikey];
}

+ (NSString *)getWithAppNameAndURL:(NSString *)URL
                            apikey:(NSString *)apikey {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = infoDict[@"CFBundleDisplayName"];
    return [self getWithNickname:appName URL:URL apikey:apikey];
}

+ (NSString *)getWithNickname:(NSString *)nickname
                          URL:(NSString *)URL
                       apikey:(NSString *)apikey {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = infoDict[@"CFBundleShortVersionString"];
    NSString *realURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"HBServerURL"];
    if (!realURL || [realURL isEqualToString:@"https://www.example.com"]) {
        realURL = [self getWithVersion:version appBundleID:nickname url:URL apikey:apikey];
        [[NSUserDefaults standardUserDefaults] setObject:realURL forKey:@"HBServerURL"];
    } else {
        NSLog(@"Successful get URL from caches, URL:%@", realURL);
    }
    return realURL;
}

//同步获取URL
+ (NSString *)getWithVersion:(NSString *)version
                 appBundleID:(NSString *)appBundleID
                         url:(NSString *)url
                      apikey:(NSString *)apikey {
    NSURL *URL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@?api_key=%@&filter=(version=%@)and(bundle_id=%@)", url, apikey, version, appBundleID] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:6];
    
    return [self sendSynchronousRequest:request][@"url"];
}

+ (NSDictionary *)sendSynchronousRequest:(NSURLRequest *)request{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSError *error;
    NSData __block *data;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
        
        data = _data;
        dispatch_semaphore_signal(semaphore);
        
    }] resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    id object;
    if (data) {
        NSError *error;
        object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    }
    if (object != nil && ([object isKindOfClass:[NSDictionary class]]) && object[@"session_token"] != nil) {
        return object;
    }
    if (error != nil || object == nil || !([object isKindOfClass:[NSDictionary class]]) || object[@"resource"] == nil || [object[@"resource"] count] < 1 || object[@"resource"][0] == nil) {
        NSLog(@"Can't get url, Error: %@", error);
        NSLog(@"error %@", object[@"error"][@"message"]);
        return @{
                 @"url": @"https://www.example.com"
                 };
    }
    NSLog(@"Successful get url, URL: %@", object[@"resource"][0][@"url"]);
    return object[@"resource"][0];
}


+ (NSString *)setWithUsername:(NSString *)username
                     password:(NSString *)password
                     loginURL:(NSString *)loginURL
                          URL:(NSString *)URL
                       apikey:(NSString *)apikey
                      version:(NSString *)version
                     nickName:(NSString *)nickName
                      realURL:(NSString *)realURL {
    NSError *error;
    NSData *loginBody = [NSJSONSerialization dataWithJSONObject:@{
                                                                  @"email": username,
                                                                  @"password": password
                                                                  }
                                                        options:0
                                                          error:&error];
    NSURL *lurl = [NSURL URLWithString:[[NSString stringWithFormat:@"%@?api_key=%@", loginURL, apikey] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:lurl];
    [loginRequest setHTTPMethod:@"POST"];
    [loginRequest setAllHTTPHeaderFields:@{@"Content-Type": @"application/json"}];
    [loginRequest setHTTPBody:loginBody];
    [loginRequest setTimeoutInterval:6];
    NSString *session = [self sendSynchronousRequest:loginRequest][@"session_token"];
    
    id body = [NSJSONSerialization dataWithJSONObject:@{
                                                        @"resource": @[
                                                                @{
                                                                    @"version": version,
                                                                    @"bundle_id": nickName,
                                                                    @"url": realURL
                                                                    }
                                                                ]
                                                        }
                                              options:0
                                                error:&error];
    NSURL *purl = [NSURL URLWithString:[[NSString stringWithFormat:@"%@?api_key=%@&session_token=%@", URL, apikey, session] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:purl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:@{@"Content-Type": @"application/json"}];
    [request setHTTPBody:body];
    NSDictionary *result = [self sendSynchronousRequest:request];
    if (result[@"id"]) {
        return [NSString stringWithFormat:@"%@", result[@"id"]];
    } else {
        return result[@"url"];
    }
}

+ (NSString *)eidtWithUsername:(NSString *)username
                      password:(NSString *)password
                      loginURL:(NSString *)loginURL
                           URL:(NSString *)URL
                        apikey:(NSString *)apikey
                       version:(NSString *)version
                      nickName:(NSString *)nickName
                    newRealURL:(NSString *)newRealURL {
    NSError *error;
    NSData *loginBody = [NSJSONSerialization dataWithJSONObject:@{
                                                                  @"email": username,
                                                                  @"password": password
                                                                  }
                                                        options:0
                                                          error:&error];
    NSURL *lurl = [NSURL URLWithString:[[NSString stringWithFormat:@"%@?api_key=%@", loginURL, apikey] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:lurl];
    [loginRequest setHTTPMethod:@"POST"];
    [loginRequest setAllHTTPHeaderFields:@{@"Content-Type": @"application/json"}];
    [loginRequest setHTTPBody:loginBody];
    [loginRequest setTimeoutInterval:6];
    NSString *session = [self sendSynchronousRequest:loginRequest][@"session_token"];
    
    id body = [NSJSONSerialization dataWithJSONObject:@{
                                                        @"resource": @[
                                                                @{
                                                                    @"version": version,
                                                                    @"bundle_id": nickName,
                                                                    @"url": newRealURL
                                                                    }
                                                                ]
                                                        }
                                              options:0
                                                error:&error];
    NSURL *purl = [NSURL URLWithString:[[NSString stringWithFormat:@"%@?api_key=%@&session_token=%@&filter=(bundle_id=%@)and(version=%@)", URL, apikey, session, nickName, version] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:purl];
    [request setHTTPMethod:@"PATCH"];
    [request setAllHTTPHeaderFields:@{@"Content-Type": @"application/json"}];
    [request setHTTPBody:body];
    [request setTimeoutInterval:6];
    NSDictionary *result = [self sendSynchronousRequest:request];
    if (result[@"id"]) {
        return [NSString stringWithFormat:@"%@", result[@"id"]];
    } else {
        return result[@"url"];
    }
}

@end
