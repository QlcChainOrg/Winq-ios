//
//  TransferUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/27.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "NeoTransferUtil.h"
#import "NEOWalletUtil.h"
#import "ToxRequestModel.h"
//#import "P2pMessageManage.h"
#import "Qlink-Swift.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
#import "HistoryRecrdInfo.h"
#import "VPNTranferMode.h"
//#import <NEOFramework/NEOFramework.h>
#import "WalletCommonModel.h"
#import "UserModel.h"

#define TIMER_SEC  35
#define Time_ReTransfer 60

int requestCont = 0;
dispatch_source_t _timer;

//@interface BecomeTranferMode : BBaseModel
//
//@property (nonatomic ,strong) NSString *vpnName;
//@property (nonatomic , strong) NSString *vpnConnectTime;
//@property (nonatomic , strong) NSString *p2pId;
//@property (nonatomic , strong) NSString *transferSuccessTime;
//@property (nonatomic , strong) NSString *tranferAddress;
//@property (nonatomic , strong) NSString *tranferCost;
//@property (nonatomic ,strong) NSString *recordId;
//@property (nonatomic , assign) BOOL isTranferSuccess;
//@property (nonatomic , assign) BOOL isBecomeTranfer;
//@property (nonatomic , assign) BOOL isCurrentConnect;
//
//@end
//
//@implementation BecomeTranferMode
//
//@end

@implementation NeoTransferUtil

+ (instancetype) getShareObject {
    static dispatch_once_t pred = 0;
    __strong static NeoTransferUtil *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc]init];
    });
    return sharedObj;
}

//- (NSMutableArray *)vpnList
//{
//    if (!_vpnList) {
//        _vpnList = [NSMutableArray array];
//    }
//    return _vpnList;
//}

/**
 获取当前连接vpn
 
 @return vpn
 */
//+ (VPNInfo *) currentConnectVPNInfo
//{
//    //
////    NEVPNStatus status = [VPNUtil.shareInstance getVpnConnectStatus];
////    if (status != NEVPNStatusConnected) {
////        [HWUserdefault deleteObjectWithKey:Current_Connenct_VPN];
////        return nil;
////    }
////    NSDictionary *dc = [HWUserdefault getObjectWithKey:Current_Connenct_VPN];
////    if (dc) {
////        return [VPNInfo getObjectWithKeyValues:dc];
////    }
//    return nil;
//}

/**
 获取当前连接vpn name
 
 @return vpn name
 */
//+ (NSString *) currentVPNName
//{
//    VPNInfo *connectInfo = [NeoTransferUtil currentConnectVPNInfo];
//    if (connectInfo) {
//        return connectInfo.vpnName;
//    }
//    return @"";
//}

/**
 开启vpn连接定时扣费
 */
//+ (void) startVPNConnectTran
//{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    //dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC); // 开始时间
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),TIMER_SEC*NSEC_PER_SEC, 0); //每30秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        //[NeoTransferUtil sendFundsRequestWithType:3 withVPNInfo:[NeoTransferUtil currentConnectVPNInfo]];
//        [NeoTransferUtil readUserDefaultVPNList];
//    });
//    dispatch_resume(_timer);
//}

