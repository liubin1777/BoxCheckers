//
//  BCCamera.m
//  BoxCheckers
//
//  Created by Andrew Carter on 4/14/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCCamera.h"

@implementation BCCamera

@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;
@synthesize xRotation = _xRotation;
@synthesize yRotation = _yRotation;
@synthesize zRotation = _zRotation;

- (void)animateToX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z xRotation:(GLfloat)xRotation yRotation:(GLfloat)yRotation zRotation:(GLfloat)zRotation duration:(GLfloat)duration completion:(AnimationCompletionBlock)completion {
 
    _animationCompletion = [completion copy];
    
    _destinationX = x;
    _destinationY = y;
    _destinationZ = z;
    _destinationXRotation = xRotation;
    _destinationYRotation = yRotation;
    _destinationZRotation = zRotation;
    
    _startX = self.x;
    _startY = self.y;
    _startZ = self.z;
    _startXRotation = self.xRotation;
    _startYRotation = self.yRotation;
    _startZRotation = self.zRotation;
 
    _startDate = [NSDate date];
    
    _animationStart = [[NSDate date] timeIntervalSinceDate:_startDate];
    _animationDuration = duration;
    
    _shouldAnimate = YES;
    
}

- (void)animateIfNeeded {
 
    if (!_shouldAnimate) {
            return;
    }
        
    GLfloat endTime = _animationStart + _animationDuration;
    GLfloat currentTime = [[NSDate date] timeIntervalSinceDate:_startDate];
    GLfloat totalTime = _animationDuration;    
    GLfloat currentElapsed = currentTime - _animationStart;
        
    if (currentTime > endTime) {
      
        _shouldAnimate = NO;
        
        self.x = _destinationX;
        self.y = _destinationY;
        self.z = _destinationZ;
        self.xRotation = _destinationXRotation;
        self.yRotation = _destinationYRotation;
        self.zRotation = _destinationZRotation;
        
        _animationCompletion();
        
        return;
    }
    
    GLfloat xDelta = _destinationX - _startX;
    GLfloat yDelta = _destinationY - _startY;
    GLfloat zDelta = _destinationZ - _startZ;
    GLfloat xRotationDelta = _destinationXRotation - _startXRotation;
    GLfloat yRotationDelta = _destinationYRotation - _startYRotation;
    GLfloat zRotationDelta = _destinationZRotation - _startZRotation;
    
    GLfloat percentage = currentElapsed / totalTime;
    
    self.x = _startX + (xDelta * percentage);
    self.y = _startY + (yDelta * percentage);
    self.z = _startZ + (zDelta * percentage);
    self.xRotation = _startXRotation + (xRotationDelta * percentage);
    self.yRotation = _startYRotation + (yRotationDelta * percentage);
    self.zRotation = _startZRotation + (zRotationDelta * percentage);

    
}

#ifdef kAddCameraDebugValues 

- (void)setX:(GLfloat)x {
    
    _x = x;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CameraPositionChanged" object:self];

}

- (void)setY:(GLfloat)y {
    
    _y = y;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CameraPositionChanged" object:self];

}

- (void)setZ:(GLfloat)z {
    
    _z = z;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CameraPositionChanged" object:self];

}

- (void)setXRotation:(GLfloat)xRotation {
    
    _xRotation = xRotation;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CameraPositionChanged" object:self];

}

- (void)setYRotation:(GLfloat)yRotation {
    
    _yRotation = yRotation;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CameraPositionChanged" object:self];

}

- (void)setZRotation:(GLfloat)zRotation {
    
    _zRotation = zRotation;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CameraPositionChanged" object:self];

}

#endif

@end
