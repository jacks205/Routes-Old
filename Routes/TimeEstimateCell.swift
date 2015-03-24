//
//  TimeEstimateCell.swift
//  Routes
//
//  Created by Mark Jackson on 3/21/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//
import UIKit

class TimeEstimateCell: UITableViewCell {
    
    //ROW HEIGHT 189
    
    let pi : CGFloat = 3.14159265359
    //Traffic level color: (light, medium, heavy) traffic
    var trafficColorRef : CGColorRef?
    
    override func drawRect(rect: CGRect) {
        let ref = UIGraphicsGetCurrentContext()
        
        if let trafColorRef = self.trafficColorRef {
            drawTrafficColorLayer(ref, trafficColor: trafColorRef)
        }else{
            drawTrafficColorLayer(ref, trafficColor: Colors.MediumTrafficColor.Light)
        }
        CGContextSetShadowWithColor(ref, CGSize(width: 0, height: 0), 0, nil)
        drawDarkGrayLayer(ref)
        drawTimeEstimateView(ref, light: Colors.MediumTrafficColor.Light, medium: Colors.MediumTrafficColor.Medium, dark: Colors.MediumTrafficColor.Dark)
        let width : CGFloat = self.bounds.width * 0.3 / 3
        for(var i : CGFloat = 0; i < 3; ++i){
            let x = i * width
            drawIntegerSlot(ref, x: x, y: 2, width: width - 2, height: self.bounds.height / 2 * 2 / 3)
        }
        drawCenterLine(ref)
        drawSettingsCircle(ref)
        
    }
    
    //MARK: IB Outlet
    func settingsButtonClick(sender : UIButton){
        println("Settings!")
            
    }
    
    
    //MARK: Drawing Methods
    func drawIntegerSlot(ref : CGContext, x : CGFloat, y : CGFloat, width : CGFloat, height : CGFloat){
        CGContextSaveGState(ref)
        CGContextSetFillColorWithColor(ref, Colors.MediumTrafficColor.Medium)
        CGContextFillRect(ref, CGRectMake(x, y, width, height))
        let color = UIColor.whiteColor()
        let size : CGFloat = 35
        let font = UIFont(name: "Times", size: size)
        var number = NSMutableAttributedString(string: "2")
        number.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, 1))
        number.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, 1))
        number.drawAtPoint(CGPoint(x: width / 2 - size / 3, y: height / 2 - size / 2))
        CGContextRestoreGState(ref)
    }
    
    func drawTimeEstimateView(ref : CGContext, light : CGColorRef, medium : CGColorRef, dark : CGColorRef){
        CGContextSaveGState(ref)
        let width : CGFloat = self.bounds.width * 0.3
        let height : CGFloat = self.bounds.height / 2
        CGContextSetFillColorWithColor(ref, dark)
        CGContextFillRect(ref, CGRectMake(0, 0, width, height))
        CGContextRestoreGState(ref)
    }
    
    func drawCenterLine(ref : CGContext){
        CGContextSaveGState(ref)
        let lineWidth : CGFloat = 1.5
        CGContextSetLineWidth(ref, lineWidth)
        CGContextSetStrokeColorWithColor(ref, UIColor.blackColor().CGColor)
        CGContextMoveToPoint(ref, 0, self.bounds.height / 2)
        CGContextAddLineToPoint(ref, self.bounds.width, self.bounds.height / 2)
        CGContextStrokePath(ref)
        CGContextRestoreGState(ref)
    }
    
    func drawSettingsGear(position : CGPoint, width : CGFloat, height : CGFloat){
        let gear : UIImage? = UIImage(named: "gear-dark")
        if let icon = gear {
            let button : UIButton = UIButton(frame: CGRectMake((position.x - width / 2), (position.y - height / 2), width, height))
            button.setBackgroundImage(icon, forState: UIControlState.Normal)
            button.addTarget(self, action: "settingsButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
            self.contentView.addSubview(button)
        }else{
            println("No Gear Icon")
        }
    }
    
    func drawSettingsCircle(ref : CGContext){
        CGContextSaveGState(ref)
        
        //Length from right side of cell
        let percentageOffset : CGFloat = 0.85
        let radius : CGFloat = 35
        let x = self.bounds.width * percentageOffset
        let y = self.bounds.height / 2
        let startAngle : CGFloat = 0
        let endAngle : CGFloat = 2 * self.pi
        let lineWidth : CGFloat = 1.5
        
        CGContextSetFillColorWithColor(ref, Colors.defaultWhiteColor())
        CGContextSetStrokeColorWithColor(ref, UIColor.blackColor().CGColor)
        CGContextSetLineWidth(ref, lineWidth)
        CGContextAddArc(ref, x, y, radius, startAngle, endAngle, 1)
        CGContextDrawPath(ref, kCGPathFillStroke)
        drawSettingsGear(CGPoint(x: x, y: y), width: radius, height: radius)
        
        CGContextRestoreGState(ref)
    }
    
    func drawDarkGrayLayer(ref : CGContext){
        //Save default state
        CGContextSaveGState(ref)
        CGContextSetFillColorWithColor(ref, Colors.darkGrayColor())
//        CGContextSetStrokeColorWithColor(ref, UIColor.blackColor().CGColor)
//        CGContextSetLineWidth(ref, 2)
        CGContextAddRect(ref, CGRectMake(0, self.bounds.height / 2, self.bounds.width, self.bounds.height / 2))
        CGContextDrawPath(ref, kCGPathFill)
        CGContextRestoreGState(ref)
    }
    
    func drawTrafficColorLayer(ref : CGContext, trafficColor : CGColorRef){
        //Save default state
        CGContextSaveGState(ref)
        
        CGContextSetFillColorWithColor(ref, trafficColor)
        CGContextAddRect(ref, CGRectMake(0, 0, self.bounds.width, self.bounds.height))
        CGContextFillPath(ref)
        
        CGContextRestoreGState(ref)
    }
    
    //MARK: Convienence Methods
    func DEGREES_TO_RADIANS(degrees : Float) -> CGFloat{
        return pi * CGFloat(degrees) / 180;
    }
    
    
}
