//
//  ProfileViewController.m
//  InterfacePPE
//
//  Created by zhou mao qiao on 14-3-25.
//  Copyright (c) 2014年 leon. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize userName;
@synthesize password;
@synthesize weight;
@synthesize city;
@synthesize sex;
@synthesize age;

@synthesize saveButton;
@synthesize editButton;






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
    
    NSLog(@"Connection 2 finished");
    
    userName.delegate=self;
    password.delegate=self;
    weight.delegate=self;
    city.delegate=self;
    age.delegate=self;
    
    
    
    
    [userName setText:[[AppDelegate themodel] login]];
    [userName setEnabled:false];
    [password setText:[[AppDelegate themodel] password]];
    [password setSecureTextEntry:true];
    [password setEnabled:false];
    [age setText:[NSString stringWithFormat:@"%d",[[AppDelegate themodel] age]]];
    [age setEnabled:false];
    [weight setText:[NSString stringWithFormat:@"%.2f",[[AppDelegate themodel] weight]]];
    [weight setEnabled:false];
    
    [sex setSelectedSegmentIndex:[[AppDelegate themodel] sex]];
    [sex setEnabled:false];
    [city setText:[[AppDelegate themodel] ville]];
    [city setEnabled:false];
    [saveButton setHidden:true];
    
    if([[AppDelegate themodel] bac] >=0.25)
    {
        [[self view] setBackgroundColor:[UIColor colorWithRed:(159.0 / 255.0) green:(4.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0]];
    }
    else
    {
        [[self view] setBackgroundColor:[UIColor colorWithRed:(105.0 / 255.0) green:(190.0 / 255.0) blue:(106.0 / 255.0) alpha:1.0]];
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




- (IBAction)edit:(id)sender {
    NSLog(@"Edit profile Button clicked");
    [password setEnabled:true];
    [age setEnabled:true];
    [weight setEnabled:true];
    [sex setEnabled:true];
    [city setEnabled:true];
    [saveButton setHidden:false];
    [editButton setHidden:true];
}

- (IBAction)save:(id)sender {
    NSLog(@"Save profile Button clicked");

    [[AppDelegate themodel] setPassword:[password text]];
    [[AppDelegate themodel] setVille:[city text]];
    [[AppDelegate themodel] setSex:[sex selectedSegmentIndex]];
    
    
    [[AppDelegate themodel] setWeight:[[weight text ] doubleValue]];
    [[AppDelegate themodel] setAge:[[age text] intValue]];
    NSLog(@"sent the profile to server");
    
    [[AppDelegate themodel] update:[NSString stringWithFormat:@"&login=%@&password=%@&age=%d&weight=%f&sex=%d&ville=%@",[[AppDelegate themodel] login],[[AppDelegate themodel] password],[[AppDelegate themodel] age],[[AppDelegate themodel] weight],[[AppDelegate themodel] sex],[[AppDelegate themodel] ville]]];
    
    while (! [AppDelegate themodel].connectionFinished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        NSLog(@"waiting 7");
    }
    
    if([[AppDelegate themodel] updated]){
        [self performSegueWithIdentifier: @"updateProfile" sender: self];
        [[AppDelegate themodel] setUpdated:false];
        NSLog(@"Updated your profile successful");
    }else{
        NSLog(@"update profile failed");
        
    }
}

- (IBAction)letDownKeyboard:(id)sender {
    [sender resignFirstResponder];

    
}

//keyboard will avoid the textfield when it begains to edit 
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//Height of the keyboard is 216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //move Y to offset place to display the keyboard
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}



//reset the original view after finish the edit textfield
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}



@end
