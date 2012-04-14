//
//  BCGameView.m
//  BoxCheckers
//
//  Created by Andrew Carter on 4/13/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCGameView.h"

#import <QuartzCore/QuartzCore.h>

#ifdef kAddCameraDebugValues
    #import "BCCamera.h"
#endif

@implementation BCGameView

@synthesize eaglLayer = _eaglLayer;
@synthesize context = _context;

#ifdef kAddCameraDebugValues

@synthesize cameraXLabel = _cameraXLabel;
@synthesize cameraYLabel = _cameraYLabel;
@synthesize cameraZLabel = _cameraZLabel;
@synthesize cameraXRotLabel = _cameraXRotLabel;
@synthesize cameraYRotLabel = _cameraYRotLabel;
@synthesize cameraZRotLabel = _cameraZRotLabel;

#endif

- (id)initWithFrame:(CGRect)frame {
 
    self = [super initWithFrame:frame];
    
    if (self) {
        
#ifdef kAddCameraDebugValues
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraPositionChanged:) name:@"CameraPositionChanged" object:nil];
        
        void (^configureAndAddLabelSubview)(UILabel *) = ^(UILabel *label) {
          
            label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.shadowColor = [UIColor blackColor];
            label.shadowOffset = CGSizeMake(-1.0f, -1.0f);
            [self addSubview:label];
            
        };
        
        _cameraXLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 380.0f, CGRectGetWidth(frame) - 10.0f, 16.0f)];
        configureAndAddLabelSubview(_cameraXLabel);
        
        _cameraYLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(_cameraXLabel.frame), CGRectGetWidth(frame) - 10.0f, 16.0f)];
        configureAndAddLabelSubview(_cameraYLabel);
        
        _cameraZLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(_cameraYLabel.frame), CGRectGetWidth(frame) - 10.0f, 16.0f)];
        configureAndAddLabelSubview(_cameraZLabel);
        
        _cameraXRotLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(_cameraZLabel.frame), CGRectGetWidth(frame) - 10.0f, 16.0f)];
        configureAndAddLabelSubview(_cameraXRotLabel);
        
        _cameraYRotLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(_cameraXRotLabel.frame), CGRectGetWidth(frame) - 10.0f, 16.0f)];
        configureAndAddLabelSubview(_cameraYRotLabel);
        
        _cameraZRotLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(_cameraYRotLabel.frame), CGRectGetWidth(frame) - 10.0f, 16.0f)];
        configureAndAddLabelSubview(_cameraZRotLabel);

#endif
        
    }
    
    return self;
    
}

#ifdef kAddCameraDebugValues

- (void)cameraPositionChanged:(NSNotification *)nofitication {

    BCCamera *camera = nofitication.object;
    
    _cameraXLabel.text = [NSString stringWithFormat:@"X: %f",camera.x];
    _cameraYLabel.text = [NSString stringWithFormat:@"Y: %f",camera.y];
    _cameraZLabel.text = [NSString stringWithFormat:@"Z: %f",camera.z];
    _cameraXRotLabel.text = [NSString stringWithFormat:@"XROT: %f",camera.xRotation];
    _cameraYRotLabel.text = [NSString stringWithFormat:@"YROT: %f",camera.yRotation];
    _cameraZRotLabel.text = [NSString stringWithFormat:@"ZROT: %f",camera.zRotation];

}

#endif

- (CAEAGLLayer *)eaglLayer {
 
    return (CAEAGLLayer *)self.layer;
    
}

+ (Class)layerClass {
    
    return [CAEAGLLayer class];
    
}

@end
