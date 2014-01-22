//
//  DirectionsCustomTableViewCell.m
//  NavigationTracker
//
//  Created by Mark Jackson on 1/15/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import "DirectionsCustomTableViewCell.h"

@implementation DirectionsCustomTableViewCell

NSString *const DirectionsCustomCellTableViewCellEnclosingTableViewDidBeginScrollingNotification = @"DirectionsCustomCellTableViewCellEnclosingTableViewDidBeginScrollingNotification";

#define kCatchWidth 180


-(void)awakeFromNib{
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
    moreButton.frame = CGRectMake(0, 0, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
    [moreButton setTitle:@"More" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(userPressedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewButtonView addSubview:moreButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
    deleteButton.frame = CGRectMake(kCatchWidth / 2.0f, 0, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewButtonView addSubview:deleteButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enclosingTableViewDidScroll) name:DirectionsCustomCellTableViewCellEnclosingTableViewDidBeginScrollingNotification object:nil];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x < 0) {
        scrollView.contentOffset = CGPointZero;
    }
    
    self.scrollViewButtonView.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - kCatchWidth), 0.0f, kCatchWidth, CGRectGetHeight(self.bounds));

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView.contentOffset.x > kCatchWidth) {
        targetContentOffset->x = kCatchWidth;
    }
    else {
        *targetContentOffset = CGPointZero;
        
        // Need to call this subsequently to remove flickering.
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointZero animated:YES];
        });
    }
}

-(void)enclosingTableViewDidScroll {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)openMap:(id)sender {
    // Alert view to open the iPhone's map app
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Leaving App!" message:@"Do you want to start directions for this destination?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
    
    [alertView show];
    
    
}

#pragma mark - UIAlertView Method

// Alert View delegate method to open Map app
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        CLLocationDegrees latitude = [[self.direction latitude] doubleValue];
        CLLocationDegrees longitude = [[self.direction longitude] doubleValue];
        
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, longitude);
        
        [self launchMapApp:coordinates withName:self.direction.address];
        NSLog(@"Launching Map app");
    }
    else if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"Cancelling");
    }
    
}

#pragma mark - Launching Map App

-(void)launchMapApp: (CLLocationCoordinate2D) coordinates withName:(NSString*) name{
    // Launching map app with location and name of destination
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: coordinates addressDictionary: nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = name;
    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems: items launchOptions: options];
}

#pragma mark - Scroll View Buttons

-(void)userPressedMoreButton{
    NSLog(@"More Button");
}

-(void)userPressedDeleteButton{
    NSLog(@"Delete Button");
}

@end
