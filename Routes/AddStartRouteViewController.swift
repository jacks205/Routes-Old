//
//  AddDirectionViewController.swift
//  Routes
//
//  Created by Mark Jackson on 3/22/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//
import UIKit
import SPGooglePlacesAutocomplete

protocol AddRouteProtocol{
    func addRouteViewControllerDismissed(startingLocation : Location, endingLocation : Location)
}

class AddStartRouteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
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
        
        self.locations = []
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
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextClick(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier! == "endRoute"){
            if let cellIndexPath = self.selectedCellIndexPath{
                let vc : AddEndRouteViewController = segue.destinationViewController as AddEndRouteViewController
                if let currentLocation = self.currentCoords{
                    vc.currentCoords = currentLocation
                }else{
                    Alert.createAlertView("Warning!", message: "We do not have your current location, results may vary.", sender: self)
                }
                let startLocation : Location? = self.locations![cellIndexPath.row]
                if let location = startLocation {
                    vc.startingLocation = location
                }
                
            }else{
                //TODO: Can change this by hiding next button instead
                Alert.createAlertView("Oops.", message: "Please select start location.", sender: self)
            }
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
        
        var cell : LocationTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("LocationCell") as LocationTableViewCell
        
        let autocorrectLocation : Location? = self.locations![indexPath.row]
        if let location = autocorrectLocation{
            cell.locationNameLabel.text = location.areaOfInterest
            cell.locationAddressLabel.text = location.buildAddressString()
            let pinImage : UIImageView = UIImageView(frame: CGRectMake(24, 26, 20, 24))
            pinImage.image = UIImage(named: "pin", inBundle: NSBundle.mainBundle(), compatibleWithTraitCollection: nil)
            pinImage.tag = 100
            pinImage.userInteractionEnabled = false
            cell.contentView.addSubview(pinImage)
        }
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView.backgroundColor = UIColor(CGColor: Colors.CellSelectionColor)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        println("didSelectRowAtIndexPath")
        self.changeSelectedCell(indexPath)
    }
    
    func changeSelectedCell(indexPath : NSIndexPath?){
        if let selectedRow = self.selectedCellIndexPath{
            self.tableView.deselectRowAtIndexPath(selectedRow, animated: false)
            if selectedRow == indexPath {
                self.selectedCellIndexPath = nil
                self.nextButton.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
            }else{
                self.selectedCellIndexPath = indexPath
                self.nextButton.backgroundColor = UIColor(CGColor: Colors.TrafficColors.GreenLight)
            }
        }else{
            self.selectedCellIndexPath = indexPath
            self.nextButton.backgroundColor = UIColor(CGColor: Colors.TrafficColors.GreenLight)
        }
    }
    
    
    //MARK: SearchBar Delegate Methods
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if(countElements(searchBar.text) > 0){
            self.changeSelectedCell(self.selectedCellIndexPath)
            self.locations?.removeAll(keepCapacity: false)
            var query : SPGooglePlacesAutocompleteQuery = SPGooglePlacesAutocompleteQuery(apiKey: Constants.GOOGLE_PLACE_API_KEY)
            query.input = searchBar.text // search key word
            if let location = self.currentCoords{
                query.location = location  // user's current location
            }
            query.radius = 5000   // search addresses close to user
            query.language = "en" // optional
            query.types = SPGooglePlacesAutocompletePlaceType.PlaceTypeAll; // Only return geocoding (address) results.
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
        self.searchBar.resignFirstResponder()
    }
    
    //Handles dismissing keyboard when uitableview is selectable
    //TODO: add in gist for future reference
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
    
    // Handler for dismissing keyboard
    func handleTouch(recognizer : UITapGestureRecognizer){
        if recognizer.view != self.searchBar && self.searchBar.isFirstResponder() {
            self.searchBar.resignFirstResponder()
        }
    }
    
    
}
