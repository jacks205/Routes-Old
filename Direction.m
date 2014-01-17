//
//  Direction.m
//  NavigationTracker
//
//  Created by Mark Jackson on 1/14/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import "Direction.h"

@implementation Direction

-(id)initWithAddress:(NSString*)address city:(NSString*)city state:(NSString*)state zipcode:(NSString*)zipcode{
    self = [super init];
    if (self) {
        self.address = address;
        self.city = city;
        self.state = state;
        self.zipcode = zipcode;
    }
    
    return self;
}

+ (id)directionWithAddress:(NSString*)address city:(NSString*)city state:(NSString*)state zipcode:(NSString*)zipcode{
    return [[self alloc] initWithAddress:address city:city state:state zipcode:zipcode];
    
}


-(NSURL *)buildUrl: (CLLocationCoordinate2D) currentCoords{
    
    NSString *formattedString = [NSString stringWithFormat:@"http://route.cit.api.here.com/routing/7.2/calculateroute.json?app_id=%@&app_code=%@&waypoint0=geo!%f,%f&waypoint1=geo!%@,%@&mode=fastest;car;traffic:enabled&arrival", APP_ID, APP_CODE, currentCoords.latitude, currentCoords.longitude, [self latitude], [self longitude]];

    NSURL *routesUrl = [NSURL URLWithString:formattedString];
    
    return routesUrl;
    
}





@end
