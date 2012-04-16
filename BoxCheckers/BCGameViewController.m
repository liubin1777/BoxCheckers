//
//  BCGameViewController.m
//  BoxCheckers
//
//  Created by Andrew Carter on 4/13/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCGameViewController.h"
#import "BCGameViewController+CameraDebug.h"

#import "BCGameView.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "CC3GLMatrix.h"

#import "BCGLObject.h"
#import "BCTypes.h"
#import "BCBox.h"
#import "BCCylinder.h"
#import "BCCheckerBoard.h"
#import "BCCamera.h"

@interface BCGameViewController ()


@end

@interface BCGameViewController ()

- (void)setupLayer;
- (void)setupContext;
- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType;
- (void)compileShaders;
- (void)render:(CADisplayLink *)displayLink;

//Camera Scripts

- (void)zoomTowardsCheckerboard;

@end

@implementation BCGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.wantsFullScreenLayout = YES;
        
        _camera = [BCCamera new];
        _camera.x = 0.0f;
        _camera.y = 5.0f;
        _camera.z = 1.5f;
        _camera.xRotation = -60.0f;
        _camera.yRotation = 0.0f;
        _camera.zRotation = 0.0f;
        
        _drawables = [NSMutableArray new];
        
        BCCheckerBoard *checkerBoard = [BCCheckerBoard new];
        
        [_drawables addObject:checkerBoard];
        
    
        for (NSUInteger x = 0; x < 9; x += 2) {
            
            BCCylinder *cylinder = [BCCylinder new];
            cylinder.z = -6.0f;
            cylinder.x = x * 2.0f;
            cylinder.y = 0.0f;
            [cylinder setColorWithUIColor:[UIColor redColor]];
            [_drawables addObject:cylinder];
            
        }
        
        for (NSUInteger x = 1; x < 9; x += 2) {
            
            BCCylinder *cylinder = [BCCylinder new];
            cylinder.z = -6.0f;
            cylinder.x = x * 2.0f;
            cylinder.y = 2.0f;
            [cylinder setColorWithUIColor:[UIColor redColor]];
            [_drawables addObject:cylinder];
            
        }
        
        for (NSUInteger x = 1; x < 9; x += 2) {
            
            BCCylinder *cylinder = [BCCylinder new];
            cylinder.z = -6.0f;
            cylinder.x = x * 2.0f;
            cylinder.y = 16.0f;
            [cylinder setColorWithUIColor:[UIColor blackColor]];
            [_drawables addObject:cylinder];
            
        }
        
        for (NSUInteger x = 0; x < 9; x += 2) {
            
            BCCylinder *cylinder = [BCCylinder new];
            cylinder.z = -6.0f;
            cylinder.x = x * 2.0f;
            cylinder.y = 14.0f;
            [cylinder setColorWithUIColor:[UIColor blackColor]];
            [_drawables addObject:cylinder];
            
        }
        
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
    [BCCylinder loadWithModelViewUniform:_modelViewUniform colorSlot:_colorSlot positionSlot:_positionSlot];
    
    [self setupDisplayLink];
 
#ifdef kAddCameraDebugSliders
    [self addCameraDebugSliders];
#endif
    
#ifdef kAddCameraDebugValues
    [self addCameraDebugValues];
#endif
    
    [self zoomTowardsCheckerboard];
    
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
    
    [_camera animateIfNeeded];
    
    [modelView translateBy:CC3VectorMake(_camera.x, _camera.y, _camera.z)];

    CC3GLMatrix *scratchMatrix = [CC3GLMatrix matrix];
    
    for (id <BCGLObject> drawable in _drawables) {
     
        [scratchMatrix populateFrom:modelView];
            
        [drawable drawWithModelViewMatrix:scratchMatrix];
                
    }
       
    [_gameView.context presentRenderbuffer:GL_RENDERBUFFER];
    
}

#pragma mark - Camera Scripts

- (void)zoomTowardsCheckerboard {
 
    _camera.x = 0.0f;
    _camera.y = 15.5f;
    _camera.z = -33.0f;
    _camera.xRotation = -57.0f;
    _camera.yRotation = 1.3f;
    _camera.zRotation = 1.3f;
    
    [_camera animateToX:-8.0f y:-7.0f z:-16.0f xRotation:0.0f yRotation:0.0f zRotation:0.0f duration:2.0f completion:^{
        
        [_camera animateToX:-8.0f y:8.0f z:-4.0f xRotation:-70.0f yRotation:0.0f zRotation:0.0f duration:2.0f completion:^{
           
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 60.0f)];
            label.textAlignment = UITextAlignmentCenter;
            label.font = [UIFont fontWithName:@"Helvetica-Bold" size:58];
            label.adjustsFontSizeToFitWidth = YES;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.text = @"CHECKERS!";
            label.shadowColor = [UIColor blackColor];
            label.shadowOffset = CGSizeMake(-1.0f, -1.0f);
            [self.view addSubview:label];
            
        }];
        
    }];

}

@end
