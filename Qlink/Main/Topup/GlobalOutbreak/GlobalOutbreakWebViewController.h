//
//  WebViewController.h
//  Qlink
//
//  Created by 旷自辉 on 2018/5/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseViewController.h"

//typedef enum : NSUInteger {
//    WebFromTypeTelegram,
//    WebFromTypeFacebook,
//    WebFromTypeWinq,
//} WebFromType;

@interface GlobalOutbreakWebViewController : QBaseViewController

//@property (nonatomic) WebFromType fromType;
@property (nonatomic, strong) NSString *inputTitle;
@property (nonatomic, strong) NSString *inputUrl;

@end
