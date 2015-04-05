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
    var directions : [Direction]
    var searchDirections : [Direction]
    var currentCoords : CLLocationCoordinate2D?
    var isSearching : Bool!
    var refreshControl : UIRefreshControl!
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        self.directions = []
        self.searchDirections = []
        super.init(coder: aDecoder)
    }
    
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
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshRoutes()
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
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "pullToRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
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
        //TODO: Create module/pod for this
        //Directions exist
        for direction in self.directions{
            if let url = direction.buildUrl(){
                println(url)
                Alamofire.request(.GET, url, parameters: nil, encoding: ParameterEncoding.URL)
                    .responseJSON({ (req, res, json, error) -> Void in
                        println("responseJSON")
                        if let err = error{
                            println("Error: \(err)")
                            println(req)
                            println(res)
                        }else{
                            println(json)
                            let json : JSON = JSON(json!)
                            let summary : JSON = json[Constants.RESPONSE_KEY][Constants.ROUTE_KEY][0][Constants.SUMMARY_KEY]
//                            println("route")
//                            println(json[Constants.RESPONSE_KEY][Constants.ROUTE_KEY])
//                            println("summary")
//                            println(json[Constants.RESPONSE_KEY][Constants.ROUTE_KEY][0][Constants.SUMMARY_KEY])
                            //Distance
                            if let distance = summary[Constants.DISTANCE_KEY].int{
                                direction.distance = distance
                            }else{
                                println(summary[Constants.DISTANCE_KEY].error!)
                            }
                            //Traffic Time
                            if let trafficTime = summary[Constants.TRAFFIC_TIME_KEY].int{
                                direction.trafficTime = trafficTime
                            }else{
                                println(summary[Constants.TRAFFIC_TIME_KEY].error!)
                            }
                            //Base Time
                            if let baseTime = summary[Constants.BASE_TIME_KEY].int{
                                direction.baseTime = baseTime
                            }else{
                                println(summary[Constants.BASE_TIME_KEY].error!)
                            }

                        }
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    })
            }else{
                Alert.createAlertView("Oops!", message: "One of your routes is invalid", sender: self)
            }
            
        }
        
    }
    
    //MARK: TableView Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching! {
            return self.searchDirections.count
        }else{
            return self.directions.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : RouteTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as RouteTableViewCell
        var directionEntry : Direction?
        if !self.isSearching! {
            directionEntry = self.directions.get(indexPath.row)
        }else{
            directionEntry = self.searchDirections.get(indexPath.row)
        }
        if let direction = directionEntry {
            if let startAreaOfInterest = direction.startingLocation?.areaOfInterest{
                cell.startLocation.text = startAreaOfInterest
            }
            if let endAreaOfInterest = direction.endingLocation?.areaOfInterest{
                cell.endLocation.text = endAreaOfInterest
            }
            //Setting via description
            //Can accept nil value
            cell.setViaRouteDescription(direction.viaDirections)
            //Calculate user friendly values for distance and time
            if let dist = direction.distance{
                let distanceString = metersToMilesString(Float(dist))
                cell.distanceLabel.text = distanceString;
            }
            if let trafficTime = direction.trafficTime{
                cell.trafficTime = direction.trafficTime
                let trafficTimeString = secondsToHoursAndMinutesString(trafficTime)
                cell.totalTravelTime = trafficTimeString
            }
            if let baseTime = direction.baseTime{
                cell.baseTime = baseTime
            }
            //Must set this in the cellForRowAtIndexPath: method
            cell.backgroundColor = UIColor.clearColor()
        }
        return cell
    }
    
    //MARK: Pull to refresh listener method
    func pullToRefresh(sender : AnyObject){
        if self.directions.count == 0{
            self.refreshControl.endRefreshing()
        }else{
            self.refreshRoutes()
        }
    }
    
    
    //MARK: SearchBar Delegate Methods
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //Check if user is searching for specific route
        if(countElements(searchText) > 0){
            //Populate searchDirections
            self.searchDirections.removeAll(keepCapacity: false)
            for route in self.directions{
                if let startAreaOfInterest = route.startingLocation?.areaOfInterest{
                    let rangeStartLocation : Range = Range<String.Index>(start: searchText.startIndex, end: startAreaOfInterest.endIndex)
                    if (startAreaOfInterest.lowercaseString.rangeOfString(searchText.lowercaseString, options: NSStringCompareOptions.AnchoredSearch, range: rangeStartLocation, locale: nil) != nil) {
                        self.searchDirections.append(route)
                    }
                }
                if let endAreaOfInterest = route.endingLocation?.areaOfInterest{
                    let rangeEndLocation : Range = Range<String.Index>(start: searchText.startIndex, end: endAreaOfInterest.endIndex)
                    if (endAreaOfInterest.lowercaseString.rangeOfString(searchText.lowercaseString, options: NSStringCompareOptions.AnchoredSearch, range: rangeEndLocation, locale: nil) != nil) {
                        self.searchDirections.append(route)
                    }
                }
                
                
            }
            self.isSearching = true
        }else{
            self.isSearching = false
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
    //MARK: AddRouteProtocol
    //AddRouteProtocol method
    func addRouteViewControllerDismissed(startingLocation : Location, endingLocation : Location){
        //Create Direction out of locations
        println(startingLocation.print())
        println(endingLocation.print())
        let newDirection : Direction = Direction(startingLocation: startingLocation, endingLocation: endingLocation, viaDirections: nil)
        self.directions.append(newDirection)
        println("Appended")
        self.refreshRoutes()
    }
    
    //IBAction for addButton to add a route and present a modal
    @IBAction func addDirection(sender: AnyObject) {

    }
    
//    //Segue method
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(segue.identifier! == "addRoute")
        if(segue.identifier! == "addRoute"){
            println(segue.destinationViewController)
            let navController : UINavigationController = segue.destinationViewController as UINavigationController
            println(navController.topViewController)
            let vc : AddStartRouteViewController? = navController.topViewController as? AddStartRouteViewController
            println(vc)
            if let addStartRouteController = vc  {
                println("CUURENTY COORDS")
                println(self.currentCoords)
                addStartRouteController.currentCoords = self.currentCoords
                addStartRouteController.directionTableDelegate = self
            }
        }
    }
    
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

struct Alert {
    static func createAlertView(title : String, message : String, sender : AnyObject){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
        sender.presentViewController(alert, animated: true, completion: nil)
    }
}

