//
//  AddDestinationViewController.h
//  NavigationTracker
//
//  Created by Mark Jackson on 1/14/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLGeocoder.h>
#import "SVProgressHUD.h"
#import "Direction.h"
#import "Constants.h"

@protocol SecondDelegate <NSObject>
-(void) secondViewControllerDismissed:(Direction *)direction;
@end

@interface AddDirectionsViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *state;
@property (strong, nonatomic) IBOutlet UITextField *zipcode;

@property (nonatomic, assign) id<SecondDelegate> directionTableDelegate;
@property (strong, nonatomic) IBOutlet UITextField *autocompleteTextField;

-(void)processDirections;
//-(void)sendJsonReq;
-(void)generateCoordinatesFromAddress;
- (IBAction)addDestination:(id)sender;
-(void)cancelModal:(bool)validAddress sender:(id)sender;
- (IBAction)cancel:(id)sender;


#pragma mark - Autocomplete
@property(nonatomic,strong)UITableView *autocompleteTableView;

-(void)createAutocompleteTableView;


@end
