//
//  HBServerURL.h
//  serverURL
//
//  Created by Bill Hu on 2017/6/16.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBServerURL : NSObject

//直接用Bundle ID获取url, 不适合具有appExtension类应用
+ (NSString *)getWithBundleIDandURL:(NSString *)URL
                             apikey:(NSString *)apikey;

//直接用app Display Name获取, 如果名字过长建议尽量避免使用
+ (NSString *)getWithAppNameAndURL:(NSString *)URL
                            apikey:(NSString *)apikey;

//用自定义的nickname获取, 涉及多个后端地址时使用更方便
+ (NSString *)getWithNickname:(NSString *)nickname
                          URL:(NSString *)URL
                       apikey:(NSString *)apikey;

//用完整信息获取
+ (NSString *)getWithVersion:(NSString *)version
                 appBundleID:(NSString *)appBundleID
                         url:(NSString *)url
                      apikey:(NSString *)apikey;

//请在在使用前调用创建, 上架前修改 PS: URL为dreamFactory地址, realURL为存储的URL
+ (NSString *)setWithUsername:(NSString *)username
                     password:(NSString *)password
                     loginURL:(NSString *)loginURL
                          URL:(NSString *)URL
                       apikey:(NSString *)apikey
                      version:(NSString *)version
                     nickName:(NSString *)nickName
                      realURL:(NSString *)realURL;

//请在在使用前调用创建, 上架前修改 PS: URL为dreamFactory地址, realURL为存储的URL
+ (NSString *)eidtWithUsername:(NSString *)username
                      password:(NSString *)password
                      loginURL:(NSString *)loginURL
                           URL:(NSString *)URL
                        apikey:(NSString *)apikey
                       version:(NSString *)version
                      nickName:(NSString *)nickName
                    newRealURL:(NSString *)newRealURL;


@end
