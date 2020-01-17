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

@end

NS_ASSUME_NONNULL_END