//+ (void) readUserDefaultVPNList
//{
//    NSArray *listArray = [HWUserdefault getObjectWithKey:VPN_CONNECT_LIST];
//    if (listArray && listArray.count > 0) {
//       NeoTransferUtil *tranferUtil = [NeoTransferUtil getShareObject];
//        [listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            VPNTranferMode *mode = [VPNTranferMode getObjectWithKeyValues:obj];
//            __block BOOL isExit = NO;
//            [tranferUtil.vpnList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                VPNTranferMode *tranVPNMode = (VPNTranferMode *)obj;
//                if ([tranVPNMode.vpnName isEqualToString:mode.vpnName]) {
//                    tranVPNMode.isCurrentConnect = mode.isCurrentConnect;
//                    tranVPNMode.isTranferSuccess = mode.isTranferSuccess;
//                    tranVPNMode.vpnConnectTime = mode.vpnConnectTime;
//                    isExit = YES;
//                }
//            }];
//            if (!isExit) {
//                [tranferUtil.vpnList addObject:mode];
//            }
//        }];
//
//        [tranferUtil.vpnList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            VPNTranferMode *tranVPNMode = (VPNTranferMode *)obj;
//
//            if (tranVPNMode.isCurrentConnect) {// 更新当前连接VPN 时间
//                NSString *connectTime = tranVPNMode.vpnConnectTime;
//                if (![[NSStringUtil getNotNullValue:connectTime] isEmptyString]) {
//                    // 判断上次连接时间 超过一时间扣费
//                    NSDateFormatter *dateFormatrer = [NSDateFormatter defaultDateFormatter];
//                    NSDate *backDate = [dateFormatrer dateFromString:connectTime];
//                    // 判断日期相隔时间
//                    NSInteger minu = [[NSDate date] minutesAfterDate:backDate];
//                    // 小于1小时不扣费 并且 上次扣费要成功
//                    if (labs(minu) >= VPN_TRANFER_TIME) {
//                        // 两次网络不一样时。关闭VPN
//                        if (tranVPNMode.isMain != [ConfigUtil isMainNetOfServerNetwork]) {
////                            [[VPNUtil shareInstance] stopVPN];
//                            // 将当前VPN连接状态置为NO
//                            [NeoTransferUtil updateUserDefaultVPNListCurrentVPNConnectStatus];
//                        } else {
//                            NSString *enterBackTime = [[NSDate date] formattedDateYearYueRi:@"yyyy-MM-dd HH:mm:ss"];
//                            tranVPNMode.vpnConnectTime = enterBackTime;
//                            tranVPNMode.isTranferSuccess = NO;
//                            tranVPNMode.isBecomeTranfer = NO;
//                            NSArray *list = [HWUserdefault getObjectWithKey:VPN_CONNECT_LIST];
//                            NSMutableArray *array = [NSMutableArray arrayWithArray:list];
//
//                            __block NSInteger vpnIndex = 0;
//                            __block VPNTranferMode *tempM = nil;
//                            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                VPNTranferMode *vpnMode = [VPNTranferMode getObjectWithKeyValues:obj];
//                                if ([tranVPNMode.vpnName isEqualToString:vpnMode.vpnName]) {
//                                    vpnMode.isTranferSuccess = NO;
//                                    vpnMode.vpnConnectTime = enterBackTime;
//                                    tempM = vpnMode;
//                                    vpnIndex = idx;
//                                    *stop = YES;
//                                }
//                            }];
//
//                            if (tempM) {
//                                [array replaceObjectAtIndex:vpnIndex withObject:tempM.mj_keyValues];
//                                [HWUserdefault insertObj:array withkey:VPN_CONNECT_LIST];
//                            }
//                        }
//                    }
//                }
//            }
//
//            // 需要扣费的
//            if (!tranVPNMode.isTranferSuccess) {
//                if (!tranVPNMode.isBecomeTranfer) {
//                    if (tranVPNMode.isMain == [ConfigUtil isMainNetOfServerNetwork]) {
//                         [NeoTransferUtil sendFreeToConnectVPNCountWithVPNTranferMode:tranVPNMode];
//                    }
//                }
//            }
//
//        }];
//    }
//}

//#pragma mark - 扣除vpn连接费用
//+ (void) tranferVPNConnestCostWithVPNInfo:(VPNTranferMode *) vpnInfo
//{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 是否有足够资产连接VPN
//            if ([NeoTransferUtil isConnectionAssetsAllowedWithCost:vpnInfo.tranferCost]) {
//                [NeoTransferUtil vpnConnectTranReqeustWithVpnTranferInfo:vpnInfo];
//            } else {
////                [[VPNUtil shareInstance] stopVPN];
//               // 将当前VPN连接状态置为NO
//                [NeoTransferUtil updateUserDefaultVPNListCurrentVPNConnectStatus];
//            }
//        });
//}

//#pragma mark - 是不是可以免费连接VPN
//+ (void) sendFreeToConnectVPNCountWithVPNTranferMode:(VPNTranferMode *) vpnInfo
//{
//    NSString *freeKey = vpnInfo.isMain ? VPN_FREE_MAIN_COUNT : VPN_FREE_COUNT;
//    if ([[NSStringUtil getNotNullValue:[HWUserdefault getObjectWithKey:freeKey]] isEqualToString:@"0"]) {
//        // 调用扣费
//        [NeoTransferUtil tranferVPNConnestCostWithVPNInfo:vpnInfo];
//    }  else {
//        NSString *p2pId = [UserModel getOwnP2PId];
//        [RequestService requestWithUrl:zsFreeNum_Url params:@{@"p2pId":p2pId} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//            if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//                NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
//                if (dataDic) {
//                    NSString *freeNum = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"freeNum"]];
//                    NSString *freeKey = vpnInfo.isMain ? VPN_FREE_MAIN_COUNT : VPN_FREE_COUNT;
//                    [HWUserdefault insertObj:freeNum withkey:freeKey];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:CHEKC_VPN_FREE_COUNT_SUCCESS object:nil];
//                    if ([freeNum integerValue] > 0) { // 可以免费连接
//                        //  调用免费
//                        [NeoTransferUtil sendFreeConnectVPNRequestWithVPNInfo:vpnInfo];
//                    } else {
//                        // 调用扣费
//                        [NeoTransferUtil tranferVPNConnestCostWithVPNInfo:vpnInfo];
//                    }
//                }
//            }
//        } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//
//        }];
//    }
//
//
//}
//#pragma mark - 获取免费连接次数
//+ (void) checkFreeConnectCount
//{
//    NSString *p2pId = [UserModel getOwnP2PId];
//    [RequestService requestWithUrl:zsFreeNum_Url params:@{@"p2pId":p2pId} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
//            if (dataDic) {
//                NSString *freeNum = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"freeNum"]];
//                NSString *freeKey = [ConfigUtil isMainNetOfServerNetwork] ? VPN_FREE_MAIN_COUNT : VPN_FREE_COUNT;
//                [HWUserdefault insertObj:freeNum withkey:freeKey];
//                [[NSNotificationCenter defaultCenter] postNotificationName:CHEKC_VPN_FREE_COUNT_SUCCESS object:nil];
//            }
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//
//    }];
//}

