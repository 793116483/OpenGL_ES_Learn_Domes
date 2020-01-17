//
//  ViewController.m
//  OpenGL_ES绘图Dome
//
//  Created by 瞿杰 on 2020/1/15.
//  Copyright © 2020 yiniu. All rights reserved.
//

#import "ViewController.h"
#import "QJImageView.h"
#import "QJ3DImageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QJVertexAttribColor color = {1.0,0,0,0.5};
        CGSize size = [UIScreen mainScreen].bounds.size ;

        // 一张2D图展示 2D 效果
        QJImageView * imageView = [[QJImageView alloc] init];
        imageView.blankColor = color;
        imageView.image = [UIImage imageNamed:@"for_test.png"];
    //    imageView.ignoreAllVertexAttributeColorDraw = NO ;
        imageView.frame = CGRectMake(0, 0, size.width, size.height / 2);
        [self.view addSubview:imageView];

        // 一张2D图展示成 3D 效果
        QJ3DImageView * imageView_3D = [[QJ3DImageView alloc] init];
        imageView_3D.blankColor = color;
        imageView_3D.image = [UIImage imageNamed:@"for_test.png"];
        imageView_3D.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame), size.width, size.height / 2 - 1);
        [self.view addSubview:imageView_3D];
}

@end
