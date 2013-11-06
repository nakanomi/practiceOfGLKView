//
//  ShaderBase.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/15.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "ShaderBase.h"

@interface ShaderBase()
{
}
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

- (BOOL)setupAttributes;
- (BOOL)setupUniforms;
- (void)initUniforms;

@end

@implementation ShaderBase
@synthesize programId = _programId;
@synthesize textureCount = _textureCount;

- (id)init
{
	self = [super init];
	if (self != nil) {
		_programId = 0;
		_textureCount = 1;
		[self initUniforms];
	}
	return self;
}

- (void)dealloc
{
	if (self.programId != 0) {
		glDeleteProgram(_programId);
		_programId = 0;
	}
	NSLog(@"%s", __PRETTY_FUNCTION__);
	[super dealloc];
}


- (BOOL)loadShaderWithVsh: (NSString*)vshFile withFsh:(NSString*)fshFile
{
	BOOL result = NO;
	@try {
		assert(_programId == 0);
		GLuint vertShader, fragShader;
		NSString *vertShaderPathname, *fragShaderPathname;
		
		// Create shader program.
		_programId = glCreateProgram();
		
		// Create and compile vertex shader.
		vertShaderPathname = [[NSBundle mainBundle] pathForResource:vshFile ofType:@"vertsh"];
		if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
			NSLog(@"Failed to compile vertex shader:%@", vshFile);
			return NO;
		}
		
		// Create and compile fragment shader.
		fragShaderPathname = [[NSBundle mainBundle] pathForResource:fshFile ofType:@"fragsh"];
		if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
			NSLog(@"Failed to compile fragment shader:%@", fshFile);
			return NO;
		}
		
		// Attach vertex shader to program.
		glAttachShader(_programId, vertShader);
		
		// Attach fragment shader to program.
		glAttachShader(_programId, fragShader);
		// Bind attribute locations.
		// This needs to be done prior to linking.
		// アトリビュート変数のロケーション設定。実装クラスのものが呼ばれる。
		[self setupAttributes];
		
		// Link program.
		if (![self linkProgram:_programId]) {
			NSLog(@"Failed to link program: %d", _programId);
			
			if (vertShader) {
				glDeleteShader(vertShader);
				vertShader = 0;
			}
			if (fragShader) {
				glDeleteShader(fragShader);
				fragShader = 0;
			}
			if (_programId) {
				glDeleteProgram(_programId);
				_programId = 0;
			}
			
			return NO;
		}
		
		// Get uniform locations.
		// ユニフォーム変数のロケーション設定。実装クラスのものが呼ばれる。
		[self setupUniforms];
		
		// Release vertex and fragment shaders.
		if (vertShader) {
			glDetachShader(_programId, vertShader);
			glDeleteShader(vertShader);
		}
		if (fragShader) {
			glDetachShader(_programId, fragShader);
			glDeleteShader(fragShader);
		}
		NSLog(@"%s complete", __PRETTY_FUNCTION__);
		result = YES;
	}
	@catch (NSException *exception) {
		
	}

	return result;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
	GLchar* buf = nil;
	
	@try {
		GLint status;
		const GLchar *source;
		
		source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
		if (!source) {
			NSLog(@"Failed to load  shader");
			return NO;
		}
		
		*shader = glCreateShader(type);
		
		{
			unsigned int len = strlen(source);
			len += 128;
			unsigned int size = len * sizeof(GLchar);
			buf = (GLchar*)malloc(size);
			sprintf(buf, "precision mediump float;\n %s", source);
		}
		glShaderSource(*shader, 1, (const GLchar**)&buf, NULL);
		glCompileShader(*shader);
		
#if defined(DEBUG)
		GLint logLength;
		glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
		if (logLength > 0) {
			GLchar *log = (GLchar *)malloc(logLength);
			glGetShaderInfoLog(*shader, logLength, &logLength, log);
			NSLog(@"Shader compile log:\n%s", log);
			free(log);
		}
#endif
		
		glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
		if (status == 0) {
			glDeleteShader(*shader);
			return NO;
		}
	}
	@catch (NSException *exception) {
		NSLog(@"%@", exception);
		assert(false);
	}
	@finally {
		if (buf != nil) {
			free(buf);
		}
	}
    
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}
#pragma mark -publicな仮想関数のようなもの
- (GLint) getUniformIndex: (int) index
{
	int result = -1;
	assert(NO);
	return result;
}



#pragma mark -protectedな仮想関数のようなもの
- (BOOL)setupAttributes
{
	assert(NO);
	return NO;
}
- (BOOL)setupUniforms
{
	NSLog(@"%s このシェーダーはユニフォーム変数を持ちません", __PRETTY_FUNCTION__);
	return NO;
}
- (void)initUniforms
{
	NSLog(@"%s このシェーダーはユニフォーム変数を持ちません", __PRETTY_FUNCTION__);
}
- (void)setUniformsOnRenderWithParam:(float)param
{
	
}


@end
