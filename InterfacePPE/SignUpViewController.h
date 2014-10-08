//
//  SignUpViewController.h
//  InterfacePPE
//
//  Created by leon on 12/02/2014.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UITextField *age;

@property (weak, nonatomic) IBOutlet UILabel *signupInfo;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sex;


- (IBAction)saveSignUp:(id)sender;
- (IBAction)letDownKeyboard:(id)sender;

@end
