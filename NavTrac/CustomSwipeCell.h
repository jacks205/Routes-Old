//
//  CustomSwipeCell.h
//  NavTrac
//
//  Created by Mark Jackson on 1/21/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <MapKit/MapKit.h>
#import "Direction.h"

@class CustomSwipeCell;

@protocol CustomSwipeCellDelegate <NSObject>

-(void)cellDidSelectDelete:(CustomSwipeCell *)cell;
-(void)cellDidSelectMore:(CustomSwipeCell *)cell;

@end

extern NSString *const CustomSwipeCellEnclosingTableViewDidBeginScrollingNotification;

@interface CustomSwipeCell : UITableViewCell

@property (nonatomic, weak) id<CustomSwipeCellDelegate> delegate;

@property(strong, nonatomic) Direction *direction;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIView *scrollViewContentView;      //The cell content (like the label) goes in this view.
@property (nonatomic, weak) UIView *scrollViewButtonView;       //Contains our two buttons

@property (nonatomic, weak) UILabel *addressLabel;
@property (weak, nonatomic) UILabel *cityStateLabel;
@property (weak, nonatomic) UILabel *zipcodeLabel;

@property (weak, nonatomic) UILabel *distanceLabel;
@property (weak, nonatomic) UILabel *travelTimeLabel;


@end

