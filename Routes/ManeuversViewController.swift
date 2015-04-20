//
//  ManeuvarsViewController.swift
//  Routes
//
//  Created by Mark Jackson on 4/19/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import UIKit

class ManeuversViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var direction : Direction?
    var maneuvars : [Maneuver]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeTableView()
        println(self.direction)
        if let maneuvars = self.direction?.maneuvars {
            self.maneuvars = maneuvars
        }else{
            self.maneuvars = []
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func initializeTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    

    //MARK: Table View Delegate/Datasource Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.maneuvars!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ManeuverCell") as! UITableViewCell
        
        if let maneuver = self.maneuvars!.get(indexPath.row){
            cell.textLabel!.text = maneuver.instruction
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        println("didSelectRowAtIndexPath")
    }


}
