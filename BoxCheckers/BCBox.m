//
//  BCBox.m
//  BoxCheckers
//
//  Created by Andrew Carter on 4/13/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCBox.h"

#import "BCTypes.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "CC3GLMatrix.h"

static GLuint ColorSlot;
static GLuint PositionSlot;
static GLuint ModelViewUniform;

static GLuint VertexBuffer;
static GLuint IndexBuffer;

const static BCVertex Vertices[] = {
    {1, -1, 1},
    {1, 1, 1},
    {-1, 1, 1}, 
    {-1, -1, 1}, 
    {1, -1, -1}, 
    {1, 1, -1},
    {-1, 1, -1},
    {-1, -1, -1}};


const static GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 6, 5,
    4, 7, 6,
    // Left
    2, 7, 3,
    7, 6, 2,
    // Right
    0, 4, 1,
    4, 1, 5,
    // Top
    6, 2, 1, 
    1, 6, 5,
    // Bottom
    0, 3, 7,
    0, 7, 4    
};

@implementation BCBox

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
