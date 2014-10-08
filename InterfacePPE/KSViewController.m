//
//  KSViewController.m
//  InterfacePPE
//
//  Created by leon on 12/03/2014.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import "KSViewController.h"

//#define PERFORMANCE_TEST
#define GREEN_PLOT_IDENTIFIER       @"Green Plot"
#define BLUE_PLOT_IDENTIFIER        @"Blue Plot"

@interface KSViewController ()



@end

@implementation KSViewController
@synthesize dataForPlot1;
@synthesize ttitle;
@synthesize dataArray;




- (void)viewDidLoad{
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        NSLog(@"title = %@",self.ttitle);
        [self plotView];
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self.view window] == nil)
    {
        self.view = nil;
    }
}

-(void)plotView{
    
        
        //创建图表
        graph = [[CPTXYGraph alloc] initWithFrame:self.view.bounds];
        
        //给图表添加一个主题
        //CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    
        //[graph applyTheme:theme];
    
        //创建画板，将图表添加到画板
        CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
        hostingView.hostedGraph = graph;
    
        if([[AppDelegate themodel] bac] >=0.25)
        {
            [hostingView setBackgroundColor:[UIColor colorWithRed:(159.0 / 255.0) green:(4.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0]];
        }
        else
        {
            [hostingView setBackgroundColor:[UIColor colorWithRed:(105.0 / 255.0) green:(190.0 / 255.0) blue:(106.0 / 255.0) alpha:1.0]];
        }
    
        [self.view addSubview:hostingView];
        
        
        //设置图表的边框
        //左边的padding设置为0
        graph.paddingLeft = 0;
        //顶部的的padding设置0
        graph.paddingTop = 0;
        //右边的padding设置为0
        graph.paddingRight = 0;
        //底部的padding设置为0
        graph.paddingBottom = 0;
        
        //坐标区域的边框设置
        //左边的padding设置为45.0
        graph.plotAreaFrame.paddingLeft = 40.0 ;
        //顶部的padding设置为40.0
        graph.plotAreaFrame.paddingTop = 40.0 ;
        //右边的padding设置为5.0
        graph.plotAreaFrame.paddingRight = 15.0 ;
        //底部的padding设置为80.0
        graph.plotAreaFrame.paddingBottom = 80.0 ;
        
        
        //设置坐标范围
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
        plotSpace.allowsUserInteraction = YES;
        //plotSpace.allowsUserInteraction=NO;
    
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(5.0)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(1.0)];
        
        //设置坐标刻度大小
        CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet ;

        CPTXYAxis *x = axisSet.xAxis;
    
        //x 轴：不显示小刻度线
        x. minorTickLineStyle = nil ;
        // 大刻度线间距： 50 单位
        x. majorIntervalLength = CPTDecimalFromString (@"1");
        // 坐标原点： 0
        x. orthogonalCoordinateDecimal = CPTDecimalFromString ( @"0" );
        
        CPTXYAxis *y = axisSet.yAxis ;
        //y 轴：不显示小刻度线
        y. minorTickLineStyle = nil ;
        // 大刻度线间距： 50 单位
        y. majorIntervalLength = CPTDecimalFromString ( @"0.1" );
        // 坐标原点： 0
        y. orthogonalCoordinateDecimal = CPTDecimalFromString (@"0");
        
        //创建绿色区域
        dataSourceLinePlot = [[CPTScatterPlot alloc] init];
        dataSourceLinePlot.identifier = @"Green Plot";
        
        //设置绿色区域边框的样式
        CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
        //设置线的宽度
        lineStyle.lineWidth = 1.f;
        //设置线的颜色
        //lineStyle.lineColor = [CPTColor greenColor];
        [lineStyle setLineColor:[CPTColor whiteColor]];
        //添加线到绿色区域中
        dataSourceLinePlot.dataLineStyle = lineStyle;
        //设置透明实现添加动画
        dataSourceLinePlot.opacity = 0.0f;
        [dataSourceLinePlot setOpacity:1.0];
        //设置数据元代理
        dataSourceLinePlot.dataSource = self;
        //绿色区域添加到图表中
        [graph addPlot:dataSourceLinePlot];
        
        // 创建一个颜色渐变：从 建变色 1 渐变到 无色
        //CPTGradient *areaGradient = [ CPTGradient gradientWithBeginningColor :[CPTColor greenColor] endingColor :[CPTColor colorWithComponentRed:0.65 green:0.65 blue:0.16 alpha:0.2]];
        // 渐变角度： -90 度（顺时针旋转）
        //areaGradient.angle = -90.0f ;
        // 创建一个颜色填充：以颜色渐变进行填充
        //CPTFill *areaGradientFill = [ CPTFill fillWithGradient :areaGradient];
        // 为图形设置渐变区
        //dataSourceLinePlot.areaFill = areaGradientFill;
        dataSourceLinePlot.areaBaseValue = CPTDecimalFromString ( @"0.0" );
        dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationLinear ;
        
        
        dataForPlot1 = [[NSMutableArray alloc] init];
        [self plotData];
    }
    
    
    //添加数据
    -(void) plotData{
        if ([dataSourceLinePlot.identifier isEqual:@"Green Plot"]) {
            NSString *xp1 = [NSString stringWithFormat:@"%d",0];
            NSString *yp1 = [NSString stringWithFormat:@"%f",[[AppDelegate themodel] bac]];
            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp1, @"x", yp1, @"y", nil];
            [dataForPlot1 insertObject:point1 atIndex:0];
            
            NSString *xp2 = [NSString stringWithFormat:@"%d",1];
            NSString *yp2 = [NSString stringWithFormat:@"%f",[[AppDelegate themodel] bac]-0.24*1];
            NSMutableDictionary *point2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp2, @"x", yp2, @"y", nil];
            [dataForPlot1 insertObject:point2 atIndex:1];
            
            NSString *xp3 = [NSString stringWithFormat:@"%d",2];
            NSString *yp3 = [NSString stringWithFormat:@"%f",[[AppDelegate themodel] bac]-0.22*2];
            NSMutableDictionary *point3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp3, @"x", yp3, @"y", nil];
            [dataForPlot1 insertObject:point3 atIndex:2];
            
            NSString *xp4 = [NSString stringWithFormat:@"%d",3];
            NSString *yp4 = [NSString stringWithFormat:@"%f",[[AppDelegate themodel] bac]-0.20*3];
            NSMutableDictionary *point4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp4, @"x", yp4, @"y", nil];
            [dataForPlot1 insertObject:point4 atIndex:3];
            
            NSString *xp5 = [NSString stringWithFormat:@"%d",4];
            NSString *yp5 = [NSString stringWithFormat:@"%f",[[AppDelegate themodel] bac]-0.185*4];
            NSMutableDictionary *point5 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp5, @"x", yp5, @"y", nil];
            [dataForPlot1 insertObject:point5 atIndex:4];
            
            NSString *xp6 = [NSString stringWithFormat:@"%d",5];
            NSString *yp6 = [NSString stringWithFormat:@"%f",[[AppDelegate themodel] bac]-0.18*5];
            NSMutableDictionary *point6 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp6, @"x", yp6, @"y", nil];
            [dataForPlot1 insertObject:point6 atIndex:5];
            
            NSString *xp7 = [NSString stringWithFormat:@"%d",6];
            NSString *yp7 = [NSString stringWithFormat:@"%f",[[AppDelegate themodel] bac]-0.18*6];
            NSMutableDictionary *point7 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp7, @"x", yp7, @"y", nil];
            [dataForPlot1 insertObject:point7 atIndex:6];
            
            NSString *xp8 = [NSString stringWithFormat:@"%d",7];
            NSString *yp8 = [NSString stringWithFormat:@"%f",[[AppDelegate themodel] bac]-0.18*7];
            NSMutableDictionary *point8 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp8, @"x", yp8, @"y", nil];
            [dataForPlot1 insertObject:point8 atIndex:7];
            
            NSString *xp9 = [NSString stringWithFormat:@"%d",8];
            NSString *yp9 = [NSString stringWithFormat:@"%f",[[AppDelegate themodel] bac]-0.18*8];
            NSMutableDictionary *point9 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp9, @"x", yp9, @"y", nil];
            [dataForPlot1 insertObject:point9 atIndex:8];
            
            NSString *xp10 = [NSString stringWithFormat:@"%d",9];
            NSString *yp10 = [NSString stringWithFormat:@"%f",[[AppDelegate themodel] bac]-0.18*9];
            NSMutableDictionary *point10 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp10, @"x", yp10, @"y", nil];
            [dataForPlot1 insertObject:point10 atIndex:9];
            
            NSString *xp11 = [NSString stringWithFormat:@"%d",10];
            NSString *yp11 = [NSString stringWithFormat:@"%f",[[AppDelegate themodel] bac]-0.18*10];
            NSMutableDictionary *point11 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp11, @"x", yp11, @"y", nil];
            [dataForPlot1 insertObject:point11 atIndex:10];
            
        }
    }
    
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
        return [dataForPlot1 count];
    }
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
        NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
        NSNumber *num;
        //让视图偏移
        if ( [(NSString *)plot.identifier isEqualToString:@"Green Plot"] ) {
            num = [[dataForPlot1 objectAtIndex:index] valueForKey:key];
            if ( fieldEnum == CPTScatterPlotFieldX ) {
                num = [NSNumber numberWithDouble:[num doubleValue] - r];
            }
        }
        //添加动画效果
        CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeInAnimation.duration = 1.0f;
        fadeInAnimation.removedOnCompletion = NO;
        fadeInAnimation.fillMode = kCAFillModeForwards;
        fadeInAnimation.toValue = [NSNumber numberWithFloat:2.0];
        [dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
        return num;
    }

@end
