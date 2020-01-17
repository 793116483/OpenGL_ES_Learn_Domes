//
//  QJImageView.m
//  OpenGL_ES绘图Dome
//
//  Created by 瞿杰 on 2020/1/15.
//  Copyright © 2020 yiniu. All rights reserved.
//

#import "QJImageView.h"

#import "QJDrawTrianglesModel.h"
#import "QJVertexAttribute.h"

@interface QJImageView ()

/// 显示图片的 上下文，它与view 邦定
@property (nonatomic , strong) EAGLContext * myContext ;

/// GPU 数组缓存中的个数
@property (nonatomic , assign) int nCount ;

@end

@implementation QJImageView
+(Class)layerClass {
    // GLKView 绘图必须 在 CAEAGLLayer 图层上才可以
    return [CAEAGLLayer class] ;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.ignoreAllVertexAttributeColorDraw = YES ;
        
        // 代理方法 用于绘图
        self.delegate = self ;
        
        // 指定 像素 颜色格式
        self.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888 ;
        self.drawableDepthFormat = GLKViewDrawableDepthFormat24 ;
    }
    return self ;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.triaglesAttributeArray.count) {
        self.nCount = 0 ;
        return ;
    }
    
    if (![self initDrawPreparationSuccess]) {
        self.context = nil ;
        self.myContext = nil ;
        self.nCount = 0 ;
    }
}

/// 画图配制：顶点化数据 + 纹理化数据
-(BOOL)initDrawPreparationSuccess {
    
    // 1. 关联 view 与 myContext
    self.context = self.myContext ;
    
    /* 2.【功能】： 把 self.myContext 设置成 当前屏幕 绘图的上下文
       【绘图前提】： 这一步必须先设置，不然后面 获取 图片纹理信息 时不成功
     */
    if (![EAGLContext setCurrentContext:self.myContext]) {
        NSLog(@"邦定上下文失败");
        return NO ;
    }
    glEnable(GL_DEPTH_TEST);
   
    // 3. 把三角形顶点数组 拷贝到 GPU 的缓存中
    GLuint buffers = [self setVertexAttributeArrayBufferWithTriaglesArray:self.triaglesAttributeArray   isDrawVertexColor:!self.ignoreAllVertexAttributeColorDraw];
    
    // 4. 获取图片的纹理 并给 myEffect 着色器
    GLKTextureInfo * textureInfo = [self setTextureInfoWithCGImage:self.image.CGImage];
    
    // 无纹理数据 不能绘图，则删除 GPU 数组缓存池
    if (!textureInfo) {
        glDeleteBuffers(0, &buffers);
    }
    
    /// 有纹理化需要的数据 可以绘图
    return textureInfo != nil ;
}


/// 初始化 顶点属性数组 缓存 ，并告知 GPU 读取方式
-(GLuint)setVertexAttributeArrayBufferWithTriaglesArray:(NSArray<QJDrawTrianglesModel *> *)triaglesArray
                                      isDrawVertexColor:(BOOL)isDrawVertexColor {
        
    /**
        【顶点数据】：两个三角形顶点坐标 + 对应的图片纹理坐标
     
            【顶点坐标】    ：是图片在上下文显示的位置；前三个是顶点坐标（x、y、z轴），以上下文内的中心点为原点 ，如果有内容缩放模式时，可以通过图片比例计算 顶点坐标
         
            【图片纹理坐标】 ：后面两个是 图片纹理坐标（x，y），以需要绘制的图片 左下角为原点
     */
    GLfloat squareVertexAttributes[self.triaglesAttributeArray.count * 3 * 9 ] ;
    GLuint n = 0 ;
    for (QJDrawTrianglesModel * trianglesModel in triaglesArray) {
        
        // 三角形模型
        NSArray<QJVertexAttribute *> * vertexAttArray = [trianglesModel vertexArray];
        
        for (QJVertexAttribute * vertexAtt in vertexAttArray) {
          
            // 三角形 顶点坐标
            squareVertexAttributes[n++] = vertexAtt.position.x ;
            squareVertexAttributes[n++] = vertexAtt.position.y ;
            squareVertexAttributes[n++] = vertexAtt.position.z ;
            
            // 顶点坐标 对应的 纹理坐标
            squareVertexAttributes[n++] = vertexAtt.texcoord.x ;
            squareVertexAttributes[n++] = vertexAtt.texcoord.y ;

            // 顶点颜色
            if (isDrawVertexColor) {
                squareVertexAttributes[n++] = vertexAtt.color.red ;
                squareVertexAttributes[n++] = vertexAtt.color.green ;
                squareVertexAttributes[n++] = vertexAtt.color.blue ;
                squareVertexAttributes[n++] = vertexAtt.color.alpha ;
            }
        }
    }
    
    self.nCount = n ;
    
    // 1. GPU 开辟 顶点属性数组缓存池，并从CPU 拷贝 顶点属性数组数据 到 GPU 数组缓存池
    GLuint buffers ;
    glGenBuffers(1, &buffers);
    glBindBuffer(GL_ARRAY_BUFFER, buffers);
    // 从CPU缓存中把 顶点数据数组 拷贝到 GPU 缓存池中 供GPU的顶点单元获取；这一步时有点耗时
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexAttributes), squareVertexAttributes, GL_STATIC_DRAW);
    
    GLsizei vertexSize = sizeof(GLfloat) * (isDrawVertexColor ? 9 : 5) ;
    
    // 1.1 告诉 GPU 绘图时，获取 缓存中的 顶点坐标 在缓存中的 开始位置 和 格式
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    // 获取方式（3：顶点是3D位置 、GL_FLOAT：顶点的数据类型，GL_FALSE：顶点坐标不需要转平面坐标(因为已经是平面坐标) 、sizeof(GLfloat)*5 ：表示一个顶点的大小 、(GLfloat *)NULL + 0 ：在一个顶点数据中取纹理坐标的起始位置下标）
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, vertexSize, (GLfloat *)NULL + 0);
     
    // 1.2 告诉 GPU 图片 纹理坐标 获取方式
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, vertexSize, (GLfloat *)NULL + 3);
    
    // 1.3 告诉 GPU 顶点的颜色
    if (isDrawVertexColor) {
        glEnableVertexAttribArray(GLKVertexAttribColor) ;
        glVertexAttribPointer(GLKVertexAttribColor, 4 , GL_FLOAT, GL_FALSE, vertexSize, (GLfloat *)NULL + 5);
    }
    
    return buffers ;
}

