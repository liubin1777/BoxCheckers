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

@end
