//
//  Constants.h
//  NavTrac
//
//  Created by Mark Jackson on 1/20/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//Nokia
#define APP_ID @"r1tw0Jfj8hLWis8Ns2tt"
#define APP_CODE @"Pqvm7CtvG23oQJo8wuf1WA"

#define DISTANCE_KEY @"distance"
#define BASE_TIME_KEY @"baseTime"
#define TRAFFIC_TIME_KEY @"trafficTime"
#define TRAVEL_TIME_KEY @"travelTime"

#define SUMMARY_KEY @"summary"
#define RESPONSE_KEY @"response"
#define ROUTE_KEY @"route"

#define URL_1 @"http://route.cit.api.here.com/routing/7.2/calculateroute.json?"
#define URL_2 @"&mode=fastest;car;traffic:enabled&arrival"

@end
