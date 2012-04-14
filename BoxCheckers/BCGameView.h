//
//  BCGameView.h
//  BoxCheckers
//
//  Created by Andrew Carter on 4/13/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAEAGLLayer;

@interface BCGameView : UIView 

@property (nonatomic, readonly) CAEAGLLayer *eaglLayer;
@property (nonatomic, strong) EAGLContext *context;

#ifdef kAddCameraDebugValues

@property (nonatomic, readonly) UILabel *cameraXLabel;
@property (nonatomic, readonly) UILabel *cameraYLabel;
@property (nonatomic, readonly) UILabel *cameraZLabel;
@property (nonatomic, readonly) UILabel *cameraXRotLabel;
@property (nonatomic, readonly) UILabel *cameraYRotLabel;
@property (nonatomic, readonly) UILabel *cameraZRotLabel;

- (void)cameraPositionChanged:(NSNotification *)nofitication;

#endif

@end
