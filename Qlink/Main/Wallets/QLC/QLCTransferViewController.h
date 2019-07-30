//
//  ETHTransferViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class QLCTokenModel;

@interface QLCTransferViewController : QBaseViewController

@property (nonatomic, strong) QLCTokenModel *inputAsset;
@property (nonatomic, strong) NSArray *inputSourceArr;
@property (nonatomic, strong) NSString *inputAddress;

@end

NS_ASSUME_NONNULL_END
