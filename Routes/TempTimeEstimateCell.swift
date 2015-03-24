//
//  TempTimeEstimateCell.swift
//  Routes
//
//  Created by Mark Jackson on 3/22/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import UIKit

class TempTimeEstimateCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    
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
    
    
    
    
}
