//
//  DirectionsCustomTableViewCell.h
//  NavigationTracker
//
//  Created by Mark Jackson on 1/15/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionsCustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityStateLabel;
@property (strong, nonatomic) IBOutlet UILabel *zipcodeLabel;

@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *travelTimeLabel;

@end
