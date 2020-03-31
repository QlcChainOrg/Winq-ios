//
//  MyAssetsView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "MyAssetsView.h"
#import "UIView+Animation.h"
#import "VPNMode.h"
#import "NEOWalletUtil.h"
//#import "VPNOperationUtil.h"

#import "GlobalConstants.h"

@implementation MyAssetsView

//- (IBAction)clickCancel:(id)sender {
//
//    [self zoomOutAnimationDuration:.6 target:self callback:@selector(dismiss)];
//}

#pragma uitableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.soureArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MyAssetsCell_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAssetsCell *myCell = [tableView dequeueReusableCellWithIdentifier:MyAssetsCellReuse];
    myCell.settingBtn.tag = indexPath.row;
    id mode = [self.soureArray objectAtIndex:indexPath.row];
    [myCell setMode:mode];
    kWeakSelf(self);
    [myCell setSetBlock:^(id mode) {
        [weakself jumpAssetsWithMode:mode];
    }];
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
}

#pragma - mark jump vc
- (void)jumpAssetsWithMode:(id) mode {
    if (self.setBlock) {
        self.setBlock(mode);
    }
}

+ (MyAssetsView *)getNibView {
    MyAssetsView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"MyAssetsView" owner:self options:nil] firstObject];
    [nibView setTableView];
    return nibView;
}

- (void)setTableView {
    _tableV.delegate = self;
    _tableV.dataSource = self;
    //_mainTable.slimeView.delegate = self;
    _tableV.showsVerticalScrollIndicator = NO;
    _tableV.showsHorizontalScrollIndicator = NO;
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableV registerNib:[UINib nibWithNibName:MyAssetsCellReuse bundle:nil] forCellReuseIdentifier:MyAssetsCellReuse];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkData) name:UPDATE_ASSETS_TZ object:nil];
    [self checkData];
}

/**
 同步查询所有数据.
 */
- (void)checkData {
    NSArray *finfAlls = [VPNInfo bg_find:VPNREGISTER_TABNAME where:[NSString stringWithFormat:@"order by %@ desc",bg_sqlKey(@"bg_id")]];
//    NSArray *finfAlls = [VPNInfo bg_find:VPNREGISTER_TABNAME where:[NSString stringWithFormat:@"where %@=%@ order by %@ desc",bg_sqlKey(@"isMainNet"),bg_sqlValue(@([ConfigUtil isMainNetOfChainNetwork])),bg_sqlKey(@"bg_id")]];
    
    //NSArray* finfAlls = [VPNInfo bg_findAll:VPNREGISTER_TABNAME];
    if (self.soureArray.count > 0) { // 更新keyChain
//        [VPNOperationUtil saveArrayToKeyChain];
    }
    if (finfAlls && finfAlls.count > 0) {
        if (self.soureArray.count > 0) {
            [self.soureArray removeAllObjects];
        }
        [self.soureArray addObjectsFromArray:finfAlls];
        [_tableV reloadData];
        [self sendGetAssetsRequest];
    } else {
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"no_assets")];
    }
}

#pragma -mark lazy
- (NSMutableArray *)soureArray
{
    if (!_soureArray) {
        _soureArray = [NSMutableArray array];
    }
    return _soureArray;
}
- (NSMutableArray *)removeArray
{
    if (!_removeArray) {
        _removeArray = [NSMutableArray array];
    }
    return _removeArray;
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 获取资产信息
 */
- (void) sendGetAssetsRequest {
    [RequestService requestWithUrl5:ssIdquerys_Url params:@{@"ssIds":[self getVPNNames]} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        //[self hideHud];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSArray *dataArray = [responseObject objectForKey:Server_Data];
            if(dataArray)  {
                dataArray = [VPNInfo mj_objectArrayWithKeyValuesArray:dataArray];
                [self loadSuccessWithArray:dataArray];
            }
        } else {
            [kAppD.window makeToastDisappearWithText:[responseObject objectForKey:@"msg"]];
        }
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        //[self hideHud];
      
        [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"request_error")];
    }];
}

- (void)loadSuccessWithArray:(NSArray *) array {
    // 本地的
    [self.soureArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *mode = (VPNInfo *) obj;
        // 服务器的
        __block BOOL isExit = YES;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VPNInfo *info = (VPNInfo *) obj;
//            if ([mode.vpnName isEqualToString:info.ssId] && mode.isMainNet == info.isMainNet) {
            if ([mode.vpnName isEqualToString:info.ssId]) {
                mode.qlc = info.qlc;
                mode.registerQlc = info.registerQlc;
                if ([[NSStringUtil getNotNullValue:info.address] isBlankString]) {
                     isExit = NO;
                }
                *stop = YES;
            }
        }];
        // 如果服务器不存在 删除本地
        if (!isExit) {
            [self.removeArray addObject:mode];
        }
    }];

    [self.removeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *info = (VPNInfo *) obj;
        // 删除本地数据库
        NSString *where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"vpnName"),bg_sqlValue(info.vpnName)];
//        NSString *where = [NSString stringWithFormat:@"where %@=%@ and %@=%@",bg_sqlKey(@"vpnName"),bg_sqlValue(info.vpnName),bg_sqlKey(@"isMainNet"),bg_sqlValue(@(info.isMainNet))];
        [VPNInfo bg_delete:VPNREGISTER_TABNAME where:where];
        // 删除本地
        [self.soureArray removeObject:info];
    }];
    
     [_tableV reloadData];
    
//    kWeakSelf(self);
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        VPNInfo *mode = (VPNInfo *) obj;
//        [weakself changeVPNQlcWithVPNInfo:mode];
//    }];
//
//    [_tableV reloadData];
}

- (void) changeVPNQlcWithVPNInfo:(VPNInfo *) info
{
   
    [self.soureArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *mode = (VPNInfo *) obj;
        if ([mode.vpnName isEqualToString:info.ssId]) {
            mode.qlc = info.qlc;
            mode.registerQlc = info.registerQlc;
            *stop = YES;
        }
    }];
  
}

- (NSArray *) getVPNNames
{
    __block NSString *vpnNames = @"";
    kWeakSelf(self);
    [self.soureArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VPNInfo *mode = (VPNInfo *) obj;
        vpnNames = [vpnNames stringByAppendingString:mode.vpnName];
        if (idx != weakself.soureArray.count-1) {
            vpnNames = [vpnNames stringByAppendingString:@","];
        }
    }];
    return [vpnNames componentsSeparatedByString:@","];
}
@end
