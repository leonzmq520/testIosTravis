//
//  SimpleTableAppDelegate.h
//  InterfacePPE
//
//  Created by leon on 27/11/2013.
//  Copyright (c) 2013 leon. All rights reserved.
//

#import <UIKit/UIKit.h>
///add the #import statement
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapLocation.h"
#import "MyModel.h"
#import "KSViewController.h"
#import "MainMenuViewController.h"



static MyModel *themodel;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;




+ (MyModel*)themodel;


+ (void) setTheModel:(MyModel*)Themodel;


@end
