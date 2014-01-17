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
#import "Constants.h"


@interface Direction : NSObject


@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *zipcode;

@property(nonatomic) NSNumber *distance;
@property(nonatomic) NSNumber *baseTime;
@property(nonatomic) NSNumber *trafficTime;
@property(nonatomic) NSNumber *travelTime;

@property(nonatomic, strong)NSString *latitude;
@property(nonatomic, strong)NSString *longitude;

-(id)initWithAddress:(NSString*)destAddress city:(NSString*)city state:(NSString*)state zipcode:(NSString*)zipcode;

+ (id)directionWithAddress:(NSString*)address city:(NSString*)city state:(NSString*)state zipcode:(NSString*) zipcode;

-(NSURL*)buildUrl: (CLLocationCoordinate2D) currentCoords;
@end
