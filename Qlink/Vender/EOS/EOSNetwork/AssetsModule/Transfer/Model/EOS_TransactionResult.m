//
//  TransactionResult.m
//  pocketEOS
//
//  Created by oraclechain on 2018/3/22.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "EOS_TransactionResult.h"

@implementation EOS_TransactionResult
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"transaction_id" : @"data.transaction_id",
             @"error" : @"data"
             };
}
@end