//#pragma mark - 发送免费连接VPN请求
//+ (void) sendFreeConnectVPNRequestWithVPNInfo:(VPNTranferMode *) vpnInfo
//{
//    // 更新VPNInfo正在交易的状态
//    NSString *p2pId = [UserModel getOwnP2PId];
//    [NeoTransferUtil updateVPNListDidTranferStatusWithVPNName:vpnInfo.vpnName status:YES];
//    NSDictionary *parames = @{@"assetName":vpnInfo.vpnName,@"fromP2pId":p2pId,@"toP2pId":vpnInfo.p2pId?:@"",@"addressTo":vpnInfo.tranferAddress?:@""};
//    [RequestService requestWithUrl:freeConnection_Url params:parames httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            // 更新VPNInfo支付的状态
//            [NeoTransferUtil updateVPNListTranferStatusWithVPNName:vpnInfo.vpnName];
//            NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
//            if (dataDic) {
//                NSString *freeNum = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"freeNum"]];
//                NSString *freeKey = vpnInfo.isMain ? VPN_FREE_MAIN_COUNT : VPN_FREE_COUNT;
//                [HWUserdefault insertObj:freeNum withkey:freeKey];
//                [[NSNotificationCenter defaultCenter] postNotificationName:CHEKC_VPN_FREE_COUNT_SUCCESS object:nil];
//            }
//
//        } else {
//            // 更新VPNInfo正在交易的状态
//            [NeoTransferUtil updateVPNListDidTranferStatusWithVPNName:vpnInfo.vpnName status:NO];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        // 更新VPNInfo正在交易的状态
//        [NeoTransferUtil updateVPNListDidTranferStatusWithVPNName:vpnInfo.vpnName status:NO];
//    }];
//}
/**
 是否可以连接资产
 
 @return 是。不是
 */
//+ (BOOL) isConnectionAssetsAllowedWithCost:(NSString *)cost
//{
//    BOOL isConnect = NO;
//    if (kAppD.balanceInfo) {
//
//        if ([kAppD.balanceInfo.gas doubleValue] >= GAS_Control && [kAppD.balanceInfo.qlc floatValue] >= [cost floatValue]) {
//            isConnect = YES;
//        }
//
////        if ([kAppD.balanceInfo.qlc floatValue] >= [cost floatValue]) {
////            isConnect = YES;
////        }
//    }
//    return isConnect;
//}

#pragma -mark 获取资产
+ (void)sendGetBalanceRequest {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (![NEOWalletManage.sharedInstance haveDefaultWallet]) {
        return;
    }
    NSString *address = [NEOWalletManage.sharedInstance getWalletAddress];
//    NSString *address = @"AbepoJwqkEhdqprPe9qmBLxPGGF7QDz744";
    [RequestService requestWithUrl:getTokenBalance_Url params:@{@"address":address} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
            if(dataDic)  {
                kAppD.balanceInfo = [BalanceInfo mj_objectWithKeyValues:dataDic];
            } else {
                kAppD.balanceInfo = nil;
            }
        } else {
            kAppD.balanceInfo = nil;
            DDLogDebug(@"获取资产失败");
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        kAppD.balanceInfo = nil;
        DDLogDebug(@"获取资产失败：%@",error.description);
        requestCont ++;
        if (requestCont <2) {
            [NeoTransferUtil sendGetBalanceRequest];
        } else {
            requestCont = 0;
        }
        
    }];
}

