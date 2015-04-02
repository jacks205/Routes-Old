//
//  AddEndRouteViewController.swift
//  Routes
//
//  Created by Mark Jackson on 3/29/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import UIKit
import SPGooglePlacesAutocomplete

class AddEndRouteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    var directionTableDelegate : AddRouteProtocol?
    var currentCoords : CLLocationCoordinate2D?
    var locations : [Location]?
    var selectedCellIndexPath : NSIndexPath?
    
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
        
        //TODO: Fix to add tap gesture only in certain states of the search bar
//        var tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTouch:")
//        self.view.addGestureRecognizer(tap)
        
        self.locations = [Location]()
        for i in 0...5{
            let location : Location = Location(areaOfInterest: "Chapman University", streetNumber: "1", streetAddress: "University Dr", city: "Orange", state: "CA", county: "Orange", postalCode: "92866", country: "US")
            self.locations?.append(location)
        }
    }
    
    func initializeSearchBar(){
        self.searchBar.delegate = self
        UITextField.appearance().textColor = UIColor.whiteColor()
    }
    
    //Initializes table view and sets delegates
    func initializeTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    
    @IBAction func addRoute(sender: AnyObject) {
//        self.processRoute()
    }
    
//    func generateCoordinatesFromAddress(direction : Direction){
//        let geocoder = CLGeocoder()
//        let formattedAddress = "\(direction.address!), \(direction.city!), \(direction.state!), \(direction.zipcode!)"
//        println(formattedAddress)
//        geocoder.geocodeAddressString(formattedAddress, completionHandler: { (placemarkObjects : [AnyObject]!, error : NSError!) -> Void in
//            if(error != nil){
//                println(error.localizedDescription)
//                self.createAlertView("Oops", message: "There was an error generating the route. Please try again.")
//            }else{
//                let placemarks : [CLPlacemark] = placemarkObjects as [CLPlacemark]
//                //One placemark
//                for placemark : CLPlacemark? in placemarks{
//                    if let pm = placemark{
//                        //Process placemark
//                        direction.latitude = Float(pm.location.coordinate.latitude)
//                        direction.longitude = Float(pm.location.coordinate.longitude)
//                    }
//                }
//                println("Direction: \(direction.latitude!), \(direction.longitude!)")
////                self.cancelModal(direction)
//            }
//        })
//    }
//    
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
    
    @IBAction func cancelModal(sender : AnyObject){
        println("cancelModal")
//        self.directionTableDelegate!.addRouteViewControllerDismissed(direction)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func back(sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func routeClick(sender: AnyObject) {
        if self.selectedCellIndexPath != nil{
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            //TODO: Can change this by hiding next button instead
            Alert.createAlertView("Oops.", message: "Please select end location.", sender: self)
        }
        
        
    }

    //MARK: Table View Delegate/Datasource Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations!.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : LocationTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("LocationCell2") as LocationTableViewCell
        
        let autocorrectLocation : Location? = self.locations![indexPath.row]
        if let location = autocorrectLocation{
            cell.locationNameLabel.text = location.areaOfInterest
            cell.locationAddressLabel.text = "\(location.streetNumber) \(location.streetAddress)\n\(location.city), \(location.state) \(location.postalCode)"
            let pinImage : UIImageView = UIImageView(frame: CGRectMake(24, 26, 20, 24))
            pinImage.image = UIImage(named: "pin", inBundle: NSBundle.mainBundle(), compatibleWithTraitCollection: nil)
            pinImage.tag = 100
            cell.contentView.addSubview(pinImage)
        }
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView.backgroundColor = UIColor(CGColor: Colors.CellSelectionColor)
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
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("searchBarSearchButtonClicked")
        println(countElements(searchBar.text))
        if(countElements(searchBar.text) > 0){
            self.locations = [Location]()
            var query : SPGooglePlacesAutocompleteQuery = SPGooglePlacesAutocompleteQuery(apiKey: Constants.GOOGLE_PLACE_API_KEY)
            query.input = searchBar.text // search key word
            println(self.currentCoords)
            if let location = self.currentCoords{
                query.location = location  // user's current location
            }
            query.radius = 50   // search addresses close to user
            query.language = "en" // optional
            query.types = SPGooglePlacesAutocompletePlaceType.PlaceTypeAll; // Only return geocoding (address) results.
            println(query)
            query.fetchPlaces { (places : [AnyObject]!, error : NSError!) -> Void in
                if (error != nil){
                    println(error.localizedDescription)
                }else{
                    for place in places {
                        let googlePlaceMark : SPGooglePlacesAutocompletePlace? = place as? SPGooglePlacesAutocompletePlace
                        if let placeMark = googlePlaceMark {
                            placeMark.resolveToPlacemark({ (clPlace : CLPlacemark!, addressString : String!, error : NSError!) -> Void in
                                if (error != nil){
                                    println("Error \(error.localizedDescription)")
                                    self.tableView.reloadData()
                                }else{
                                    let newLocation : Location = Location(addressString: addressString, place: clPlace)
                                    self.locations?.append(newLocation)
                                    self.tableView.reloadData()
                                }
                            })
                        }
                    }
                    //                    self.tableView.reloadData()
                }
            }
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        println("searchBarShouldEndEditing")
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        println("didSelectRowAtIndexPath")
        if let selectedRow = self.selectedCellIndexPath{
            self.tableView.deselectRowAtIndexPath(selectedRow, animated: false)
            if selectedRow == indexPath {
                self.selectedCellIndexPath = nil
                self.nextButton.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
            }else{
                self.selectedCellIndexPath = indexPath
                self.nextButton.backgroundColor = UIColor.greenColor()
            }
        }else{
            self.selectedCellIndexPath = indexPath
            self.nextButton.backgroundColor = UIColor.greenColor()
        }
    }
    
    // Handler for dismissing keyboard
    func handleTouch(recognizer : UITapGestureRecognizer){
        if recognizer.view != self.searchBar && self.searchBar.isFirstResponder() {
            self.searchBar.resignFirstResponder()
        }
    }
}