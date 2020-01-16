//
//  ViewController.m
//  OpenGL_ES绘图Dome
//
//  Created by 瞿杰 on 2020/1/15.
//  Copyright © 2020 yiniu. All rights reserved.
//

#import "ViewController.h"
#import "QJImageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    QJImageView * imageView = [[QJImageView alloc] init];
    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"image0.png"];
    imageView.frame = [UIScreen mainScreen].bounds;
    
    [self.view addSubview:imageView];
}

@end
