//
//  VpnRegisterServerViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/8/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VpnRegisterServerViewController.h"
//#import "ChooseContinentViewController.h"
#import "ChooseCountryUtil.h"
//#import "SeizeVPNViewController.h"
#import <NetworkExtension/NetworkExtension.h>
#import "SelectCountryModel.h"
#import "VPNFileUtil.h"
#import "HistoryRecrdInfo.h"
#import "NEOWalletUtil.h"
#import "HeartbeatUtil.h"
#import "NeoTransferUtil.h"
#import "VPNOperationUtil.h"
#import "Qlink-Swift.h"
#import "ChooseCountryView.h"
#import "VPNMode.h"
#import <MMWormhole/MMWormhole.h>
#import "MD5Util.h"
#import "ContinentModel.h"
#import "ChooseConfigurationCell.h"
#import "WalletQRViewController.h"
#import "VPNDataUtil.h"
//#import <NEOFramework/NEOFramework.h>
#import "ToxRequestModel1.h"
#import "P2pMessageManage.h"
#import "WalletCommonModel.h"
#import "ToxRequestModel.h"

#define FeeMin 0.1
#define FeeMax 3
#define ConnectionMin 1
#define ConnectionMax 20
#define CHOOSECOUNTRY @"Choose a country"
#define CELL_SELECT_BTN_TAG 8884
#define P2P_Message_Timeout 15

@interface VpnRegisterServerViewController () {
    BOOL checkConnnectOK;
    BOOL connectVpnDone;
}
@property (weak, nonatomic) IBOutlet UITextView *serverP2pIdTF;

@property (weak, nonatomic) IBOutlet UILabel *lblNavTitle;

//@property (weak, nonatomic) IBOutlet UIView *vpnNameUnderlineV;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UITextField *vpnNameTF;
@property (nonatomic, strong) NSString *vpnTFName;
@property (nonatomic, strong) NSString *selectCountryStr;
@property (nonatomic, strong) CountryModel *selectCountryM;

//@property (weak, nonatomic) IBOutlet UITextField *profileTF;
@property (weak, nonatomic) IBOutlet UITextField *privateKeyTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
//@property (nonatomic, strong) NSString *selectName;
@property (nonatomic, strong) NSString *profileName;
@property (nonatomic, strong) NSString *serverP2Pid;

@property (weak, nonatomic) IBOutlet UIView *settingBack;
@property (weak, nonatomic) IBOutlet UILabel *hourlyLab;
@property (weak, nonatomic) IBOutlet UISlider *hourlyFeeSlider;
@property (weak, nonatomic) IBOutlet UILabel *connectionLab;
@property (weak, nonatomic) IBOutlet UISlider *connectionSlider;
@property (nonatomic, strong) NSString *hourlyFee;
@property (nonatomic, strong) NSString *connectNum;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (nonatomic) BOOL assetIsValidate;
@property (nonatomic,copy) NSString *hex;
@property (nonatomic , strong) ChooseCountryView *countryView;
@property (nonatomic , assign) BOOL isFileNameSame;

@property (nonatomic) BOOL isVerifyVPN; // 是否验证VPN操作中
@property (nonatomic, strong) MMWormhole *wormhole;

@property (weak, nonatomic) IBOutlet UITableView *configurationTable;
//@property (nonatomic, strong) NSMutableArray *vpnDataArr;
@property (nonatomic, strong) NSMutableArray *vpnNameArr;
@property (nonatomic, strong) NSData *selectVpnData;
@property (nonatomic, strong) NSString *vpnFileMd5;
@property (nonatomic) NSInteger tempSelectIndex;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getFileFailHeight; // 44
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getFileSuccessHeight; // table.height + 29
@property (nonatomic) NSInteger selectFileIndex;

@end

@implementation VpnRegisterServerViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnStatusChange:) name:VPN_STATUS_CHANGE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savePreferenceFail:) name:SAVE_VPN_PREFERENCE_FAIL_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCountryNoti:) name:SELECT_COUNTRY_NOTI_VPNREGISTER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configVPNError:) name:CONFIG_VPN_ERROR_NOTI object:nil];
    // vpn 文件发送完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnSendSuccessNoti:) name:FILE_SEND_SUCCESS_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendVpnFileListRspSuccessNoti:) name:SendVpnFileListRsp_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendVpnFileNewRspSuccessNoti:) name:SendVpnFileNewRspOfRegister_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkConnectRsp:) name:CheckConnectRsp_Register_Noti object:nil];
    
}

#pragma mark - Init
- (instancetype) initWithRegisterType:(RegisterServerType) type
{
    if (self = [super init]) {
        _registerType = type;
    }
    return self;
}

- (instancetype) initWithRegisterType:(RegisterServerType) type withVPNName:(NSString *) name withSeizePrice:(NSString *) seize_price withOldPrice:(NSString *) old_price vpnAddress:(NSString *)address vpnP2pid:(NSString *) toP2pid
{
    if (self = [super init]) {
        _registerType = type;
        self.vpnName = name;
        self.seizePrice = seize_price;
        self.oldPrice = old_price;
        self.vpnAddress = address;
        self.vpnP2pid = toP2pid;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self addObserve];
    [self dataInit];
    [self wormholeInit];
    [self configView];
    if (_registerType == UpdateServerVPN) {
        [_registerBtn setTitle:NSStringLocalizable(@"vpn_update") forState:UIControlStateNormal];
        _lblNavTitle.text = NSStringLocalizable(@"vpn_detail");
        [self configureVPNInfo];
    }
    
    
    
//    [self getConfigurationFile];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateHourlyAndConnection];
}

