//
//  BCCylinder.h
//  BoxCheckers
//
//  Created by Andrew Carter on 4/15/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCGLObject.h"

@interface BCCylinder : NSObject <BCGLObject>

@property (nonatomic, assign) GLfloat x;
@property (nonatomic, assign) GLfloat y;
@property (nonatomic, assign) GLfloat z;
@property (nonatomic, strong) NSMutableData *color;

+ (void)loadWithModelViewUniform:(GLuint)modelViewUniform colorSlot:(GLuint)colorSlot positionSlot:(GLuint)positionSlot;
- (void)drawWithModelViewMatrix:(CC3GLMatrix *)modelView;
- (void)setColorWithArray:(GLfloat *)array;
- (void)setColorWithUIColor:(UIColor *)color;

@end
