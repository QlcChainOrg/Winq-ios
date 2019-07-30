//
//  WalletUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBaseViewController.h"
#import "HistoryRecrdInfo.h"

#define GAS_Control 0.00000001

@class NEOWalletInfo;

typedef enum : NSUInteger {
    CheckProcess_VPN_ADD,
    CheckProcess_VPN_LIST,
    CheckProcess_WALLET_TABBAR,
    CheckProcess_VPN_SEIZE,
    CheckProcess_VPN_CONNECT,
} CheckProcessFrom;

@interface NEOWalletUtil : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, assign) BOOL isLock;
@property (nonatomic, assign) BOOL isDelay;

+ (BOOL) isExistPass;
+ (BOOL) setKeyValue:(NSString *) key value:(NSString *) value;
+ (BOOL) setDataKey:(NSString *) key Datavalue:(NSData *) data;
+ (NSData *) getKeyDataValue:(NSString *) key;
+ (NSString *) getKeyValue:(NSString *) key;
+ (BOOL) removeChainKey:(NSString *) key;
+ (BOOL) removeAllKey;
+ (void) setUnlock:(BOOL) lock;
+ (BOOL) isExistWalletPrivateKey;
// 转帐id 是否存在 不存在则生成
+(NSString *) getExChangeId;
+ (BOOL) setWalletkeyWithKey:(NSString *) walletkey withWalletValue:(NSString *) walletValue;
+ (void) checkWalletPassAndPrivateKey:(QBaseViewController *) vs TransitionFrom:(CheckProcessFrom)checkFrom;
// 获取当前钱包的信息
+ (void) getCurrentWalletInfo;
// 获取所有钱包
+ (NSArray *) getAllWalletList;
// 获取当前选择钱包的索引
+(NSInteger) getCurrentWalletIndex;
+ (CheckProcessFrom)getCheckFrom;
+ (void)manageCancelWork;
+ (void)manageContiueWork;
// 得到vpn所有名字
+ (NSArray *) getVPNAllName;
// 保存交易记录
+ (void) saveTranQLCRecordWithQlc:(NSString *) qlc txtid:(NSString *) txtid  neo:(NSString *) neo recordType:(int) type assetName:(NSString *) assetName friendNum:(int) friendNum p2pID:(NSString *) p2pID connectType:(int) connectType isReported:(BOOL) isReported isMianNet:(BOOL) isMain;
// 钱包创建成功 后调用。获取默认的qlc gas
+ (void) sendWalletDefaultReqeustWithAddress:(NSString *) address;
// 获取当前网络
+ (BOOL)isMainNetOfNeo;

#pragma mark - neo钱包新接口
#pragma mark - neo转账send
+ (void)sendNEOWithTokenHash:(NSString *)tokenHash decimals:(NSInteger)decimals assetName:(NSString *)assetName amount:(NSString *)amount toAddress:(NSString *)toAddress fromAddress:(NSString *)fromAddress symbol:(NSString *)symbol assetType:(NSInteger)assetType mainNet:(BOOL)mainNet remarkStr:(nullable NSString *)remarkStr fee:(double)fee;

+ (void)getNEOTXWithTokenHash:(NSString *)tokenHash decimals:(NSInteger)decimals assetName:(NSString *)assetName amount:(NSString *)amount toAddress:(NSString *)toAddress fromAddress:(NSString *)fromAddress symbol:(NSString *)symbol assetType:(NSInteger)assetType mainNet:(BOOL)mainNet remarkStr:(nullable NSString *)remarkStr fee:(double)fee completeBlock:(void(^)(NSString *txHex))completeBlock;

@end
