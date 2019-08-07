//
//  ConfigUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ConfigUtil.h"

@interface ConfigUtil ()

@property (nonatomic, strong) NSNumber *mainNet;

@end

@implementation ConfigUtil

+ (instancetype)shareInstance {
    static dispatch_once_t pred = 0;
    __strong static ConfigUtil *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc] init];
    });
    return sharedObj;
}

+ (void)setServerNetworkEnvironment:(BOOL)mainNet {
    [ConfigUtil shareInstance].mainNet = @(mainNet);
}

+ (BOOL)isMainNetOfServerNetwork {
    NSNumber *mainNet = [ConfigUtil shareInstance].mainNet;
    if (mainNet == nil || [mainNet boolValue] == YES) {
        return YES;
    } else {
        return NO;
    }
}
    
+ (NSDictionary *)getConfig {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = @"";
    if ([ConfigUtil isMainNetOfServerNetwork]) {
        path = [bundle pathForResource:@"ConfigurationRelease" ofType:@"plist"];
    } else {
        path = [bundle pathForResource:@"ConfigurationDebug" ofType:@"plist"];
    }
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:path];
    return config;
}

+ (NSString *)getServerDomain {
    NSDictionary *config = [ConfigUtil getConfig];
    NSString *serverDomain = config[@"ServerDomain"];
//    NSLog(@"配置文件url = %@",serverDomain);
    return serverDomain;
}
    
+ (NSString *)getMIFI {
    NSDictionary *config = [ConfigUtil getConfig];
    NSString *mifi = config[@"MIFI"];
    return mifi;
}

+ (NSString *)getChannel {
    NSDictionary *config = [ConfigUtil getConfig];
    NSString *channel = config[@"Channel"];
    return channel;
}

+ (void)setLocalUsingCurrency:(NSString *)currency {
    [HWUserdefault insertObj:currency withkey:Local_Currency];
}

+ (NSString *)getLocalUsingCurrency {
    NSString *currency = [HWUserdefault getObjectWithKey:Local_Currency];
    if (![currency isKindOfClass:[NSString class]]) {
        return @"USD";
    }
    return currency?:@"USD";
}

+ (NSString *)getLocalUsingCurrencySymbol {
    NSString *currency = [ConfigUtil getLocalUsingCurrency];
    NSInteger index = [[ConfigUtil getLocalCurrencyArr] indexOfObject:currency];
    return [ConfigUtil getLocalCurrencySymbolArr][index];
}

+ (NSArray *)getLocalCurrencyArr {
    return @[@"USD",@"CNY"];
}

+ (NSArray *)getLocalCurrencySymbolArr {
    return @[@"$",@"￥"];
}

+ (void)setLocalTouch:(BOOL)show {
    [HWUserdefault insertObj:@(show) withkey:Local_Show_Touch];
}

+ (BOOL)getLocalTouch {
    
    return YES;
    
    NSNumber *localTouch = [HWUserdefault getObjectWithKey:Local_Show_Touch]?:@(YES);
    if (![localTouch isKindOfClass:[NSNumber class]]) {
        localTouch = @(YES);
    }
    return [localTouch boolValue];
}

@end
