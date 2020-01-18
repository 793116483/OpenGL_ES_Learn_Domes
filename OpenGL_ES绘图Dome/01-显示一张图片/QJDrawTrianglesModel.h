//
//  QJDrawTrianglesModel.h
//  OpenGL_ES绘图Dome
//
//  Created by 瞿杰 on 2020/1/17.
//  Copyright © 2020 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class QJVertexAttribute ;

/// GPU 是根据 三角形模型 进行绘制
@interface QJDrawTrianglesModel : NSObject

#pragma mark 三角形的 三个顶点属性必须都要设置
@property (nonatomic , strong) QJVertexAttribute * vertex0 ;
@property (nonatomic , strong) QJVertexAttribute * vertex1 ;
@property (nonatomic , strong) QJVertexAttribute * vertex2 ;


/// 创建 三角形模型
/// @param vertexArray 三角形的顶点数组【 vertexArray.count >= 3 ，否则 绘制不出理想的图形】
/// @return 当 vertexArray.count >= 3 返回的是 非空对象
+(nullable instancetype)drawTrianglesModelWithVertexArray:(NSArray<QJVertexAttribute *> *) vertexArray ;

- (nullable NSArray<QJVertexAttribute *> *) vertexArray ;



/// 判断 当前三角形模型 是不是 一个三角形
- (BOOL)isTriangles ;

/// 判断两个三角形 是不是 同一个三角形 【PS：顶点坐标相同,则视为同一个三角形，否则视为不同】
/// @param triangles 三角形模型
- (BOOL)isSameTo:(QJDrawTrianglesModel *)triangles ;

@end

NS_ASSUME_NONNULL_END
