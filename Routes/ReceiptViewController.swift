//
//  ReceiptViewController.swift
//  Routes
//
//  Created by Mark Jackson on 4/5/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController, UITextFieldDelegate, ZCarouselDelegate {
    @IBOutlet weak var startingShortNameTextField: UITextField!
    @IBOutlet weak var endingShortNameTextField: UITextField!
    
    var startingLocation : Location?
    var endingLocation : Location?
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var mapCarousel: ZCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.routeButton.backgroundColor = UIColor(CGColor: Colors.TrafficColors.GreenLight)
        self.topBarView.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
        self.view.backgroundColor = UIColor(CGColor: Colors.IndicatorBackground)
        self.view.opaque = true
        self.view.alpha = 1
        
        self.mapCarousel.ZCdelegate = self
        self.mapCarousel.addButtons(["Map1", "Map2", "Map3"])
        
        self.startingShortNameTextField.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
        self.startingShortNameTextField.delegate = self
        self.endingShortNameTextField.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
        self.endingShortNameTextField.delegate = self
        if let startLocation = self.startingLocation, endLocation = self.endingLocation {
            self.startingShortNameTextField.text = startLocation.areaOfInterest
            self.endingShortNameTextField.text = endLocation.areaOfInterest
        }
    }
    
    
    @IBAction func addRoute(sender: AnyObject) {
        if let endLocation = self.endingLocation, startLocation = self.startingLocation{
            //Delegate stuff to send back to the RoutesViewController
            startLocation.shortName = self.startingShortNameTextField.text
            endLocation.shortName = self.endingShortNameTextField.text
            println((self.navigationController?.presentingViewController as! UINavigationController).topViewController)
            let nc : UINavigationController = self.navigationController?.presentingViewController as! UINavigationController
            let vc : RoutesTableViewController = nc.topViewController as! RoutesTableViewController
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                vc.addRouteViewControllerDismissed(startLocation, endingLocation: endLocation)
            })
        }else{
            Alert.createAlertView("Sorry!", message: "There was a problem with one of the addresses you provided.", sender: self)
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func exitModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func back(sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    //MARK: ZCarousel Delegate Method
    func ZCarouselShowingIndex(scrollview: ZCarousel, index: Int) {
        if scrollview == self.mapCarousel {
            println("Showing Button at index \(index)")
        }
    }


}
