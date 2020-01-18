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

-(BOOL)isSameTo:(QJVertexAttribute *)aVertexAttribute {
    if (aVertexAttribute == nil) return NO ;
    if (self == aVertexAttribute) return YES ;
    
    if (self.position.x != aVertexAttribute.position.x ||
        self.position.y != aVertexAttribute.position.y ||
        self.position.z != aVertexAttribute.position.z) {
        return NO ;
    }
    
    return YES ;
}

@end
