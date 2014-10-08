//
//  MapLocation.m
//  InterfacePPE
//
//  Created by leon on 22/01/2014.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation
@synthesize name;
@synthesize address;
@synthesize coordinate;
@synthesize switchType;

- (id)initWithName:(NSString*)locationName address:(NSString*)locationAddress coordinate:(CLLocationCoordinate2D)locationCoordinate {
    if ((self = [super init])) {
        name = [locationName copy];
        address = [locationAddress copy];
        coordinate = locationCoordinate;
        
    }
    return self;
}

- (NSString *)title {
    if ([name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return name;
}

- (NSString *)subtitle {
    return address;
}




@end
