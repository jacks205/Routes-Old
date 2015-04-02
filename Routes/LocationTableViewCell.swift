//
//  LocationTableViewCell.swift
//  Routes
//
//  Created by Mark Jackson on 3/29/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removePinImage()
    }
    
    func removePinImage(){
        for subView in self.contentView.subviews{
            if subView.tag == 100{
                subView.removeFromSuperview()
            }
        }
    }
    
    
}
