//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TradeIDInputBlock)(NSString *txid);

@interface TradeIDInputView : UIView

@property (nonatomic, copy) TradeIDInputBlock confirmBlock;

+ (instancetype)getInstance;
- (void)show;

@end

NS_ASSUME_NONNULL_END
