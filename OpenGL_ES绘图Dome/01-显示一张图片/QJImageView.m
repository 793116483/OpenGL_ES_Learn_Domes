//
//  QJImageView.m
//  OpenGL_ES绘图Dome
//
//  Created by 瞿杰 on 2020/1/15.
//  Copyright © 2020 yiniu. All rights reserved.
//

#import "QJImageView.h"

@interface QJImageView ()

/// 显示图片的 上下文，它与view 邦定
@property (nonatomic , strong) EAGLContext * myContext ;

/// 着色器
@property (nonatomic , strong) GLKBaseEffect * myEffect ;

@end

@implementation QJImageView
+(Class)layerClass {
    return [CAEAGLLayer class] ;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self drawPreparationSuccess]) {
        // 关联 view 与 myContext
        self.context = self.myContext ;
    }
}



/// 画图配制：顶点化数据 + 纹理化数据
-(BOOL)drawPreparationSuccess {
    /*
          【功能】： 把 self.myContext 设置成 当前屏幕 绘图的上下文
       【绘图前提】： 这一步必须先设置，不然后面 获取 图片纹理信息 时不成功
     */
    if (![EAGLContext setCurrentContext:self.myContext]) {
        NSLog(@"邦定上下文失败");
        return NO ;
    }
    
    /**
        【顶点数据】：两个三角形顶点坐标 + 对应的图片纹理坐标
     
            【顶点坐标】    ：是图片在上下文显示的位置；前三个是顶点坐标（x、y、z轴），以上下文内的中心点为原点 ，如果有内容缩放模式时，可以通过图片比例计算 顶点坐标
         
            【图片纹理坐标】 ：后面两个是 图片纹理坐标（x，y），以需要绘制的图片 左下角为原点
     */
    GLfloat squareVertexAttributes[] =
    {
        0.9f, -0.9f, 0.0f,    1.0f, 0.0f, //右下
        0.9f, 0.9f, -0.0f,    1.0f, 1.0f, //右上
        -0.9f, 0.9f, 0.0f,    0.0f, 1.0f, //左上
        
        0.9f, -0.9f, 0.0f,    1.0f, 0.0f, //右下
        -0.9f, 0.9f, 0.0f,    0.0f, 1.0f, //左上
        -0.9f, -0.9f, 0.0f,   0.0f, 0.0f, //左下
    };
    
    // GPU 开辟 数组缓存池，并从CPU 拷贝 顶点数组数据 到 GPU 数组缓存池
    GLuint buffers ;
    glGenBuffers(1, &buffers);
    glBindBuffer(GL_ARRAY_BUFFER, buffers);
    // 从CPU缓存中把 顶点数据数组 拷贝到 GPU 缓存池中 供GPU的顶点单元获取；这一步时有点耗时
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexAttributes), squareVertexAttributes, GL_STATIC_DRAW);
    
    // 告诉 GPU 绘图时，获取 缓存中的 顶点坐标 在缓存中的 开始位置 和 格式
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    // 获取方式（3：顶点是3D位置 、GL_FLOAT：顶点的数据类型，GL_FALSE：顶点坐标不需要转平面坐标(因为已经是平面坐标) 、sizeof(GLfloat)*5 ：表示一个顶点的大小 、(GLfloat *)NULL + 0 ：在数组中取顶点的初始位置下标）
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL + 0);
    
    // 告诉 GPU 图片 纹理坐标 获取方式
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL + 0);
    
    /**
        【纹理化 功能】：1.纹理帖图；2.颜色化 : 得到 图片纹理的 颜色数据 (颜色值 ，与 深度) 等
      
        @parameter GLKTextureLoaderOriginBottomLeft 纹理坐标系是以Bottom Left为原点
     
        方式二：
                NSString* filePath = [[NSBundle mainBundle] pathForResource:@"image0" ofType:@"png"];
                GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
     */
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(YES), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithCGImage:self.image.CGImage options:options error:nil];
    
    // 着色器 设置纹理配制
    self.myEffect.texture2d0.name = textureInfo.name;
    
    // 无纹理数据 不能绘图，则删除 GPU 数组缓存池
    if (!textureInfo) {
        glDeleteBuffers(0, &buffers);
    }
    
    /// 有纹理化需要的数据 可以绘图
    return textureInfo != nil ;
}

/**
 *  当前view将要显示时，开始渲染：以三角形(GL_TRIANGLES)
 *
 * 注意：如果没有实现 drawRect: 方法，self 就需要实现 self.delegate 的代码方法 才能在指定的上下文 绘图
*/
-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 设置上下文的背景
    glClearColor(1.0f, 0.0f, 0.0f, 1.0);
    // 应用设置的 颜色 和 颜色深度(DEPTH = alpha)
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // 启动着色器 准备画图
    [self.myEffect prepareToDraw];
    
    // 把顶点数组 分成 两个三角形 方式 在上下文内 画图
    glDrawArrays(GL_TRIANGLES, 0, 6);
}


- (EAGLContext *)myContext {
    if (!_myContext) {
        
        _myContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        _myContext.multiThreaded = YES ;
        
        // 指定 像素 颜色格式
        self.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888 ;
    }
    return _myContext ;
}

-(GLKBaseEffect *)myEffect {
    if (!_myEffect) {
        _myEffect = [[GLKBaseEffect alloc] init];
        _myEffect.texture2d0.enabled = YES ;
    }
    return _myEffect ;
}

@end
