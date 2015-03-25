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

class DirectionsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate, AddRouteProtocol {
    
    var locationManager : CLLocationManager?
    var directions : NSMutableArray?
    var currentCoords : CLLocationCoordinate2D?
    
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addGradientLayer()
        
        
        //TODO: Place in function
        self.tableView.delegate = self
        self.tableView.dataSource = self
        println(self.tableView)
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor.clearColor()
        println(self.tableView.backgroundColor)
        
        //TODO: Place in function
        self.searchBar.delegate = self
        UITextField.appearance().textColor = UIColor.whiteColor()
        self.searchBarView.backgroundColor = UIColor.clearColor()
        
//        self.view.backgroundColor = UIColor.blueColor()
        
        //Load in directions from user
        self.directions = NSMutableArray()
        for(var i = 0; i < 5; ++i){
            let dir : Direction = Direction(address: "12345 A Street", city: "Some City", state: "CA",  zipcode: "12345")
            dir.distance = 123412
            dir.trafficTime = 12313
            dir.travelTime = 213131
            self.directions?.addObject(dir)
        }
        
        //Initialize Location Manager and update location
        initializeLocationManager()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        self.refreshRoutes()
    }
    
    func initializeLocationManager(){
        self.locationManager = CLLocationManager()
        if let locationManagerOp = self.locationManager{
            locationManagerOp.delegate = self;
            locationManagerOp.distanceFilter = kCLDistanceFilterNone
            locationManagerOp.desiredAccuracy = kCLLocationAccuracyBest
            locationManagerOp.startUpdatingLocation()
        }
    }
    
    func addGradientLayer(){
        var gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view!.frame
        gradient.colors = [Colors.TableViewGradient.Start, Colors.TableViewGradient.End]
        self.view!.layer.insertSublayer(gradient, atIndex: 0)

    }
    
    func refreshRoutes(){
        //Directions exist
        for direction in self.directions!{
            if let dir : Direction = direction as? Direction{
                Alamofire.request(.GET, dir.buildUrl(self.currentCoords!)!, parameters: nil, encoding: ParameterEncoding.URL)
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
    }
    
    //MARK: TableView Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.directions!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : TempTimeEstimateCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as TempTimeEstimateCell

        let direction : Direction = self.directions?.objectAtIndex(indexPath.row) as Direction
        cell.addressLabel.text = direction.address
        cell.cityLabel.text = "\(direction.city), \(direction.state)"
        cell.zipcodeLabel.text = direction.zipcode
        
        let distance = direction.distance
        let trafficTime = direction.trafficTime
        
        //Calculate user friendly values for distance and time
        let distanceString = metersToMilesString(Float(distance!))
        let trafficTimeString = secondsToHoursAndMinutesString(trafficTime!)
        
        cell.distanceLabel.text = distanceString;
        cell.travelTimeLabel.text = trafficTimeString;
        
        //Must set this in the cellForRowAtIndexPath: method
        cell.backgroundColor = UIColor.clearColor()

        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        println("You selected cell #\(indexPath.row)!")
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
    
    func addRouteViewControllerDismissed(direction : Direction){
        self.directions?.addObject(direction)
        self.tableView.reloadData()
    }
    
    @IBAction func addDirection(sender: AnyObject) {
       self.performSegueWithIdentifier("addDirection", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "addDirection"){
            let vc : AddDirectionViewController = segue.destinationViewController as AddDirectionViewController
            vc.directionTableDelegate = self
        }
    }
    
    //MARK: Current Location Delegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location : CLLocation = locations.last as CLLocation
        self.currentCoords = location.coordinate
    }
    
    //MARK: Convienence Methods
    func metersToMilesString(meters : Float) -> String{
        let distance = meters * 0.000621371
        return String(format: "%.2f", distance)
    }
    
    func secondsToHoursAndMinutesString(seconds : Int) -> String{
        let intSeconds = seconds;
        let hours = intSeconds / 3600;
        let minutes = intSeconds % 3600 / 60;
        return "\(hours)h \(minutes)m"
    }
    
    //Mark: Launching Map App
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