#pragma mark - Config
- (void)dataInit {
//    _serverP2pIdTF.text = @"A06A5193F94A992A9E928AF9ECD793558A2EDF679F543B3B20FB0A1DB00C036D6B8E9F9366CC";
    [_configurationTable registerNib:[UINib nibWithNibName:ChooseConfigurationCellReuse bundle:nil] forCellReuseIdentifier:ChooseConfigurationCellReuse];
    _getFileFailHeight.constant = 0;
    _getFileSuccessHeight.constant = 0;
    _selectFileIndex = -1;
    
    if (_registerType == UpdateServerVPN) {
        _assetIsValidate = YES;
    } else {
        _assetIsValidate = NO;
    }
}

- (void)wormholeInit {
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:GROUP_WORMHOLE
                                                         optionalDirectory:DIRECTORY_WORMHOLE];
    //    kWeakSelf(self);
    [self.wormhole listenForMessageWithIdentifier:VPN_ERROR_REASON_IDENTIFIER
                                         listener:^(id messageObject) {
                                             DDLogDebug(@"vpn_error_reason---------------%@",messageObject);
                                             VPNConnectOperationType operationType = [VPNOperationUtil shareInstance].operationType;
                                             if (operationType == registerConnect) { // 注册连接vpn
                                                 [kAppD.window hideToast];
                                                 [KEYWINDOW makeToastDisappearWithText:messageObject];
                                             }
                                         }];
}

#pragma -mark UPDATE_VPN初始化
- (void) configureVPNInfo
{
    if (_registerType == UpdateServerVPN) {
        _vpnNameTF.text = self.vpnInfo.vpnName?:@"";
        _vpnNameTF.enabled = NO;
        _countryLab.text = self.vpnInfo.country?:@"";
//        _profileTF.text = self.vpnInfo.profileLocalPath?:@"";
        _serverP2pIdTF.text = self.vpnInfo.p2pId;
        _privateKeyTF.text = self.vpnInfo.privateKeyPassword?:@"";
        _privateKeyTF.enabled = NO;
        _userNameTF.text = self.vpnInfo.username?:@"";
        _userNameTF.enabled = NO;
        _passwordTF.text = self.vpnInfo.password?:@"";
        _passwordTF.enabled = NO;
        [_hourlyFeeSlider setValue:[self.vpnInfo.connectCost floatValue] animated:YES];
        [_connectionSlider setValue:[self.vpnInfo.connectNum floatValue] animated:YES];
        [self updateHourlyAndConnection];
        
        [self addFriendAndCheckOnline]; // 更新vpn需要调用获取vpn file list
    }
}

- (void)configView {
//    _vpnNameUnderlineV.textField = _vpnNameTF;
    _contentView.layer.cornerRadius = 3.0f;
    _contentView.layer.masksToBounds = YES;
    [_vpnNameTF addTarget:self action:@selector(vpnNameEndEdit) forControlEvents:UIControlEventEditingDidEnd];
    
    _hourlyLab.adjustsFontSizeToFitWidth = YES;
    UIImage *img = [UIImage imageNamed:@"icon_the_selected"];
    [_hourlyFeeSlider setThumbImage:img forState:UIControlStateNormal];
    [_connectionSlider setThumbImage:img forState:UIControlStateNormal];
}

- (void)updateHourlyAndConnection {
    [self updateHourlyLab];
    [self updateConnectionLab];
}

- (void)updateHourlyLab {
    CGFloat thumbWidth = 20;
    CGFloat startX = _hourlyFeeSlider.left + thumbWidth/2.0;
    CGFloat endX = _hourlyFeeSlider.right - thumbWidth/2.0;
    CGFloat moveWidth = endX - startX;
    CGFloat labWidth = 50;
    CGFloat labHeight = 20;
    _hourlyLab.text = [NSString stringWithFormat:@"%.1f",_hourlyFeeSlider.value];
    CGFloat offsetX = moveWidth*((_hourlyFeeSlider.value - _hourlyFeeSlider.minimumValue)/(_hourlyFeeSlider.maximumValue - _hourlyFeeSlider.minimumValue));
    _hourlyLab.frame = CGRectMake(startX - labWidth/2.0 + offsetX, _hourlyFeeSlider.top - labHeight, labWidth, labHeight);
}

- (void)updateConnectionLab {
    CGFloat thumbWidth = 20;
    CGFloat startX = _connectionSlider.left + thumbWidth/2.0;
    CGFloat endX = _connectionSlider.right - thumbWidth/2.0;
    CGFloat moveWidth = endX - startX;
    CGFloat labWidth = 50;
    CGFloat labHeight = 20;
    _connectionLab.text = [NSString stringWithFormat:@"%.0f",_connectionSlider.value];
    CGFloat offsetX = moveWidth*((_connectionSlider.value - _connectionSlider.minimumValue)/(_connectionSlider.maximumValue - _connectionSlider.minimumValue));
    _connectionLab.frame = CGRectMake(startX - labWidth/2.0 + offsetX, _connectionSlider.top - labHeight, labWidth, labHeight);
}

#pragma mark - Operation
- (void)validateAssetIsexist {
    if (_registerType == RegisterServerVPN) {
        [self requestValidateAssetIsexist];
    }
}

