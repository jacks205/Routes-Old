//
//  DirectionsTableViewController.h
//  NavigationTracker
//
//  Created by Mark Jackson on 1/14/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

#import "Constants.h"
#import "Direction.h"
#import "AddDirectionsViewController.h"
#import "SVProgressHUD.h"
#import "CustomSwipeCell.h"


@interface DirectionsTableViewController : UITableViewController <SecondDelegate, CLLocationManagerDelegate, CustomSwipeCellDelegate, UIActionSheetDelegate, UIAlertViewDelegate>{
    CLLocationManager *locationManager;
}

@property(nonatomic,strong) NSMutableArray *directions;
@property(nonatomic)CLLocationCoordinate2D currentCoords;
@property(nonatomic, strong) Direction *selectedDirection;
@property(nonatomic, strong) CustomSwipeCell *chosenCell;

- (IBAction)addDirections:(id)sender;
@property(nonatomic,strong)UIRefreshControl *refreshControl;


-(NSString*)secondsToHoursAndMinutes: (NSNumber*)seconds;
-(NSString*)metersToMiles:(NSNumber*) meters;
-(void)sendRefreshQuery;
-(void)refreshDirections;
@end