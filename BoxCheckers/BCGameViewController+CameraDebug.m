//
//  BCGameViewController+CameraDebug.m
//  BoxCheckers
//
//  Created by Andrew Carter on 4/14/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCGameViewController+CameraDebug.h"

#import "BCCamera.h"

@implementation BCGameViewController (CameraDebug)

- (void)addCameraDebugValues {
    

    
}

- (void)addCameraDebugSliders {
 
    UISlider *xslider = [UISlider new];
    xslider.frame = CGRectMake(0.0f, 0.0f, 160.0f, CGRectGetHeight(xslider.frame));
    xslider.alpha = 0.5f;
    xslider.value = 0.5f;
    [xslider addTarget:self action:@selector(xSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:xslider];
    
    UISlider *yslider = [UISlider new];
    yslider.frame = CGRectMake(0.0f, 25.0f, 160.0f, CGRectGetHeight(yslider.frame));
    yslider.alpha = 0.5f;
    yslider.value = 0.5f;
    [yslider addTarget:self action:@selector(ySliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:yslider];
    
    UISlider *zslider = [UISlider new];
    zslider.frame = CGRectMake(0.0f, 50.0f, 160.0f, CGRectGetHeight(zslider.frame));
    zslider.alpha = 0.5f;
    zslider.value = 0.5f;
    [zslider addTarget:self action:@selector(zSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:zslider];
    
    UISlider *xrslider = [UISlider new];
    xrslider.frame = CGRectMake(0.0f, 75.0f, 160.0f, CGRectGetHeight(xrslider.frame));
    xrslider.alpha = 0.5f;
    xrslider.value = 0.5f;
    [xrslider addTarget:self action:@selector(xrSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:xrslider];
    
    UISlider *yrslider = [UISlider new];
    yrslider.frame = CGRectMake(0.0f, 100.0f, 160.0f, CGRectGetHeight(yrslider.frame));
    yrslider.alpha = 0.5f;
    yrslider.value = 0.5f;
    [yrslider addTarget:self action:@selector(yrSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:yrslider];
    
    UISlider *zrslider = [UISlider new];
    zrslider.frame = CGRectMake(0.0f, 125.0f, 160.0f, CGRectGetHeight(zrslider.frame));
    zrslider.alpha = 0.5f;
    zrslider.value = 0.5f;
    [zrslider addTarget:self action:@selector(zrSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:zrslider];
    
}

- (void)xSliderValueChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    _camera.x = -50.0f + (100.0f * slider.value);
    
}

- (void)ySliderValueChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    _camera.y = -50.0f + (100.0f * slider.value);
    
}

- (void)zSliderValueChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    _camera.z = -50.0f + (100.0f * slider.value);
    
}

- (void)xrSliderValueChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    _camera.xRotation = -90.0f + (180.0f * slider.value);
    
}

- (void)yrSliderValueChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    _camera.yRotation = -90.0f + (180.0f * slider.value);
    
}

- (void)zrSliderValueChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    _camera.zRotation = -90.0f + (180.0f * slider.value);
    
}


@end
