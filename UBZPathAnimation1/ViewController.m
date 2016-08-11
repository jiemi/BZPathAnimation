//
//  ViewController.m
//  UBZPathAnimation1
//
//  Created by 萧锐杰 on 16/7/31.
//  Copyright © 2016年 萧锐杰. All rights reserved.
//

#import "ViewController.h"
#import "AnimationView.h"

@interface ViewController ()
@property(nonatomic,strong) AnimationView *animatingView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animatingView = [[AnimationView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 120)];
    [self.view addSubview:self.animatingView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.animatingView.frame), 50, 50)];
    [button setTitle:@"start" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)start {
    [self.animatingView startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
