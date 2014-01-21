//
//  Direction.h
//  NavigationTracker
//
//  Created by Mark Jackson on 1/14/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import <Parse/Parse.h>
#import "Constants.h"


@interface Direction : PFObject<PFSubclassing>

+(NSString *)parseClassName;

@property(retain) NSString *address;
@property(retain) NSString *city;
@property(retain) NSString *state;
@property(retain) NSString *zipcode;

@property(retain) NSNumber *distance;
@property(retain) NSNumber *baseTime;
@property(retain) NSNumber *trafficTime;
@property(retain) NSNumber *travelTime;

@property(retain)NSString *latitude;
@property(retain)NSString *longitude;

@property(retain)NSString *userId;
@property(retain)NSString *username;

-(id)initWithAddress:(NSString*)destAddress city:(NSString*)city state:(NSString*)state zipcode:(NSString*)zipcode;

+ (id)directionWithAddress:(NSString*)address city:(NSString*)city state:(NSString*)state zipcode:(NSString*)zipcode direction:(Direction *) direction user:(PFUser *) user;

// Build url each time to go with users current location
-(NSURL*)buildUrl: (CLLocationCoordinate2D) currentCoords;
@end
