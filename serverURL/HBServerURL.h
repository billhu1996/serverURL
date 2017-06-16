//
//  HBServerURL.h
//  serverURL
//
//  Created by Bill Hu on 2017/6/16.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBServerURL : NSObject

+(NSString *)getWithURL:(NSString *)URL
                 apikey:(NSString *)apikey;

@end
