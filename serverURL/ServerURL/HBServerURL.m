//
//  HBServerURL.m
//  serverURL
//
//  Created by Bill Hu on 2017/6/16.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "HBServerURL.h"

@implementation HBServerURL

+(NSString *)getWithURL:(NSString *)URL
                 apikey:(NSString *)apikey {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appBundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *version = infoDict[@"CFBundleShortVersionString"];
    NSString *realURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"HBServerURL"];
    if (!realURL || [realURL isEqualToString:@"https://www.apple.com"]) {
        realURL = [self getWithVersion:version appBundleID:appBundleID url:URL apikey:apikey];
        [[NSUserDefaults standardUserDefaults] setObject:realURL forKey:@"HBServerURL"];
        
    }
    return realURL;
}

+(NSString *)getWithVersion:(NSString *)version
                appBundleID:(NSString *)appBundleID
                 url:(NSString *)url
              apikey:(NSString *)apikey {
    NSURL *URL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@?api_key=%@&filter=(version=%@) and (bundle_id=%@)", url, apikey, version, appBundleID] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:60];
    
    return [self sendSynchronousRequest:request][@"url"];
}

+(NSDictionary *)sendSynchronousRequest:(NSURLRequest *)request{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSError *error;
    NSData __block *data;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
        
        data = _data;
        dispatch_semaphore_signal(semaphore);
        
    }] resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil || object == nil || !([object isKindOfClass:[NSDictionary class]]) || !object[@"resource"] || !object[@"resource"][0]) {
        return @{
                 @"url": @"https://www.apple.com"
                 };
    }
    return object[@"resource"][0];
}

@end
