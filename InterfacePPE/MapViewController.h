//
//  MapViewController.h
//  InterfacePPE
//
//  Created by zhou mao qiao on 13-12-3.
//  Copyright (c) 2013年 leon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"




///implement the “CLLocationManagerDelegate”
@interface MapViewController : UIViewController <MKMapViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate>


///map view
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
///display adress
@property (weak, nonatomic) IBOutlet UILabel *getAddressLabel;

@property (weak, nonatomic) IBOutlet UIButton *myCurrentLocation;



///action of get current adress
- (IBAction)getCurrentLocation:(id)sender;

- (IBAction)busSwitchButtonValueChanged:(id)sender;

- (IBAction)taxiSwitchButtonValueChanged:(id)sender;

- (IBAction)samSwitchButtonValueChanged:(id)sender;

- (IBAction)metroSwitchButtonValueChanged:(id)sender;

///switch buttons 

@property (weak, nonatomic) IBOutlet UISwitch *busSwitchButton;

@property (weak, nonatomic) IBOutlet UISwitch *taxiSwitchButton;

@property (weak, nonatomic) IBOutlet UISwitch *samSwitchButton;

@property (weak, nonatomic) IBOutlet UISwitch *metroSwitchButton;

//2 status controller
@property char  photoStatus;
@property char  switchButtonStatus;

//button view
@property (weak, nonatomic) IBOutlet UIButton *busViewButton;

@property (weak, nonatomic) IBOutlet UIButton *taxiViewButton;

@property (weak, nonatomic) IBOutlet UIButton *samViewButton;
@property (weak, nonatomic) IBOutlet UIButton *metroViewButton;

//action

- (IBAction)busTagButton:(id)sender;

- (IBAction)taxiTagButton:(id)sender;

- (IBAction)samTagButton:(id)sender;
- (IBAction)metroTagButton:(id)sender;

@end
