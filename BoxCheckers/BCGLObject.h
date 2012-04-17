//
//  BCGLObject.h
//  BoxCheckers
//
//  Created by Andrew Carter on 4/15/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

@class CC3GLMatrix;

@protocol BCGLObject <NSObject>

@optional

@property (nonatomic, strong) NSMutableData *color;

+ (void)loadWithModelViewUniform:(GLuint)modelViewUniform colorSlot:(GLuint)colorSlot positionSlot:(GLuint)positionSlot;

@required

@property (nonatomic, assign) GLfloat x;
@property (nonatomic, assign) GLfloat y;
@property (nonatomic, assign) GLfloat z;

- (void)drawWithModelViewMatrix:(CC3GLMatrix *)modelView;


@end
