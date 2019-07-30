//
//  MyOrderDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "EntrustOrderDetailViewController.h"
#import "EntrustOrderDetailCell.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "RefreshHelper.h"
#import "EntrustOrderInfoModel.h"
#import "TradeOrderListModel.h"

@interface EntrustOrderDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *contentBack;

@property (weak, nonatomic) IBOutlet UIView *orderStatusBack;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusSubTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *volumeLab;
@property (weak, nonatomic) IBOutlet UILabel *remainLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTableHeight;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBackHeight; // 59
@property (weak, nonatomic) IBOutlet UIView *bottomBack;

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) EntrustOrderInfoModel *orderInfoM;

@end

@implementation EntrustOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestEntrust_order_info];
}

#pragma mark - Operation
- (void)configInit {
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:EntrustOrderDetailCellReuse bundle:nil] forCellReuseIdentifier:EntrustOrderDetailCellReuse];
    kWeakSelf(self);
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestTrade_order_list];
    }];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTrade_order_list];
    }];
    
    _contentBack.hidden = YES;
    
    _cancelBtn.layer.cornerRadius = 4.0;
    _cancelBtn.layer.masksToBounds = YES;
    [_bottomBack shadowWithColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] offset:CGSizeMake(0,-0.5) opacity:1 radius:0];
}

- (void)refreshOrderInfoView {
    if (_orderInfoM) {
        _contentBack.hidden = NO;
        
        if ([_orderInfoM.status isEqualToString:@"NORMAL"]) {
            _orderStatusBack.backgroundColor = MAIN_BLUE_COLOR;
            _statusTitleLab.text = @"Active";
            _statusSubTitleLab.text = @"Active";
            _bottomBackHeight.constant = 59;
        } else if ([_orderInfoM.status isEqualToString:@"CANCEL"]) {
            _orderStatusBack.backgroundColor = UIColorFromRGB(0x999999);
            _statusTitleLab.text = @"Revoked";
            _statusSubTitleLab.text = @"Revoked";
            _bottomBackHeight.constant = 0;
        } else if ([_orderInfoM.status isEqualToString:@"END"]) {
            _orderStatusBack.backgroundColor = UIColorFromRGB(0x4ACCAF);
            _statusTitleLab.text = @"Completed";
            _statusSubTitleLab.text = @"Completed";
            _bottomBackHeight.constant = 0;
        }
        
        if ([_orderInfoM.type isEqualToString:@"SELL"]) {
            _addressTitleLab.text = @"ERC-20 Address to receive USDT";
            _addressLab.text = _orderInfoM.usdtAddress;
            _typeLab.text = @"ENTRUST SELL QGAS";
            _typeLab.textColor = UIColorFromRGB(0xFF3669);
            _remainLab.text = [NSString stringWithFormat:@"%@ QGAS",@([_orderInfoM.totalAmount integerValue] - [_orderInfoM.lockingAmount integerValue] - [_orderInfoM.completeAmount integerValue])];
            _remainLab.textColor = UIColorFromRGB(0xFF3669);
        } else if ([_orderInfoM.type isEqualToString:@"BUY"]) {
            _addressTitleLab.text = @"QLC Chain Address to receive QGAS";
            _addressLab.text = _orderInfoM.qgasAddress;
            _typeLab.text = @"ENTRUST BUY QGAS";
            _typeLab.textColor = MAIN_BLUE_COLOR;
            _remainLab.text = [NSString stringWithFormat:@"%@ QGAS",@([_orderInfoM.totalAmount integerValue] - [_orderInfoM.lockingAmount integerValue] - [_orderInfoM.completeAmount integerValue])];
            _remainLab.textColor = MAIN_BLUE_COLOR;
        }
        _totalLab.text = [NSString stringWithFormat:@"%@ QGAS",_orderInfoM.totalAmount];
        _unitPriceLab.text = [NSString stringWithFormat:@"%@ USDT",_orderInfoM.unitPrice];
        _volumeLab.text = [NSString stringWithFormat:@"%@-%@ QGAS",_orderInfoM.minAmount,_orderInfoM.maxAmount];
        
        
    }
}

#pragma mark - Request
- (void)requestEntrust_order_info {
    NSDictionary *params = @{@"entrustOrderId":_inputEntrustOrderId?:@""};
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:entrust_order_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.orderInfoM = [EntrustOrderInfoModel getObjectWithKeyValues:responseObject[@"order"]];
            [weakself refreshOrderInfoView];
            
            [weakself requestTrade_order_list];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)requestTrade_order_list {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSString *page = [NSString stringWithFormat:@"%@",@(_currentPage)];
    NSString *size = @"20";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token,@"page":page,@"size":size,@"entrustOrderId":_inputEntrustOrderId?:@""}];

    [RequestService requestWithUrl:trade_order_list_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [TradeOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderList"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            [weakself.sourceArr addObjectsFromArray:arr];
            weakself.currentPage += 1;
            [weakself.mainTable reloadData];
            weakself.mainTableHeight.constant = arr.count*EntrustOrderDetailCell_Height;
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
    }];
}

- (void)requestEntrust_cancel_order {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token,@"entrustOrderId":_inputEntrustOrderId?:@""}];
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:entrust_cancel_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"Success."];
            [weakself requestEntrust_order_info];
        } else {
            [kAppD.window makeToastDisappearWithText:@"Fail."];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EntrustOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:EntrustOrderDetailCellReuse];

    TradeOrderListModel *model = _sourceArr[indexPath.row];
    [cell config:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return EntrustOrderDetailCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addressCopyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _addressLab.text?:@"";
    [kAppD.window makeToastDisappearWithText:@"Copied"];
}


- (IBAction)cancelAction:(id)sender {
    [self requestEntrust_cancel_order];
}

@end
