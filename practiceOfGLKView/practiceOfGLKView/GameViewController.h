//
//  GameViewController2.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/19/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKView.h>

enum GAMEVIEW_SHADER {
	NONE = 0,
	OVERLAY,
	DODGE,
	BURN,
	ADD,
	BLUR_TEST_5DOT,
	OFF_GRADATION,
	STAR_LIGHT_SCOPE,
	DISTORTION_1_1,
	DISTORTION_1_2,
	
	DISTORTION_2_1,
	DISTORTION_2_2,
	};
@interface GameViewController : UIViewController<GLKViewDelegate>

@property (assign) GAMEVIEW_SHADER setupShader;
@end
