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
@property(nonatomic,strong) NSMutableArray *testAutoCompleteDataSource;
@property(nonatomic,strong) NSMutableArray *testAutoChoices;

@end

@implementation AddDirectionsViewController
@synthesize directionTableDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    _testAutoCompleteDataSource = [NSMutableArray array];
    _testAutoChoices =[NSMutableArray array];
    for(int i = 0; i < 5 ; ++i){
        [_testAutoCompleteDataSource addObject:@"testAutocomplete"];
    }
    
    self.autocompleteTextField.delegate = self;
    self.autocompleteTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self createAutocompleteTableView];
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
        [SVProgressHUD dismiss];
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
                NSLog(@"Saved in the Background!");
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

#pragma mark - Autocomplete

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"textField method");
    self.autocompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    NSLog(@"searchAuto method");
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [_testAutoChoices removeAllObjects];
    for(NSString *curString in _testAutoCompleteDataSource) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [_testAutoChoices addObject:curString];
        }
    }
    if ([_testAutoChoices count] == 0){
        self.autocompleteTableView.hidden = YES;
    }
    [self.autocompleteTableView reloadData];
}

-(void)createAutocompleteTableView{
    self.autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 121, 320, 120) style:UITableViewStylePlain];
    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    self.autocompleteTableView.scrollEnabled = YES;
    self.autocompleteTableView.hidden = YES;
    [self.view addSubview:self.autocompleteTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    NSString *autocomplete = [_testAutoChoices objectAtIndex:indexPath.row];
    cell.textLabel.text = autocomplete;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.autocompleteTextField.text = cell.textLabel.text;
    
    self.autocompleteTableView.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_testAutoChoices count];
}
@end
