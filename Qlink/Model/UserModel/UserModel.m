//
//  UserModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import "UserModel.h"
#import "NEOWalletUtil.h"

@implementation UserModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"rsaPublicKey" : @"data",
             @"ID": @"id"
             };
}

+(NSDictionary *)mj_objectClassInArray{
    return @{};
}

+ (NSString *)getOwnP2PId {
    NSString *p2pid = [NEOWalletUtil getKeyValue:P2P_KEY];
//    if ([[NSStringUtil getNotNullValue:p2pid] isEmptyString]) {
//        char p2pId[38*2+1];
//        int result =ReturnOwnP2PId(&p2pId);
//        if (result == 0) {
//            p2pid = [NSString stringWithUTF8String:p2pId];
//            [WalletUtil setKeyValue:P2P_KEY value:p2pid];
//        } else {
//            return @"";
//        }
//    }
    return p2pid?:@"";
}

+ (void)storeUser:(UserModel *)model {
    NSData *data = [HWUserdefault getObjectWithKey:UserModel_Local];
    NSMutableArray *muArr = [NSMutableArray array];
    if (!data) {
        [muArr addObject:model];
    } else {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [muArr addObjectsFromArray:arr];
        __block BOOL isExist = NO;
        __block NSInteger existIndex = 0;
        [muArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserModel *tempM = obj;
            if ([tempM.account isEqualToString:model.account]) {
                isExist = YES;
                existIndex = idx;
                *stop = YES;
            }
        }];
        if (!isExist) {
            [muArr addObject:model];
        } else {
            [muArr replaceObjectAtIndex:existIndex withObject:model];
        }
    }
    NSData *archiverData = [NSKeyedArchiver archivedDataWithRootObject:muArr];
    [HWUserdefault insertObj:archiverData withkey:UserModel_Local];
}

+ (UserModel *)fetchUser:(NSString *)account {
    NSData *data = [HWUserdefault getObjectWithKey:UserModel_Local];
    __block UserModel *model = nil;
    if (data) {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserModel *tempM = obj;
            if ([tempM.account isEqualToString:account]) {
                model = tempM;
                *stop = YES;
            }
        }];
    }
    return model;
}

+ (UserModel *)fetchUserOfLogin {
    NSData *data = [HWUserdefault getObjectWithKey:UserModel_Local];
    __block UserModel *model = nil;
    if (data) {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserModel *tempM = obj;
            if ([tempM.isLogin boolValue] == YES) {
                model = tempM;
                *stop = YES;
            }
        }];
    }
    return model;
}

+ (void)cleanUser:(NSString *)account {
    NSData *data = [HWUserdefault getObjectWithKey:UserModel_Local];
    NSMutableArray *muArr = [NSMutableArray array];
    if (data) {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [muArr addObjectsFromArray:arr];
        __block BOOL isExist = NO;
        __block NSInteger existIndex = 0;
        [muArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserModel *tempM = obj;
            if ([tempM.account isEqualToString:account]) {
                isExist = YES;
                existIndex = idx;
                *stop = YES;
            }
        }];
        if (isExist) {
            [muArr removeObjectAtIndex:existIndex];
        }
        NSData *archiverData = [NSKeyedArchiver archivedDataWithRootObject:muArr];
        [HWUserdefault insertObj:archiverData withkey:UserModel_Local];
    }
}

+ (void)cleanAllUser {
    [HWUserdefault deleteObjectWithKey:UserModel_Local];
}

+ (void)logout:(NSString *)account {
    NSData *data = [HWUserdefault getObjectWithKey:UserModel_Local];
    if (data) {
        __block UserModel *model = nil;
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserModel *tempM = obj;
            if ([tempM.account isEqualToString:account]) {
                model = tempM;
                *stop = YES;
            }
        }];
        if (model) {
            model.isLogin = @(NO);
            [UserModel storeUser:model];
        }
    }
}

+ (BOOL)inLogin:(NSString *)account {
    NSData *data = [HWUserdefault getObjectWithKey:UserModel_Local];
    __block BOOL isLogin = NO;
    if (data) {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserModel *tempM = obj;
            if ([tempM.account isEqualToString:account]) {
                isLogin = [tempM.isLogin boolValue];
                *stop = YES;
            }
        }];
    }
    return isLogin;
}

+ (BOOL)haveLoginAccount {
    NSData *data = [HWUserdefault getObjectWithKey:UserModel_Local];
    __block BOOL isLogin = NO;
    if (data) {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserModel *tempM = obj;
            if ([tempM.isLogin boolValue] == YES) {
                isLogin = YES;
                *stop = YES;
            }
        }];
    }
    return isLogin;
}

@end