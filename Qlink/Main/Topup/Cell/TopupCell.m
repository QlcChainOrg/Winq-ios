//
//  FinanceCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupCell.h"
#import "GlobalConstants.h"
#import "TopupProductModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSNumber+RemoveZero.h"
#import "NSString+RemoveZero.h"
#import "RLArithmetic.h"

@implementation TopupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    
    _discountBack.layer.cornerRadius = 14;
    _discountBack.layer.masksToBounds = YES;
    _discountBack.layer.borderWidth = 1;
    _discountBack.layer.borderColor = [UIColor whiteColor].CGColor;
    _contentBack.layer.cornerRadius = 10;
    _contentBack.layer.masksToBounds = YES;
    
    _soldoutBack.layer.cornerRadius = 6;
    _soldoutBack.layer.masksToBounds = YES;
    _soldout_tipBack.layer.cornerRadius = 13;
    _soldout_tipBack.layer.masksToBounds = YES;
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _titleLab.text = nil;
    _titleEnLab.text = nil;
    _subTitleLab.text = nil;
    _subTitleEnLab.text = nil;
    _checkDiscountLab.text = nil;
    _discountLab.text = nil;
    _desLab.text = nil;
}

- (void)config:(TopupProductModel *)model {
    
    NSString *language = [Language currentLanguageCode];
//    NSNumber *discountNum = @(0);
    NSString *discountNumStr = @"0";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
//        discountNumStr = [NSString stringFromDouble:100-[model.discount doubleValue]*100];
        discountNumStr = @(100).sub(model.discount.mul(@(100)));
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
//        discountNumStr = [NSString stringFromDouble:[model.discount doubleValue]*10];
        discountNumStr = model.discount.mul(@(10));
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
//        discountNumStr = [NSString stringFromDouble:100-[model.discount doubleValue]*100];
        discountNumStr = @(100).sub(model.discount.mul(@(100)));
    }
    _titleLab.text = [NSString stringWithFormat:@"%@%@%@",model.country,model.province,model.isp];
    _titleEnLab.text = [NSString stringWithFormat:@"%@%@%@",model.countryEn,model.provinceEn,model.ispEn];
    _subTitleLab.text = model.name;
    _subTitleEnLab.text = model.nameEn;
    _checkDiscountLab.text = kLang(@"view_your_exclusive_offers");
    
    NSString *discountStr = kLang(@"_discount");
    NSString *discountShowStr = [NSString stringWithFormat:@"%@%@",discountNumStr,discountStr];
    NSMutableAttributedString *discountAtt = [[NSMutableAttributedString alloc] initWithString:discountShowStr];
    // .SFUIDisplay-Semibold  .SFUI-Semibold
    [discountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:30] range:NSMakeRange(0, discountShowStr.length)];
    [discountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:14] range:[discountShowStr rangeOfString:discountStr]];
    [discountAtt addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, discountShowStr.length)];
    _discountLab.attributedText = discountAtt;
//    _discountLab.text = [NSString stringWithFormat:@"%@%@",@([model.discount doubleValue]*10),kLang(@"_discount")];
    
    _desLab.text = kLang(@"recharge_phone_bill");
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.imgPath]];
    [_backImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"topup_guangdong_mobile"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    _soldoutBack.hidden = (model.stock && [model.stock doubleValue] == 0)?NO:YES;// 售罄
    _soldout_topTipLab.text = kLang(@"coming_soon_next_month");
    _soldout_tipLab.text = kLang(@"sold_out");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
