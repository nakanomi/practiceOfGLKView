//
//  main.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/15.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
	/*
	@autoreleasepool {
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
	 */
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal;
	@try {
		retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	} @catch (NSException *exception) {
		NSLog(@"%@", [exception callStackSymbols]);
		@throw exception;
	} @finally {
		[pool release];
	}
	return retVal;
}
