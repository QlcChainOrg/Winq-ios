//
//  EntrustOrderInfoModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EntrustOrderInfoModel : BBaseModel

@property (nonatomic, strong) NSNumber *completeAmount;// = 0;
@property (nonatomic, strong) NSString *head;// = "/data/dapp/head/cd67f44e4b8a428e8660356e9463e693.jpg";
@property (nonatomic, strong) NSString *ID;// = f71e12acd7ef4765ae1399213719f982;
@property (nonatomic, strong) NSNumber *lockingAmount;// = 0;
@property (nonatomic, strong) NSNumber *maxAmount;// = 1000;
@property (nonatomic, strong) NSNumber *minAmount;// = 100;
@property (nonatomic, strong) NSString *nickname;// = 18670819116;
@property (nonatomic, strong) NSString *orderTime;// = "2019-07-15 16:33:32";
@property (nonatomic, strong) NSNumber *otcTimes;// = 0;
@property (nonatomic, strong) NSString *qgasAddress;// = "qlc_1fyz7ksawbgak4tqfyhspsbo4udsao1x8prui9unp6ggw7rpifea6ia76pj7";
@property (nonatomic, strong) NSString *status;// = NORMAL;
@property (nonatomic, strong) NSNumber *totalAmount;// = 1000;
@property (nonatomic, strong) NSString *type;// = BUY;
@property (nonatomic, strong) NSString *unitPrice;// = "0.001";
@property (nonatomic, strong) NSString *usdtAddress;// = "";
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *userId;

@end

NS_ASSUME_NONNULL_END
