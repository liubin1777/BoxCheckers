//
//  BCAppDelegate.m
//  BoxCheckers
//
//  Created by Andrew Carter on 4/13/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "BCAppDelegate.h"

#import "BCGameViewController.h"

@implementation BCAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    BCGameViewController *gameViewController = [[BCGameViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = gameViewController;    
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
