//
//  ReceiptViewController.swift
//  Routes
//
//  Created by Mark Jackson on 4/5/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {
    
    var startingLocation : Location?
    var endingLocation : Location?
    
    @IBOutlet weak var routeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
        self.routeButton.backgroundColor = UIColor(CGColor: Colors.TableViewGradient.End)
        self.view.backgroundColor = UIColor(CGColor: Colors.IndicatorBackground)
        self.view.opaque = true
        self.view.alpha = 1
    }
    
    
    @IBAction func addRoute(sender: AnyObject) {
            if let endLocation = self.endingLocation{
                if let startLocation = self.startingLocation {
                    //Delegate stuff to send back to the RoutesViewController
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

    @IBAction func back(sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }


}
