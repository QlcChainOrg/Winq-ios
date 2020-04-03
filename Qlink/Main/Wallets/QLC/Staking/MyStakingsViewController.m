//
//  MyStakingsViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyStakingsViewController.h"
#import "UIView+Gradient.h"
#import "NewStakingViewController.h"
#import "MyStakingsCell.h"
#import "StakingDetailViewController.h"
#import "AFJSONRPCClient.h"
#import "ConfigUtil.h"
#import "WalletCommonModel.h"
#import "RefreshHelper.h"
#import "PledgeInfoByBeneficialModel.h"
#import "NSString+RandomStr.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
#import "QContractView.h"
#import "NEOWalletInfo.h"
#import "QLCWalletInfo.h"
#import "UserModel.h"
#import "DailyEarningsViewController.h"
#import "RLArithmetic.h"
#import "RSAUtil.h"
#import "ClaimConstants.h"
#import "NSString+RemoveZero.h"

static NSInteger const PledgeInfo_PageCount = 10;
static NSInteger const PledgeInfo_PageFirst = 0;

@interface MyStakingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topBack;
@property (weak, nonatomic) IBOutlet UIView *totalBack;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UIButton *invokeBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalStakingVolumeLab;
@property (weak, nonatomic) IBOutlet UILabel *stakingAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *earningsLab;
@property (weak, nonatomic) IBOutlet UILabel *freeAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *freeEarningsLab;
@property (weak, nonatomic) IBOutlet UILabel *totalEarningsLab;
@property (weak, nonatomic) IBOutlet UIView *lendingBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lendingHeight; // 70


@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) __block NSString *myStakingAmount;
@property (nonatomic) __block NSString *myEarningsAmount;
@property (nonatomic) __block NSString *freeStakingAmount;
@property (nonatomic) __block NSString *freeEarningsAmount;
@property (nonatomic, strong) QContractView *contractV;

@end

@implementation MyStakingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.theme_backgroundColor = globalBackgroundColorPicker;
    
    [self configInit];
    
    [self pullToRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getFreeRequest];
    [self refreshView];
}

#pragma mark - Operation
- (void)configInit {
    [_topBack addHorizontalQGradientWithStart:UIColorFromRGB(0x4986EE) end:UIColorFromRGB(0x4752E9) frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _lendingBack.layer.cornerRadius = 6;
    _lendingBack.layer.masksToBounds = YES;
    _totalBack.layer.cornerRadius = 4;
    _totalBack.layer.masksToBounds = YES;
    _invokeBtn.layer.cornerRadius = 4.0f;
    _invokeBtn.layer.masksToBounds = YES;
    [_mainTable registerNib:[UINib nibWithNibName:MyStakingsCellReuse bundle:nil] forCellReuseIdentifier:MyStakingsCellReuse];
    self.baseTable = _mainTable;
    _sourceArr = [NSMutableArray array];
    _currentPage = PledgeInfo_PageFirst;
    _freeStakingAmount = @"0";
    _freeEarningsAmount = @"0";
    _myStakingAmount = @"0";
    _myEarningsAmount = @"0";
    _lendingHeight.constant = 0;
    if ([UserModel haveLoginAccount] && [UserModel isBind]) { // 登录且已绑定
        _lendingHeight.constant = 70;
    }
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = PledgeInfo_PageFirst;
//        [weakself requestPledgeInfoByPledge:NO];
        [weakself pullToRequest];
    } type:RefreshTypeColor];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestPledgeInfoByPledge:NO];
    } type:RefreshTypeColor];
}

- (void)pullToRequest {
    [self requestPledgeInfoByPledge:NO];
    
    [self getFreeRequest];
}

- (void)getFreeRequest {
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself getClaimedAmount];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself getFreeStakeAmount];
    });
}

- (void)getClaimedAmount {
    kWeakSelf(self);
    [self requestReward_reward_total:Claim_Type_Register status:Claim_Status_Success completeBlock:^(NSString *reward) {
        weakself.freeEarningsAmount = reward;
        [weakself refreshAmountViewOfFree];
    }];
}

- (void)getFreeStakeAmount {
    kWeakSelf(self);
    [self requestWinq_reward_qlc_amountWithCompleteBlock:^(NSString *amount) {
        weakself.freeStakingAmount = amount;
        [weakself refreshAmountViewOfFree];
    }];
}

- (void)refreshView {
    [_mainTable reloadData];
    
    [self refreshAmountViewOfMy];
}

