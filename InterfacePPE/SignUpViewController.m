//
//  SignUpViewController.m
//  InterfacePPE
//
//  Created by leon on 12/02/2014.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import "SignUpViewController.h"


@interface SignUpViewController ()

@end



@implementation SignUpViewController

@synthesize userName;
@synthesize password;
@synthesize weight;
@synthesize city;
@synthesize sex;
@synthesize age;

@synthesize signupInfo;


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
    [password setSecureTextEntry:true];
    
    userName.delegate=self;
    password.delegate=self;
    weight.delegate=self;
    city.delegate=self;
    age.delegate=self;
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




- (IBAction)letDownKeyboard:(id)sender {
    [sender resignFirstResponder];

}

- (IBAction)saveSignUp:(id)sender {
    
    if(![[userName text] isEqualToString:@""]&&![[password text] isEqualToString:@""]&&![[weight text] isEqualToString:@""]){
        NSLog(@"Save SignUp Button clicked");
        [[AppDelegate themodel] setLogin:[userName text]];
        [[AppDelegate themodel] setPassword:[password text]];
        [[AppDelegate themodel] setVille:[city text]];
        [[AppDelegate themodel] setSex:[sex selectedSegmentIndex]];
        [[AppDelegate themodel] setWeight:[[weight text ] doubleValue]];
        [[AppDelegate themodel] setAge:[[age text] intValue]];
        NSLog(@"sent the profile to server");
    
    

        [[AppDelegate themodel] checkLogin];
    
        while (! [AppDelegate themodel].connectionFinished)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            NSLog(@"waiting 7");
        }
    
            if([AppDelegate themodel].loginAvailable)
            {
                [[AppDelegate themodel] signUp];
        
                while (! [AppDelegate themodel].connectionFinished)
                {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    NSLog(@"waiting 7");
                }
        
                if([AppDelegate themodel].signedUp){
                    [self performSegueWithIdentifier: @"signup" sender: self];
                    NSLog(@"please Login,you have created your personnal account");
                }else{
                    NSLog(@"signup failed");
                    [signupInfo setHidden:NO];
                    [signupInfo setText:@"Erreur serveur: réessayez"];
                }
       
            }else{
                NSLog(@"Username already taken");
                [signupInfo setHidden:NO];
                [signupInfo setText:@"Ce pseudo est déjà pris"];
            }
    
    }else{
        NSLog(@"empty info");
        [signupInfo setHidden:NO];
        [signupInfo setText:@"Les champs étoiles sont à remplir obligatoirement"];
    }
    
    
    
}

//keyboard will avoid the textfield when it begains to edit 
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//heigh keyboard 216
    
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



