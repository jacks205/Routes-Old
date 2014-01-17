//
//  DirectionsTableViewController.h
//  NavigationTracker
//
//  Created by Mark Jackson on 1/14/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Direction.h"
#import "AddDirectionsViewController.h"
#import "DirectionsCustomTableViewCell.h"
#import "SVProgressHUD.h"

@interface DirectionsTableViewController : UITableViewController <SecondDelegate, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

@property(nonatomic,strong) NSMutableArray *directions;
@property(nonatomic)CLLocationCoordinate2D currentCoords;
- (IBAction)addDirections:(id)sender;
@property(nonatomic,strong)UIRefreshControl *refreshControl;

-(NSString*)secondsToHoursAndMinutes: (NSNumber*)seconds;
-(NSString*)metersToMiles:(NSNumber*) meters;

-(void)refreshDirections;
@end
