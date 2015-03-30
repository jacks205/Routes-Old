//
//  AddDirectionViewController.swift
//  Routes
//
//  Created by Mark Jackson on 3/22/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//
import UIKit
import CoreLocation
import SPGooglePlacesAutocomplete

protocol AddRouteProtocol{
    func addRouteViewControllerDismissed(direction : Direction)
}

class AddStartRouteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    var directionTableDelegate : AddRouteProtocol?
    var currentCoords : CLLocationCoordinate2D?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialization
        self.searchBarView.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
        self.nextButton.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
        self.view.backgroundColor = UIColor(CGColor: Colors.IndicatorBackground)
        self.view.opaque = true
        self.view.alpha = 1
        self.initializeTableView()
        self.initializeSearchBar()
        
        var tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTouch:")
        //        tap.addTarget(self.searchBar, action: "handleTouch:")
        //        tap.addTarget(self.searchBarView, action: "handleTouch:")
        self.view.addGestureRecognizer(tap)
        
//        var query : SPGooglePlacesAutocompleteQuery = SPGooglePlacesAutocompleteQuery(apiKey: Constants.GOOGLE_PLACE_API_KEY)
//        query.input = "13406 Ph"; // search key word
//        if let location = self.currentCoords{
//            query.location = location;  // user's current location
//        }
//        query.radius = 50;   // search addresses close to user
//        query.language = "en"; // optional
//        query.types = SPGooglePlacesAutocompletePlaceType.PlaceTypeGeocode; // Only return geocoding (address) results.
//        query.fetchPlaces { (places : [AnyObject]!, error : NSError!) -> Void in
//            if (error != nil){
//                println(error.localizedDescription)
//            }else{
//                for place in places {
//                    let googlePlaceMark : SPGooglePlacesAutocompletePlace? = place as? SPGooglePlacesAutocompletePlace
//                    if let placeMark = googlePlaceMark {
//                        placeMark.resolveToPlacemark({ (clPlace : CLPlacemark!, addressString : String!, error : NSError!) -> Void in
//                            if (error != nil){
//                                println(error.localizedDescription)
//                            }else{
//                                println(addressString)
//                            }
//                        })
//                    }
//                }
//            }
//        }
    }
    
    func initializeSearchBar(){
        self.searchBar.delegate = self
        UITextField.appearance().textColor = UIColor.whiteColor()
    }
    
    //Initializes table view and sets delegates
    func initializeTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    
    @IBAction func addRoute(sender: AnyObject) {
//        self.processRoute()
    }
    
    func generateCoordinatesFromAddress(direction : Direction){
        let geocoder = CLGeocoder()
        let formattedAddress = "\(direction.address!), \(direction.city!), \(direction.state!), \(direction.zipcode!)"
        println(formattedAddress)
        geocoder.geocodeAddressString(formattedAddress, completionHandler: { (placemarkObjects : [AnyObject]!, error : NSError!) -> Void in
            if(error != nil){
                println(error.localizedDescription)
                self.createAlertView("Oops", message: "There was an error generating the route. Please try again.")
            }else{
                let placemarks : [CLPlacemark] = placemarkObjects as [CLPlacemark]
                //One placemark
                for placemark : CLPlacemark? in placemarks{
                    if let pm = placemark{
                        //Process placemark
                        direction.latitude = Float(pm.location.coordinate.latitude)
                        direction.longitude = Float(pm.location.coordinate.longitude)
                    }
                }
                println("Direction: \(direction.latitude!), \(direction.longitude!)")
//                self.cancelModal(direction)
            }
        })
    }
    
    func processRoute(){
//        let address : String = self.addressTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        let city : String = self.cityTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        let state : String = self.stateTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        let zipcode : String = self.zipcodeTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        
//        if(countElements(address) == 0 || countElements(city) == 0  || countElements(state) == 0 || countElements(zipcode) == 0){
//            self.createAlertView("Oops", message: "Please enter all fields")
//        }else{
//            let direction : Direction = Direction(startingLocation: "Current Location", endingLocation: "School", viaDirections: ["I-55S","Chapman"], address: address, city: city, state: state, zipcode: zipcode)
//            self.generateCoordinatesFromAddress(direction)
//        }
    }
    
    func cancelModal(direction : Direction){
        println("cancelModal")
//        self.directionTableDelegate!.addRouteViewControllerDismissed(direction)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        println("cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextClick(sender: AnyObject) {
        println("nextClick")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepareForSegue")
    }
    
    func createAlertView(title : String, message : String){
        var alert = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Table View Delegate/Datasource Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : LocationTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("LocationCell") as LocationTableViewCell
        println(cell)
        cell.locationNameLabel.text = "Chapman University"
        cell.locationAddressLabel.text = "1 University Drive\nOrange, CA 92886"
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    //MARK: SearchBar Delegate Methods
    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        println("searchBarTextDidEndEditing")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        println("searchBarCancelButtonClicked")
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //Check if user is searching for specific route
//        if(countElements(searchText) > 0){
//            //Populate searchDirections
//            self.searchDirections = [Direction]()
//            for route in self.directions! {
//                println(route.endingLocation!.lowercaseString)
//                let range : Range = Range<String.Index>(start: searchText.startIndex, end: route.endingLocation!.endIndex)
//                if (route.endingLocation?.lowercaseString.rangeOfString(searchText.lowercaseString, options: NSStringCompareOptions.AnchoredSearch, range: range, locale: nil) != nil) {
//                    self.searchDirections?.append(route)
//                }
//            }
//            self.isSearching = true
//        }else{
//            self.isSearching = false
//        }
//        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("searchBarSearchButtonClicked")
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        println("searchBarShouldEndEditing")
        return true
    }
    
    // Handler for dismissing keyboard
    func handleTouch(recognizer : UITapGestureRecognizer){
        if recognizer.view != self.searchBar && self.searchBar.isFirstResponder() {
            self.searchBar.resignFirstResponder()
        }
    }
    
    
}
