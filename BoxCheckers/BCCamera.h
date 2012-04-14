//
//  BCCamera.h
//  BoxCheckers
//
//  Created by Andrew Carter on 4/14/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/ES2/gl.h>

typedef void (^AnimationCompletionBlock)();

@interface BCCamera : NSObject {
 
    GLfloat _x;
    GLfloat _y;
    GLfloat _z;
    GLfloat _xRotation;
    GLfloat _yRotation;
    GLfloat _zRotation;
    
    GLfloat _destinationX;
    GLfloat _destinationY;
    GLfloat _destinationZ;
    GLfloat _destinationXRotation;
    GLfloat _destinationYRotation;
    GLfloat _destinationZRotation;
    
    GLfloat _startX;
    GLfloat _startY;
    GLfloat _startZ;
    GLfloat _startXRotation;
    GLfloat _startYRotation;
    GLfloat _startZRotation;
    
    GLfloat _animationDuration;
    GLfloat _animationStart;
    
    BOOL _shouldAnimate;
 
    NSDate *_startDate;
 
    AnimationCompletionBlock _animationCompletion;
    
}

@property (nonatomic, assign) GLfloat x;
@property (nonatomic, assign) GLfloat y;
@property (nonatomic, assign) GLfloat z;
@property (nonatomic, assign) GLfloat xRotation;
@property (nonatomic, assign) GLfloat yRotation;
@property (nonatomic, assign) GLfloat zRotation;

- (void)animateToX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z xRotation:(GLfloat)xRotation yRotation:(GLfloat)yRotation zRotation:(GLfloat)zRotation duration:(GLfloat)duration completion:(AnimationCompletionBlock)completion;
- (void)animateIfNeeded;

@end
