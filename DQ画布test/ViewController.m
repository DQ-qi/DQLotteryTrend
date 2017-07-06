//
//  ViewController.m
//  DQ画布test
//
//  Created by 邓琪 dengqi on 2017/3/1.
//  Copyright © 2017年 YuBei. All rights reserved.
//

#import "ViewController.h"
#import "DQTestView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (nonatomic, strong) DQTestView *testView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _button1.selected = YES;
    _testView = [[DQTestView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-64)
                 ];
    [self.view addSubview:_testView];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)buttonAction:(UIButton *)sender {//重画
    sender.selected = !sender.selected;
    [_testView DQRandomFormArrayFunction];//清空数据
    [_testView setNeedsDisplay];//通知系统视图的内容需要重绘 触发- (void)drawRect:(CGRect)rect方法
    
}


@end
