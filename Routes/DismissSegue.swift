//
//  DismissSegue.swift
//  Routes
//
//  Created by Mark Jackson on 3/30/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//
import UIKit
class DismissSegue : UIStoryboardSegue {
    override func perform() {
        let vc : UIViewController = self.sourceViewController as UIViewController
        vc.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
