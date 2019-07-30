//
//  WalletsSwitchCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "WalletsSwitchCell.h"
#import "WalletCommonModel.h"

@implementation WalletsSwitchCell

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
    _addressLab.text = nil;
//    _selectImg.image = nil;
}

- (void)configCellWithModel:(WalletCommonModel *)model selectM:(WalletCommonModel *)selectM {
    _selectImg.hidden = YES;
    WalletCommonModel *compareWalletM = selectM;
    if (model.walletType == WalletTypeETH) {
        _icon.image = [UIImage imageNamed:@"eth_wallet"];
        _addressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        if (compareWalletM && [compareWalletM.address isEqualToString:model.address]) {
            _selectImg.hidden = NO;
        }
    } else if (model.walletType == WalletTypeNEO) {
        _icon.image = [UIImage imageNamed:@"neo_wallet"];
        _addressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        if (compareWalletM && [compareWalletM.address isEqualToString:model.address]) {
            _selectImg.hidden = NO;
        }
    } else if (model.walletType == WalletTypeEOS) {
        _icon.image = [UIImage imageNamed:@"eos_wallet"];
        _addressLab.text = model.account_name;
        if (compareWalletM && [compareWalletM.account_name isEqualToString:model.account_name]) {
            _selectImg.hidden = NO;
        }
    } else if (model.walletType == WalletTypeQLC) {
        _icon.image = [UIImage imageNamed:@"qlc_wallet"];
        _addressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        if (compareWalletM && [compareWalletM.address isEqualToString:model.address]) {
            _selectImg.hidden = NO;
        }
    }
    
    _nameLab.text = model.name;
}

@end
