//
//  DirectionsTableViewController.swift
//  Routes
//
//  Created by Mark Jackson on 3/21/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON

class RoutesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate, AddRouteProtocol {
    
    var locationManager : CLLocationManager?
    var directions : [Direction]?
    var searchDirections : [Direction]?
    var currentCoords : CLLocationCoordinate2D?
    
    var isSearching : Bool!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.isSearching = false
        
        // Add gradient background
        self.addGradientLayer()
        
        
        //Initializers
        self.initializeTableView()
        self.initializeSearchBar()
        self.initializeLocationManager()
        
        var tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTouch:")
        //        tap.addTarget(self.searchBar, action: "handleTouch:")
        //        tap.addTarget(self.searchBarView, action: "handleTouch:")
        self.view.addGestureRecognizer(tap)
        
        
        //TODO: Remove and implement real dataset
        //Load in directions from user
        self.directions = [Direction]()
        for(var i = 0; i < 3; ++i){
            let dir : Direction = Direction(startingLocation: "Current Location", endingLocation: "School", viaDirections: ["I-55S","Chapman"], address: "12345 A Street", city: "Some City", state: "CA",  zipcode: "12345")
            dir.distance = 123412
            dir.trafficTime = 12313
            dir.travelTime = 213131
            self.directions?.append(dir)
        }
        for(var i = 0; i < 3; ++i){
            let dir : Direction = Direction(startingLocation: "Current Location", endingLocation: "Work", viaDirections: ["I-57S","Lambert"], address: "12345 A Road", city: "Some Town", state: "CA",  zipcode: "54321")
            dir.distance = 13745
            dir.trafficTime = 13445
            dir.travelTime = 13445
            self.directions?.append(dir)
        }
        for(var i = 0; i < 3; ++i){
            let dir : Direction = Direction(startingLocation: "Current Location", endingLocation: "Winterfell", viaDirections: ["Kings Road", "The Twins", "Kings Landing"], address: "12345 A Road", city: "Some Town", state: "CA",  zipcode: "54321")
            dir.distance = 139995
            dir.trafficTime = 135445
            dir.travelTime = 135245
            self.directions?.append(dir)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //Initialize Location Manager and update location
    func initializeLocationManager(){
        self.locationManager = CLLocationManager()
        if let locationManagerOp = self.locationManager{
            locationManagerOp.delegate = self;
            locationManagerOp.distanceFilter = kCLDistanceFilterNone
            locationManagerOp.desiredAccuracy = kCLLocationAccuracyBest
            locationManagerOp.requestWhenInUseAuthorization()
            locationManagerOp.startMonitoringSignificantLocationChanges()
            locationManagerOp.startUpdatingLocation()
        }
    }
    
    //Initializes table view and sets delegates
    func initializeTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    //Initializes search bar and sets delegates
    func initializeSearchBar(){
        self.searchBar.delegate = self
        UITextField.appearance().textColor = UIColor.whiteColor()
        self.searchBarView.backgroundColor = UIColor.clearColor()
    }
    
    //Creates and adds background gradient color
    func addGradientLayer(){
        var gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view!.frame
        gradient.colors = [Colors.TableViewGradient.Start, Colors.TableViewGradient.End]
        self.view!.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    //For refreshing current routes and parsing data from API
    func refreshRoutes(){
        //Directions exist
        for direction in self.directions!{
            Alamofire.request(.GET, direction.buildUrl(self.currentCoords!)!, parameters: nil, encoding: ParameterEncoding.URL)
                .responseJSON(options: nil, completionHandler: { (
                    req, res, json, error) -> Void in
                    if(error != nil){
                        println("Error: \(error)")
                        println(req)
                        println(res)
                    }else{
                        let json = JSON(json!)
                        if let summary = json[Constants.RESPONSE_KEY][Constants.ROUTE_KEY][0][Constants.SUMMARY_KEY].string{
                            println(summary)
                            //TODO: Fix SwiftyJSON Parsing
                            //                                if let distance = summary[Constants.DISTANCE_KEY].int{
                            //                                    dir.distance = distance
                            //                                }
                            //                                if let baseTime = summary[Constants.BASE_TIME_KEY].int{
                            //                                    dir.baseTime = baseTime
                            //                                }
                            //                                if let trafficTime = summary[Constants.TRAFFIC_TIME_KEY].int{
                            //                                    dir.trafficTime = trafficTime
                            //                                }
                            //                                if let travelTime = summary[Constants.TRAVEL_TIME_KEY].int{
                            //                                    dir.travelTime = travelTime
                            //                                }
                        }else{
                            println("Error: \(json.string)")
                        }
                    }
                })
            self.tableView.reloadData()
        }
    }
    
    //MARK: TableView Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching! {
            return self.searchDirections!.count
        }else{
            return self.directions!.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : RouteTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as RouteTableViewCell
        var directionEntry : Direction?
        if !self.isSearching! {
            directionEntry = self.directions![indexPath.row]
        }else{
            directionEntry = self.searchDirections![indexPath.row]
        }
        if let direction = directionEntry {
            cell.startToEndLocation.text = "\(direction.startingLocation!) -> \(direction.endingLocation!)"
            cell.setViaRouteDescription(direction.viaDirections)
            
            let distance = direction.distance
            let trafficTime = direction.trafficTime
            
            //Calculate user friendly values for distance and time
            let distanceString = metersToMilesString(Float(distance!))
            let trafficTimeString = secondsToHoursAndMinutesString(trafficTime!)
            
            cell.distanceLabel.text = distanceString;
            cell.totalTravelTime = trafficTimeString;
            
            //Must set this in the cellForRowAtIndexPath: method
            cell.backgroundColor = UIColor.clearColor()
//            let indicatorXPosition : CGFloat = cell.frame.width * RouteTableViewCellConst.IndicatorRectXOffset
//            let indicatorYPosition : CGFloat = cell.frame.height * RouteTableViewCellConst.TrafficIndicatorOffsetPercentage
//            let baseWidth : CGFloat = cell.frame.width * RouteTableViewCellConst.IndicatorBaseWidthPercentage
//            let travelTimeLabel : UILabel = UILabel(frame: CGRectMake(indicatorXPosition + 10, indicatorYPosition - 15, baseWidth, RouteTableViewCellConst.IndicatorBaseHeight))
//            travelTimeLabel.text = trafficTimeString
//            travelTimeLabel.textColor = UIColor.whiteColor()
//            travelTimeLabel.font = UIFont(name: "Helvetica Neue", size: 11)
//            travelTimeLabel.tag = 100
//            cell.contentView.addSubview(travelTimeLabel)
        }
        return cell
    }
    
    //    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        println("You selected cell #\(indexPath.row)!")
    //        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    //    }
    
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
        if(countElements(searchText) > 0){
            //Populate searchDirections
            self.searchDirections = [Direction]()
            for route in self.directions! {
                println(route.endingLocation!.lowercaseString)
                let range : Range = Range<String.Index>(start: searchText.startIndex, end: route.endingLocation!.endIndex)
                if (route.endingLocation?.lowercaseString.rangeOfString(searchText.lowercaseString, options: NSStringCompareOptions.AnchoredSearch, range: range, locale: nil) != nil) {
                    self.searchDirections?.append(route)
                }
            }
            self.isSearching = true
        }else{
            self.isSearching = false
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("searchBarSearchButtonClicked")
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        println("searchBarShouldEndEditing")
        return true
    }
    
    
    //MARK: AddRouteProtocol
    //AddRouteProtocol method
    func addRouteViewControllerDismissed(direction : Direction){
        self.directions?.append(direction)
        self.tableView.reloadData()
    }
    
    //IBAction for addButton to add a route and present a modal
    @IBAction func addDirection(sender: AnyObject) {
        let vc : AddDirectionViewController = self.storyboard!.instantiateViewControllerWithIdentifier("addDirectionViewController") as AddDirectionViewController
        vc.directionTableDelegate = self
//        self.providesPresentationContextTransitionStyle = true
//        self.definesPresentationContext = true
//        vc.modalPresentationStyle = .OverCurrentContext
        vc.currentCoords = self.currentCoords
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
//    //Segue method
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        println(segue.identifier)
//        if(segue.identifier == "addDirection"){
//            let vc : AddDirectionViewController = segue.destinationViewController as AddDirectionViewController
//            vc.directionTableDelegate = self
////            self.definesPresentationContext = true
//            vc.view.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
//            self.providesPresentationContextTransitionStyle = true
//            self.definesPresentationContext = true
////            self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//            vc.modalPresentationStyle = .OverCurrentContext
//            vc.currentCoords = self.currentCoords
////            println(self.currentCoords)
//        }
//    }
    
    //MARK: Current Location Delegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location : CLLocation = locations.last as CLLocation
        self.currentCoords = location.coordinate
    }
    
    //MARK: Convienence Methods
    //Converts meters to a string containing miles and formated .2f
    func metersToMilesString(meters : Float) -> String{
        let distance = meters * 0.000621371
        return String(format: "%.1f mi", distance)
    }
    
    //Takes in total seconds and converts it to a string formatted "00h 00m"
    func secondsToHoursAndMinutesString(seconds : Int) -> String{
        let intSeconds = seconds;
        let hours = intSeconds / 3600;
        let minutes = intSeconds % 3600 / 60;
        return "\(hours) hrs \(minutes) min"
    }
    
    // Handler for dismissing keyboard
    func handleTouch(recognizer : UITapGestureRecognizer){
        if recognizer.view != self.searchBar && self.searchBar.isFirstResponder() {
            self.searchBar.resignFirstResponder()
        }
    }
    
    //MARK: Launching Map App
    func launchMapApp(coordinates : CLLocationCoordinate2D, name: String) -> Void{
        // Launching map app with location and name of destination
        let place : MKPlacemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let destination : MKMapItem = MKMapItem(placemark: place)
        destination.name = name;
        let items = [destination]
        let options = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey)
        MKMapItem.openMapsWithItems(items, launchOptions: options)
    }
    
    
}

