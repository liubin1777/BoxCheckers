//
//  BCCylinder.m
//  BoxCheckers
//
//  Created by Andrew Carter on 4/15/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCCylinder.h"

#import "BCTypes.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "CC3GLMatrix.h"

static GLuint ColorSlot;
static GLuint PositionSlot;
static GLuint ModelViewUniform;

static GLuint VertexBuffer;
static GLuint IndexBuffer;

static BCVertex Vertices[] = {

    {0.0f, 0.0f, 1.0f},
    {0.25f, -0.75f, 1.0f},
    {0.75f, -0.25f, 1.0f},
    {0.75f, 0.25f, 1.0f},
    {0.25f, 0.75f, 1.0f},
    {-0.25f, 0.75f, 1.0f},
    {-0.75f, 0.25f, 1.0f},
    {-0.75f, -0.25f, 1.0f},
    {-0.25f, -0.75f, 1.0f},
    
    {0.0f, 0.0f, 0.0f},
    {0.25f, -0.75f, 0.0f},
    {0.75f, -0.25f, 0.0f},
    {0.75f, 0.25f, 0.0f},
    {0.25f, 0.75f, 0.0f},
    {-0.25f, 0.75f, 0.0f},
    {-0.75f, 0.25f, 0.0f},
    {-0.75f, -0.25f, 0.0f},
    {-0.25f, -0.75f, 0.0f},

};

static GLubyte Indices[] = {
    
    0,1,2,
    0,2,3,
    0,3,4,
    0,4,5,
    0,5,6,
    0,6,7,
    0,7,8,
    0,8,1,
    
    9,10,11,
    9,11,12,
    9,12,13,
    9,13,14,
    9,14,15,
    9,15,16,
    9,16,17,
    9,17,10,
    
    1,10,11,
    1,2,11,
    
    2,11,12,
    2,3,12,
    
    3,12,13,
    3,4,13,
    
    4,13,14,
    4,5,14,
    
    5,14,15,
    5,6,15,
    
    6,15,16,
    6,7,16,
    
    7,16,17,
    7,8,17,
    
    8,17,10,
    8,1,10
    
};

@implementation BCCylinder

@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;
@synthesize color = _color;

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.x = 0.0f;
        self.y = 0.0f;
        self.z = -7.0f;
        GLfloat color[] = {0.5f, 0.5f, 0.5f, 1.0f};
        self.color = [NSMutableData dataWithBytes:color length:sizeof(color)*sizeof(GLfloat)];
        
    }
    
    return self;
    
}

- (void)setColorWithArray:(GLfloat *)array {
    
    self.color = [NSMutableData dataWithBytes:array length:sizeof(array)*sizeof(GLfloat)];
    
}

- (void)setColorWithUIColor:(UIColor *)color {
    
    GLfloat red = 0.0f;
    GLfloat green = 0.0f;
    GLfloat blue = 0.0f;
    GLfloat alpha = 0.0f;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    GLfloat array[] = {red, green, blue, alpha};
    
    [self setColorWithArray:array];
    
}

+ (void)loadWithModelViewUniform:(GLuint)modelViewUniform colorSlot:(GLuint)colorSlot positionSlot:(GLuint)positionSlot {

    glGenBuffers(1, &VertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, VertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &IndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, IndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    ModelViewUniform = modelViewUniform;
    ColorSlot = colorSlot;
    PositionSlot = positionSlot;
    
}

- (void)drawWithModelViewMatrix:(CC3GLMatrix *)modelView {
    
    glBindBuffer(GL_ARRAY_BUFFER, VertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, IndexBuffer);
    
    [modelView translateBy:CC3VectorMake(self.x, self.y, self.z)];
    
    glUniformMatrix4fv(ModelViewUniform, 1, GL_FALSE, modelView.glMatrix);
    
    glUniform4fv(ColorSlot, 1, [self.color mutableBytes]);
    
    glVertexAttribPointer(PositionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(BCVertex), 0);
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices) / sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    
}

@end
