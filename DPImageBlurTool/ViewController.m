//
//  ViewController.m
//  DPImageBlurTool
//
//  Created by Andrew on 2017/8/18.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "ViewController.h"
#import "DPImageBlurTool.h"

@interface ViewController ()
{
    UIImageView *icon;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    icon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 50, self.view.bounds.size.width - 40, self.view.bounds.size.width - 40)];
    icon.image = [DPImageBlurTool setGaussianBlur:[UIImage imageNamed:@"github"]];
    [self.view addSubview:icon];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.backgroundColor = [UIColor redColor];
    left.frame = CGRectMake(20, self.view.bounds.size.width + 10, (self.view.bounds.size.width - 40) / 2, 44);
    [left setTitle:@"模糊" forState:UIControlStateNormal];
    [left setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.backgroundColor = [UIColor greenColor];
    right.frame = CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.width + 10, (self.view.bounds.size.width - 40) / 2, 44);
    [right setTitle:@"消除模糊" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.width + 100, self.view.bounds.size.width - 40, 20)];
    slider.minimumValue = 0;
    slider.maximumValue = 1.0;
    [slider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
}

//添加模糊
- (void)leftClick
{
    icon.image = [DPImageBlurTool setGaussianBlur:[UIImage imageNamed:@"github"]];
}

//消除模糊
- (void)rightClick
{
    [DPImageBlurTool removGaussianBlur:[UIImage imageNamed:@"github"] withImageView:icon duration:1 imageBlurLevel:0.4];
}

- (void)valueChange:(UISlider *)slider
{
    icon.image = [DPImageBlurTool setGaussianBlur:[UIImage imageNamed:@"github"] withBlurLevel:slider.value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