- (void)storeRegisterVPN:(NSDictionary *)dic {
    VPNInfo *localVpnInfo = [VPNInfo new];
    localVpnInfo.bg_tableName = VPNREGISTER_TABNAME;
    localVpnInfo.vpnName = dic[@"vpnName"];
    localVpnInfo.country = dic[@"country"];
    localVpnInfo.p2pId = dic[@"p2pId"];
    localVpnInfo.ownerP2pId = dic[@"ownerP2pId"];
    localVpnInfo.isServerVPN = YES;
    localVpnInfo.address = dic[@"address"];
    localVpnInfo.qlc = dic[@"qlc"];
    localVpnInfo.registerQlc = dic[@"qlc"];
    localVpnInfo.connectNum = dic[@"connectNum"];
    localVpnInfo.connectCost = dic[@"connectCost"];
    localVpnInfo.ipV4Address = dic[@"ipV4Address"];
    localVpnInfo.bandwidth = dic[@"bandWidth"];
    localVpnInfo.profileLocalPath = dic[@"profileLocalPath"];
    localVpnInfo.isMainNet = [ConfigUtil isMainNetOfServerNetwork];
    localVpnInfo.password = _passwordTF.text.trim?: @"";
    localVpnInfo.privateKeyPassword = _privateKeyTF.text.trim?: @"";
    localVpnInfo.username = _userNameTF.text.trim?: @"";
    
    [localVpnInfo bg_saveOrUpdate];
    // 更新keyChain
    [VPNOperationUtil saveArrayToKeyChain];
}

- (void)tellVpnServerRegisterSuccess:(NSDictionary *)dic {
    NSString *vpnfileName = _vpnNameArr[_selectFileIndex]?:@"";
    NSString *password = _passwordTF.text.trim?:@"";
    NSString *privateKeyPassword = _privateKeyTF.text.trim?:@"";
    NSString *userName = _userNameTF.text.trim?:@"";
    NSString *vpnName = dic[@"vpnName"]?:@"";
    
    ToxRequestModel1 *model = [[ToxRequestModel1 alloc] init];
    model.type = vpnRegisterSuccessNotify;
    NSDictionary *tempDic = @{@"password":password, @"vpnName":vpnName, @"privateKeyPassword":privateKeyPassword,@"userName":userName,@"vpnfileName":vpnfileName};
    model.data = tempDic;
    NSString *str = model.mj_JSONString;
    [ToxManage sendMessageWithMessage:str withP2pid:self.serverP2Pid];
}

- (BOOL)isEmptyOfUsername {
    BOOL empty = NO;
    if (self.userNameTF.text == nil || self.userNameTF.text.length <= 0) {
        empty = YES;
    }
    return empty;
}

- (BOOL)isEmptyOfPassword {
    BOOL empty = NO;
    if (self.passwordTF.text == nil || self.passwordTF.text.length <= 0) {
        empty = YES;
    }
    return empty;
}

- (BOOL)isEmptyOfPrivateKey {
    BOOL empty = NO;
    if (self.privateKeyTF.text == nil || self.privateKeyTF.text.length <= 0) {
        empty = YES;
    }
    return empty;
}

- (BOOL)isEmptyOfCountry {
    BOOL empty = NO;
    if (self.selectCountryStr == nil || [self.selectCountryStr isEmptyString]) {
        empty = YES;
    }
    return empty;
}

- (BOOL)isEmptyOfVPNName {
    BOOL empty = NO;
    if (self.vpnNameTF.text == nil || self.vpnNameTF.text.length <= 0) {
        empty = YES;
    }
    return empty;
}

- (BOOL)isEmptyOfP2PID {
    BOOL empty = NO;
    if (self.serverP2pIdTF.text == nil || self.serverP2pIdTF.text.length <= 0) {
        empty = YES;
    }
    return empty;
}

- (BOOL)isEmptyOfProfile {
    BOOL empty = NO;
//    if (_vpnDataArr.count <= 0) {
    if (_vpnNameArr.count <= 0) {
        empty = YES;
    }
    if (_selectFileIndex < 0) {
        empty = YES;
    }
    return empty;
}

- (void)vpnNameEndEdit {
    _vpnName = _vpnNameTF.text;
    [self validateAssetIsexist];
}

- (void)verifyProfile {
//    if (!self.selectName) {
//        return;
//    }
//    NSString *vpnPath = [VPNFileUtil getVPNPathWithFileName:self.selectName];
//    NSData *vpnData = [NSData dataWithContentsOfFile:vpnPath];
//    if (!vpnData) {
//        [kAppD.window showHint:[NSString stringWithFormat:@"%@ %@",self.selectName,NSStringLocalizable(@"not_found")]];
//        return;
//    }
//    NSData *vpnData = ((NSDictionary *)_vpnDataArr[_selectFileIndex]).allValues.firstObject;
    VPNUtil.shareInstance.connectData = _selectVpnData;
    kWeakSelf(self);
    [VPNUtil.shareInstance applyConfigurationWithVpnData:_selectVpnData completionHandler:^(NSInteger type) {
        if (type == 0) { // 自动
            [weakself goConnect];
        } else if (type == 1) { // 私钥
            if ([weakself isEmptyOfPrivateKey]) {
                [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"Fill_PrivateKey")];
                return;
            }
            VPNUtil.shareInstance.vpnPrivateKey = weakself.privateKeyTF.text;
            [weakself goConnect];
        } else if (type == 2) { // 用户名密码
            if ([weakself isEmptyOfUsername]) {
                [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"Fill_Username")];
                return;
            }
            if ([weakself isEmptyOfPassword]) {
                [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"Fill_Password")];
                return;
            }
            VPNUtil.shareInstance.vpnUserName = weakself.userNameTF.text;
            VPNUtil.shareInstance.vpnPassword = weakself.passwordTF.text;
            [weakself goConnect];
        } else if (type == 3) { // 私钥和用户名密码
            if ([weakself isEmptyOfUsername]) {
                [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"Fill_Username")];
                return;
            }
            if ([weakself isEmptyOfPassword]) {
                [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"Fill_Password")];
                return;
            }
            if ([weakself isEmptyOfPrivateKey]) {
                [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"Fill_PrivateKey")];
                return;
            }
            VPNUtil.shareInstance.vpnPrivateKey = weakself.privateKeyTF.text;
            VPNUtil.shareInstance.vpnUserName = weakself.userNameTF.text;
            VPNUtil.shareInstance.vpnPassword = weakself.passwordTF.text;
            [weakself goConnect];
        }
    }];
}

