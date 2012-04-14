//
//  BCCamera.h
//  BoxCheckers
//
//  Created by Andrew Carter on 4/14/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/ES2/gl.h>

@interface BCCamera : NSObject

@property (nonatomic, assign) GLfloat x;
@property (nonatomic, assign) GLfloat y;
@property (nonatomic, assign) GLfloat z;
@property (nonatomic, assign) GLfloat xRotation;
@property (nonatomic, assign) GLfloat yRotation;
@property (nonatomic, assign) GLfloat zRotation;

@end
