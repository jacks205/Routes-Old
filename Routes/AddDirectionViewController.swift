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

class AddDirectionViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var directionTableDelegate : AddRouteProtocol?
    var currentCoords : CLLocationCoordinate2D?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0.85
        //Initialization
//        println("here")
        self.initializeSearchBar()
        
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
    
    func createAlertView(title : String, message : String){
        var alert = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}
