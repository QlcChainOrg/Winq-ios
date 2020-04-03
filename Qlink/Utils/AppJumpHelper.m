//
//  PushJumpHelper.m
//  Qlink
//
//  Created by Jelly Foo on 2019/11/26.
//  Copyright © 2019 pan. All rights reserved.
//

#import "AppJumpHelper.h"
#import "TradeOrderDetailViewController.h"
#import "GlobalConstants.h"
#import "QlinkTabbarViewController.h"
#import "MainTabbarViewController.h"
#import "QNavigationController.h"
#import "UserModel.h"
#import "ClaimQGASTipView.h"
#import "DailyEarningsViewController.h"
#import "RecordListViewController.h"

@implementation AppJumpHelper

+ (void)jumpToWallet {
    if (kAppD.needFingerprintVerification) {
        [kAppD presentFingerprintVerify:^{
            kAppD.mtabbarC.selectedIndex = TabbarIndexWallet;
        }];
    } else {
        kAppD.mtabbarC.selectedIndex = TabbarIndexWallet;
    }
}

+ (void)jumpToOTC {
    kAppD.mtabbarC.selectedIndex = TabbarIndexFinance;
}

+ (void)jumpToTopup {
    kAppD.mtabbarC.selectedIndex = TabbarIndexTopup;
}

+ (void)jumpToDailyEarnings {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
    if (![UserModel isBind]) {
        [ClaimQGASTipView show:^{
        }];
        return;
    }
    
    DailyEarningsViewController *vc = [DailyEarningsViewController new];
    [((QNavigationController *)kAppD.mtabbarC.selectedViewController) pushViewController:vc animated:YES];
}

+ (void)jumpToMyOrderList:(OTCRecordListType)listType {
    BOOL haveLogin = [UserModel haveLoginAccount];
    if (!haveLogin) {
        [kAppD presentLoginNew];
        return;
    }
    
    RecordListViewController *vc = [RecordListViewController new];
    vc.inputType = listType;
    [((QNavigationController *)kAppD.mtabbarC.selectedViewController) pushViewController:vc animated:YES];
}

@end
