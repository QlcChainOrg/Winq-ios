//
//  AppDelegate+AppService.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/29.
//  Copyright © 2018 pan. All rights reserved.
//

#import "AppDelegate+AppService.h"
////#import "QlinkTabbarViewController.h"
#import "Qlink-Swift.h"
//#import "LaunchViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "NEOWalletUtil.h"
#import "DDLogUtil.h"
#import <Bugly/Bugly.h>
#import <BGFMDB/BGFMDB.h>
//#import "VPNFileInputView.h"
//#import "QlinkNavViewController.h"
//#import "VPNFileUtil.h"
//#import "OLImage.h"
#import "NotifactionView.h"
//#import "ChatUtil.h"
//#import "VPNOperationUtil.h"
#import <BGFMDB/BGDB.h>
#import "SystemUtil.h"
#import "NeoTransferUtil.h"
#import "DBManageUtil.h"
#import "GuidePageViewController.h"
#import <QLCFramework/QLCFramework.h>
#import "WalletCommonModel.h"
//#import "LocationTracker.h"
//#import "LoginSetPWViewController.h"
//#import "LoginInputPWViewController.h"
//#import "LoginPWModel.h"
//#import "WalletCommonModel.h"
#import "NSBundle+Language.h"
#import "FirebaseUtil.h"
@import Firebase;
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "JPushTagHelper.h"
#import "JPushConstants.h"
#import "AppJumpHelper.h"
#import "ProjectEnum.h"

@interface AppDelegate () <BuglyDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate (AppService)

#pragma mark - 配置Firebase
- (void)configFirebase {
    [FIRApp configure];
    
    [FirebaseUtil logEventWithItemID:Firebase_Event_StartApp itemName:Firebase_Event_StartApp contentType:Firebase_Event_StartApp];
}

#pragma mark - 配置DDLog
- (void)configDDLog {
    //开启DDLog 颜色
    //    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    //    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    //配置DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    //    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7; // 7
    [DDLog addLogger:fileLogger];
    
    //针对单个文件配置DDLog打印级别，尚未测试
    //    [DDLog setLevel:DDLogLevelAll forClass:nil];
    
    //    DDLogVerbose(@"Verbose");
    //    DDLogDebug(@"Debug");
    //    DDLogInfo(@"Info");
    //    DDLogWarn(@"Warn");
    //    DDLogError(@"Error");
    
    [DDLogUtil getDDLog];
}

#pragma mark - 配置App语言
- (void)configAppLanguage {
    NSString *languages = [Language currentLanguageCode]?:@"";
    if ([languages isEmptyString]) {
        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *languageName = appLanguages[0];
        // 默认用系统语言
        if (languageName && [languageName containsString:LanguageCode[1]]) {
            [Language userSelectedLanguage:LanguageCode[1]];
        } else {
            [Language userSelectedLanguage:LanguageCode[0]];
        }
    } else {
        [Language userSelectedLanguage:languages];
    }
}

#pragma mark - 配置手势 默认开启
- (void)configTouch {
    NSString *touchStatu = [HWUserdefault getStringWithKey:TOUCH_SWITCH_KEY];
    if ([[NSStringUtil getNotNullValue:touchStatu] isEmptyString]) {
        [HWUserdefault insertString:@"1" withkey:TOUCH_SWITCH_KEY];
    }
}

#pragma mark - 配置状态栏
- (void)configStatusBar {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - 设置IQKeyboardManager
- (void)keyboardManagerConfig {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:15]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}

#pragma mark - 配置Bugly
- (void)configBugly {
    BuglyConfig * config = [[BuglyConfig alloc] init];
    // 设置自定义日志上报的级别，默认不上报自定义日志
    //    config.reportLogLevel = BuglyLogLevelWarn;
    config.delegate = self;
    [Bugly startWithAppId:Bugly_AppID config:config];
}

