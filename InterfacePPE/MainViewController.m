//
//  MainViewController.m
//  InterfacePPE
//
//  Created by leon on 15/01/2014.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end




@implementation MainViewController

@synthesize result;
@synthesize login;
@synthesize password;
@synthesize message;
@synthesize signInButton;
@synthesize BLEmessage;
@synthesize indicator;
@synthesize indicatorMainView;
@synthesize graphButton;

@synthesize messageInput;
@synthesize messages;

@synthesize startTest;
@synthesize retry;
@synthesize showResult;
@synthesize counter;


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
    
    if([self.title isEqualToString:@"Accueil"])
    {
        NSLog(@"View did load");
        
        login.delegate=self;
        password.delegate=self;
        messageInput.delegate=self;
        
        [[AppDelegate themodel] GetUsers];
        
        if([[AppDelegate themodel] isLogged]==YES)
        {
            [self performSegueWithIdentifier:@"connection" sender:self];
        }
        
        [[[self signInButton] layer] setCornerRadius:[self signInButton].frame.size.width/2];
        
        NSLog(@"View displayed");
    }

    
    
   //for the view StartToTest
    else if([self.title isEqualToString:@"StartToTest"])
    {
         [[AppDelegate themodel] getUserData];
        
        [NSThread detachNewThreadSelector:@selector(connection) toTarget:self withObject:nil];
        
        [[[self startTest] layer] setCornerRadius:[self startTest].frame.size.width/2];
        [[[self counter] layer] setCornerRadius:[self counter].frame.size.width/2];
    }
    
    else if ([self.title isEqualToString:@"displayResult"])
    {
        if([[AppDelegate themodel] bac] >=0.25)
        {
            [[self view] setBackgroundColor:[UIColor colorWithRed:(159.0 / 255.0) green:(4.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0]];
        }
        else
        {
            [[self view] setBackgroundColor:[UIColor colorWithRed:(105.0 / 255.0) green:(190.0 / 255.0) blue:(106.0 / 255.0) alpha:1.0]];
        }
        
        result.text=[NSString stringWithFormat:@"%.2f mg/L",[AppDelegate themodel].bac];
        
        [[[self graphButton] layer] setCornerRadius:[self graphButton].frame.size.width/2];
        [[[self graphButton] layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [[[self graphButton] layer] setBorderWidth:1.0f];        
    }
    
    
    else if ([self.title isEqualToString:@"Messagerie"])
    {
        NSLog(@"view did load");
        
        [[self navigationItem] setTitle:[[AppDelegate themodel] destinataire]];
        
        if([[AppDelegate themodel] bac] >=0.25)
        {
            [[self view] setBackgroundColor:[UIColor colorWithRed:(159.0 / 255.0) green:(4.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0]];
        }
        else
        {
            [[self view] setBackgroundColor:[UIColor colorWithRed:(105.0 / 255.0) green:(190.0 / 255.0) blue:(106.0 / 255.0) alpha:1.0]];
        }
        
        [[AppDelegate themodel] setOnChat:YES];
        
        [NSThread detachNewThreadSelector:@selector(updateMessageRegularly) toTarget:self withObject:nil];
        
        NSLog(@"view displayed");
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

-(void) startAnimating
{
    [indicatorMainView startAnimating];
}

-(void) stopAnimating
{
    [indicatorMainView stopAnimating];
}

- (void)connection
{
    [self performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
    
    while (! [[AppDelegate themodel] connectionFinished])
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
        NSLog(@"waiting server Data");
    }
    
    if([[AppDelegate themodel] manager]==nil)
    {
        [[AppDelegate themodel] setManager:[[CBCentralManager alloc] initWithDelegate:[AppDelegate themodel] queue:nil]];
    }
    
    [[AppDelegate themodel] centralManagerDidUpdateState:[[AppDelegate themodel] manager]];
    
    //attendre la fin du set up de la connexion
    NSDate *deadline=[[NSDate alloc] initWithTimeIntervalSinceNow:5];
    while ((![[AppDelegate themodel] connected]) && ([[NSDate date] compare:deadline]==NSOrderedAscending))
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.5]];
        
    }
    [self performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    
    if([[AppDelegate themodel] connected])
    {
        [startTest setHidden:NO];
        [BLEmessage setText:@""];
    }
    else
    {
        [[[AppDelegate themodel] manager] stopScan];
        [retry setHidden:NO];
        [BLEmessage setText:@"La connexion à l'Ethyloclé a échoué"];
        /*[startTest setHidden:NO];
        [BLEmessage setText:@""];*/
    }
}


- (IBAction)signIn:(id)sender {
    NSLog(@"SignIn Button clicked");
    
    [message setText:@""];
    [indicator startAnimating];
    [[AppDelegate themodel] setLogin:[login text]];
    [[AppDelegate themodel] setPassword:[password text]];
    
    [[AppDelegate themodel] signIn];
    
    while (! [AppDelegate themodel].connectionFinished)
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
        NSLog(@"waiting 1");
    }
    
    [indicator stopAnimating];
    if([[AppDelegate themodel] isLogged]==YES)
    {
        [[AppDelegate themodel] writePlist];
        [self performSegueWithIdentifier:@"connection" sender:self];
    }
    else
    {
        [message setText:@"Pseudo ou mot de passe incorrect" ];
    }
}


- (IBAction)letDownKeyboard:(id)sender{
    [sender resignFirstResponder];
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
        [self performSegueWithIdentifier:@"Deconnexion1" sender:self];
    }
}

- (IBAction)startTest:(id)sender
{
    //Descompte de 10 sec
    [self count];
    
    
    [[[AppDelegate themodel] dataReceivedList] removeAllObjects];
    
    //Prendre des mesures pendant 5 secondes
    NSDate *deadline=[[NSDate alloc] initWithTimeIntervalSinceNow:5];
    while ([[NSDate date] compare:deadline]==NSOrderedAscending)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
        
        [[[AppDelegate themodel] peripheral] readValueForCharacteristic:[[[AppDelegate themodel] characteristic] objectAtIndex:0]];
    }
    
    [showResult setHidden:NO];
    [BLEmessage setText:@"Vous pouvez arrêter de souffler"];
    
    //[[AppDelegate themodel] setBac:0.35];

    //Traitement des données et calcul du taux d'alcoolémie
    unsigned char byte1;
    unsigned char byte2;
    
    float value=0;
    
    @try
    {
        for (NSData *datum in [[AppDelegate themodel] dataReceivedList])
        {
            [datum getBytes:&byte1 range:NSMakeRange(0, 1)];
            [datum getBytes:&byte2 range:NSMakeRange(1, 1)];
            
            NSLog(@"value= %d",[MyModel convertHexToInt:byte1 byte:byte2]);
            
            value = value + [MyModel convertHexToInt:byte1 byte:byte2];
        }
        
        value = value / [[[AppDelegate themodel] dataReceivedList] count];
        
        NSLog(@"average value: %f", value);
        
        if([MyModel convertValueToBAC:value]<=0){
            [[AppDelegate themodel] setBac:0];
        }
        else{
        [[AppDelegate themodel] setBac:[MyModel convertValueToBAC:value]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Erro occured in didUpdateNotificationState: %@", [exception description]);
    }
    @finally
    {
        
    }
}

- (IBAction)showResult:(id)sender {
  
    
    [[AppDelegate themodel] update:[NSString stringWithFormat:@"&login=%@&bac=%f", [[AppDelegate themodel] login],[[AppDelegate themodel] bac] ]];
    
    [[[AppDelegate themodel] manager] cancelPeripheralConnection:[[AppDelegate themodel] peripheral]];
    [[AppDelegate themodel] setManager:NULL];
    [[AppDelegate themodel] setConnected:NO];
    [[AppDelegate themodel] setPeripheral:nil];
    
    //Passer à la vue suivante
    [self performSegueWithIdentifier:@"showResult" sender:self];
   
}

- (IBAction)forgotPassword:(id)sender {
    NSLog(@"forgot password button pressed");
    [message setText:@"Veuillez contacter <contact@ethylocle.com> "];
}
////////////////////////////////////////////////////
- (IBAction)retry:(id)sender
{
    [retry setHidden:YES];
    [self connection];
    
    //[self performSegueWithIdentifier:@"showResult" sender:self];
}
/////////////////////////////////////////////////////
-(void) count
{
    [startTest setHidden:YES];
    [counter setHidden:NO];
    [counter setText:@"10"];
    [BLEmessage setText:@"Préparez-vous à souffler"];
    
    //descompte
    NSDate *deadline=[[NSDate alloc] initWithTimeIntervalSinceNow:10];
    while ([[NSDate date] compare:deadline]==NSOrderedAscending)
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
        
        [counter setText:[NSString stringWithFormat:@"%d",[[counter text] intValue] - 1]];
    }
    
    [BLEmessage setText:@"Soufflez Maintenant !!!"];
    [counter setText:@""];
    
    [counter setHidden:YES];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[AppDelegate themodel] MESSAGES] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [[cell textLabel] setFont:[UIFont fontWithName:@"Euphemia UCAS" size:17.0 ]];
    [[cell textLabel] setTextColor:[UIColor whiteColor]];
    [[cell textLabel] setText:[[[[AppDelegate themodel] MESSAGES] objectAtIndex:indexPath.row] objectAtIndex:3]];
    
    if([[[[[AppDelegate themodel] MESSAGES] objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:[[AppDelegate themodel] login]])
    {
        [cell setBackgroundColor:[UIColor blueColor]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor yellowColor]];
    }
    
    return cell;
}

- (void) updateMessageRegularly
{
    while([[AppDelegate themodel] onChat])
    {
        [self updateMessage];
        
        sleep(5);
    }
}

- (void) updateMessage
{
    [[AppDelegate themodel] receiveMessage];
    
    while(![[AppDelegate themodel] connectionFinished])
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        NSLog(@"waiting 11");
    }
    
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
}




- (IBAction)send:(id)sender {
    [[AppDelegate themodel] setOnChat:NO];
    
    while(![[AppDelegate themodel] connectionFinished])
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        NSLog(@"waiting 12");
    }
    
    [[AppDelegate themodel] setContenu:[self.messageInput text]];
    
    [[AppDelegate themodel] sendMessage];
    
    [self.messageInput setText:@""];
    
    while(![[AppDelegate themodel] connectionFinished])
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        NSLog(@"waiting 13");
    }
    
    if([[AppDelegate themodel] messageSent])
    {
        [[AppDelegate themodel] setOnChat:YES];
        
        [NSThread detachNewThreadSelector:@selector(updateMessageRegularly) toTarget:self withObject:nil];
        
        [[AppDelegate themodel] setMessageSent:NO];
    }
    else
    {
        NSLog(@"Error sending the message");
    }

}

- (void) refreshTableView
{
    [messages reloadData];
    
}

//keyboard will avoid the textfield when it begins to edit
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//keyborad 216
    
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
        