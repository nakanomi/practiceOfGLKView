//
//  GLKGameViewController.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/11/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "GLKGameViewController.h"

@interface GLKGameViewController ()
@property (strong, nonatomic) EAGLContext *context;

@end

@implementation GLKGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [_context release];
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
	view.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
