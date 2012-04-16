//
//  BCCheckerBoard.h
//  BoxCheckers
//
//  Created by Andrew Carter on 4/14/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCGLObject.h"

@class CC3GLMatrix;

@interface BCCheckerBoard : NSObject <BCGLObject> {
 
    NSMutableArray *_tiles;
    
}

@property (nonatomic, assign) GLfloat x;
@property (nonatomic, assign) GLfloat y;
@property (nonatomic, assign) GLfloat z;

- (void)drawWithModelViewMatrix:(CC3GLMatrix *)modelView;

@end
