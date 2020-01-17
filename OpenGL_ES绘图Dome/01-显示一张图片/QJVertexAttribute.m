//
//  QJVertexAttribute.m
//  OpenGL_ES绘图Dome
//
//  Created by 瞿杰 on 2020/1/17.
//  Copyright © 2020 yiniu. All rights reserved.
//

#import "QJVertexAttribute.h"

@implementation QJVertexAttribute

+(instancetype)vertexAttributeWithPosition:(QJVertexAttribPosition)position texcoord:(QJVertexAttribTexcoord)texcoord {
    
    QJVertexAttribute * vertexAttibute = [[self alloc] init];
    vertexAttibute.position = position ;
    vertexAttibute.texcoord = texcoord ;
        
    return vertexAttibute ;
}

+(instancetype)vertexAttributeWithPosition:(QJVertexAttribPosition)position texcoord:(QJVertexAttribTexcoord)texcoord color:(QJVertexAttribColor)color {
    
    QJVertexAttribute * vertexAttibute = [self  vertexAttributeWithPosition:position texcoord:texcoord];
    vertexAttibute.color = color ;
    
    return vertexAttibute ;
}

@end
