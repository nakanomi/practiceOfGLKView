//
//  TextureBase.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/18/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//
#import <GLKit/GLKit.h>
#import "TextureBase.h"

@interface TextureBase()
{
	GLuint _textureId;
	CGSize _textureSize;
	NSString* _nameOfTexture;
}
@end

@implementation TextureBase
@synthesize textureId = _textureId;
@synthesize textureSize = _textureSize;
@synthesize nameOfTexture = _nameOfTexture;


- (id)init
{
	self = [super init];
	if (self != nil) {
		_textureId = 0;
		_textureSize = CGSizeMake(0, 0);
		_nameOfTexture = nil;
	}
	return self;
}

- (void)dealloc
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	if (self.textureId > 0) {
		glDeleteTextures(1, &_textureId);
	}
	if (self.nameOfTexture != nil) {
		[_nameOfTexture release];
	}
	[super dealloc];
}

- (BOOL)loadTextureFromName:(NSString*)nameOfTexture ofType:(NSString*)nameOfType
{
	BOOL result = NO;
	@try {
		NSLog(@"GL Error = %u", glGetError());
		NSString* filePath = [[NSBundle mainBundle] pathForResource:nameOfTexture ofType:nameOfType];
		NSError* error;
		GLKTextureInfo *texInfo0 = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:&error];
		if (texInfo0 != nil) {
			NSLog(@"Texture loaded successfully. id = %d file = %@ size = (%d x %d)",
				  
				  texInfo0.name, nameOfTexture, texInfo0.width, texInfo0.height);
			_textureId = texInfo0.name;
			_textureSize.width = texInfo0.width;
			_textureSize.height = texInfo0.height;
			_nameOfTexture = [[NSString alloc] initWithString:nameOfTexture];
			result = YES;
		}
		else {
			NSLog(@"%@", error);
			@try {
				@throw [[NSException alloc] initWithName:@"test" reason:@"test" userInfo:nil];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.callStackSymbols);
			}
		}
		
	}
	@catch (NSException *exception) {
		assert(0);
	}
	return result;
}


@end
