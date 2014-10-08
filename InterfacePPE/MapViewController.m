//
//  MapViewController.m
//  InterfacePPE
//
//  Created by zhou mao qiao on 13-12-3.
//  Copyright (c) 2013年 leon. All rights reserved.
//

#import "MapViewController.h"



@interface MapViewController (){
    
}


@end


@implementation MapViewController
{
    CLLocationManager *locationManager;
    ///Add two instances variables geocoder and placemark
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    //MKUserLocation *userLocationAnnotation;
    //NSString *responseLocationString;
}

///add setter and getter
@synthesize getAddressLabel;
@synthesize mapView;
@synthesize myCurrentLocation;
@synthesize busSwitchButton;
@synthesize taxiSwitchButton;
@synthesize samSwitchButton;
@synthesize metroSwitchButton;

@synthesize photoStatus;
@synthesize switchButtonStatus;


@synthesize busViewButton;
@synthesize taxiViewButton;
@synthesize samViewButton;
@synthesize metroViewButton;

#define MERCATOR_RADIUS 85445659.44705395




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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




#pragma mark - MapView lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   
    ///map view use to delegate itself
    [self.mapView setDelegate:self];
    
    ///annotation in the map(enable the localisation)
    [self.mapView setShowsUserLocation:YES];
    
    ///Add the following code to instantiate the CLLocationManager object
    locationManager = [[CLLocationManager alloc] init];
    
    ///Initialize the geocoder
    geocoder = [[CLGeocoder alloc] init];
    
   
}



#pragma mark - Get the zoom level
- (int)getZoomLevel:(MKMapView*)mapView {
    
    return 21-round(log2(self.mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * self.mapView.bounds.size.width)));
    
}
- (void)mapView:(MKMapView *)pMapView regionDidChangeAnimated:(BOOL)animated {
   
    NSLog(@"zoom level %d", [self getZoomLevel:self.mapView]);
    
} 






- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    MapLocation *Annotation = annotation;
    
    static NSString *identifier = @"MapLocation";
    
    if ([annotation isKindOfClass:[MapLocation class]]) {
       
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        //MKPinAnnotationView *annotationViewTaxi = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        //MKPinAnnotationView *annotationViewSam = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        //MKPinAnnotationView *annotationViewMetro = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        
        if (annotationView==nil ) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
           // NSLog(@"11111111if");
            
        }else {
            annotationView.annotation = annotation;
           // NSLog(@"222222else");
            }
        
        switch (photoStatus) {
            case 'B':{
                annotationView.image=[UIImage imageNamed:@"annotationBus.png"];
                NSLog(@"annotationBus.png");
            }
            break;
                
            case 'T':{
                annotationView.image=[UIImage imageNamed:@"annotationTaxi.png"];
                NSLog(@"annotationTaxi.png");
                
            }
            break;
                
            case 'S':{
                annotationView.image=[UIImage imageNamed:@"annotationSam.png"];
                NSLog(@"annotationSam.png");
                
                if (switchButtonStatus=='S') {
                    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                    [rightButton setTitle:[Annotation name] forState:UIControlStateNormal];
                    [rightButton addTarget:self action:@selector(chatButtonPressed:) forControlEvents:UIControlEventTouchUpInside]; //display another view
                    annotationView.rightCalloutAccessoryView = rightButton;
                }
                
            }
            break;
                
            case 'M':{
                annotationView.image=[UIImage imageNamed:@"annotationMetro.png"];
                NSLog(@"annotationMetro.png");
            }
            break;
            
        }
        
       return annotationView;
    }
    return nil;
}



-(void)chatButtonPressed:(id)sender
{
    UIButton *rightbutton = sender;
    [[AppDelegate themodel] setDestinataire:[rightbutton titleForState:UIControlStateNormal]];
    [self performSegueWithIdentifier: @"chatWithSam" sender: self];
}






/* it can can simply call the startUpdatingLocation method to the location service. The service will then continuously send your application a stream of location data if it initialized a CLLocationManager object.*/

- (IBAction)getCurrentLocation:(id)sender
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    ///hidden the button
    myCurrentLocation.hidden = YES;
    
}


//switch ValueChanged listenner
- (IBAction)busSwitchButtonValueChanged:(id)sender {
    if (busSwitchButton.on) {
        switchButtonStatus='B';
        NSLog(@"busSwitchButtonTest on");
        
        [self plotPositions];
        
    }else{

        NSLog(@"busSwitchButtonTest off");
        [self removeAnnotationsByGroup:@"bus"];
        busViewButton.hidden=NO;
        busSwitchButton.hidden=YES;
        
    }
}

