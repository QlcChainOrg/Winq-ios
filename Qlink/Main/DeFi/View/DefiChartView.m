//
//  HistoryChartView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/19.
//  Copyright © 2018 pan. All rights reserved.
//

#import "DefiChartView.h"
#import <Charts/Charts-Swift.h>
#import "UIColor+Random.h"
#import "GlobalConstants.h"
#import "DefiHistoricalStatsListModel.h"
#import "DefiProjectListModel.h"
#import "NSString+RemoveZero.h"
#import "DefiChartXValueFormatter.h"
#import "DefiChartYValueFormatter.h"
#import "NSDate+Category.h"

@interface DefiChartView ()  <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet LineChartView *chartView;
@property (nonatomic, strong) NSMutableArray *lineArr;
//@property (nonatomic, strong) NSString *currentSymbol;
@property (nonatomic, copy) HistoryChartNoDataBlock noDataB;
@property (nonatomic, copy) HistoryChartHaveDataBlock haveDataB;

@property (nonatomic, strong) NSArray *statsListArr;

@end

@implementation DefiChartView

+ (instancetype)getInstance {
    DefiChartView *view = [[[NSBundle mainBundle] loadNibNamed:@"DefiChartView" owner:self options:nil] lastObject];
    [view configInit];
    return view;
}

- (void)configInit {
    _lineArr = [NSMutableArray array];
    
    _chartView.delegate = self;
    _chartView.chartDescription.enabled = NO;
    _chartView.noDataText = @"No Data";
    _chartView.drawMarkers = NO;
    _chartView.doubleTapToZoomEnabled = YES;
    _chartView.legend.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.xAxis.labelPosition = XAxisLabelPositionBottom;
    
    // x-axis limit line
//    ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Index 10"];
//    llXAxis.lineWidth = 4.0;
//    llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
//    llXAxis.labelPosition = ChartLimitLabelPositionBottomRight;
//    llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
    
    //[_chartView.xAxis addLimitLine:llXAxis];
    
//    _chartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
//    _chartView.xAxis.gridLineDashPhase = 0.f;
    
//    ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:150.0 label:@"Upper Limit"];
//    ll1.lineWidth = 4.0;
//    ll1.lineDashLengths = @[@5.f, @5.f];
//    ll1.labelPosition = ChartLimitLabelPositionRightTop;
//    ll1.valueFont = [UIFont systemFontOfSize:10.0];
    
//    ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:-30.0 label:@"Lower Limit"];
//    ll2.lineWidth = 4.0;
//    ll2.lineDashLengths = @[@5.f, @5.f];
//    ll2.labelPosition = ChartLimitLabelPositionRightBottom;
//    ll2.valueFont = [UIFont systemFontOfSize:10.0];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
//    [leftAxis addLimitLine:ll1];
//    [leftAxis addLimitLine:ll2];
    leftAxis.axisMaximum = 200.0;
    leftAxis.axisMinimum = -50.0;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
//    leftAxis.inverted = YES;
    
    _chartView.rightAxis.enabled = NO;
    
    //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
    //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
    
//    BalloonMarker *marker = [[BalloonMarker alloc]
//                             initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
//                             font: [UIFont systemFontOfSize:12.0]
//                             textColor: UIColor.whiteColor
//                             insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
//    marker.chartView = _chartView;
//    marker.minimumSize = CGSizeMake(80.f, 40.f);
//    _chartView.marker = marker;
    
    _chartView.legend.form = ChartLegendFormLine;
    
//    _sliderX.value = 45.0;
//    _sliderY.value = 100.0;
//    [self slidersValueChanged:nil];
    
    [_chartView animateWithXAxisDuration:2];
}

- (void)refreshLeftAxisWithMax:(double)max min:(double)min {
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.axisMaximum = max;
    leftAxis.axisMinimum = min;
}

- (void)refreshXAxisWithMax:(double)max min:(double)min {
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.axisMaximum = max;
    xAxis.axisMinimum = min;
}

- (void)configWithNoDataBlock:(HistoryChartNoDataBlock)noDataBlock haveDataBlock:(HistoryChartHaveDataBlock)haveDataBlock {
    _noDataB = noDataBlock;
    _haveDataB = haveDataBlock;
//    [self request_defi_stats_list];
    
    
    if (_noDataB) {
        _noDataB();
    }
}

- (void)handlerData:(NSDictionary *)responseObject {
    _statsListArr = [DefiHistoricalStatsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"historicalStatsList"]];
}

