//
//  BCGameViewController.h
//  BoxCheckers
//
//  Created by Andrew Carter on 4/13/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCCamera;

@interface BCGameViewController : UIViewController {
 
    NSMutableArray *_drawables;
    BCCamera *_camera;
    
}

@end
