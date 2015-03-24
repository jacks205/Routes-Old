//
//  AddDirectionViewController.swift
//  Routes
//
//  Created by Mark Jackson on 3/22/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//
import UIKit
import CoreLocation

protocol AddRouteProtocol{
    func addRouteViewControllerDismissed(direction : Direction)
}

class AddDirectionViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!

    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    var directionTableDelegate : AddRouteProtocol?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func addRoute(sender: AnyObject) {
        self.processRoute()
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
        let address : String = self.addressTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let city : String = self.cityTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let state : String = self.stateTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let zipcode : String = self.zipcodeTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if(countElements(address) == 0 || countElements(city) == 0  || countElements(state) == 0 || countElements(zipcode) == 0){
            self.createAlertView("Oops", message: "Please enter all fields")
        }else{
            let direction : Direction = Direction(address: address, city: city, state: state, zipcode: zipcode)
            self.generateCoordinatesFromAddress(direction)
        }
    }
    
    func cancelModal(direction : Direction){
        self.directionTableDelegate!.addRouteViewControllerDismissed(direction)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func createAlertView(title : String, message : String){
        var alert = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}
