//
//  conversationController.m
//  InterfacePPE
//
//  Created by leon on 19/03/2014.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import "conversationController.h"

@interface conversationController ()

@end

@implementation conversationController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[AppDelegate themodel] bac] >=0.25)
    {
        [[self view] setBackgroundColor:[UIColor colorWithRed:(159.0 / 255.0) green:(4.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0]];
    }
    else
    {
        [[self view] setBackgroundColor:[UIColor colorWithRed:(105.0 / 255.0) green:(190.0 / 255.0) blue:(106.0 / 255.0) alpha:1.0]];
    }
    
    [[AppDelegate themodel] conversationMessage];
    
    while(![[AppDelegate themodel] connectionFinished])
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[AppDelegate themodel] CONVERSATION] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if([[AppDelegate themodel] bac] >=0.25)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:(159.0 / 255.0) green:(4.0 / 255.0) blue:(48.0 / 255.0) alpha:1.0]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor colorWithRed:(105.0 / 255.0) green:(190.0 / 255.0) blue:(106.0 / 255.0) alpha:1.0]];
    }
    
    [[cell textLabel] setFont:[UIFont fontWithName:@"Euphemia UCAS" size:17.0 ]];
    [[cell textLabel] setTextColor:[UIColor whiteColor]];
    [[cell textLabel] setText:[[[AppDelegate themodel] CONVERSATION] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text] isEqualToString:@""])
    {
        [[AppDelegate themodel] setDestinataire:[[[AppDelegate themodel] CONVERSATION] objectAtIndex:indexPath.row]];
        [self performSegueWithIdentifier:@"message" sender:self];
    }
    
    [tableView reloadData];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
