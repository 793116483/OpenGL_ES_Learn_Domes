//
//  QJImageView.h
//  OpenGL_ES绘图Dome
//
//  Created by 瞿杰 on 2020/1/15.
//  Copyright © 2020 yiniu. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <UIKit/UIKit.h>

#import "QJVertexAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@class QJDrawTrianglesModel ;

@interface QJImageView : GLKView<GLKViewDelegate>

/// 着色器
@property (nonatomic , readonly) GLKBaseEffect * myEffect ;

/// 空白处的填充颜色,相当于背景色
@property (nonatomic) QJVertexAttribColor blankColor ;

/// 需要绘制的图形
@property (nonatomic , strong) UIImage * image ;

/// GPU 绘制 image 图的 顶点属性 数组 , 子类可以重写该 getter 方法 , 默认是图片填充
@property (nonatomic , copy ) NSArray<QJDrawTrianglesModel *> * triaglesAttributeArray ;

/// 是否忽略 所有三角形的顶点属性 QJVertexAttribute 对象的 color 绘制 ; 默认为 YES
@property (nonatomic , assign) BOOL ignoreAllVertexAttributeColorDraw ;

@end

NS_ASSUME_NONNULL_END
