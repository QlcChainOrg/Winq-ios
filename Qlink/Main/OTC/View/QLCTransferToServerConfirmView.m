//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QLCTransferToServerConfirmView.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface QLCTransferToServerConfirmView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *sendtoLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end

@implementation QLCTransferToServerConfirmView

+ (instancetype)getInstance {
    QLCTransferToServerConfirmView *view = [[[NSBundle mainBundle] loadNibNamed:@"QLCTransferToServerConfirmView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
//    [view configInit];
    return view;
}

//- (void)configInit {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    _walletNameLab.text = currentWalletM.name;
//    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[currentWalletM.address substringToIndex:8],[currentWalletM.address substringWithRange:NSMakeRange(currentWalletM.address.length - 8, 8)]];
//}

- (void)configWithFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress amount:(NSString *)amount tokenName:(NSString *)tokenName memo:(NSString *)memo {
    WalletCommonModel *walletM = [WalletCommonModel getWalletWithAddress:fromAddress];
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    _walletNameLab.text = walletM.name;
    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[walletM.address substringToIndex:8],[walletM.address substringWithRange:NSMakeRange(walletM.address.length - 8, 8)]];
    _sendtoLab.text = toAddress;
    _amountLab.text = amount;
//    _statusLab.text = [NSString stringWithFormat:@"%@ %@",kLang(@"sell"),tokenName];
    _statusLab.text = memo?:[NSString stringWithFormat:@"%@ %@",kLang(@"sell"),tokenName];
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    [self.tipBack showPopAnimate];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if (_confirmBlock) {
        _confirmBlock();
    }
    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}


@end