- (void)refreshAmountViewOfTotal {
    _totalStakingVolumeLab.text = [_myStakingAmount.div(@(QLC_UnitNum)).add(_freeStakingAmount) showfloatStrWith2Decimal];
    NSString *dd = _myEarningsAmount.div(@(QLC_UnitNum)).add(_freeEarningsAmount);
    _totalEarningsLab.text = [dd showfloatStrWith2Decimal];
}

- (void)refreshAmountViewOfFree {
    _freeAmountLab.text = _freeStakingAmount;
    _freeEarningsLab.text = _freeEarningsAmount;
    
    [self refreshAmountViewOfTotal];
}

- (void)refreshAmountViewOfMy {
    _myStakingAmount = @"0";
    _myEarningsAmount = @"0";
    kWeakSelf(self);
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PledgeInfoByBeneficialModel *model = obj;
        if (![model.state isEqualToString:PledgeState_WithdrawDone]) { // 赎回成功的不需要加
            weakself.myStakingAmount = weakself.myStakingAmount.add(model.amount);
        }
        weakself.myEarningsAmount = weakself.myEarningsAmount.add(model.qgas);
    }];
    
    _stakingAmountLab.text = _myStakingAmount.div(@(QLC_UnitNum));
    _earningsLab.text = _myEarningsAmount.div(@(QLC_UnitNum));
    
    [self refreshAmountViewOfTotal];
}

