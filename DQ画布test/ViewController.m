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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DQTestView *testView = [[DQTestView alloc]initWithFrame:CGRectMake(0, 64, 375, 667)
                            ];
    [self.view addSubview:testView];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
