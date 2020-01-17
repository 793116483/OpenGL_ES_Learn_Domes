//
//  QJVertexAttribute.h
//  OpenGL_ES绘图Dome
//
//  Created by 瞿杰 on 2020/1/17.
//  Copyright © 2020 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 结构体
/// 顶点属性 的 3D坐标，所有属性取值范围 [-1.0 ~ 1.0]
/// 如: 3D坐标原点 (0.0 , 0.0 , 0.0) ，表示该顶点位置是 view自身 的中心点
struct QJVertexAttribPosition {
    GLfloat x , y , z ;
};
typedef struct QJVertexAttribPosition QJVertexAttribPosition;

/// 顶点属性 的 纹理坐标，所有属性取值范围 [0.0 ~ 1.0]
/// 如: 纹理的坐标原点 (0.0 , 0.0) 也就是一张图片的 左下角
struct QJVertexAttribTexcoord {
    GLfloat x , y ;
};
typedef struct QJVertexAttribTexcoord QJVertexAttribTexcoord;


/// 顶点属性 的 颜色，取值范围 [0.0 ~ 1.0]
/// 如: 纹理的坐标原点 (0.0 , 0.0) 也就是一张图片的 左下角
struct QJVertexAttribColor {
    GLfloat red , green , blue , alpha ;
};
typedef struct QJVertexAttribColor QJVertexAttribColor;




#pragma mark - 顶点属性 类
@interface QJVertexAttribute : NSObject

/**【必设】 顶点位置（即 是所属view上的顶点位置）  */
@property (nonatomic) QJVertexAttribPosition position ;
/**【必设】 顶点位置 对应的 纹理坐标(即 图片自身 的点)  */
@property (nonatomic) QJVertexAttribTexcoord texcoord ;

/*【可选】 顶点的颜色值 */
@property (nonatomic) QJVertexAttribColor color ;



/// 创建顶点属性
/// @param position 顶点位置
/// @param texcoord 顶点位置 对应的 纹理坐标(即 图片自身 的点)
+(instancetype) vertexAttributeWithPosition:(QJVertexAttribPosition)position texcoord:(QJVertexAttribTexcoord)texcoord  ;

/// 创建顶点属性
/// @param position 顶点位置
/// @param texcoord 顶点位置 对应的 纹理坐标(即 图片自身 的点)
/// @param color 顶点的颜色值
+(instancetype) vertexAttributeWithPosition:(QJVertexAttribPosition)position texcoord:(QJVertexAttribTexcoord)texcoord color:(QJVertexAttribColor)color ;


@end






NS_ASSUME_NONNULL_END
