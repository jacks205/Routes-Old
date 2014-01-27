//
//  DirectionsTableViewController.m
//  NavigationTracker
//
//  Created by Mark Jackson on 1/14/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import "DirectionsTableViewController.h"

@interface DirectionsTableViewController ()

@end

@implementation DirectionsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO: Create Login and Sign up controllers
    // Temporary sign in
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
//        NSLog(@"%@", currentUser);
        [self sendRefreshQuery];
    } else {
        // show the signup or login screen
//        NSLog(@"Not Current User");
        [PFUser logInWithUsernameInBackground:@"testname" password:@"password"
            block:^(PFUser *user, NSError *error) {
                if (user) {
                    // Do stuff after successful login.
//                    NSLog(@"Logged in");
                    [self sendRefreshQuery];
                } else {
                    // The login failed. Check error to see why.
                    PFUser *user = [PFUser user];
                    user.username = @"testname";
                    user.password = @"password";
                    user.email = @"testname@gmail.com";
//                    NSLog(@"Logged in as %@", user);
                    // other fields can be set just like with PFObject
                    
                    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            // Hooray! Let them use the app now.
//                            NSLog(@"Signed Up!!");
                        } else {
                            NSString *errorString = [error userInfo][@"error"];
                            // Show the errorString somewhere and let the user try again.
                            NSLog(@"%@", errorString);
                        }
                        [self sendRefreshQuery];
                    }];
                }
            }];
        
    }
    
    
    self.directions = [NSMutableArray array];
    
    
    // Setting up Location Manager to keep iPhone's current location updating
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    //Init pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshDirections) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCellOptionsView"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"DirectionsCustomCell"];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshDirections];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.directions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomSwipeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    static NSString *CellIdentifier = @"DirectionsCustomCell";
//    DirectionsCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Fill up DirectionsCustomCell fields
    Direction* direction = [self.directions objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.direction = direction;
    cell.addressLabel.text = [direction address];
    cell.cityStateLabel.text = [NSString stringWithFormat:@"%@, %@", direction.city, direction.state];
    cell.zipcodeLabel.text = [direction zipcode];
    
    NSNumber *distance = [direction distance];
    NSNumber *trafficTime = [direction trafficTime];
//
//    //Calculate user friendly values for distance and time
    NSString *distanceString = [self metersToMiles:distance];
    NSString *travelTimeString = [self secondsToHoursAndMinutes:trafficTime];
//
    cell.distanceLabel.text = distanceString;
    cell.travelTimeLabel.text = travelTimeString;
    
    
    return cell;
}



#pragma mark - Conversion Methods

-(NSString*)metersToMiles: (NSNumber*) meters{
    int intMeters = [meters intValue];
    NSString *formattedString = [NSString stringWithFormat:@"%.2f mi", (float)intMeters * 0.000621371];
    
    return formattedString;
}


-(NSString*)secondsToHoursAndMinutes: (NSNumber*)seconds{
    int intSeconds = [seconds intValue];
    int hours = intSeconds / 3600;
    int minutes = intSeconds % 3600 / 60;
    NSString *formattedString = [NSString stringWithFormat:@"%dh %dm", hours, minutes];
//    NSString *formattedString = [NSString stringWithFormat:@"%dh %dm",(intSeconds / 3600) , (intSeconds % 60)];
//    NSLog(@"%@", formattedString);
    return formattedString;
}

#pragma mark - Add Directions


- (void)secondViewControllerDismissed:(Direction *) direction
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.directions addObject:direction];
    
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"addDirections"]){
        AddDirectionsViewController* vc = (AddDirectionsViewController*)[segue destinationViewController];
        vc.directionTableDelegate = self;
    }
}


- (IBAction)addDirections:(id)sender {
    [self performSegueWithIdentifier:@"addDirections" sender:self];
}

#pragma mark - Parse
-(void)sendRefreshQuery{
    PFQuery *query = [PFQuery queryWithClassName:@"Directions"];
//    NSLog(@"%@", [[PFUser currentUser] objectId]);
    [query whereKey:@"userId" equalTo:[[PFUser currentUser] objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", [error userInfo]);
        }else{
            self.directions = (NSMutableArray *)objects;
            [self refreshDirections];
//            NSLog(@"%@", self.directions);
        }
    }];

}

#pragma mark Refresh
-(void)refreshDirections{
    // Directions exist
    if ([self.directions count] != 0){
        for(Direction* direction in self.directions){
            NSURL *routeUrl = [direction buildUrl: self.currentCoords];
            
//            NSLog(@"BEFORE");
//            
//            NSURLRequest *request = [NSURLRequest requestWithURL:routeUrl];
//            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            op.responseSerializer = [AFJSONResponseSerializer serializer];
//            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"JSON: %@", responseObject);
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//            [[NSOperationQueue mainQueue] addOperation:op];
//            
//            NSLog(@"AFTER");
            // Parsing through json from API
            
            NSData *jsonData = [NSData dataWithContentsOfURL:routeUrl];
            
        //    TODO: Error checking in case JSON Data isn't recieved from API
            NSError *error = nil;
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            
            NSDictionary *responseDictionary = [NSDictionary dictionaryWithDictionary:[dataDictionary objectForKey: RESPONSE_KEY]];
            
            NSArray *routeArray = [responseDictionary objectForKey:ROUTE_KEY];
            NSDictionary *routeDictionary = [routeArray objectAtIndex:0];
            
            
            NSDictionary *summaryDictionary = [NSDictionary dictionaryWithDictionary:[routeDictionary objectForKey:SUMMARY_KEY]];
            
            // Fill Direction fields
            direction.distance = [summaryDictionary objectForKey:DISTANCE_KEY];
            direction.baseTime = [summaryDictionary objectForKey:BASE_TIME_KEY];
            direction.trafficTime =[summaryDictionary objectForKey:TRAFFIC_TIME_KEY];
            direction.travelTime = [summaryDictionary objectForKey:TRAVEL_TIME_KEY];
        }
        
    }
    // End pull to refresh view
    [self.tableView reloadData];
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }

}

#pragma mark - Current Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations lastObject];
    self.currentCoords = [location coordinate];
}

#pragma mark - Custom Swipe Delegate Methods

-(void)cellDidSelectDelete:(CustomSwipeCell *)cell{
    [self.chosenCell.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self.directions removeObjectAtIndex:indexPath.row];
    
    NSLog(@"Deleted Cell");
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //    TODO: Remove from Parse
}


-(void)cellDidSelectMore:(CustomSwipeCell *)cell{
    [self.chosenCell.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    self.chosenCell = cell;
    NSLog(@"More Cell");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Open in Apple Maps" otherButtonTitles:nil, nil];
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}


#pragma mark - Alert View Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}

#pragma mark - Action Sheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"Open in Apple Maps"]){
        CLLocationDegrees latitude = [[self.chosenCell.direction latitude] doubleValue];
        CLLocationDegrees longitude = [[self.chosenCell.direction longitude] doubleValue];
        
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, longitude);
        
        [self launchMapApp:coordinates withName:self.chosenCell.direction.address];
        NSLog(@"Launching Map app");
        [self.chosenCell.scrollView setContentOffset:CGPointMake(0,0) animated:YES];

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

@end
