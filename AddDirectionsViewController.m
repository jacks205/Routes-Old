//
//  AddDestinationViewController.m
//  NavigationTracker
//
//  Created by Mark Jackson on 1/14/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//

#import "AddDirectionsViewController.h"

@interface AddDirectionsViewController ()


@property(nonatomic, strong)Direction *direction;

@end

@implementation AddDirectionsViewController
@synthesize directionTableDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

-(void)processDirections{
    // Start progress overlay
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    // Get trimmed text values from form
    NSString* destAddress = [[self.address text]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* destCity = [[self.city text]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* destState = [[self.state text]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* destZipcode = [[self.zipcode text]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Check if fields are empty
    if([destAddress length] == 0 || [destCity length] == 0  || [destState length] == 0 || [destZipcode length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter all fields." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        
        self.direction = [Direction objectWithClassName:[Direction parseClassName]];
        self.direction = [Direction directionWithAddress:destAddress city:destCity state:destState zipcode:destZipcode direction:self.direction user: [PFUser currentUser]];
        [self generateCoordinatesFromAddress];
    }
}

// iOS Geocoder to get coordinates for an address
-(void)generateCoordinatesFromAddress{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // Geocoder Formatted string
    NSString *formattedString = [NSString stringWithFormat:@"%@, %@, %@, %@", self.direction.address, self.direction.city, self.direction.state, self.direction.zipcode];
    [geocoder geocodeAddressString:formattedString completionHandler:^(NSArray* placemarks, NSError* error){
        // Error with Geocoder getting the address
        if(error){
            [SVProgressHUD dismiss];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There was an error generating the route. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            [self cancelModal:NO sender:self];
        }else{
            for (CLPlacemark* aPlacemark in placemarks)
            {
                // Process the placemark.
                self.direction.latitude = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
                self.direction.longitude = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
                //                NSLog(@"%@, %@", self.latitude, self.longitude);
                
            }
            // Save direction object in Parse
            [self.direction saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error){
                    // If there is an error, then save later
                    [self.direction saveEventually];
                }
            }];
            [self cancelModal:YES sender:self];
        }
    }];
}


- (IBAction)addDestination:(id)sender {
    [self processDirections];
    
}

-(void)cancelModal:(bool)validAddress sender:(id)sender{
    if(validAddress){
        if([self.directionTableDelegate respondsToSelector:@selector(secondViewControllerDismissed:)])
        {
            [self.directionTableDelegate secondViewControllerDismissed:self.direction];
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
