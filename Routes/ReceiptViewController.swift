//
//  ReceiptViewController.swift
//  Routes
//
//  Created by Mark Jackson on 4/5/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var startingShortNameTextField: UITextField!
    @IBOutlet weak var endingShortNameTextField: UITextField!
    
    var startingLocation : Location?
    var endingLocation : Location?
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var routeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.routeButton.backgroundColor = UIColor(CGColor: Colors.TrafficColors.GreenLight)
        self.topBarView.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
        self.view.backgroundColor = UIColor(CGColor: Colors.IndicatorBackground)
        self.view.opaque = true
        self.view.alpha = 1
        self.startingShortNameTextField.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
        self.startingShortNameTextField.delegate = self
        self.endingShortNameTextField.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
        self.endingShortNameTextField.delegate = self
        if let startLocation = self.startingLocation {
            self.startingShortNameTextField.text = startLocation.areaOfInterest
        }
        if let endLocation = self.endingLocation {
            self.endingShortNameTextField.text = endLocation.areaOfInterest
        }
        
    }
    
    
    @IBAction func addRoute(sender: AnyObject) {
        if let endLocation = self.endingLocation{
            if let startLocation = self.startingLocation {
                //Delegate stuff to send back to the RoutesViewController
                startLocation.shortName = self.startingShortNameTextField.text
                endLocation.shortName = self.endingShortNameTextField.text
                let vc : RoutesTableViewController = self.navigationController?.presentingViewController as RoutesTableViewController
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    vc.addRouteViewControllerDismissed(startLocation, endingLocation: endLocation)
                })
            }else{
                Alert.createAlertView("Sorry!", message: "There was a problem with the starting address you provided.", sender: self)
            }
        }else{
            Alert.createAlertView("Sorry!", message: "There was a problem with the ending address you provided.", sender: self)
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


}
