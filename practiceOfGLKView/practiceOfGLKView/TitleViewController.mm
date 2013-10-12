//
//  TitleViewController.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/16.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "TitleViewController.h"
//#import "GameViewController.h"
#import "GameViewController.h"
//#import "GLKGameViewController.h"

@interface TitleViewController ()

@end

@implementation TitleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPushButton:(id)sender
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	if ([sender isEqual:self.btnGame]) {
		 //GLKGameViewController *controller = [[GLKGameViewController alloc] initWithNibName:@"GLKGameViewController" bundle:nil];
		GameViewController *controller = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}

- (void)dealloc {
	[_btnGame release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setBtnGame:nil];
	[super viewDidUnload];
}
@end