- (IBAction)taxiSwitchButtonValueChanged:(id)sender {
    if (taxiSwitchButton.on) {
        switchButtonStatus='T';
        NSLog(@"taxiSwitchButtonTest on");

       [self plotPositions];
    }else{
        NSLog(@"taxiSwitchButtonTest off");
        [self removeAnnotationsByGroup:@"taxi"];
        taxiViewButton.hidden=NO;
        taxiSwitchButton.hidden=YES;
        
    }
}

- (IBAction)samSwitchButtonValueChanged:(id)sender {
    if (samSwitchButton.on) {
        switchButtonStatus='S';
        NSLog(@"busSwitchButtonTest on");

        [self plotPositions];
        
    }else{
        NSLog(@"samSwitchButtonTest off");
        [self removeAnnotationsByGroup:@"sam"];
        samViewButton.hidden=NO;
        samSwitchButton.hidden=YES;
        
    }

}

- (IBAction)metroSwitchButtonValueChanged:(id)sender {
    if (metroSwitchButton.on) {
        switchButtonStatus='M';
        NSLog(@"metroSwitchButtonTest on");
        [self plotPositions];
    }else{
        NSLog(@"metroSwitchButtonTest off");
        [self removeAnnotationsByGroup:@"metro"];
        metroViewButton.hidden=NO;
        metroSwitchButton.hidden=YES;
    }

}


// Add new method above switch ValueChanged in the mapview

- (void)plotPositions{
    
    
    switch (switchButtonStatus) {
        case 'B':{
            [[AppDelegate themodel] getBus];
            while (! [AppDelegate themodel].connectionFinished)
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                NSLog(@"waiting 6");
                
            }
            
            for(int i=0;i<((unsigned long)[AppDelegate themodel].BUS.count-1);i++){
                if(i%4==0){
                    
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = [[[AppDelegate themodel].BUS objectAtIndex:i+2] doubleValue];
                    coordinate.longitude =[[[AppDelegate themodel].BUS objectAtIndex:i+3] doubleValue];
                    NSString * address =[[AppDelegate themodel].BUS objectAtIndex:i];
                    NSString * locationDescription=[[AppDelegate themodel].BUS objectAtIndex:i+1];
                    MapLocation *annotationBus = [[MapLocation alloc] initWithName:locationDescription address:address coordinate:coordinate];
                    [annotationBus setSwitchType:@"bus"];
                    [mapView addAnnotation:annotationBus];
                    
                }
            }
            photoStatus='B';
            NSLog(@"viewBusYES");

        }
        break;
        
        case 'T':{
            [[AppDelegate themodel] getTaxi];
            while (! [AppDelegate themodel].connectionFinished)
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                NSLog(@"waiting 6");
                
            }
            
            for(int i=0;i<((unsigned long)[AppDelegate themodel].TAXI.count-1);i++){
                if(i%4==0){
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = [[[AppDelegate themodel].TAXI objectAtIndex:i+1] doubleValue];
                    coordinate.longitude =[[[AppDelegate themodel].TAXI objectAtIndex:i+2] doubleValue];
                    NSString * address =[[AppDelegate themodel].TAXI objectAtIndex:i];
                    NSString * locationDescription=[[AppDelegate themodel].TAXI objectAtIndex:i+3];
                    
                    MapLocation *annotationTaxi = [[MapLocation alloc] initWithName:locationDescription address:address coordinate:coordinate];
                    [annotationTaxi setSwitchType:@"taxi"];
                    [mapView addAnnotation:annotationTaxi];
                }
            }
            photoStatus='T';
            NSLog(@"viewtaxiYES");

            
        }
        break;
            
        case 'S':{
            [[AppDelegate themodel] getSam];
            while (! [AppDelegate themodel].connectionFinished)
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                NSLog(@"waiting 6");
                
            }
            
            for(int i=0;i<((unsigned long)[AppDelegate themodel].SAM.count-1);i++){
                if(i%6==0){
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = [[[AppDelegate themodel].SAM objectAtIndex:i+4] doubleValue];
                    coordinate.longitude =[[[AppDelegate themodel].SAM objectAtIndex:i+5] doubleValue];
                    NSString * address =[[AppDelegate themodel].SAM objectAtIndex:i+3];
                    NSString * locationDescription=[[AppDelegate themodel].SAM objectAtIndex:i];
                    
                    MapLocation *annotationSam = [[MapLocation alloc] initWithName:locationDescription address:address coordinate:coordinate];
                    [annotationSam setSwitchType:@"sam"];
                    [mapView addAnnotation:annotationSam];
                }
                
            }
            
            photoStatus='S';
            NSLog(@"viewSamYES");

        }
        break;
            
        case 'M':{
            [[AppDelegate themodel] getMetro];
            while (! [AppDelegate themodel].connectionFinished)
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                NSLog(@"waiting 6");
                
            }
            
            for(int i=0;i<((unsigned long)[AppDelegate themodel].METRO.count-1);i++){
                if(i%4==0){
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = [[[AppDelegate themodel].METRO objectAtIndex:i+2] doubleValue];
                    coordinate.longitude =[[[AppDelegate themodel].METRO objectAtIndex:i+3] doubleValue];
                    NSString * address =[[AppDelegate themodel].METRO objectAtIndex:i];
                    NSString * locationDescription=[[AppDelegate themodel].METRO objectAtIndex:i+1];
                    
                    MapLocation *annotationMetro = [[MapLocation alloc] initWithName:locationDescription address:address coordinate:coordinate] ;
                    [annotationMetro setSwitchType:@"metro"];
                    [mapView addAnnotation:annotationMetro];
                }
            }
            photoStatus='M';
            NSLog(@"viewMetroYES");
            
        }
        break;
    }
    
}




