//
//  MyOrderListCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyOrderListTradeCell.h"
#import "TradeOrderListModel.h"
#import <UIImageView+WebCache.h>
#import "UserModel.h"
#import "OrderStatusUtil.h"

@interface MyOrderListTradeCell ()

@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end

@implementation MyOrderListTradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _icon.layer.cornerRadius = _icon.width/2.0;
    _icon.layer.masksToBounds = YES;
    
    [_contentBack addShadowWithOpacity:1.0 shadowColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5] shadowOffset:CGSizeMake(0,4) shadowRadius:10 andCornerRadius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    
}

- (void)config:(TradeOrderListModel *)model type:(RecordListType)type {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.head]];
    [_icon sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    _nameLab.text = model.nickname;
    _timeLab.text = model.createDate;
    UserModel *loginM = [UserModel fetchUserOfLogin];
    _typeLab.text = [loginM.ID isEqualToString:model.buyerId]?@"BUY QGAS":@"SELL QGAS";
    _typeLab.textColor = [loginM.ID isEqualToString:model.buyerId]?MAIN_BLUE_COLOR:UIColorFromRGB(0xFF3669);
    _amountLab.text = model.usdtAmount;
    NSString *statusStr = @"";
    UIColor *statusColor = nil;
    if (type == RecordListTypeProcessing) {
        statusStr = [OrderStatusUtil getStatusStr:model.status];
        statusColor = [OrderStatusUtil getStatusColor:model.status];
    } else if (type == RecordListTypeCompleted) {
        if ([model.status isEqualToString:ORDER_STATUS_QGAS_PAID]) {
            statusStr = @"Successful Deal";
            statusColor = UIColorFromRGB(0x01B5AB);
        }
    } else if (type == RecordListTypeClosed) {
        statusStr = @"Closed";
        statusColor = UIColorFromRGB(0x29282A);
    } else if (type == RecordListTypeAppealed) {
        if ([model.appealStatus isEqualToString:APPEAL_STATUS_YES]) {
            statusStr = @"Appeal Processing";
            statusColor = UIColorFromRGB(0xD0021B);
        } else if ([model.appealStatus isEqualToString:APPEAL_STATUS_SUCCESS]) {
            statusStr = @"Successful Appeal";
            statusColor = UIColorFromRGB(0x01B5AB);
        } else if ([model.appealStatus isEqualToString:APPEAL_STATUS_FAIL]) {
            statusStr = @"Appeal Failed";
            statusColor = UIColorFromRGB(0x29282A);
        }
    }
    _statusLab.text = statusStr;
    _statusLab.textColor = statusColor;
}

@end
