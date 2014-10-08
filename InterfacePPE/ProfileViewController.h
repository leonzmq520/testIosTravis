//
//  ProfileViewController.h
//  InterfacePPE
//
//  Created by zhou mao qiao on 14-3-25.
//  Copyright (c) 2014年 leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ProfileViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sex;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

- (IBAction)edit:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)letDownKeyboard:(id)sender;




@end