- (void)goConnect {
    [kAppD.window makeToastInView:self.view text:NSStringLocalizable(@"check")];
    
    _isVerifyVPN = YES;
    connectVpnDone = NO;
    NSTimeInterval timeout = CONNECT_VPN_TIMEOUT;
    [self performSelector:@selector(connectVpnTimeout) withObject:nil afterDelay:timeout];
    // vpn连接操作
    [VPNOperationUtil shareInstance].operationType = registerConnect;
    [VPNUtil.shareInstance configVPN];
}

- (void)connectVpnTimeout {
    if (!connectVpnDone) {
        [kAppD.window hideToast];
        [VPNUtil.shareInstance stopVPN];
    }
}

- (void)addSendCheckConnect {
    [kAppD.window makeToastInView:KEYWINDOW text:NSStringLocalizable(@"checking")];
//    _connectStep = ConnectStepCheckConnect;
    checkConnnectOK = NO;
    // 发送获取配置文件消息
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = checkConnectReq;
    NSString *p2pid = [ToxManage getOwnP2PId];
    NSDictionary *dataDic = @{APPVERSION:APP_Build,P2P_ID:p2pid,@"type":@(0)}; // type:0-注册  1-连接 2-vpn上报服务器
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    [ToxManage sendMessageWithMessage:str withP2pid:self.serverP2Pid];
    [self performSelector:@selector(checkConnectTimeout) withObject:nil afterDelay:P2P_Message_Timeout];
}

- (void)addFriendAndCheckOnline {
    [self.vpnNameArr removeAllObjects];
//    [self.vpnDataArr removeAllObjects];
    [[VPNDataUtil shareInstance].vpnDataDic removeAllObjects];
    [_configurationTable reloadData];
    _getFileFailHeight.constant = 0;
    _getFileSuccessHeight.constant = 0;
    
    if ([[NSStringUtil getNotNullValue:self.serverP2Pid] isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"p2pid_empty")];
    } else {
        // -1:添加好友失败   -2:好友不在线  >0 成功
        int result = [VPNFileUtil getServerVPNFileWithServerId:self.serverP2Pid];
        if (result > 0) {
            [self addSendCheckConnect];
        } else {
            [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"wait_p2p_online")];
            _getFileFailHeight.constant = 44;
            _getFileSuccessHeight.constant = 0;
        }
    }
}

- (void)sendVpnFileListRequest {
    [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:30];
    ToxRequestModel1 *model = [[ToxRequestModel1 alloc] init];
    model.type = sendVpnFileListReq;
    NSDictionary *tempDic = @{APPVERSION:APP_Build};
    model.data = tempDic;
    NSString *str = model.mj_JSONString;
    [VPNDataUtil shareInstance].sendVpnFileListRspMsgid = nil;
    [[VPNDataUtil shareInstance].sendVpnFileListRspArr removeAllObjects];
    [VPNDataUtil shareInstance].sendVpnFileListRspMsg = nil;
    [ToxManage sendMessageWithMessage:str withP2pid:self.serverP2Pid];
}

#pragma mark - Noti
- (void)vpnStatusChange:(NSNotification *)noti {
    NEVPNStatus status = (NEVPNStatus)[noti.object integerValue];
    switch (status) {
        case NEVPNStatusInvalid:
            break;
        case NEVPNStatusDisconnected:
        {
            
        }
            break;
        case NEVPNStatusConnecting:
            break;
        case NEVPNStatusConnected:
        {
            [kAppD.window hideToast];
            if (_isVerifyVPN) { // 如果是验证操作的话，断开连接
                _isVerifyVPN = NO;
                connectVpnDone = YES;
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectVpnTimeout) object:nil];
                [self performSelector:@selector(requestRegisterVpnByFeeV3) withObject:nil afterDelay:0.6];
            }
        }
            break;
        case NEVPNStatusReasserting:
            break;
        case NEVPNStatusDisconnecting:
        {
            [kAppD.window hideToast];
            if (_isVerifyVPN) { // 如果是验证操作的话
                _isVerifyVPN = NO;
                connectVpnDone = YES;
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectVpnTimeout) object:nil];
                //                [self.view showHint:NSStringLocalizable(@"check_profile")];
            }
        }
            break;
        default:
            break;
    }
}

- (void)savePreferenceFail:(NSNotification *)noti {
    [kAppD.window hideToast];
    [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"save_failed")];
}

- (void)selectCountryNoti:(NSNotification *)noti {
    self.selectCountryM = noti.object;
    _countryLab.text = _selectCountryM.name;
    _selectCountryStr = _selectCountryM.name;
}

- (void)configVPNError:(NSNotification *)noti {
    NSString *errorDes = noti.object;
    DDLogDebug(@"Config VPN Error:%@",errorDes);
    [kAppD.window hideToast];
    [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"configuration_faield")];
}

- (void) vpnSendSuccessNoti:(NSNotification *) noti {
    [kAppD.window hideToast];
    NSDictionary *vpnDic = (NSDictionary *)noti.object;
    if (vpnDic) {
        _getFileSuccessHeight.constant = 29 + vpnDic.count*38;
        _getFileFailHeight.constant = 0;
        
       __block NSMutableArray *tempArr = [NSMutableArray array];
        [vpnDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSDictionary *dic = @{key:obj};
            [tempArr addObject:dic];
        }];
        
        if (_registerType == UpdateServerVPN) { // 更新vpn需要找到之前的vpn显示出来
            __block NSInteger tempSelectIndex = 0;
            [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                NSString *vpnPath = dic.allKeys.firstObject;
                if ([_vpnInfo.profileLocalPath isEqualToString:vpnPath]) {
                    tempSelectIndex = idx;
                }
            }];
            _selectFileIndex = tempSelectIndex;
        }
        
