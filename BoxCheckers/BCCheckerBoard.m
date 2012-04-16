//
//  BCCheckerBoard.m
//  BoxCheckers
//
//  Created by Andrew Carter on 4/14/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCCheckerBoard.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "CC3GLMatrix.h"

#import "BCBox.h"

@implementation BCCheckerBoard

@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.x = 0.0f;
        self.y = 0.0f;
        self.z = 0.0f;
        
        _tiles = [NSMutableArray new];
        
        for (NSInteger y = 0; y < 9; y++) {
            
            for (NSInteger x = 0; x <9; x++) {
                
                BCBox *box = [BCBox new];
                
                box.y = y * 2;
                box.x = x * 2;
                
                if (y % 2 == 0) {
                 
                    if (x % 2 == 0) {
                        [box setColorWithUIColor:[UIColor blackColor]];
                    } else {
                        [box setColorWithUIColor:[UIColor redColor]];

                    }
                    
                } else {
                    
                    if (x % 2 == 0) {
                        [box setColorWithUIColor:[UIColor redColor]];

                    } else {
                        [box setColorWithUIColor:[UIColor blackColor]];

                    }
                    
                }
                
                
                [_tiles addObject:box];
                
            }
            
        }
        
    }
    
    return self;
    
}

- (void)drawWithModelViewMatrix:(CC3GLMatrix *)modelView {
    
    CC3GLMatrix *scratchMatrix = [CC3GLMatrix matrix];
    [scratchMatrix populateFrom:modelView];
    
    [scratchMatrix translateBy:CC3VectorMake(self.x, self.y, self.z)];
    
    for (BCBox *box in _tiles) {
     
        [modelView populateFrom:scratchMatrix];
        
        [box drawWithModelViewMatrix:modelView];
        
    }
    
}

@end
