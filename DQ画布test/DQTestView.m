//
//  DQTestView.m
//  DQ画布test
//
//  Created by 邓琪 on 2017/3/1.
//  Copyright © 2017年 . All rights reserved.
//

#import "DQTestView.h"
#define maxNum 10 //号码的排数 除期号
#define FormWidth [[UIScreen mainScreen] bounds].size.width/(maxNum+1)//格子的宽度
#define FormHeight FormWidth//格子的高度
@interface DQTestView()

@property (nonatomic, copy) NSArray *xDatas;//保存期号的数组

@property (nonatomic, copy) NSArray *yDatas;//保存号码的数组

@property (nonatomic, strong) NSMutableArray *fillDatas;// 填充的数据

@property (nonatomic, strong) NSMutableArray *frameArr;//保存中奖的号码的位置的数组
@end
@implementation DQTestView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _yDatas = @[@"01期",@"02期",@"03期",@"04期",@"05期",@"06期",@"07期",@"08期",@"09期",@"10期"];
        _xDatas = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        _fillDatas = [NSMutableArray array];
        _frameArr = [NSMutableArray new];
        
        [self DQRandomFormArrayFunction];
        
    }
    return self;
}
//随机产生随机的中奖号码 即填充的数据
- (void)DQRandomFormArrayFunction{
    if (_frameArr.count>0) {
        [_frameArr removeAllObjects];
    }
    if (_fillDatas.count>0) {
        [_fillDatas removeAllObjects];
    }
    for (NSInteger i=0; i<_xDatas.count; i++) {
        NSString *number = [self randomFormArray:_xDatas];
        [_fillDatas addObject:number];
    }
}
- (NSString *)randomFormArray:(NSArray *)array{
    
    NSInteger count = array.count;
    NSInteger index = arc4random()%count;
    
    return [NSString stringWithFormat:@"%ld",index];
}

- (void)drawRect:(CGRect)rect{
    //注意 以下所有的坐标不能超过本类的区域 否则看不效果
    CGContextRef context = UIGraphicsGetCurrentContext();
    //FormHeight 为格子的高度 7是离上边界的距离 不设置 就会出现显示边界的线不好控制
    for (int i=0; i<=_yDatas.count; i++) {
        if (i<_yDatas.count) {
            NSString *period = _yDatas[i];
            //调用计算字符串的宽高的方法
            CGSize size = [self calculaTetextSize:period andSize:CGSizeMake(FormWidth , FormHeight)];
            //画期号的文字
            [period drawInRect:CGRectMake((FormWidth-size.width)/2.0,(FormHeight-size.height)/2.0+FormHeight*i+7, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor]}];
            
        }
        //画横线
        // 设置画笔颜色
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        // 设置画笔的宽度
        CGContextSetLineWidth(context, .4);
        // 画笔的起始坐标
        CGContextMoveToPoint(context, 0, i*FormHeight + 7);
        // 画直线
        CGContextAddLineToPoint(context, [[UIScreen mainScreen] bounds].size.width, i*FormHeight+7);
        CGContextDrawPath(context, kCGPathStroke);
        
    }
    
    
    for (int j=0; j <= _yDatas.count; j++) {
        if (j<maxNum) {
            for (int i=0; i<maxNum; i++) {
                NSString *period = _xDatas[j];
                CGSize size = [self calculaTetextSize:period andSize:CGSizeMake(FormWidth, FormHeight)];
                // 画号码 位置根据期号的号码类推
                [period drawInRect:CGRectMake((FormWidth-size.width)/2.0+j*FormWidth+FormWidth,(FormHeight-size.height)/2.0+i*FormHeight+7, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor]}];
            }
            
        }
        //画纵线
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextSetLineWidth(context, .4);
        CGContextMoveToPoint(context, j*FormWidth, 7);
        CGContextAddLineToPoint(context, j*FormWidth, maxNum*FormHeight+7);
        CGContextDrawPath(context, kCGPathStroke);
    }
    //先计算 要填充号码的中心位置 用数组保存
    for (int i = 0; i<_fillDatas.count; i++) {
        NSString *number = _fillDatas[i];
        for (int x = 0; x < _xDatas.count; x++) {
            
            if ([number intValue] ==x) {
                CGPoint point = CGPointMake(FormWidth*x+FormWidth/2+FormWidth, FormHeight*i+FormHeight/2+7);
                NSString *str = NSStringFromCGPoint(point);
                //保存圆中心的位置 给下面的连线
                [_frameArr addObject:str];
                
            }
        }
    }
    //先画走势线 然后把填充的圆挡住线 这样的效果好
    for (int i=0; i<_frameArr.count; i++) {
        NSString *str = [_frameArr objectAtIndex:i];
        CGPoint point = CGPointFromString(str);
        // 设置画笔颜色
        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextSetLineWidth(context, 1.5);
        if (i==0) {
            
            // 画笔的起始坐标
            CGContextMoveToPoint(context, point.x, point.y);
            
        }else{
            NSString *str1 = [_frameArr objectAtIndex:i-1];
            CGPoint point1 = CGPointFromString(str1);
            CGContextMoveToPoint(context, point1.x, point1.y);
            CGContextAddLineToPoint(context, point.x,  point.y);
        }
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    // 画填充圆
    for (int i = 0; i<_fillDatas.count; i++) {
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextSetLineWidth(context, .4);
        NSString *number = _fillDatas[i];
        for (int x = 0; x < _xDatas.count; x++) {
            
            if ([number intValue] ==x) {
                //画圆圈
                CGContextAddArc(context, FormWidth*x+FormWidth/2+FormWidth, FormHeight*i+FormHeight/2+7, FormHeight/2, 0, M_PI*2, 1);
                CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
                CGContextDrawPath(context, kCGPathStroke);
                
                //填满整个圆
                CGContextAddArc(context, FormWidth*x+FormWidth/2+FormWidth, FormHeight*i+FormHeight/2+7, FormHeight/2, 0, M_PI*2, 1);
                CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
                CGContextDrawPath(context, kCGPathFill);
                NSString *numberStr = [NSString stringWithFormat:@"%@",number];
                CGSize size = [self calculaTetextSize:numberStr andSize:CGSizeMake(FormWidth, FormHeight)];
                //画内容
                [numberStr drawInRect:CGRectMake((FormWidth-size.width)/2.0+x*FormWidth+FormWidth,(FormHeight-size.height)/2.0+i*FormHeight+7, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor redColor]}];
            }
        }
    }
    
}
//这里是计算text的宽高 好设置数字的位置 为中心位置
- (CGSize )calculaTetextSize:(NSString *)text andSize:(CGSize)size{
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName :[UIFont systemFontOfSize:12],
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT)
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil].size;
    return contentSize;
}
@end