//        if (self.vpnDataArr.count > 0) {
//            [self.vpnDataArr removeAllObjects];
//        }
//        [self.vpnDataArr addObjectsFromArray:tempArr];
        [_configurationTable reloadData];
    } else {
        _getFileSuccessHeight.constant = 0;
        _getFileFailHeight.constant = 44;
    }
}

- (void)sendVpnFileListRspSuccessNoti:(NSNotification *)noti {
    [kAppD.window hideToast];
    NSString *vpnNameStr = (NSString *)noti.object; // 用分号隔开
    NSArray *nameArr = [vpnNameStr componentsSeparatedByString:@";"];
    if (nameArr && nameArr.count > 0) {
        _getFileSuccessHeight.constant = 29 + nameArr.count*38;
        _getFileFailHeight.constant = 0;
        
//        __block NSMutableArray *tempArr = [NSMutableArray array];
//        [vpnDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            NSDictionary *dic = @{key:obj};
//            [tempArr addObject:dic];
//        }];
        _selectFileIndex = -1; // 还没拿vpndata文件 默认不选择
        if (_registerType == UpdateServerVPN) { // 更新vpn需要找到之前的vpn显示出来
            __block NSInteger tempSelectIndex = 0;
            [nameArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *vpnPath = obj;
                if ([_vpnInfo.profileLocalPath containsString:vpnPath]) {
                    tempSelectIndex = idx;
                }
            }];
            _selectFileIndex = tempSelectIndex;
        }
        
        if (self.vpnNameArr.count > 0) {
            [self.vpnNameArr removeAllObjects];
        }
        [self.vpnNameArr addObjectsFromArray:nameArr];
        [_configurationTable reloadData];
    } else {
        _getFileSuccessHeight.constant = 0;
        _getFileFailHeight.constant = 44;
    }
}

- (void)sendVpnFileNewRspSuccessNoti:(NSNotification *)noti {
    [kAppD.window hideToast];
    NSArray *arr = noti.object;
    if (arr && arr.count > 0) {
        _selectVpnData = [arr[0] dataUsingEncoding:NSUTF8StringEncoding];
        _vpnFileMd5 = arr[1]?:@"";
    }
    
    _selectFileIndex = _tempSelectIndex;
    [_configurationTable reloadData];
}

- (void)checkConnectRsp:(NSNotification *)noti {
//    if (_connectStep != ConnectStepCheckConnect) {
//        return;
//    }
    if (checkConnnectOK) {
        return;
    }
    NSNumber *serverVersion = noti.object;
    if (!serverVersion || [serverVersion integerValue] < 1) { // 旧server
        [kAppD.window makeToastDisappearWithText:@"Please update server"];
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkConnectTimeout) object:nil];
    checkConnnectOK = YES;
    [kAppD.window hideToast];
    
    [self sendVpnFileListRequest];
}

- (void)checkConnectTimeout {
    if (!checkConnnectOK) {
//        _connectStep = ConnectStepNone;
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"connect_timeout")];
        [[NSNotificationCenter defaultCenter] postNotificationName:Check_Connect_Timeout_Noti object:nil];
    }
}

#pragma mark - Request
- (void)requestValidateAssetIsexist {
    if (self.vpnTFName.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSDictionary *params = @{@"vpnName":self.vpnTFName,@"type":@"3"};
    [RequestService requestWithUrl:validateAssetIsexist_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == Server_Code_Success) {
            if ([responseObject[Server_Data][@"isExist"] integerValue] == 0) { // vpnname不存在
                weakself.registerType = RegisterServerVPN;
                _assetIsValidate = YES;
                //                [weakself.registerV1 unableClaim];
            } else { // vpnname存在
                //                _assetIsValidate = YES;
                weakself.registerType = RegisterServerVPN;
                _assetIsValidate = NO;
                NSString *msg = NSStringLocalizable(@"repeat_vpn_name");
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertOK = [UIAlertAction actionWithTitle:NSStringLocalizable(@"ok") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertC addAction:alertOK];
                [self presentViewController:alertC animated:YES completion:nil];
                
                //                return;
                //                weakSelf.registerType = SeizeVPNWhenRegister;
                //                weakSelf.vpnName = weakSelf.vpnName;
                //                NSString *oldPrice = [NSString stringWithFormat:@"%@",@([responseObject[Server_Data][@"qlc"] floatValue])];
                //                weakSelf.oldPrice = oldPrice;
                //                [weakself.registerV1 setClaimText:oldPrice];
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window makeToastDisappearWithText:error.domain];
    }];
    
}

// 查询vpn资产信息
- (void)requestssIdquery {
    kWeakSelf(self);
    [kAppD.window makeToastInView:self.view text:nil];
    NSDictionary *params = @{@"ssId":self.vpnTFName};
    [RequestService requestWithUrl:ssIdquery_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == Server_Code_Success) {
            weakself.vpnP2pid = responseObject[Server_Data][@"p2pId"]?:@"";
            weakself.vpnAddress = responseObject[Server_Data][@"address"]?:@"";
            [weakself getRegisterOperation];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:error.domain];
    }];
    
}

// vpn验证成功后调用
- (void)requestRegisterVpnByFeeV3 {
    if (_registerType == UpdateServerVPN) {
        [self sendUpdateVPNRequest];
    } else {
        [self registerVPNAndTranQLC];
    }
}

