//
//  BuySellDetailViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class EntrustOrderListModel;

@interface BuySellDetailViewController : QBaseViewController

@property (nonatomic, strong) EntrustOrderListModel *inputEntrustOrderListM;

@end

NS_ASSUME_NONNULL_END
