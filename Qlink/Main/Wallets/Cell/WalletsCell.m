//
//  WalletsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/25.
//  Copyright © 2018 pan. All rights reserved.
//

#import "WalletsCell.h"
#import "ETHAddressInfoModel.h"
#import "NSString+RemoveZero.h"
#import "TokenPriceModel.h"
#import "NEOAddressInfoModel.h"
#import "EOSSymbolModel.h"

@implementation WalletsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _icon.image = nil;
    _nameLab.text = nil;
    _balanceLab.text = nil;
    _priceLab.text = nil;
}

- (void)configCellWithToken:(Token *)model tokenPriceArr:(NSArray *)tokenPriceArr {
    if (![model isKindOfClass:[Token class]]) {
        return;
    }
    _icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"eth_%@",model.tokenInfo.symbol.lowercaseString]];
    _nameLab.text = model.tokenInfo.symbol;
    
    NSString *num = [model getTokenNum];
    NSString *price = [model getPrice:tokenPriceArr];
    _balanceLab.text = [NSString stringWithFormat:@"%@",num];
    _priceLab.text = [NSString stringWithFormat:@"%@%@",[ConfigUtil getLocalUsingCurrencySymbol],price];
}

- (void)configCellWithAsset:(NEOAssetModel *)model tokenPriceArr:(NSArray *)tokenPriceArr {
    if (![model isKindOfClass:[NEOAssetModel class]]) {
        return;
    }
    _icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"neo_%@",model.asset_symbol.lowercaseString]];
    _nameLab.text = model.asset_symbol;
    
    NSString *num = [model getTokenNum];
    NSString *price = [model getPrice:tokenPriceArr];
    _balanceLab.text = [NSString stringWithFormat:@"%@",num];
    _priceLab.text = [NSString stringWithFormat:@"%@%@",[ConfigUtil getLocalUsingCurrencySymbol],price];
}

- (void)configCellWithSymbol:(EOSSymbolModel *)model tokenPriceArr:(NSArray *)tokenPriceArr {
    if (![model isKindOfClass:[EOSSymbolModel class]]) {
        return;
    }
    _icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"eos_%@",model.symbol.lowercaseString]];
    _nameLab.text = model.symbol;
    
    NSString *num = [model getTokenNum];
    NSString *price = [model getPrice:tokenPriceArr];
    _balanceLab.text = [NSString stringWithFormat:@"%@",num];
    _priceLab.text = [NSString stringWithFormat:@"%@%@",[ConfigUtil getLocalUsingCurrencySymbol],price];
}


@end