//获取主网地址
- (void) sendMainAddressRequst
{
    [kAppD.window makeToastInView:self.view text:nil];

    // 获取主网地址
    kWeakSelf(self);
    [RequestService requestWithUrl:mainAddress_Url params:@{} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == Server_Code_Success) {
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            if (dataDic) {
                NSString *toAddress = [dataDic objectForKey:@"address"];
                weakself.vpnAddress = [NSStringUtil getNotNullValue:toAddress];
                [weakself getHexWithAddress:weakself.vpnAddress qlc:@"1"];
            } else {
                [kAppD.window hideToast];
            }
        } else {
            [kAppD.window hideToast];
            [weakself.view makeToastDisappearWithText:responseObject[Server_Msg]];
        }
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"request_error")];
    }];
    
}

/**
 获取hex
 @param toAddress 发送到地址
 */
- (void) getHexWithAddress:(NSString *) toAddress qlc:(NSString *) qlc  {
    kWeakSelf(self);
    BOOL isMainNetTransfer = NO;
    // 获取主测网的hash
    NSString *tokenHash = AESSET_TEST_HASH;
    if (isMainNetTransfer) {
        tokenHash = AESSET_MAIN_HASH;
    }
    // 获取 hex
    [NEOWalletManage.sharedInstance getTXWithAddressWithIsQLC:true address:toAddress tokeHash:tokenHash qlc:qlc mainNet:isMainNetTransfer completeBlock:^(NSString* txHex) {
        if ([[NSStringUtil getNotNullValue:txHex] isEmptyString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [kAppD.window hideToast];
                [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"VPNRegFailed")];
            });
        } else { // 获取到hex
            // 检测vpn配置文件
            [kAppD.window hideToast];
            weakself.hex = txHex;
            [weakself verifyProfile];
        }
    }];
}

// 注册并转帐
- (void) registerVPNAndTranQLC {
    [kAppD.window makeToastInView:self.view text:nil];
    kWeakSelf(self);
    NSString *vpnName = self.vpnTFName?:@"";
    NSString *country = self.selectCountryStr?:@"";
    NSString *ownerp2pId = [ToxManage getOwnP2PId]?:@"";
    NSString *p2pId = self.serverP2Pid;
    NSString *address = [WalletCommonModel getCurrentSelectWallet].address;
    //    NSString *qlc = _registerV1.deposit;
    NSString *qlc = @"1"; // 默认1
    NSString *connectCost = self.hourlyFee?:@"";
    NSString *connectNum = self.connectNum?:@"";
    NSString *ipV4Address = @"";
    NSString *bandWidth = @"";
    //    NSString *profileLocalPath = [VPNFileUtil getVPNPathWithFileName:_registerV2.profileName]?:@"";
    NSString *profileLocalPath = self.profileName?:@"";
    if (!weakself.vpnInfo) {
        _vpnInfo = [[VPNInfo alloc] init];
        _vpnInfo.vpnName = vpnName;
        _vpnInfo.cost = qlc;
        _vpnInfo.address = address;
    }
//    NSString *hashFilePath = [VPNFileUtil getVPNPathWithFileName:self.profileName];
//    NSString *hash = [MD5Util md5WithPath:hashFilePath];
//    NSData *vpnData = _vpnDataArr[_selectFileIndex];
//    NSData *vpnData = ((NSDictionary *)_vpnDataArr[_selectFileIndex]).allValues.firstObject;
    
//    NSString *hash = [MD5Util md5WithData:_selectVpnData]?:@"";
    NSString *hash = _vpnFileMd5?:@"";
    
    NSDictionary *params = @{@"vpnName":vpnName,@"country":country,@"p2pId":p2pId,@"ownerP2pId":ownerp2pId,@"address":address,@"tx":weakself.hex,@"qlc":qlc,@"connectCost":connectCost,@"connectNum":connectNum,@"ipV4Address":ipV4Address,@"bandWidth":bandWidth,@"profileLocalPath":profileLocalPath,@"hash":hash};
    [RequestService requestWithUrl:ssIdRegisterVpnByFeeV6_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [VPNUtil.shareInstance stopVPN]; // 关掉vpn连接
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == Server_Code_Success) {
            // 移除抢注的vs
            NSString *regQLC = @"1";
            // 发送扣款通知
            [NeoTransferUtil sendLocalNotificationWithQLC:regQLC isIncome:NO];
            // 保存交易记录
            [NEOWalletUtil saveTranQLCRecordWithQlc:regQLC txtid:[NSStringUtil getNotNullValue:responseObject[@"recordId"]] neo:@"0" recordType:5 assetName:_vpnInfo.vpnName friendNum:0 p2pID:[NSStringUtil getNotNullValue:_vpnInfo.p2pId] connectType:0 isReported:NO isMianNet:[ConfigUtil isMainNetOfServerNetwork]];
            // 本地保存注册的vpn资产
            [weakself storeRegisterVPN:params];
            // 告诉vpn server注册成功
            [weakself tellVpnServerRegisterSuccess:params];
//            // 告诉WINQ服务器注册成功
//            [VPNFileUtil sendRegisterSuccessToServer:p2pId vpnName:vpnName vpnfileName:profileLocalPath userName:weakSelf.userNameTF.text.trim?:@"" password:weakSelf.passwordTF.text.trim?:@"" privateKey:weakSelf.privateKeyTF.text.trim?:@""];
            // 发送心跳
//            [HeartbeatUtil sendHeartbeatRequest];
            [weakself backToRoot];
        } else {
            [weakself.view makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [VPNUtil.shareInstance stopVPN]; // 关掉vpn连接
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:error.domain];
    }];
}

