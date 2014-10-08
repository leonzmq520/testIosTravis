//
//  MainMenuViewController.m
//  InterfacePPE
//
//  Created by leon on 17/02/2014.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import "MainMenuViewController.h"
//#import "MainViewController.h"

@interface MainMenuViewController ()

@end





@implementation MainMenuViewController


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
	// Do any additional setup after loading the view.
    if([[AppDelegate themodel] bac] >=0.25)
    {
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:(159.0 / 255.0) green:(4.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
        
        
       /* [[[[self tabBar] items] objectAtIndex:0] setSelectedImageTintColor:[UIColor colorWithRed:(159.0 / 255.0) green:(4.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0]];
        [[[[self tabBar] items] objectAtIndex:1] setSelectedImageTintColor:[UIColor colorWithRed:(159.0 / 255.0) green:(4.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0]];
        [[[[self tabBar] items] objectAtIndex:2] setSelectedImageTintColor:[UIColor colorWithRed:(159.0 / 255.0) green:(4.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0]];
        [[[[self tabBar] items] objectAtIndex:3] setSelectedImageTintColor:[UIColor colorWithRed:(159.0 / 255.0) green:(4.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0]];*/
    }
    else
    {
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:(105.0 / 255.0) green:(190.0 / 255.0) blue:(106.0 / 255.0) alpha:1.0], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
        
        
        /*UIImage* icon1 = [UIImage imageNamed:@"bubble1.png"];
        UITabBarItem *updatesItem = [[UITabBarItem alloc] initWithTitle:@"Messagerie" image:icon1 tag:0];
        
        [updatesItem setFinishedSelectedImage:icon1 withFinishedUnselectedImage:icon1];
        
        NSMutableArray *items = [NSMutableArray arrayWithArray:[[self tabBar] items]];
        [items setObject:updatesItem atIndexedSubscript:2];
        [[(UITabBarController*)self.navigationController.topViewController tabBar] setItems:items];*/
        
        //[[[[self tabBar] items] objectAtIndex:0] setSelectedImageTintColor:[UIColor colorWithRed:(105.0 / 255.0) green:(190.0 / 255.0) blue:(106.0 / 255.0) alpha:1.0]];
        //[[[[self tabBar] items] objectAtIndex:1] setSelectedImageTintColor:[UIColor colorWithRed:(105.0 / 255.0) green:(190.0 / 255.0) blue:(106.0 / 255.0) alpha:1.0]];
        //[[[[self tabBar] items] objectAtIndex:2] setSelectedImageTintColor:[UIColor colorWithRed:(105.0 / 255.0) green:(190.0 / 255.0) blue:(106.0 / 255.0) alpha:1.0]];
        //[[[[self tabBar] items] objectAtIndex:3] setSelectedImageTintColor:[UIColor colorWithRed:(105.0 / 255.0) green:(190.0 / 255.0) blue:(106.0 / 255.0) alpha:1.0]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self.view window] == nil)
    {
        self.view = nil;
    }

}

- (IBAction)signOut:(id)sender
{
    NSLog(@"sign out");
    
    if (![[NSFileManager defaultManager] removeItemAtPath:[[AppDelegate themodel] fichier]error:NULL])
    {
        NSLog(@"failed to remove item at path");
    }
    else
    {
        [self performSegueWithIdentifier:@"Deconnexion2" sender:self];
    }
}


@end