//#pragma -mark 连接成功后，发消息给提供方记录
//+ (void) sendVPNConnectSuccessMessageWithVPNInfo:(id) vpnObject withType:(NSInteger) type
//{
//    // 发送获取配置文件消息
//    ToxRequestModel *model = [[ToxRequestModel alloc] init];
////    model.type = recordSaveReq;
//    NSString *vpnName = @"";
//    NSString *vpnCost = @"";
//    NSString *recordId = @"";
//    NSString *p2pId = @"";
//    BOOL isMianNet = YES;
//    NSDate *tranferDate = nil;
//    
//    if ([vpnObject isKindOfClass:[VPNInfo class]]) {
//        VPNInfo *vpnInfo = vpnObject;
//        vpnName = vpnInfo.vpnName;
//        vpnCost = vpnInfo.cost;
//        recordId = vpnInfo.recordId;
//        p2pId = vpnInfo.p2pId;
//        isMianNet = vpnInfo.isMainNet;
//        tranferDate = [NSDate date];
//    } else {
//        VPNTranferMode *vpnInfo = vpnObject;
//        vpnName = vpnInfo.vpnName;
//        vpnCost = vpnInfo.tranferCost;
//        recordId = vpnInfo.recordId;
//        p2pId = vpnInfo.p2pId;
//        isMianNet = vpnInfo.isMain;
//        NSString *connectTime = vpnInfo.vpnConnectTime;
//        if([connectTime isBlankString]) {
//            tranferDate = [NSDate date];
//        } else {
//            NSDateFormatter *dateFormatrer = [NSDateFormatter defaultDateFormatter];
//            tranferDate = [dateFormatrer dateFromString:connectTime];
//        }
//    }
//    
//    NSDictionary *dataDic = @{APPVERSION:APP_Build,ASSETS_NAME:vpnName,QLC_COUNT:vpnCost,TRAN_TYPE:[NSString stringWithFormat:@"%ld",(long)type],EXCANGE_ID:[NSStringUtil getNotNullValue:recordId],TIME_SAMP:[NSString stringWithFormat:@"%llud",[NSDate getMillisecondTimestampFromDate:tranferDate]],TX_ID:[NSStringUtil getNotNullValue:recordId],IS_MAINNET:isMianNet?@"1":@"0"};
//    model.data = dataDic.mj_JSONString;
//    NSString *str = model.mj_JSONString;
////    [ToxManage sendMessageWithMessage:str withP2pid:p2pId];
//}

#pragma -mark 设置本地通知
/**
 发送本地通知
 
 @param qlc qlc
 @param isIncome 是否是收入
 */
+ (void) sendLocalNotificationWithQLC:(id) qlc isIncome:(BOOL) isIncome {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    UNMutableNotificationContent *notiContent = [[UNMutableNotificationContent alloc] init];
    
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:.5 repeats:NO];
    
    NSString *qlcCount = [NSString stringWithFormat:@"%.2f",[qlc floatValue]];
    
    NSString *alertBody = [NSString stringWithFormat:@"%@ %@ qlc",NSStringLocalizable(@"spending"),qlcCount];
    NSString *alertTitle = NSStringLocalizable(@"spend_account");
    if (isIncome) {
        alertBody = [NSString stringWithFormat:@"%@ %@ qlc",NSStringLocalizable(@"income"),qlcCount];
        alertTitle = NSStringLocalizable(@"into_account");
    }
    notiContent.title = [NSString localizedUserNotificationStringForKey:alertTitle arguments:nil];
    notiContent.body =  [NSString localizedUserNotificationStringForKey:alertBody arguments:nil];
    notiContent.userInfo = @{@"type":@"1",@"qlc":qlcCount,@"title":alertTitle,@"body":alertBody};
    // 执行通知注册
    
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"sendQLC" content:notiContent trigger:trigger1];
    
    [center addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"error = %@",error);
    }];
}

//#pragma mark- 连接VPN成功后本地存在 修到VPN连接状态
//+ (void)udpateTransferModel:(VPNInfo *) vpnInfo {
//
//    NSMutableArray *list = [NSMutableArray arrayWithArray:[HWUserdefault getObjectWithKey:VPN_CONNECT_LIST]];
//    if (!list || list.count == 0) {
//        [NeoTransferUtil saveVPNListToUserdefaultWithVPNInfo:vpnInfo vpnList:list];
//    } else {
//       __block BOOL isExit = NO;
//        __block NSMutableArray *vpnList = [NSMutableArray array];
//        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            VPNTranferMode *tranferMode = [VPNTranferMode getObjectWithKeyValues:obj];
//            if ([tranferMode.vpnName isEqualToString:vpnInfo.vpnName]) {
//
//                // 判断上次连接时间 超过一时间扣费
//                NSString *connectTime = tranferMode.vpnConnectTime;
//                NSDateFormatter *dateFormatrer = [NSDateFormatter defaultDateFormatter];
//                NSDate *backDate = [dateFormatrer dateFromString:connectTime];
//                // 判断日期相隔时间
//                NSInteger minu = [[NSDate date] minutesAfterDate:backDate];
//                // 小于1小时不扣费 并且 上次扣费要成功
//                if (labs(minu) >= VPN_TRANFER_TIME) {
//                    NSString *enterBackTime = [[NSDate date] formattedDateYearYueRi:@"yyyy-MM-dd HH:mm:ss"];
//                    tranferMode.vpnConnectTime = enterBackTime;
//                    tranferMode.isTranferSuccess = NO;
//                    tranferMode.isBecomeTranfer = NO;
//                }
//                tranferMode.isCurrentConnect = YES;
//                isExit = YES;
//            } else {
//                tranferMode.isCurrentConnect = NO;
//            }
//            [vpnList addObject:[tranferMode mj_keyValues]];
//        }];
//
//        if (!isExit) {
//            [NeoTransferUtil saveVPNListToUserdefaultWithVPNInfo:vpnInfo vpnList:list];
//        } else {
//             [HWUserdefault insertObj:vpnList withkey:VPN_CONNECT_LIST];
//        }
//    }
//}
//#pragma mark- 连接VPN成功后本地不存在 保存到VPNList
//+ (void) saveVPNListToUserdefaultWithVPNInfo:(VPNInfo *)vpnInfo vpnList:(NSMutableArray *) list
//{
//    VPNTranferMode *tranferMode = [[VPNTranferMode alloc] init];
//    tranferMode.vpnName = vpnInfo.vpnName?:@"";
//    tranferMode.isCurrentConnect = YES;
//    tranferMode.tranferAddress = vpnInfo.address?:@"";
//    tranferMode.tranferCost = vpnInfo.cost?:@"0";
//    tranferMode.p2pId = vpnInfo.p2pId ?:@"";
//    tranferMode.isMain = vpnInfo.isMainNet;
//    NSString *enterBackTime = [[NSDate date] formattedDateYearYueRi:@"yyyy-MM-dd HH:mm:ss"];
//    tranferMode.vpnConnectTime = enterBackTime;
//    if (list) {
//        [list addObject:[tranferMode mj_keyValues]];
//    } else {
//        list = [NSMutableArray arrayWithObjects:[tranferMode mj_keyValues], nil];
//    }
//    [HWUserdefault insertObj:list withkey:VPN_CONNECT_LIST];
//}

