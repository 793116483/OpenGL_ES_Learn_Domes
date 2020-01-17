//
//  QJDrawTrianglesModel.m
//  OpenGL_ES绘图Dome
//
//  Created by 瞿杰 on 2020/1/17.
//  Copyright © 2020 yiniu. All rights reserved.
//

#import "QJDrawTrianglesModel.h"

@implementation QJDrawTrianglesModel

+(instancetype)drawTrianglesModelWithVertexArray:(NSArray<QJVertexAttribute *> *)vertexArray {
    if (vertexArray.count < 3) return nil ;
    
    QJDrawTrianglesModel * trianglesMode = [[self alloc] init];
    trianglesMode.vertex0 = vertexArray[0];
    trianglesMode.vertex1 = vertexArray[1];
    trianglesMode.vertex2 = vertexArray[2];
    
    return trianglesMode ;
}

-(NSArray<QJVertexAttribute *> *)vertexArray {
    NSMutableArray<QJVertexAttribute *> * vertexArray = [NSMutableArray arrayWithCapacity:3];
    if (self.vertex0) [vertexArray addObject:self.vertex0];
    if (self.vertex1) [vertexArray addObject:self.vertex1];
    if (self.vertex2) [vertexArray addObject:self.vertex2];

    if (vertexArray.count != 3) {
        return nil ;
    }
    return [vertexArray copy];
}



@end
