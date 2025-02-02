//
//  TransferService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "RichListRequest.h"
#import "GetRateRequest.h"
#import "EOS_TransactionResult.h"


typedef NS_OPTIONS(NSUInteger, PushTransactionType) {
    PushTransactionTypeTransfer ,// 转账
    PushTransactionTypeRedPacket ,//发红包
    PushTransactionTypeApprove,//押币
    PushTransactionTypeAskQustion,//提问(场景:DApp 有问必答)
    PushTransactionTypeAnswer,//回答问题(场景:DApp 有问必答)
    PushTransactionTypeRegisteVoteSystem,//投票前需要将自己注册到投票系统
};

@protocol TransferServiceDelegate<NSObject>
- (void)pushTransactionDidFinish:(EOS_TransactionResult *)result;
- (void)approveDidFinish:(EOS_TransactionResult *)result;
- (void)askQuestionDidFinish:(EOS_TransactionResult *)result;
- (void)answerQuestionDidFinish:(EOS_TransactionResult *)result;
- (void)registeToVoteSystemQuestionDidFinish:(EOS_TransactionResult *)result;


@end

@interface TransferService : BaseService
@property(nonatomic, weak) id<TransferServiceDelegate> delegate;

@property(nonatomic, copy) NSString *action;

@property(nonatomic, copy) NSString *sender;

@property(nonatomic, copy) NSString *code;// contract
@property(nonatomic, copy) NSString *binargs;

// available_keys
@property(nonatomic, strong) NSArray *available_keys;

// pushTransaction
- (void)pushTransaction;
@property (nonatomic) PushTransactionType pushTransactionType;

@property(nonatomic, strong) RichListRequest *richListRequest;



@property(nonatomic, strong) GetRateRequest *getRateRequest;

@property(nonatomic, strong) NSMutableArray *richListDataArray;


@property(nonatomic , copy) NSString *password;

@property(nonatomic , copy) NSString *permission;

@property (nonatomic) NSInteger operationType;


// 获取关注的所有账号
- (void)getRichlistAccount:(CompleteBlock)complete;


/**
 get_rate
 */
- (void)get_rate:(CompleteBlock)complete;


@property(nonatomic, copy) NSString *ref_block_num;
@end