//#pragma mark - 发送转帐QLC请求方法
//+ (void ) vpnConnectTranReqeustWithVpnTranferInfo:(VPNTranferMode *) vpnInfo {
//    BOOL haveDefaultNEOWallet = [NEOWalletManage.sharedInstance haveDefaultWallet];
//    if (!haveDefaultNEOWallet) {
//        return;
//    }
//    NSString *addressFrom = [NEOWalletManage.sharedInstance getWalletAddress];
//
//     // 更新VPNInfo正在交易的状态
//    [NeoTransferUtil updateVPNListDidTranferStatusWithVPNName:vpnInfo.vpnName status:YES];
//
//    //kWeakSelf(self);
//    BOOL isMainNetTransfer = NO;
//    NSString *tokenHash = AESSET_TEST_HASH;
//    if (isMainNetTransfer) {
//        tokenHash = AESSET_MAIN_HASH;
//    }
//    vpnInfo.recordId = [NEOWalletUtil getExChangeId];
//    NSString *remarkStr = nil;
//    NSString *addressTo = [NSStringUtil getNotNullValue:vpnInfo.tranferAddress];
//    if ([addressTo isEmptyString]) {
//        return;
//    }
//
//    double fee = NEO_fee;
//
//    [NEOWalletManage.sharedInstance getTXWithAddressWithIsQLC:true address:addressTo tokeHash:tokenHash qlc:vpnInfo.tranferCost mainNet:isMainNetTransfer remarkStr:remarkStr fee:fee completeBlock:^(NSString *txHex) {
//
//        if ([[NSStringUtil getNotNullValue:txHex] isEmptyString]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [NeoTransferUtil tranferFaieldReTranferWithVPNInfo:vpnInfo];
//            });
//        } else {
//
//            // NSLog(@"%@ txid = %@",vpnInfo.vpnName,complete);
//            // 发送交易请求
//            NSNumber *typeNum = @(3);
//            NSString *p2pId = [UserModel getOwnP2PId];
//            NSDictionary *parames = @{@"recordId":[NSStringUtil getNotNullValue:vpnInfo.recordId],@"assetName":vpnInfo.vpnName,@"type":typeNum,@"addressFrom":addressFrom,@"tx":txHex,@"qlc":vpnInfo.tranferCost,@"fromP2pId":[NSStringUtil getNotNullValue:p2pId],@"addressTo":[NSStringUtil getNotNullValue:vpnInfo.tranferAddress],@"toP2pId":[NSStringUtil getNotNullValue:vpnInfo.p2pId]};
//
//            [RequestService requestWithUrl:transTypeOperate_Url params:parames httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
////                [kAppD.window hideToast];
//                if ([[responseObject objectForKey:Server_Code] integerValue] == 0){
//                    NSDictionary *dataDic = [responseObject objectForKey:@"data"];
//                    if (dataDic) {
//                        BOOL result = [[dataDic objectForKey:@"operationResult"] boolValue];
//                        if (result) { // 交易成功
//
//                            // 转账成功之后发p2p消息告诉接收者
//                            [NeoTransferUtil sendVPNConnectSuccessMessageWithVPNInfo:(id)vpnInfo withType:3];
//                            // 更新VPN连接转帐成功
//                            [NeoTransferUtil updateVPNListTranferStatusWithVPNName:vpnInfo.vpnName];
//                            // 获取当前资产
//                            [NeoTransferUtil sendGetBalanceRequest];
//                            // 发送扣款通知
//                            [NeoTransferUtil sendLocalNotificationWithQLC:vpnInfo.tranferCost isIncome:NO];
//                            [NEOWalletUtil saveTranQLCRecordWithQlc:vpnInfo.tranferCost txtid:[NSStringUtil getNotNullValue:vpnInfo.recordId] neo:@"0" recordType:3 assetName:vpnInfo.vpnName friendNum:0 p2pID:[NSStringUtil getNotNullValue:vpnInfo.p2pId] connectType:0 isReported:NO isMianNet:vpnInfo.isMain];
//                        } else {
//                            [NeoTransferUtil tranferFaieldReTranferWithVPNInfo:vpnInfo];
//                        }
//                    } else {
//                         [NeoTransferUtil tranferFaieldReTranferWithVPNInfo:vpnInfo];
//                    }
//                } else {
//                    [NeoTransferUtil tranferFaieldReTranferWithVPNInfo:vpnInfo];
//                }
//
//            } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//                [NeoTransferUtil tranferFaieldReTranferWithVPNInfo:vpnInfo];
//            }];
//        }
//
//    }];
//}