- (void)startBenefitPrepare:(NSString *)lockTxId {

    kWeakSelf(self);
    _contractV = [QContractView addQContractView];
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___")];
    [_contractV nep5_getLockInfo:lockTxId resultHandler:^(id result, BOOL success, NSString * _Nullable message) {
        if (success) {
            NSDictionary *dic = result;
            NSString *neoAddress = dic[@"neoAddress"];
            NSString *qlcAddress = dic[@"qlcAddress"];
            NSString *neo_publicKey = [NEOWalletInfo getNEOPublicKeyWithAddress:neoAddress];
//            NSString *neo_privateKey = [NEOWalletInfo getNEOPrivateKeyWithAddress:neoAddress];
            NSString *qlc_publicKey = [QLCWalletInfo getQLCPublicKeyWithAddress:qlcAddress];
            NSString *qlc_privateKey = [QLCWalletInfo getQLCPrivateKeyWithAddress:qlcAddress];
            NSString *multiSigAddress = dic[@"multiSigAddress"];
            NSString *qlcAmount = dic[@"amount"];
            NSString *state = dic[@"state"];
            if (!neo_publicKey) {
                [kAppD.window hideToast];
                [QContractView removeQContractView:weakself.contractV];
                [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@(%@)",kLang(@"the_wallet_is_none___"),neoAddress]];
                return;
            }
            if (!qlc_publicKey) {
                [kAppD.window hideToast];
                [QContractView removeQContractView:weakself.contractV];
                [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@(%@)",kLang(@"the_wallet_is_none___"),qlcAddress]];
                return;
            }
            if ([state integerValue] == 0) {
                [kAppD.window hideToast];
                [QContractView removeQContractView:weakself.contractV];
                return;
            }
            
            [weakself.contractV ledger_pledgeInfoByTransactionID:lockTxId resultHandler:^(id result, BOOL success, NSString * _Nullable message) {
                if (!success) {
                    NSNumber *num = result;
                    if ([num integerValue] == 1) { // lock成功 未走prepare
                        NSString *qlc_amount = [NSString stringWithFormat:@"%@",@([qlcAmount doubleValue]/QLC_UnitNum)];
                        [weakself.contractV nep5_prePareBenefitPledge:qlcAddress qlcAmount:qlc_amount multiSigAddress:multiSigAddress neo_publicKey:neo_publicKey lockTxId:lockTxId qlc_privateKey:qlc_privateKey qlc_publicKey:qlc_publicKey resultHandler:^(NSString * _Nullable result, BOOL success, NSString * _Nullable message) {
                            [kAppD.window hideToast];
                            [QContractView removeQContractView:weakself.contractV];
                            if (success) {
                                [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
                                [weakself.navigationController popToRootViewControllerAnimated:YES];
                            } else {
                                NSString *tip = [kLang(@"failed_") stringByAppendingFormat:@"(%@)",message ?: @""];
                                [kAppD.window makeToastDisappearWithText:tip];
                            }
                        }];
                    } else {
                        [kAppD.window hideToast];
                        [QContractView removeQContractView:weakself.contractV];
//                        NSString *tip = [kLang(@"failed_") stringByAppendingFormat:@"(%@)",message ?: @""];
//                        [kAppD.window makeToastDisappearWithText:tip];
                    }
                } else {
                    [kAppD.window hideToast];
                    [QContractView removeQContractView:weakself.contractV];
//                    NSString *tip = [kLang(@"failed_") stringByAppendingFormat:@"(%@)",message ?: @""];
//                    [kAppD.window makeToastDisappearWithText:tip];
                }
            }];
            
        } else {
            [kAppD.window hideToast];
            [QContractView removeQContractView:weakself.contractV];
//            NSString *tip = [kLang(@"failed_") stringByAppendingFormat:@"(%@)",message ?: @""];
//            [kAppD.window makeToastDisappearWithText:tip];
        }
    }];
}

#pragma mark - Request
- (void)requestWinq_reward_qlc_amountWithCompleteBlock:(void(^)(NSString *amount))completeBlock {
    //    kWeakSelf(self);
    NSDictionary *params = @{@"dictType":winq_reward_qlc_amount};
    [RequestService requestWithUrl10:sys_dict_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSString *valueStr = responseObject[Server_Data][@"value"];
            
            if (completeBlock) {
                completeBlock(valueStr);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestReward_reward_total:(NSString *)type status:(NSString *)status completeBlock:(void(^)(NSString *reward))completeBlock {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    //    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token,@"type":type,@"status":status};
    [RequestService requestWithUrl11:reward_reward_total_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            if (completeBlock) {
                NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"rewardTotal"]];
                completeBlock(result);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestPledgeInfoByPledge:(BOOL)showLoad {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    //qlc_178gc7sgefmfbmn1fi8uqhecwyewt6wu1y9rko1fb9snu89uupm1moc65gxu
    kWeakSelf(self);
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window];
    }
    NSArray *params = @[_inputAddress?:@"", @(PledgeInfo_PageCount), @(_currentPage*PledgeInfo_PageCount)];
    // ledger_pledgeInfoByBeneficial   ledger_pledgeInfoByPledge
    DDLogDebug(@"ledger_pledgeInfoByBeneficial params = %@",params);
    [client invokeMethod:@"ledger_pledgeInfoByBeneficial" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        NSLog(@"ledger_pledgeInfoByBeneficial result=%@",responseObject);
        NSArray *arr = [PledgeInfoByBeneficialModel mj_objectArrayWithKeyValuesArray:responseObject] ;
        
        if (weakself.currentPage == PledgeInfo_PageFirst) {
            [weakself.sourceArr removeAllObjects];
        }
        [weakself.sourceArr addObjectsFromArray:arr];
        [weakself refreshView];
        // 最后加1
        weakself.currentPage += 1;
        
        if (arr.count < PledgeInfo_PageCount) {
            [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
//            weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
            weakself.mainTable.mj_footer.hidden = YES;
        } else {
            weakself.mainTable.mj_footer.hidden = NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        NSLog(@"error=%@",error);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MyStakingsCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PledgeInfoByBeneficialModel *model = _sourceArr[indexPath.row];
    [self jumpToStakingDetail:model];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyStakingsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyStakingsCellReuse];
    
    PledgeInfoByBeneficialModel *model = _sourceArr[indexPath.row];
    [cell config:model];
    
    return cell;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)invokeNewStakingAction:(id)sender {
    [self jumpToNewStaking];
}

- (IBAction)txidAction:(id)sender {
    // [NSString stringWithFormat:kLang(@"insufficient_balance_go_to_otc_page_to_purchase_"),@"QGAS"]
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *txid = alertC.textFields.firstObject.text;
        if ([txid isEmptyString]) {
            return;
        }
        [weakself startBenefitPrepare:txid];
    }];
    [alertC addAction:alertBuy];
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"txid";
    }];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)lendingDetailAction:(id)sender {
    [self jumpToDailyEarnings];
}



#pragma mark - Transition
- (void)jumpToNewStaking {
    NewStakingViewController *vc = [NewStakingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToStakingDetail:(PledgeInfoByBeneficialModel *)model {
    StakingDetailViewController *vc = [StakingDetailViewController new];
    vc.inputPledgeM = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToDailyEarnings {
    DailyEarningsViewController *vc = [DailyEarningsViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