#pragma mark - 配置FMDB
- (void)configureFMDB {
    /**
     想测试更多功能,打开注释掉的代码即可.
     */
    bg_setDebug(NO);//打开调试模式,打印输出调试信息.
    
    /**
     如果频繁操作数据库时,建议进行此设置(即在操作过程不关闭数据库);
     */
    bg_setDisableCloseDB(YES);
    
    /**
     自定义数据库名称，否则默认为BGFMDB
     */
    bg_setSqliteName(@"Qlink_DataBase");
    // 判断表名是否存在
    if (![[BGDB shareManager] bg_isExistWithTableName:VPNREGISTER_TABNAME]) {
//        [VPNOperationUtil keyChainDataToDB];
    }
    [DBManageUtil updateDBversion];
}

#pragma mark - 创建p2pid
- (void)configToxP2PNetwork {
    // 初始化实列。并创建c回调
//    [ToxManage shareMange];
    // 创建p2p连接网络
//    [ToxManage createdP2PNetwork];
}

#pragma mark - 获取用户信息
- (void)fetchUserInfo {
    [UserManage fetchUserInfo];
}

//#pragma mark - 配置群聊
//- (void)configChat {
//    [ChatUtil shareInstance];
//}

#pragma mark - 配置极光推送
- (void)configJPush:(NSDictionary *)launchOptions {
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSString *channel = @"";
    BOOL isProduction = NO;
#if DEBUG
    channel = @"Develop";
    isProduction = NO;
#else
    channel = @"App Store";
    isProduction = YES;
#endif
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:launchOptions appKey:JPush_AppKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}

#pragma mark - 是否需要显示引导页
- (void)checkGuidenPage {
    NSString *version = [HWUserdefault getStringWithKey:VERSION_KEY];
    if (![[NSStringUtil getNotNullValue:version] isEqualToString:APP_Version]) {
        [HWUserdefault insertString:APP_Version withkey:VERSION_KEY];
        GuidePageViewController *pageVC = [[GuidePageViewController alloc] init];
        self.window.rootViewController = pageVC;
    } else {
        [self addLaunchAnimation];
    }
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (UIViewController *)getCurrentUIVC {
    UIViewController  *superVC = [self getCurrentVC];
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}


#pragma mark - BuglyDelegate
/**
 *  发生异常时回调
 *
 *  @param exception 异常信息
 *
 *  @return 返回需上报记录，随异常上报一起上报
 */
- (NSString *)attachmentForException:(NSException *)exception  {
    [SystemUtil configureAPPTerminate];
    return nil;
}


#pragma mark - 推送回调
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    [SystemUtil requestBind_jpush]; // 绑定极光推送
    [JPushTagHelper setTags]; // 极光设置tag
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [self handlerPushJump:userInfo isTapLaunch:NO];
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark - 处理推送跳转
- (void)handlerPushJump:(NSDictionary *)userInfo isTapLaunch:(BOOL)isTapLaunch {
    NSString *skip = userInfo[JPush_Extra_Skip];
    if (skip) {
        if ([skip isEqualToString:JPush_Extra_Skip_Debit]) {
            if (isTapLaunch) { // 点击推送启动
                [HWUserdefault insertObj:userInfo withkey:JPush_Tag_Jump];
            } else { // app运行时点击推送
                [HWUserdefault deleteObjectWithKey:JPush_Tag_Jump];
                [AppJumpHelper jumpToDailyEarnings];
            }
        } else if ([skip isEqualToString:JPush_Extra_Skip_Trade_Order]) {
            if (isTapLaunch) { // 点击推送启动
                [HWUserdefault insertObj:userInfo withkey:JPush_Tag_Jump];
            } else { // app运行时点击推送
                [HWUserdefault deleteObjectWithKey:JPush_Tag_Jump];
                [AppJumpHelper jumpToMyOrderList:OTCRecordListTypeCompleted];
            }
        }
    }
}

@end