//#pragma mark - 转帐失败 10秒后重新转帐
//+ (void) tranferFaieldReTranferWithVPNInfo:(VPNTranferMode *) vpnInfo
//{
//    DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
//    if (vpnInfo.isMain == [ConfigUtil isMainNetOfServerNetwork]) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [NeoTransferUtil vpnConnectTranReqeustWithVpnTranferInfo:vpnInfo];
//        });
//    }
//}

//#pragma mark -更改VPNList支付状态
//+ (void) updateVPNListTranferStatusWithVPNName:(NSString *) vpnName
//{
//    NeoTransferUtil *tranferUtil = [NeoTransferUtil getShareObject];
//    [tranferUtil.vpnList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        VPNTranferMode *mode = (VPNTranferMode *)obj;
//        if ([mode.vpnName isEqualToString:vpnName]) {
//            mode.isTranferSuccess = YES;
//            mode.isBecomeTranfer = NO;
//        }
//    }];
//
//    NSArray *list = [HWUserdefault getObjectWithKey:VPN_CONNECT_LIST];
//    NSMutableArray *array = [NSMutableArray arrayWithArray:list];
//
//    __block NSInteger vpnIndex = 0;
//    __block VPNTranferMode *tempM = nil;
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        VPNTranferMode *vpnMode = [VPNTranferMode getObjectWithKeyValues:obj];
//        if ([vpnName isEqualToString:vpnMode.vpnName]) {
//            vpnMode.isTranferSuccess = YES;
//            //                                    [array addObject:[vpnMode mj_keyValues]];
//            tempM = vpnMode;
//            vpnIndex = idx;
//            *stop = YES;
//        }
//    }];
//
//    if (tempM) {
//        [array replaceObjectAtIndex:vpnIndex withObject:tempM.mj_keyValues];
//        [HWUserdefault insertObj:array withkey:VPN_CONNECT_LIST];
//    }
//}

//#pragma mark - 更新VPNList正在支付的状态
//+ (void) updateVPNListDidTranferStatusWithVPNName:(NSString *) vpnName status:(BOOL) isBecomeTranfer
//{
//    NeoTransferUtil *tranferUtil = [NeoTransferUtil getShareObject];
//    [tranferUtil.vpnList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        VPNTranferMode *mode = (VPNTranferMode *)obj;
//        if ([mode.vpnName isEqualToString:vpnName]) {
//            mode.isBecomeTranfer = isBecomeTranfer;
//        }
//    }];
//}

//#pragma mark - 将本地及当前VPNList中的连接VPN状态置为NO
//+ (void) updateUserDefaultVPNListCurrentVPNConnectStatus
//{
//    NeoTransferUtil *tranferUtil = [NeoTransferUtil getShareObject];
//    // 将当前VPN连接状态置为NO
//    [tranferUtil.vpnList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        VPNTranferMode *tranVPNMode = (VPNTranferMode *)obj;
//        if (tranVPNMode.isCurrentConnect) {
//            tranVPNMode.isCurrentConnect = NO;
//            *stop = YES;
//        }
//    }];
//    
//    // 将本地的连接状态置为NO
//    NSArray *list = [HWUserdefault getObjectWithKey:VPN_CONNECT_LIST];
//    NSMutableArray *array = [NSMutableArray arrayWithArray:list];
//    
//    __block NSInteger vpnIndex = 0;
//    __block VPNTranferMode *tempM = nil;
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        VPNTranferMode *vpnMode = [VPNTranferMode getObjectWithKeyValues:obj];
//        if (vpnMode.isCurrentConnect) {
//            vpnMode.isCurrentConnect = NO;
//            tempM = vpnMode;
//            vpnIndex = idx;
//            *stop = YES;
//        }
//    }];
//    if (tempM) {
//        [array replaceObjectAtIndex:vpnIndex withObject:tempM.mj_keyValues];
//        [HWUserdefault insertObj:array withkey:VPN_CONNECT_LIST];
//    }
//}












//--------------------------------丢弃方法-------------------------------------

/**
 交易 qlc 请求
 @param type 交易类型
 @param vpnInfo vpnInfo
 */
