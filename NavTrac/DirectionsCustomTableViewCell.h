//
//  DirectionsCustomTableViewCell.h
//  NavigationTracker
//
//  Created by Mark Jackson on 1/15/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <MapKit/MapKit.h>
#import "Direction.h"

extern NSString *const DirectionsCustomCellTableViewCellEnclosingTableViewDidBeginScrollingNotification;

@interface DirectionsCustomTableViewCell : UITableViewCell <UIScrollViewDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) Direction *direction;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityStateLabel;
@property (strong, nonatomic) IBOutlet UILabel *zipcodeLabel;

@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *travelTimeLabel;

@property (strong, nonatomic) IBOutlet UIView *scrollViewButtonView;
@property (strong, nonatomic) IBOutlet UIView *scrollViewContentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

-(void)userPressedMoreButton;
-(void)userPressedDeleteButton;


@end