- (void)refreshChart {
    DefiChartYValueFormatter *yF = [[DefiChartYValueFormatter alloc] init];
    yF.inputType = _inputType;
    _chartView.leftAxis.valueFormatter = yF;
//    _chartView.xAxis.labelPosition = XAxisLabelPositionTopInside;
//    _chartView.xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    _chartView.xAxis.labelFont = [UIFont systemFontOfSize:8.f];
    _chartView.xAxis.labelRotationAngle = -15;
//    _chartView.xAxis.labelTextColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:56/255.0 alpha:1.0];
    DefiChartXValueFormatter *xF = [[DefiChartXValueFormatter alloc] init];
    _chartView.xAxis.valueFormatter = xF;
    
    kWeakSelf(self);
    [_lineArr removeAllObjects];
    [_statsListArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DefiHistoricalStatsListModel *model = obj;
        NSInteger x = [NSDate getTimestampFromDate:[NSDate dateFromTime_c:model.statsDate]];
        NSString *xStr = [NSString stringWithFormat:@"%@",@(x)];
        if (weakself.inputType == DefiChartTypeTVLUSD) {
            NSDictionary *dic = @{@"x":xStr,@"y":model.tvlUsd};
            [weakself.lineArr addObject:dic];
        } else if (weakself.inputType == DefiChartTypeETH) {
            NSDictionary *dic = @{@"x":xStr,@"y":model.eth};
            [weakself.lineArr addObject:dic];
        } else if (weakself.inputType == DefiChartTypeDAI) {
            NSDictionary *dic = @{@"x":xStr,@"y":model.dai};
            [weakself.lineArr addObject:dic];
        } else if (weakself.inputType == DefiChartTypeBTC) {
            NSDictionary *dic = @{@"x":xStr,@"y":model.btc};
           [weakself.lineArr addObject:dic];
       }
    }];
    [_lineArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDictionary *dic1 = obj1;
        NSInteger x1 = [dic1[@"x"] doubleValue];
        NSDictionary *dic2 = obj2;
        NSInteger x2 = [dic2[@"x"] doubleValue];
        return x1>x2;
    }];
    
    if (_lineArr.count <= 0) {
        if (_noDataB) {
            _noDataB();
        }
    } else {
        if (_haveDataB) {
            _haveDataB();
        }
    }
    [weakself updateChartData];
    
}

- (void)updateChartData {
//    NSInteger usingIndex = 1;
    NSMutableArray *yDataArr = [NSMutableArray array];
    [_lineArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        [yDataArr addObject:dic[@"y"]];
    }];
    double maxLeftAxis = [[yDataArr valueForKeyPath:@"@max.doubleValue"] doubleValue];
    double minLeftAxis = [[yDataArr valueForKeyPath:@"@min.doubleValue"] doubleValue];
    [self refreshLeftAxisWithMax:maxLeftAxis min:minLeftAxis];
//    NSMutableArray *xDataArr = [NSMutableArray array];
//    [_lineArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSDictionary *dic = obj;
//        [xDataArr addObject:dic[@"x"]];
//    }];
//    double maxXAxis = [[xDataArr valueForKeyPath:@"@max.doubleValue"] doubleValue];
//    double minXAxis = [[xDataArr valueForKeyPath:@"@min.doubleValue"] doubleValue];
//    [self refreshXAxisWithMax:maxXAxis min:minXAxis];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _lineArr.count; i++) {
        NSDictionary *dic = _lineArr[i];
        double x = [dic[@"x"] doubleValue];
        double y = [dic[@"y"] doubleValue];
        [values addObject:[[ChartDataEntry alloc] initWithX:x y:y]];
//        [values addObject:[[ChartDataEntry alloc] initWithX:x y:y icon:[UIImage imageNamed:@"icon"]]];
    }
    
    LineChartDataSet *set1 = nil;
    
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        [set1 replaceEntries: values];
        set1.drawIconsEnabled = NO;
        set1.drawValuesEnabled = NO;
        set1.drawCirclesEnabled = NO;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithEntries:values];
        
        set1.drawIconsEnabled = NO;
        set1.drawValuesEnabled = NO;
        set1.drawCirclesEnabled = NO;
//        set1.lineDashLengths = @[@5.f, @2.5f];
//        set1.highlightLineDashLengths = @[@5.f, @2.5f];
//        [set1 setColor:UIColor.blackColor];
//        [set1 setCircleColor:UIColor.blackColor];
        [set1 setColor:UIColorFromRGB(0x945BFF)];
//        [set1 setCircleColor:[UIColor mainColor]];
        set1.lineWidth = 1.0;
//        set1.circleRadius = 3.0;
//        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
//        set1.formLineDashLengths = @[@5.f, @2.5f];
        set1.formLineWidth = 1.0;
        set1.formSize = 15.0;
        
//        NSArray *gradientColors = @[
//                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
//                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
//                                    ];
//        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
//
//        set1.fillAlpha = 1.f;
//        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
//        set1.drawFilledEnabled = NO;
//
//        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
    }
}


#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

//- (void)requestBinaKlinesWithSymbol:(NSString *)symbol {
//    kWeakSelf(self);
//    NSString *interval = @"1m";
//    NSDictionary *params = @{@"symbol":symbol,@"interval":interval, @"size":@(500)};
//    [RequestService requestWithUrl5:binaKlines_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            [weakself.lineArr removeAllObjects];
//            NSArray *arr = [responseObject objectForKey:Server_Data];
//            [weakself.lineArr addObjectsFromArray:arr];
//            [weakself updateChartData];
//            if (weakself.lineArr.count <= 0) {
//                if (weakself.noDataB) {
//                    weakself.noDataB();
//                }
//            } else {
//                if (weakself.haveDataB) {
//                    weakself.haveDataB();
//                }
//            }
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        if (weakself.noDataB) {
//            weakself.noDataB();
//        }
//    }];
//}

@end