- (void) sendUpdateVPNRequest
{
    kWeakSelf(self);
    self.vpnInfo.vpnName = self.vpnTFName?:@"";
    self.vpnInfo.country = self.selectCountryStr?:@"";
    self.vpnInfo.p2pId = self.serverP2Pid;
    //    self.vpnInfo.qlc = _registerV1.deposit;
    self.vpnInfo.qlc = @"1";
    self.vpnInfo.connectCost = self.hourlyFee?:@"";
    self.vpnInfo.connectNum = self.connectNum?:@"";
    self.vpnInfo.ipV4Address = @"";
    self.vpnInfo.bandwidth = @"";
    
    self.vpnInfo.profileLocalPath = self.profileName?:@"";
    
    self.vpnInfo.password = _passwordTF.text?:@"";
    self.vpnInfo.privateKeyPassword = _privateKeyTF.text?:@"";
    self.vpnInfo.username = _userNameTF.text?:@"";
    
    [kAppD.window makeToastInView:self.view text:nil];
    
    NSString *hash = @"";
    if (!_isFileNameSame) {
//        NSString *hashFilePath = [VPNFileUtil getVPNPathWithFileName:self.profileName];
//        hash = [MD5Util md5WithPath:hashFilePath];
//        NSData *vpnData = _vpnDataArr[_selectFileIndex];
//        NSData *vpnData = ((NSDictionary *)_vpnDataArr[_selectFileIndex]).allValues.firstObject;
//        hash = [MD5Util md5WithData:_selectVpnData];
        hash = _vpnFileMd5?:@"";
        self.vpnInfo.isSendSuccess = NO;
    }
    NSDictionary *params = @{@"vpnName":self.vpnInfo.vpnName,@"country":self.vpnInfo.country,@"p2pId":self.vpnInfo.p2pId,@"qlc":self.vpnInfo.qlc,@"connectCost":self.vpnInfo.connectCost,@"connectNum":self.vpnInfo.connectNum,@"ipV4Address":self.vpnInfo.ipV4Address,@"bandWidth":self.vpnInfo.bandwidth,@"profileLocalPath":self.vpnInfo.profileLocalPath,@"hash":hash};
    
    [RequestService requestWithUrl:ssIdUpdateVpnInfoV4_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (!_isFileNameSame) {
            [VPNUtil.shareInstance stopVPN]; // 关掉vpn连接
        }
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == Server_Code_Success) {
            NSString *country = responseObject[Server_Data][@"country"];
            weakself.vpnInfo.country = country?:@"";
            // 修改本地数据库
            [weakself.vpnInfo bg_saveOrUpdateAsync:^(BOOL isSuccess) {
                if (isSuccess) {
                    // 更新keyChain
                    [VPNOperationUtil saveArrayToKeyChain];
                    [weakself performSelector:@selector(sendUpdateVPNRequest) withObject:nil afterDelay:1.5];
                }
            }];
            [weakself back];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [VPNUtil.shareInstance stopVPN]; // 关掉vpn连接
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:error.domain];
    }];
}

#pragma mark - 发送更新VPN通知
- (void) sendUpdateVPNListNoti {
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_ASSETS_TZ object:nil];
}

#pragma mark - Aciton
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)clickTourilBtn:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/qlcchain/WinQ-Server/blob/master/README.md"] options:@{} completionHandler:nil];
}

- (IBAction)clickPastBtn:(id)sender {
    UIPasteboard *generalPasteboard = [UIPasteboard generalPasteboard];
    NSMutableArray *types = [[NSMutableArray alloc] init];
    [types addObjectsFromArray:UIPasteboardTypeListString];
    kWeakSelf(self);
    if ([generalPasteboard containsPasteboardTypes:types]) {
        weakself.serverP2pIdTF.text = generalPasteboard.string;
        _selectFileIndex = -1;
        [self addFriendAndCheckOnline];
    }
}

- (IBAction)clickQRBtn:(id)sender {
    [self jumpQRVCWithAddressVC];
}

- (IBAction)backAction:(id)sender {
    [self back];
}

- (IBAction)clickReloadBtn:(id)sender {
    [self addFriendAndCheckOnline];
}

- (IBAction)registerAction:(id)sender {
    //    if (_registerStep == RegisterStepOne) {
    if ([self isEmptyOfCountry]) {
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"choose_country")];
        return;
    }
    if ([self isEmptyOfVPNName]) {
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"vpnName_empty")];
        return;
    }
    if ([self isEmptyOfP2PID]) {
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"p2pid_empty")];
        return;
    }
    
    if ([self isEmptyOfProfile]) {
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"choose_a_profile")];
        return;
    }
    
    if (_assetIsValidate) { // vpnname有效
        [self getRegisterOperation];
    }
}

- (void)getRegisterOperation {
    if (_registerType == UpdateServerVPN) {
        if ([self.vpnInfo.profileLocalPath isEqualToString:self.profileName]) {
            _isFileNameSame = YES;
            [self sendUpdateVPNRequest];
        } else {
            _isFileNameSame = NO;
            [self verifyProfile];
        }
    } else {
        [self sendMainAddressRequst];
    }
}

- (IBAction)chooseCountryAction:(id)sender {
    [self selectCountryAction];
}

- (IBAction)praviteKeyEyeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString *imgName = sender.selected ? @"icon_see" : @"icon_look";
    [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    _privateKeyTF.secureTextEntry = !sender.selected;
}

- (IBAction)passwordEyeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString *imgName = sender.selected ? @"icon_see" : @"icon_look";
    [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    _passwordTF.secureTextEntry = !sender.selected;
}

- (IBAction)feeSubtractAction:(id)sender {
    if (_hourlyFeeSlider.value > FeeMin) {
        _hourlyFeeSlider.value -= 0.1;
        [self updateHourlyLab];
    }
}

- (IBAction)feeAddAction:(id)sender {
    if (_hourlyFeeSlider.value < FeeMax) {
        _hourlyFeeSlider.value += 0.1;
        [self updateHourlyLab];
    }
}

- (IBAction)connectSubtractAction:(id)sender {
    if (_connectionSlider.value > ConnectionMin) {
        _connectionSlider.value -= 1;
        [self updateConnectionLab];
    }
}

