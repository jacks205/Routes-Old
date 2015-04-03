//
//  AddEndRouteViewController.swift
//  Routes
//
//  Created by Mark Jackson on 3/29/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import UIKit
import SPGooglePlacesAutocomplete
import MapKit

class AddEndRouteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    var directionTableDelegate : AddRouteProtocol?
    var currentCoords : CLLocationCoordinate2D?
    
    var startingLocation : Location?
    
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
    
    
    @IBAction func cancelModal(sender : AnyObject){
//        println("cancelModal")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func back(sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    //TODO: Clean this logic up
    @IBAction func routeClick(sender: AnyObject) {
        if let cellIndexPath = self.selectedCellIndexPath {
            let endingLocation : Location? = self.locations?[cellIndexPath.row]
            let startingLocation : Location? = self.startingLocation
            if let endLocation = endingLocation {
                if endLocation.location == nil{
                    Alert.createAlertView("Sorry!", message: "There was a problem with the ending address you provided.", sender: self)
                }
                if let startLocation = startingLocation {
                    if startingLocation?.location == nil{
                        Alert.createAlertView("Sorry!", message: "There was a problem with the starting address you provided.", sender: self)
                    }else{
                    //Delegate stuff to send back to the RoutesViewController
                        let vc : RoutesTableViewController = self.navigationController?.presentingViewController as RoutesTableViewController
                        vc.addRouteViewControllerDismissed(startLocation, endingLocation: endLocation)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }else{
                    Alert.createAlertView("Sorry!", message: "There was a problem with the starting address you provided.", sender: self)
                }
            }else{
                Alert.createAlertView("Sorry!", message: "There was a problem with the ending address you provided.", sender: self)
            }
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
            cell.locationAddressLabel.text = location.buildAddressString()
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
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
                self.searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(countElements(searchBar.text) > 0){
            self.changeSelectedCell(self.selectedCellIndexPath)
            self.locations?.removeAll(keepCapacity: false)
            let req : MKLocalSearchRequest = MKLocalSearchRequest()
            if let currentPosition = self.currentCoords{
                println(currentPosition.latitude)
                req.region = MKCoordinateRegionMakeWithDistance(currentPosition, 50000, 50000)
            }
            req.naturalLanguageQuery = searchText
            let localSearch : MKLocalSearch = MKLocalSearch(request: req)
            localSearch.startWithCompletionHandler { (res : MKLocalSearchResponse!, error : NSError!) -> Void in
                if error != nil{
                    println(error.localizedDescription)
                    //                self.tableView.reloadData()
                }else{
                    println()
                    if let mapItems = res.mapItems as? [MKMapItem]{
                        for item in mapItems{
                            if let placemark = item.placemark{
                                let newLocation : Location = Location(addressString: item.name, place: placemark)
                                self.locations?.append(newLocation)
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    
    //Handles dismissing keyboard when uitableview is selectable
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