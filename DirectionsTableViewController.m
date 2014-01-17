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
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        NSLog(@"%@", currentUser);
    } else {
        // show the signup or login screen
        NSLog(@"Not Current User");
        [PFUser logInWithUsernameInBackground:@"ianjcksn" password:@"password"
            block:^(PFUser *user, NSError *error) {
                if (user) {
                    // Do stuff after successful login.
                    NSLog(@"Not Logged in");
                } else {
                    // The login failed. Check error to see why.
                    PFUser *user = [PFUser user];
                    user.username = @"ianjcksn";
                    user.password = @"password";
                    user.email = @"ianjcksn93@gmail.com";
                    
                    // other fields can be set just like with PFObject
                    
                    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            // Hooray! Let them use the app now.
                            NSLog(@"Signed Up!!");
                        } else {
                            NSString *errorString = [error userInfo][@"error"];
                            // Show the errorString somewhere and let the user try again.
                            NSLog(@"%@", errorString);
                        }
                    }];
                }
            }];
        
    }
    
    //TODO: Create Login and Sign up controllers

    self.directions = [NSMutableArray array];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
//    self.currentCoords = CLLocationCoordinate2DMake(33.876349, -117.797041);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshDirections) forControlEvents:UIControlEventValueChanged];
    
    PFObject *object = [PFObject objectWithClassName:@"Direction"];
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
    static NSString *CellIdentifier = @"DirectionsCustomCell";
    DirectionsCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Direction* direction = [self.directions objectAtIndex:indexPath.row];
    cell.addressLabel.text = [direction address];
    cell.cityStateLabel.text = [NSString stringWithFormat:@"%@, %@", direction.city, direction.state];
    cell.zipcodeLabel.text = [direction zipcode];
    
    NSNumber *distance = [direction distance];
    NSNumber *trafficTime = [direction trafficTime];
    
    NSString *distanceString = [self metersToMiles:distance];
    NSString *travelTimeString = [self secondsToHoursAndMinutes:trafficTime];
    
    cell.distanceLabel.text = distanceString;
    cell.travelTimeLabel.text = travelTimeString;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DirectionsCustomCell";
    DirectionsCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    self.selectedDirection = [self.directions objectAtIndex:indexPath.row];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Leaving App!" message:@"Do you want to start directions for this destination?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
    
    [alertView show];
}

#pragma mark - Conversion Methods

-(NSString*)metersToMiles: (NSNumber*) meters{
    int intMeters = [meters intValue];
    NSString *formattedString = [NSString stringWithFormat:@"%.2f mi", (float)intMeters * 0.000621371];
    
    return formattedString;
}


-(NSString*)secondsToHoursAndMinutes: (NSNumber*)seconds{
    int intSeconds = [seconds intValue];
    NSString *formattedString = [NSString stringWithFormat:@"%dh %dm",(intSeconds / 3600) , (intSeconds % 60)];
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

#pragma mark Refresh
-(void)refreshDirections{
    if ([self.directions count] != 0){
        for(Direction* direction in self.directions){
            NSURL *routeUrl = [direction buildUrl: self.currentCoords];
            NSLog(@"%@", routeUrl);
            NSData *jsonData = [NSData dataWithContentsOfURL:routeUrl];
            
        //    TODO: Error checking in case JSON Data isn't recieved from API
            NSError *error = nil;
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            
            NSDictionary *responseDictionary = [NSDictionary dictionaryWithDictionary:[dataDictionary objectForKey: RESPONSE_KEY]];
            
            NSArray *routeArray = [responseDictionary objectForKey:ROUTE_KEY];
            NSDictionary *routeDictionary = [routeArray objectAtIndex:0];
            
            
            NSDictionary *summaryDictionary = [NSDictionary dictionaryWithDictionary:[routeDictionary objectForKey:SUMMARY_KEY]];
            
            NSLog(@"%@", summaryDictionary);
            
            direction.distance = [summaryDictionary objectForKey:DISTANCE_KEY];
            direction.baseTime = [summaryDictionary objectForKey:BASE_TIME_KEY];
            direction.trafficTime =[summaryDictionary objectForKey:TRAFFIC_TIME_KEY];
            direction.travelTime = [summaryDictionary objectForKey:TRAVEL_TIME_KEY];
        }
        
    }
    [self.tableView reloadData];
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }

}

#pragma mark - Launching Map App

-(void)launchMapApp: (CLLocationCoordinate2D) coordinates withName:(NSString*) name{
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: coordinates addressDictionary: nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = name;
    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems: items launchOptions: options];
}

#pragma mark - Current Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations lastObject];
    self.currentCoords = [location coordinate];
//    NSLog(@"%f", self.currentCoords.latitude);
//    self.currentCoords = CLLocationCoordinate2DMake(33.876349, -117.797041);
}


#pragma mark - UIAlertView Method
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        CLLocationDegrees latitude = [self.selectedDirection.latitude doubleValue];
        CLLocationDegrees longitude = [self.selectedDirection.longitude doubleValue];
        
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, longitude);
        
        [self launchMapApp:coordinates withName:self.selectedDirection.address];
        NSLog(@"Launching Map app");
    }
    else if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"Cancelling");
    }

}
@end
