//
//  KSViewController.h
//  InterfacePPE
//
//  Created by leon on 12/03/2014.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "AppDelegate.h"


@interface KSViewController : UIViewController<CPTPlotDataSource, CPTAxisDelegate>
{
    CPTXYGraph                  *graph;             //画板
    CPTScatterPlot              *dataSourceLinePlot;//线
    NSMutableArray              *dataForPlot1;      //坐标数组
    NSTimer                     *timer1;            //定时器
    int                         j;
    int                         r;
    
}
@property (retain, nonatomic) NSMutableArray *dataForPlot1;
@property (strong, nonatomic) NSString *ttitle;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end