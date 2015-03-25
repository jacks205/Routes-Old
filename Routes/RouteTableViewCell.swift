//
//  TempTimeEstimateCell.swift
//  Routes
//
//  Created by Mark Jackson on 3/22/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    @IBOutlet weak var startToEndLocation : UILabel!
     @IBOutlet weak var viaRouteDescription : UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var totalDistance : String!
    var totalTravelTime : String!
    
    var trafficColor : UIColor!
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        //Initialize
                
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        //Drawing code
    }
    
    func setViaRouteDescription(mainRoads : [String]?){
        var description : String = "via"
        if let roads = mainRoads{
            for (var i = 0; i < roads.count; ++i){
                description += " \(roads[i])"
                if(i == roads.count - 2){
                    description += " and"
                }
                else if(i < roads.count - 2){
                    description += " ,"
                }
            }
        }
        self.viaRouteDescription.text = description
    }
    
    
    
    
}
