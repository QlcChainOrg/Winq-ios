//
//  DeFiKeystatsViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class DefiProjectListModel;
@class DefiTokenModel;


@interface DeFiKeystatsViewController : QBaseViewController


//@property (nonatomic, strong) NSArray *inputTvlArr;
- (void)refreshView:(NSArray *)arr withDefiTokenModel:(DefiTokenModel *) tokenM;


@end

NS_ASSUME_NONNULL_END