- (IBAction)connectAddAction:(id)sender {
    if (_connectionSlider.value < ConnectionMax) {
        _connectionSlider.value += 1;
        [self updateConnectionLab];
    }
}

- (IBAction)hourlySliderAction:(id)sender {
    [self updateHourlyLab];
}

- (IBAction)connectionSliderAction:(id)sender {
    [self updateConnectionLab];
}

- (void)selectFileAction:(UIButton *)sender {
    NSInteger index = sender.tag - CELL_SELECT_BTN_TAG;
    _tempSelectIndex = index;
    NSString *vpnName = _vpnNameArr[index];
//    [_configurationTable reloadData];
    
    // 判断好友是否在线
    if ([ToxManage getFriendConnectionStatus:self.serverP2Pid])  {
        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:30];
        ToxRequestModel1 *model = [[ToxRequestModel1 alloc] init];
        model.type = sendVpnFileNewReq;
        NSDictionary *tempDic = @{@"vpnName":vpnName, APPVERSION:APP_Build, @"register":@(1)};
        model.data = tempDic;
        NSString *str = model.mj_JSONString;
        [VPNDataUtil shareInstance].sendVpnFileNewRspMsgid = nil;
        [[VPNDataUtil shareInstance].sendVpnFileNewRspArr removeAllObjects];
        [VPNDataUtil shareInstance].sendVpnFileNewRspMsg = nil;
        [ToxManage sendMessageWithMessage:str withP2pid:self.serverP2Pid];
    } else {
        DDLogDebug(@"好友不在线，拿不了vpn文件");
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"wait_p2p_online")];
    }
}

#pragma mark - Transition
//- (void)jumpToChooseContinent {
    //    [ChooseCountryUtil shareInstance].entry = VPNRegister;
    //    ChooseContinentViewController *vc = [[ChooseContinentViewController alloc] init];
    //    if (_registerV1.selectCountry) {
    //        vc.inputContinent = [ChooseCountryUtil getContinentOfCountry:_registerV1.selectCountry];
    //    }
    //    [self.navigationController pushViewController:vc animated:YES];
//}

//- (void)jumpToSeizeVPN {
//    SeizeVPNViewController *vc = [[SeizeVPNViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void) jumpQRVCWithAddressVC {
    kWeakSelf(self);
    WalletQRViewController *vc = [[WalletQRViewController alloc] initWithCodeQRCompleteBlock:^(NSString *codeValue) {
        weakself.serverP2pIdTF.text = codeValue;
        [weakself addFriendAndCheckOnline];
    } needPop:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选择国家
- (void) selectCountryAction {
    // 显示
    [self.countryView showChooseCountryView];
    // 选择国家回调
    [self.countryView setSelectCountryBlock:^(id selectCountry) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SELECT_COUNTRY_NOTI_VPNREGISTER object:selectCountry];
    }];
}

- (ChooseCountryView *)countryView {
    if (!_countryView) {
        _countryView = [ChooseCountryView loadChooseCountryView];
        _countryView.isSave = NO;
        CGRect v1Point = [_contentView.superview convertRect:_contentView.frame toView:kAppD.window];
        _countryView.bgContraintTop.constant =v1Point.origin.y-7 ;
        if (!IS_X_LiuHai) {
            _countryView.bgContraintTop.constant =v1Point.origin.y + 37;
        }
        _countryView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _countryView;
}

#pragma mark -UITabelView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vpnNameArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseConfigurationCell_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseConfigurationCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseConfigurationCellReuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectBtn.tag = CELL_SELECT_BTN_TAG + indexPath.row;
    [cell.selectBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [cell.selectBtn addTarget:self action:@selector(selectFileAction:) forControlEvents:UIControlEventTouchUpInside];
//    NSDictionary *dic = _vpnDataArr[indexPath.row];
//    NSString *showVpn = dic.allKeys.firstObject?((NSString *)dic.allKeys.firstObject).lastPathComponent:@"";
    NSString *showVpn = _vpnNameArr[indexPath.row];
    [cell configCellWithName:showVpn];
    if (indexPath.row == _selectFileIndex) {
        [cell.selectBtn setImage:[UIImage imageNamed:@"icon_the_selected"] forState:UIControlStateNormal];
    } else {
        [cell.selectBtn setImage:[UIImage imageNamed:@"icon_the_uncheck"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Lazy

//- (NSMutableArray *)vpnDataArr
//{
//    if (!_vpnDataArr) {
//        _vpnDataArr = [[NSMutableArray alloc] init];
//    }
//    return _vpnDataArr;
//}

- (NSMutableArray *)vpnNameArr {
    if (!_vpnNameArr) {
        _vpnNameArr = [NSMutableArray array];
    }
    return _vpnNameArr;
}

- (NSString *)vpnTFName {
    _vpnTFName = _vpnNameTF.text?:@"";
    return _vpnTFName;
}
- (NSString *)serverP2Pid {
    _serverP2Pid = _serverP2pIdTF.text?:@"";
    return _serverP2Pid;
}

- (NSString *)selectCountryStr {
    _selectCountryStr = _countryLab.text?:@"";
    if ([_selectCountryStr isEqualToString:CHOOSECOUNTRY]) {
        _selectCountryStr = @"";
    }
    return _selectCountryStr;
}

- (NSString *)profileName {
    _profileName = _vpnNameArr[_selectFileIndex];
//    _profileName = ((NSDictionary *)_vpnDataArr[_selectFileIndex]).allKeys.firstObject?:@"";
    return _profileName;
}

- (NSString *)hourlyFee {
    _hourlyFee = [NSString stringWithFormat:@"%.1f",_hourlyFeeSlider.value];
    return _hourlyFee;
}

- (NSString *)connectNum {
    _connectNum = [NSString stringWithFormat:@"%.0f",_connectionSlider.value];
    return _connectNum;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
