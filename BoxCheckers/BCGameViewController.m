//
//  BCGameViewController.m
//  BoxCheckers
//
//  Created by Andrew Carter on 4/13/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCGameViewController.h"

#import "BCGameView.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "CC3GLMatrix.h"

#import "BCTypes.h"
#import "BCBox.h"
#import "BCCheckerBoard.h"
#import "BCCamera.h"

@interface BCGameViewController ()


@end

BCGameView *_gameView;

GLuint _colorRenderBuffer;
GLuint _positionSlot;
GLuint _colorSlot;
GLuint _projectionUniform;
GLuint _modelViewUniform;
GLuint _depthRenderBuffer;

@interface BCGameViewController ()

- (void)setupLayer;
- (void)setupContext;
- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType;
- (void)compileShaders;
- (void)render:(CADisplayLink *)displayLink;

@end

@implementation BCGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.wantsFullScreenLayout = YES;
        
        _camera = [BCCamera new];
        
        _drawables = [NSMutableArray new];
        
        BCCheckerBoard *checkerBoard = [BCCheckerBoard new];
        
        [_drawables addObject:checkerBoard];
        
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView {
    
    _gameView = [[BCGameView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.view = _gameView;
    
    
    
}

- (void)viewDidLoad {
    
    [self setupLayer];
    [self setupContext];
    [self setupDepthBuffer];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self compileShaders];

    [BCBox loadWithModelViewUniform:_modelViewUniform colorSlot:_colorSlot positionSlot:_positionSlot];
    
    [self setupDisplayLink];
    
    UISlider *xslider = [UISlider new];
    xslider.frame = CGRectMake(0.0f, 0.0f, 320.0f, CGRectGetHeight(xslider.frame));
    xslider.alpha = 0.5f;
    xslider.value = 0.5f;
    [xslider addTarget:self action:@selector(xSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:xslider];
    
    UISlider *yslider = [UISlider new];
    yslider.frame = CGRectMake(0.0f, 20.0f, 320.0f, CGRectGetHeight(yslider.frame));
    yslider.alpha = 0.5f;
    yslider.value = 0.5f;
    [yslider addTarget:self action:@selector(ySliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:yslider];
    
    UISlider *zslider = [UISlider new];
    zslider.frame = CGRectMake(0.0f, 40.0f, 320.0f, CGRectGetHeight(zslider.frame));
    zslider.alpha = 0.5f;
    zslider.value = 0.5f;
    [zslider addTarget:self action:@selector(zSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:zslider];
    
    UISlider *xrslider = [UISlider new];
    xrslider.frame = CGRectMake(0.0f, 60.0f, 320.0f, CGRectGetHeight(xrslider.frame));
    xrslider.alpha = 0.5f;
    xrslider.value = 0.5f;
    [xrslider addTarget:self action:@selector(xrSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:xrslider];
    
    UISlider *yrslider = [UISlider new];
    yrslider.frame = CGRectMake(0.0f, 80.0f, 320.0f, CGRectGetHeight(yrslider.frame));
    yrslider.alpha = 0.5f;
    yrslider.value = 0.5f;
    [yrslider addTarget:self action:@selector(yrSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:yrslider];
    
    UISlider *zrslider = [UISlider new];
    zrslider.frame = CGRectMake(0.0f, 100.0f, 320.0f, CGRectGetHeight(zrslider.frame));
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

#pragma mark - Shader Compilation Methods

- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType {
    
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError *error = nil;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    assert(!error);
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char *shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    
    if (compileSuccess == GL_FALSE) {
        
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
        
    }
    
    return shaderHandle;
    
}

- (void)compileShaders {
    
    GLuint vertexShader = [self compileShader:@"SimpleVertex" 
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment" 
                                       withType:GL_FRAGMENT_SHADER];
    
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    glUseProgram(programHandle);
    
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    glEnableVertexAttribArray(_positionSlot);
    
    _colorSlot = glGetUniformLocation(programHandle, "SourceColor");
    
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
    
    _modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    
}

#pragma mark - OpenGL Setup

- (void)setupDisplayLink {
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}


- (void)setupLayer {
    
    _gameView.eaglLayer.opaque = YES;
    
}

- (void)setupContext {
    
    _gameView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_gameView.context];
    
}

- (void)setupDepthBuffer {
    
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.view.frame.size.width, self.view.frame.size.height);   
    
}

- (void)setupRenderBuffer {
    
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_gameView.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_gameView.eaglLayer];
    
}

- (void)setupFrameBuffer {
    
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

#pragma mark - OpenGL Rendering

- (void)render:(CADisplayLink *)displayLink {
        
    glClearColor(0.0f / 255.0f, 127.5f / 255.0f, 0.0f / 255.0f, 1.0f);
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    
    float h = 4.0f * self.view.frame.size.height / self.view.frame.size.width;
    
    [projection populateFromFrustumLeft:-2.0f andRight:2.0f andBottom:-h / 2.0f andTop:h / 2.0f andNear:4.0f andFar:50.0f];
    
    glUniformMatrix4fv(_projectionUniform, 1, GL_FALSE, projection.glMatrix);
    
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    CC3GLMatrix *modelView = [CC3GLMatrix identity];
        
    [modelView rotateByX:_camera.xRotation];
    [modelView rotateByY:_camera.yRotation];
    [modelView rotateByZ:_camera.zRotation];
    
    [modelView translateBy:CC3VectorMake(_camera.x, _camera.y, _camera.z)];

    CC3GLMatrix *scratchMatrix = [CC3GLMatrix matrix];
    
    for (id drawable in _drawables) {
     
        [scratchMatrix populateFrom:modelView];
            
        [(BCBox *)drawable drawWithModelViewMatrix:scratchMatrix];
                
    }
       
    [_gameView.context presentRenderbuffer:GL_RENDERBUFFER];
    
}

@end
