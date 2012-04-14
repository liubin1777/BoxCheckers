//
//  BCGameView.m
//  BoxCheckers
//
//  Created by Andrew Carter on 4/13/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCGameView.h"

#import <QuartzCore/QuartzCore.h>

@implementation BCGameView

@synthesize eaglLayer = _eaglLayer;
@synthesize context = _context;

- (CAEAGLLayer *)eaglLayer {
 
    return (CAEAGLLayer *)self.layer;
    
}

+ (Class)layerClass {
    
    return [CAEAGLLayer class];
    
}

@end
