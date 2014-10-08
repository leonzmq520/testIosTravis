//
//  MapLocation.h
//  InterfacePPE
//
//  Created by leon on 22/01/2014.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapLocation : NSObject<MKAnnotation> {
    NSString *name;
    NSString *address;
    CLLocationCoordinate2D coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property NSString *switchType;

- (id)initWithName:(NSString*)locationName address:(NSString*)locationAddress coordinate:(CLLocationCoordinate2D)locationCoordinate;


@end
