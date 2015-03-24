//
//  Colors.swift
//  Routes
//
//  Created by Mark Jackson on 3/22/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//
import UIKit

struct Colors{
    //TODO: Delete Colors
    static var DarkGray : CGColorRef?
    static var DefaultWhite : CGColorRef?
    static var LightBlack : CGColorRef?
    struct MediumTrafficColor{
        static var Light : CGColorRef = CGColorCreate(Colors.genericRGBSpace(), [0.98,0.81,0.65,1])
        static var Medium : CGColorRef = CGColorCreate(Colors.genericRGBSpace(), [0.97,0.70,0.45,1])
        static var Dark : CGColorRef = CGColorCreate(Colors.genericRGBSpace(), [0.82,0.54,0.28,1])
    }
    //////////////////
    
    //New Design Colors
    static var ColorSpaceRef : CGColorSpaceRef?
    struct TableViewGradient {
        static var Start    : CGColorRef = CGColorCreate(Colors.genericRGBSpace(), [0.02, 0.02, 0.02, 1])
        static var End      : CGColorRef = CGColorCreate(Colors.genericRGBSpace(), [0.28, 0.34, 0.38, 1])
    }
    
    //TODO: Dark to Light Gradient
    struct TrafficColors {
        static var Green    : CGColorRef = CGColorCreate(Colors.genericRGBSpace(), [0.42, 0.72, 0.25, 1])
        static var Red      : CGColorRef = CGColorCreate(Colors.genericRGBSpace(), [0.89, 0.28, 0.45, 1])
        static var Yellow   : CGColorRef = CGColorCreate(Colors.genericRGBSpace(), [0.84, 0.80, 0.33, 1])
    }
    

    //MARK: Get Colors Convienence Methods
    static func genericRGBSpace() -> CGColorSpaceRef{
        if (Colors.ColorSpaceRef  == nil){
            Colors.ColorSpaceRef = CGColorSpaceCreateDeviceRGB();
        }
        return Colors.ColorSpaceRef!;
    }
    
    /////////////////
    //TODO: DELETE
    //Dark Gray for bottom layer of Cell
    static func darkGrayColor() -> CGColorRef{
        
        if (Colors.DarkGray == nil){
            var values : [CGFloat] = [0.2, 0.2, 0.2, 1];
            Colors.DarkGray = CGColorCreate(genericRGBSpace(), values);
        }
        return Colors.DarkGray!;
    }
    
    //Default white color for unchoosen traffic category
    static func defaultWhiteColor() -> CGColorRef{
        
        if (Colors.DefaultWhite == nil){
            var values : [CGFloat] = [232/255, 232/255, 232/255, 1];
            Colors.DefaultWhite = CGColorCreate(genericRGBSpace(), values);
        }
        return Colors.DefaultWhite!;
    }
    
    //Black circle for settings button
    static func lightBlackColor() -> CGColorRef{
        
        if (Colors.LightBlack == nil){
            var values : [CGFloat] = [0.14, 0.14, 0.14, 1];
            Colors.LightBlack = CGColorCreate(genericRGBSpace(), values);
        }
        return Colors.LightBlack!;
    }
    
}
