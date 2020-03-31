//
//  TopupMobilePlanCountry.h
//  Qlink
//
//  Created by Jelly Foo on 2019/12/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TopupCountryModel;

typedef void(^TopupMobilePlanCountrySelectBlock)(TopupCountryModel *selectCountryM);

@interface TopupMobilePlanCountry : UIView

@property (nonatomic, copy) TopupMobilePlanCountrySelectBlock countrySelectB;

+ (instancetype)getInstance;
- (void)refreshCountryView;


@end

NS_ASSUME_NONNULL_END
