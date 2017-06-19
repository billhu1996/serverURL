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
    }
    NSLog(@"Successful get URL from caches, URL:%@", realURL);
    return realURL;
}

//同步获取URL
+ (NSString *)getWithVersion:(NSString *)version
                 appBundleID:(NSString *)appBundleID
                         url:(NSString *)url
                      apikey:(NSString *)apikey {
    NSURL *URL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@?api_key=%@&filter=(version=%@) and (bundle_id=%@)", url, apikey, version, appBundleID] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:60];
    
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
    if (error != nil || object == nil || !([object isKindOfClass:[NSDictionary class]]) || object[@"resource"] == nil || [object[@"resource"] count] < 1 || object[@"resource"][0] == nil) {
        NSLog(@"Can't get url, Error: %@", error);
        return @{
                 @"url": @"https://www.example.com"
                 };
    }
    NSLog(@"Ssuccessful get url, URL: %@", object[@"resource"][0][@"url"]);
    return object[@"resource"][0];
}

@end