//+ (void) sendFundsRequestWithType:(int)type withVPNInfo:(VPNInfo *) vpnInfo {
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (!vpnInfo) {
//            NSLog(@"当前没有连接VPN");
//            return;
//        }
//
//        if (type == 3) { // vpn连接自己时不用扣费
//            if ([[WalletCommonModel getCurrentSelectWallet].address isEqualToString:vpnInfo.address]) {
//                return;
//            } else {
//                // 获取vpn上次连接时间
//                NSDictionary *modeDic = [HWUserdefault getObjectWithKey:vpnInfo.vpnName];
//                if (modeDic) {
//                    VPNTranferMode *tranferMode = [VPNTranferMode getObjectWithKeyValues:modeDic];
//                    NSString *connectTime = tranferMode.vpnConnectTime;
//
//                    if (![[NSStringUtil getNotNullValue:connectTime] isEmptyString]) {
//                        // 判断上次连接时间 超过一时间扣费
//                        NSDateFormatter *dateFormatrer = [NSDateFormatter defaultDateFormatter];
//                        NSDate *backDate = [dateFormatrer dateFromString:connectTime];
//                        // 判断日期相隔时间
//                        NSInteger hours = [[NSDate date] hoursAfterDate:backDate];
//                        // 小于1小时不扣费 并且 上次扣费要成功
//                        if (labs(hours) < 1) {
//                            if (tranferMode.isTranferSuccess || tranferMode.isBecomeTranfer) {
//                                return;
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        // type =3 vpn连接
//        if (type == 3) {
//            // 是否有足够资产连接VPN
//            if ([NeoTransferUtil isConnectionAssetsAllowedWithCost:vpnInfo.cost]) {
//                // 保存最后VPN连接扣费时间
//                NSString *enterBackTime = [[NSDate date] formattedDateYearYueRi:@"yyyy-MM-dd HH:mm:ss"];
//                NSDictionary *modeDic = [HWUserdefault getObjectWithKey:vpnInfo.vpnName];
//                VPNTranferMode *tranferMode = [VPNTranferMode getObjectWithKeyValues:modeDic];
//                if (tranferMode) {
//                    tranferMode.vpnConnectTime = enterBackTime;
//                    tranferMode.isTranferSuccess = NO;
//                } else {
//                    tranferMode = [[VPNTranferMode alloc] init];
//                    tranferMode.vpnConnectTime = enterBackTime;
//                    tranferMode.isTranferSuccess = NO;
//                }
//                tranferMode.isBecomeTranfer = YES;
//                [HWUserdefault insertObj:[tranferMode mj_keyValues] withkey:vpnInfo.vpnName];
//
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Time_ReTransfer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [NeoTransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:type];
//                });
//            } else {
//                // 断开VPN连接
////                [[VPNUtil shareInstance] stopVPN];
//            }
//        } else if (type == 6) { // type =6 vpn注册
//            [NeoTransferUtil sendTranAddressRequestWithVPNInfo:vpnInfo withType:type];
//        } else if (type == 5) { //type =5 vpn抢注
//            // 发送交易
//            [NeoTransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:type];
//        }
//    });
//
//
//}


//+ (void ) vpnConnectTranReqeustWithVpnInfo:(VPNInfo *) vpnInfo tranType:(int) type
//{
//    //kWeakSelf(self);
//    BOOL isMainNetTransfer = NO;
//    NSString *tokenHash = AESSET_TEST_HASH;
//    if (isMainNetTransfer) {
//        tokenHash = AESSET_MAIN_HASH;
//    }
//
//    vpnInfo.recordId = [NEOWalletUtil getExChangeId];
//    NSString *remarkStr = nil;
//    NSString *addressTo = [NSStringUtil getNotNullValue:vpnInfo.address];
//    if ([addressTo isEmptyString]) {
//        return;
//    }
//
//    double fee = NEO_fee;
//
//    __block int tranType = type;
//    [NEOWalletManage.sharedInstance getTXWithAddressWithIsQLC:true address:addressTo tokeHash:tokenHash qlc:vpnInfo.cost mainNet:isMainNetTransfer remarkStr:remarkStr fee:fee completeBlock:^(NSString *txHex) {
//
//        if ([[NSStringUtil getNotNullValue:txHex] isEmptyString]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Time_ReTransfer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [NeoTransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
//                });
//            });
//        } else {
//
//            // NSLog(@"%@ txid = %@",vpnInfo.vpnName,complete);
//
//            // 发送交易请求
//            NSNumber *typeNum = @(3);
//            NSString *p2pId = [UserModel getOwnP2PId];
//            NSDictionary *parames = @{@"recordId":[NSStringUtil getNotNullValue:vpnInfo.recordId],@"assetName":vpnInfo.vpnName,@"type":typeNum,@"addressFrom":[WalletCommonModel getCurrentSelectWallet].address ,@"tx":txHex,@"qlc":vpnInfo.cost,@"fromP2pId":[NSStringUtil getNotNullValue:p2pId],@"addressTo":[NSStringUtil getNotNullValue:vpnInfo.address],@"toP2pId":[NSStringUtil getNotNullValue:vpnInfo.p2pId]};
//            if (tranType == 6 || tranType == 5) { // 注册 抢注vpn转账
//                typeNum = @(1);
//                parames = @{@"recordId":[NSStringUtil getNotNullValue:vpnInfo.recordId],@"type":typeNum,@"addressFrom":[WalletCommonModel getCurrentSelectWallet].address ,@"tx":txHex,@"qlc":vpnInfo.cost,@"addressTo":[NSStringUtil getNotNullValue:vpnInfo.address]};
//            }
//
//            [RequestService requestWithUrl:transTypeOperate_Url params:parames httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
////                [kAppD.window hideToast];
//                if ([[responseObject objectForKey:Server_Code] integerValue] == 0){
//                    NSDictionary *dataDic = [responseObject objectForKey:@"data"];
//                    if (dataDic) {
//                        BOOL result = [[dataDic objectForKey:@"operationResult"] boolValue];
//                        if (result) { // 交易成功
//                            if (tranType == 3 || tranType == 5) { // vpn连接
//                                //转账成功之后发p2p消息告诉接收者
//                                [NeoTransferUtil sendVPNConnectSuccessMessageWithVPNInfo:vpnInfo withType:type];
//                            }
//                            if (tranType == 6) {
//                                tranType = 5;
//                            }
//                            // 更新VPN连接转帐成功
//                            NSDictionary *modeDic = [HWUserdefault getObjectWithKey:vpnInfo.vpnName];
//                            VPNTranferMode *tranferMode = [VPNTranferMode getObjectWithKeyValues:modeDic];
//                            if (tranferMode) {
//                                tranferMode.isTranferSuccess = YES;
//                                tranferMode.isBecomeTranfer = NO;
//                                [HWUserdefault insertObj:[tranferMode mj_keyValues] withkey:vpnInfo.vpnName];
//                            }
//                            // 获取当前资产
//                            [NeoTransferUtil sendGetBalanceRequest];
//                            // 发送扣款通知
//                            [NeoTransferUtil sendLocalNotificationWithQLC:vpnInfo.cost isIncome:NO];
//                            [NEOWalletUtil saveTranQLCRecordWithQlc:vpnInfo.cost txtid:[NSStringUtil getNotNullValue:vpnInfo.recordId] neo:@"0" recordType:tranType assetName:vpnInfo.vpnName friendNum:0 p2pID:[NSStringUtil getNotNullValue:vpnInfo.p2pId] connectType:0 isReported:NO isMianNet:vpnInfo.isMainNet];
//                        } else {
//                            DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Time_ReTransfer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                [NeoTransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
//                            });
//                        }
//                    } else {
//                        DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Time_ReTransfer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            [NeoTransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
//                        });
//                    }
//                } else {
//                    DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Time_ReTransfer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [NeoTransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
//                    });
//                }
//
//            } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//                DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Time_ReTransfer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [NeoTransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
//                });
//            }];
//        }
//
//
//        //        dispatch_async(dispatch_get_main_queue(), ^{
//        //            [kAppD.window hideHud];
//        //            if (!complete) {
//        //                DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
//        //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //                    [TransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
//        //                });
//        //            } else {
//        //                if (tranType == 3 || tranType == 5) { // vpn连接
//        //                    //转账成功之后发p2p消息告诉接收者
//        //                    [TransferUtil sendVPNConnectSuccessMessageWithVPNInfo:vpnInfo withType:type];
//        //                }
//        //                if (tranType == 6) {
//        //                    tranType = 5;
//        //                }
//        //                // 获取当前资产
//        //                [TransferUtil sendGetBalanceRequest];
//        //                // 发送扣款通知
//        //                [TransferUtil sendLocalNotificationWithQLC:vpnInfo.cost isIncome:NO];
//        //                [WalletUtil saveTranQLCRecordWithQlc:vpnInfo.cost txtid:@"" neo:@"0" recordType:tranType assetName:vpnInfo.vpnName friendNum:0 p2pID:@"" connectType:0 isReported:NO];
//        //            }
//        //        });
//    }];
//}

/**
 获取注册vpn时扣费地址

 @param info 注册vpninfo
 @param type 操作类型
 */
//+ (void) sendTranAddressRequestWithVPNInfo:(VPNInfo *) info withType:(int) type {
//    // 获取NEO交换地址
//    [RequestService requestWithUrl:mainAddressV2_Url params:@{} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
//        if (dataDic) {
//            NSString *toAddress = dataDic[@"NEO"][@"address"];
//            info.address = toAddress;
//            // 发送交易
//            [NeoTransferUtil vpnConnectTranReqeustWithVpnInfo:info tranType:type];
//        } else {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [NeoTransferUtil sendTranAddressRequestWithVPNInfo:info withType:type];
//            });
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [NeoTransferUtil sendTranAddressRequestWithVPNInfo:info withType:type];
//        });
//    }];
//}



@end
