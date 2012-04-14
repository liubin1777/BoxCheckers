//
//  BCGameViewController.h
//  BoxCheckers
//
//  Created by Andrew Carter on 4/13/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCCamera;
@class BCGameView;

@interface BCGameViewController : UIViewController {
 
    NSMutableArray *_drawables;
    BCCamera *_camera;
    
    BCGameView *_gameView;
    
    GLuint _colorRenderBuffer;
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    GLuint _depthRenderBuffer;
    
}

@end
