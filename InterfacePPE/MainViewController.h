//
//  MainViewController.h
//  InterfacePPE
//
//  Created by leon on 15/01/2014.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface MainViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UILabel *result;

@property (weak, nonatomic) IBOutlet UITextField *login;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;


@property (weak, nonatomic) IBOutlet UILabel *BLEmessage;

@property (weak, nonatomic) IBOutlet UILabel *counter;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorMainView;

@property (weak, nonatomic) IBOutlet UIButton *startTest;
@property (weak, nonatomic) IBOutlet UIButton *retry;
@property (weak, nonatomic) IBOutlet UIButton *showResult;
@property (weak, nonatomic) IBOutlet UIButton *graphButton;

@property (weak, nonatomic) IBOutlet UITableView *messages;
@property (weak, nonatomic) IBOutlet UITextField *messageInput;


- (IBAction)signIn:(id)sender;
- (IBAction)letDownKeyboard:(id)sender;

- (IBAction)signOut:(id)sender;

- (IBAction)startTest:(id)sender;

- (IBAction)showResult:(id)sender;

- (IBAction)forgotPassword:(id)sender;

- (IBAction)retry:(id)sender;


- (void)connection;


@end
