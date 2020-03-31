//
//  ETHTransferViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NEOTransferViewController.h"
#import "NEOTransferConfirmView.h"
#import "UITextView+ZWPlaceHolder.h"
#import "WalletCommonModel.h"
#import "NEOAddressInfoModel.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import <ETHFramework/ETHFramework.h>
#import "NEOWalletUtil.h"
#import "WalletQRViewController.h"
#import "Qlink-Swift.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
#import "NEOJSUtil.h"
#import "NEOWalletInfo.h"
//#import "GlobalConstants.h"

@interface NEOTransferViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *symbolLab;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextView *sendtoAddressTV;
@property (weak, nonatomic) IBOutlet UITextField *memoTF;

@property (nonatomic, strong) NSMutableArray *tokenPriceArr;
@property (nonatomic, strong) NEOAssetModel *selectAsset;

@end

@implementation NEOTransferViewController

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//#pragma mark - Observe
//- (void)addObserve {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferSuccess:) name:NEO_Transfer_Success_Noti object:nil];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self addObserve];
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    [_sendBtn cornerRadius:6];
}

- (void)configInit {
    _selectAsset = _inputAsset?:_inputSourceArr?_inputSourceArr.firstObject:nil;
    _tokenPriceArr = [NSMutableArray array];
    
    _sendtoAddressTV.placeholder = kLang(@"neo_wallet_address");
    _sendtoAddressTV.text = _inputAddress;
    
    _sendBtn.userInteractionEnabled = NO;
    [_amountTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    _sendtoAddressTV.delegate = self;
    
    [self refreshView];
}

- (void)refreshView {
    _symbolLab.text = _selectAsset.asset_symbol;
    _balanceLab.text = [NSString stringWithFormat:@"%@: %@ %@",kLang(@"balance"),[_selectAsset getTokenNum],_selectAsset.asset_symbol];
    [self requestTokenPrice];
}

- (void)showNEOTransferConfirmView {
    NSString *fromAddress = [WalletCommonModel getCurrentSelectWallet].address?:@"";
    NSString *toAddress = _sendtoAddressTV.text;
    NSString *amount = [NSString stringWithFormat:@"%@ %@",_amountTF.text,_selectAsset.asset_symbol];
    NEOTransferConfirmView *view = [NEOTransferConfirmView getInstance];
    [view configWithFromAddress:fromAddress toAddress:toAddress amount:amount];
//    [view configWithAddress:address amount:amount];
    kWeakSelf(self);
    view.confirmBlock = ^{
        [weakself sendTransfer:fromAddress];
    };
    [view show];
}

- (void)checkSendBtnEnable {
    if (_sendtoAddressTV.text && _sendtoAddressTV.text.length > 0 && _amountTF.text && _amountTF.text.length > 0) {
//        [_sendBtn setBackgroundColor:MAIN_BLUE_COLOR];
        _sendBtn.theme_backgroundColor = globalBackgroundColorPicker;
        _sendBtn.userInteractionEnabled = YES;
    } else {
        [_sendBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
        _sendBtn.userInteractionEnabled = NO;
    }
}

- (void)textFieldDidEnd {
    [self checkSendBtnEnable];
}

- (void)sendTransfer:(NSString *)from_address {
    NSInteger decimals = [NEO_Decimals integerValue];
    NSString *tokenHash = _selectAsset.asset_hash;
    NSString *assetName = _selectAsset.asset;
    NSString *toAddress = _sendtoAddressTV.text;
    NSString *amount = _amountTF.text;
    NSString *symbol = _selectAsset.asset_symbol;
//    NSString *fromAddress = [WalletCommonModel getCurrentSelectWallet].address;
    NSString *fromAddress = from_address;
    NSString *remarkStr = _memoTF.text;
    NSInteger assetType = 1; // 0:neo、gas  1:代币
    if ([symbol isEqualToString:@"GAS"] || [symbol isEqualToString:@"NEO"]) {
        assetType = 0;
    }
    BOOL isNEOMainNetTransfer = YES;
    double fee = NEO_fee;
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window text:NSStringLocalizable(@"loading")];
    
    NSString *wif = [NEOWalletInfo getNEOEncryptedKeyWithAddress:fromAddress]?:@"";
    NSString *decimalStr = NEO_Decimals;
    [NEOJSUtil addNEOJSView];
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___")];
    [NEOJSUtil neoTransferWithFromAddress:fromAddress toAddress:toAddress assetHash:tokenHash amount:amount numOfDecimals:decimalStr wif:wif resultHandler:^(id  _Nullable result, BOOL success, NSString * _Nullable message) {
        [kAppD.window hideToast];
        [NEOJSUtil removeNEOJSView];
        if (success) {
//            NSString *txid = result;
            [kAppD.window showWalletAlertViewWithTitle:NSStringLocalizable(@"transfer_tip") msg:[[NSMutableAttributedString alloc] initWithString:NSStringLocalizable(@"transfer_processed")] isShowTwoBtn:NO block:^{
                [weakself backToRoot];
            }];
        } else {
            [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"neo_transfer_fail")];
        }
    }];
    
    
    // 原生NEO转账(服务器已关)
//    [NEOWalletUtil sendNEOWithTokenHash:tokenHash decimals:decimals assetName:assetName amount:amount toAddress:toAddress fromAddress:fromAddress symbol:symbol assetType:assetType mainNet:isNEOMainNetTransfer remarkStr:remarkStr fee:fee successBlock:^(NSString *txid) {
//        [kAppD.window hideToast];
//        [weakself backToRoot];
//    } failureBlock:^{
//        [kAppD.window hideToast];
//    }];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Request
- (void)requestTokenPrice {
    kWeakSelf(self);
    NSString *coin = [ConfigUtil getLocalUsingCurrency];
    NSDictionary *params = @{@"symbols":@[_selectAsset.asset_symbol],@"coin":coin};
    [RequestService requestWithUrl5:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.tokenPriceArr removeAllObjects];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenPriceModel *model = [TokenPriceModel getObjectWithKeyValues:obj];
                model.coin = coin;
                [weakself.tokenPriceArr addObject:model];
            }];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - UITextViewDelete
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self checkSendBtnEnable];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)scanAction:(id)sender {
    kWeakSelf(self);
    WalletQRViewController *vc = [[WalletQRViewController alloc] initWithCodeQRCompleteBlock:^(NSString *codeValue) {
        weakself.sendtoAddressTV.text = codeValue;
    } needPop:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sendAction:(id)sender {
    if (!_amountTF.text || _amountTF.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_is_empty")];
        return;
    }
    if (!_sendtoAddressTV.text || _sendtoAddressTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"neo_wallet_address_is_empty")];
        return;
    }
    if ([_amountTF.text doubleValue] == 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_is_zero")];
        return;
    }
    if ([_amountTF.text doubleValue] > [[_selectAsset getTokenNum] doubleValue]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"balance_is_not_enough")];
        return;
    }
    
    // 检查地址有效性
    BOOL validateNEOAddress = [NEOWalletManage.sharedInstance validateNEOAddressWithAddress:_sendtoAddressTV.text];
    if (!validateNEOAddress) {
        [kAppD.window makeToastDisappearWithText:kLang(@"neo_wallet_address_is_invalidate")];
        return;
    }
    
//    // 转QLC需要gas检查
//    if ([_selectAsset.asset_symbol isEqualToString:@"QLC"]) {
//        __block NSNumber *gas = @(0);
//        [_inputSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NEOAssetModel *asset = obj;
//            if ([asset.asset_symbol isEqualToString:@"GAS"]) {
//                gas = asset.amount;
//            }
//        }];
//        if (([gas doubleValue] < GAS_Control)) {
//            [kAppD.window showWalletAlertViewWithTitle:NSStringLocalizable(@"prompt") msg:[[NSMutableAttributedString alloc] initWithString:NSStringLocalizable(@"neo_nep5_gas_less")] isShowTwoBtn:NO block:^{
//            }];
//            return;
//        }
//    }
    
    [self showNEOTransferConfirmView];
}

- (IBAction)showCurrencyAction:(id)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self);
    [_inputSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOAssetModel *model = obj;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:model.asset_symbol style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.selectAsset = model;
            [weakself refreshView];
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:nil];
}

//#pragma mark - Noti
//- (void)transferSuccess:(NSNotification *)noti {
//    [self backToRoot];
//}

@end