//delete annotations by group
-(void)removeAnnotationsByGroup:(NSString *)regex
{
    NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] init];
    //NSString *annotationType=NULL;
    NSRegularExpression * Regex=[NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (int i = 0; i < [self.mapView.annotations count]; i++) {
        MKAnnotationView *Annotation = [self.mapView.annotations objectAtIndex:i];
        if([Annotation isKindOfClass:[MapLocation class]] ){
            MapLocation *annotation=(MapLocation*)Annotation;
            //NSLog(@"%@",annotation);
            NSString *annotationType = [annotation switchType];
            //NSLog(@"%@",annotationType);
            //NSLog(@"%@",Regex);
            //NSLog(@"%@",annotationsToRemove);
            if([Regex numberOfMatchesInString:annotationType options:0 range:NSMakeRange(0, [annotationType length])]>0){
                [annotationsToRemove addObject:[self.mapView.annotations objectAtIndex:i]];
                
            }
        }
    }
    
    [self.mapView removeAnnotations:annotationsToRemove];
}




- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


//methode delegate MapView,will call it for localisation and add the user location annotation
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];

    if (!busSwitchButton.on&&!taxiSwitchButton.on&&!samSwitchButton.on&&!metroSwitchButton.on) {
        //zoom to my location actuel
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 800, 800);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
        [self.mapView setRegion:adjustedRegion animated:YES];
        //[self.mapView setCenterCoordinate:loc zoomLevel:14 animated:YES];
        NSLog(@"location******************************");
    }
    
    //self->userLocationAnnotation=userLocation;
    [[AppDelegate themodel] setLatitude:loc.latitude];
    [[AppDelegate themodel] setLongitude:loc.longitude];
    
    [[AppDelegate themodel] update:[NSString stringWithFormat:@"&login=%@&latitude=%f&longitude=%f",[[AppDelegate themodel]  login],[[AppDelegate themodel]  latitude],[[AppDelegate themodel]  longitude]]];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    //if (currentLocation != nil) {}
    
    
    // Stop Location Manager for safe battery power
    [locationManager stopUpdatingLocation];
    
    
    ///Update the “didUpdateToLocation” method to include the code for reverse geocoding:
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            getAddressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}


- (IBAction)busTagButton:(id)sender {
    if ([busViewButton tag]==100) {
        busViewButton.hidden=YES;
        busSwitchButton.hidden=NO;
    }
}

- (IBAction)taxiTagButton:(id)sender {
    if ([taxiViewButton tag]==101) {
        taxiViewButton.hidden=YES;
        taxiSwitchButton.hidden=NO;
    }
}

- (IBAction)samTagButton:(id)sender {
    if ([samViewButton tag]==102) {
        samViewButton.hidden=YES;
        samSwitchButton.hidden=NO;
    }
}

- (IBAction)metroTagButton:(id)sender {
    if ([metroViewButton tag]==103) {
        metroViewButton.hidden=YES;
        metroSwitchButton.hidden=NO;
    }
}


@end