/// 设置 着色器的纹理名；为了在GPU绘图的纹理化阶段时，读取 image对应 纹理缓存中 的 纹理
-(nullable GLKTextureInfo*)setTextureInfoWithCGImage:(nonnull CGImageRef)image {
    /**
        【纹理化 功能】：1.纹理帖图；2.颜色化 : 得到 图片纹理的 颜色数据 (颜色值 ，与 深度) 等
      
        @parameter GLKTextureLoaderOriginBottomLeft 纹理坐标系是以Bottom Left为原点
     
        方式二：
                NSString* filePath = [[NSBundle mainBundle] pathForResource:@"image0" ofType:@"png"];
                GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
     */
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(YES), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithCGImage:image options:options error:nil];
    
    // 设置 着色器的纹理名；为了绘图的纹理化阶段时，读取 image对应 纹理缓存中 的 纹理
    self.myEffect.texture2d0.name = textureInfo.name;
    
    return textureInfo ;
}


#pragma mark - 开始绘图
/**
 *  当前view将要显示时，开始渲染：以三角形(GL_TRIANGLES)
 *
 * 注意：如果没有实现 drawRect: 方法，self 就需要实现 self.delegate 的代码方法 才能在指定的上下文 绘图
*/
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // 设置上下文的背景
    glClearColor(1.0f, 0.0f, 0.0f, 1.0);
    // 应用设置的 颜色 和 颜色深度(DEPTH = alpha)
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // 启动着色器 准备画图
    [self.myEffect prepareToDraw];
    
    // 把顶点数组 分成 两个三角形 方式 在上下文内 画图
    glDrawArrays(GL_TRIANGLES, 0, self.nCount) ;
    
}

#pragma mark - geter & setter

- (EAGLContext *)myContext {
    if (!_myContext) {
        _myContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    return _myContext ;
}

@synthesize myEffect = _myEffect ;
-(GLKBaseEffect *)myEffect {
    if (!_myEffect) {
        _myEffect = [[GLKBaseEffect alloc] init];
        _myEffect.texture2d0.enabled = YES ;
    }
    return _myEffect ;
}

#pragma mark - view 与 图片 自身的 四个顶点 组成 两个三角形 的 顶点数据
-(NSArray<QJDrawTrianglesModel *> *)triaglesAttributeArray {
    
    if (!_triaglesAttributeArray) {
        
        QJVertexAttribColor color0 = {0.0f, 0.0f, 0.5f , 1.0} ;
        QJVertexAttribPosition position0 = {-1,1,0};
        QJVertexAttribTexcoord texcoord0 = {0,1};
        QJVertexAttribute * vertexAttribute0 = [QJVertexAttribute vertexAttributeWithPosition:position0 texcoord:texcoord0 color:color0] ;
        
        QJVertexAttribColor color1 = {0.5f, 0.0f, 1.0f, 1.0} ;
        QJVertexAttribPosition position1 = {-1,-1,0};
        QJVertexAttribTexcoord texcoord1 = {0,0};
        QJVertexAttribute * vertexAttribute1 = [QJVertexAttribute vertexAttributeWithPosition:position1 texcoord:texcoord1 color:color1] ;

        QJVertexAttribColor color2 = {0.0f, 0.0f, 0.5f , 1.0} ;
        QJVertexAttribPosition position2 = {1,-1,0};
        QJVertexAttribTexcoord texcoord2 = {1,0};
        QJVertexAttribute * vertexAttribute2 = [QJVertexAttribute vertexAttributeWithPosition:position2 texcoord:texcoord2 color:color2] ;
        
        QJVertexAttribColor color3 = {0.0f, 0.5f, 0.0f , 1.0} ;
        QJVertexAttribPosition position3 = {1,1,0};
        QJVertexAttribTexcoord texcoord3 = {1,1};
        QJVertexAttribute * vertexAttribute3 = [QJVertexAttribute vertexAttributeWithPosition:position3 texcoord:texcoord3 color:color3] ;

        QJDrawTrianglesModel * trianglesModel0 = [QJDrawTrianglesModel drawTrianglesModelWithVertexArray:@[ vertexAttribute0, vertexAttribute1 , vertexAttribute2 ]];
        
        QJDrawTrianglesModel * trianglesModel1 = [QJDrawTrianglesModel drawTrianglesModelWithVertexArray:@[
            vertexAttribute0 ,vertexAttribute2 , vertexAttribute3 ]];
        
        _triaglesAttributeArray = @[trianglesModel0 , trianglesModel1];
    }
    return _triaglesAttributeArray ;
}

@end
