//
//  QJ3DImageView.m
//  OpenGL_ES绘图Dome
//
//  Created by 瞿杰 on 2020/1/17.
//  Copyright © 2020 yiniu. All rights reserved.
//

#import "QJ3DImageView.h"

#import "QJDrawTrianglesModel.h"
#import "QJVertexAttribute.h"

@interface QJ3DImageView ()


@end

@implementation QJ3DImageView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 显示顶点颜色
        self.ignoreAllVertexAttributeColorDraw = NO ;
    }
    return self ;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.frame.size.height <= 0 || !self.context) {
        return ;
    }
    
    // 1。 设置 3D透视效果
    float fovyRadians = GLKMathDegreesToRadians(90.0) ; // 以人眼看屏幕视角是 垂直于屏的
    float aspect = self.frame.size.width / self.frame.size.height ;
    float nearZ = 0.1 ; // nearZ 必须 > 0 ; 所有顶点如果经过 transform 后 人的眼睛离屏 最小距离 可以看到的效果
    float farZ = 10.0 ; // farZ 必须 > nearZ ; 所有顶点如果经过 transform 后 人的眼睛离屏 最大距离 可以看到的效果
    // 1.1 projectionMatrix 用于 从人的眼睛👀位置开始投影 所有的3D顶点坐标 转成 屏幕上的二维坐标
    self.myEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(fovyRadians, aspect, nearZ, farZ);
    
    // 1.2 用于 3D mode 图 进行 旋转、平移 和 缩放
    // modelviewMatrix 的起始值必为 GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f)
    GLKMatrix4 start_modelviewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f) ;
    float radians = GLKMathDegreesToRadians(15.0) ; // 绕(1,1,1)向量轴 旋转15度
    self.myEffect.transform.modelviewMatrix = GLKMatrix4Rotate(start_modelviewMatrix , radians, 1, 1, 1);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startTimer];
    });
}

-(void)startTimer {
    float radians = GLKMathDegreesToRadians(15.0) ; // 绕(1,1,1)向量轴 旋转15度
    GLKMatrix4 start_modelviewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f) ;

    // 2. 定时器
    double delayInSeconds = 0.1;
    static dispatch_source_t timer ;
    
    if (timer == NULL) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    } else {
        return ;
    }
    
    static CGFloat flag = 0.9 ;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC, 0.0);
    dispatch_source_set_event_handler(timer, ^{
        flag += 0.1 ;
        self.myEffect.transform.modelviewMatrix = GLKMatrix4Rotate(start_modelviewMatrix , radians * flag, 1, 1, 1);
        [self setNeedsDisplay];
    });
    dispatch_resume(timer);
}

#pragma mark - view 与 图片 自身的 四个顶点 组成 两个三角形 的 顶点数据
@synthesize triaglesAttributeArray = _triaglesAttributeArray ;
-(NSArray<QJDrawTrianglesModel *> *)triaglesAttributeArray {
    
    if (!_triaglesAttributeArray) {
        
        NSArray<QJDrawTrianglesModel *> * triaglesArray = [super triaglesAttributeArray];
        
        // 其他四个角
        QJVertexAttribute * vertexAttribute1 = triaglesArray[0].vertex0 ;
        QJVertexAttribute * vertexAttribute2 = triaglesArray[0].vertex1 ;
        QJVertexAttribute * vertexAttribute3 = triaglesArray[0].vertex2 ;
        QJVertexAttribute * vertexAttribute4 = triaglesArray[1].vertex2 ;
        // 3D中心点
        QJVertexAttribPosition position5 = {0,0,1};
        QJVertexAttribTexcoord texcoord5 = {0.5,0.5};
        QJVertexAttribColor color5 = {1.0f, 1.0f, 1.5f , 1.0} ;
        QJVertexAttribute * vertexAttribute5 = [QJVertexAttribute vertexAttributeWithPosition:position5 texcoord:texcoord5 color:color5] ;

        // 3D的四个三角形面
        QJDrawTrianglesModel * trianglesModel0 = [QJDrawTrianglesModel drawTrianglesModelWithVertexArray:@[ vertexAttribute5, vertexAttribute1 , vertexAttribute2 ]];
        
        QJDrawTrianglesModel * trianglesModel1 = [QJDrawTrianglesModel drawTrianglesModelWithVertexArray:@[ vertexAttribute5 ,vertexAttribute2 , vertexAttribute3 ]];
        
        QJDrawTrianglesModel * trianglesModel2 = [QJDrawTrianglesModel drawTrianglesModelWithVertexArray:@[ vertexAttribute5 ,vertexAttribute3 , vertexAttribute4 ]];
        
        QJDrawTrianglesModel * trianglesModel3 = [QJDrawTrianglesModel drawTrianglesModelWithVertexArray:@[ vertexAttribute5 ,vertexAttribute4 , vertexAttribute1 ]];

        _triaglesAttributeArray = [triaglesArray arrayByAddingObjectsFromArray:@[trianglesModel0 , trianglesModel1 , trianglesModel2 , trianglesModel3 ]];
    }
    return _triaglesAttributeArray ;
}

@end
