//
//  TempTimeEstimateCell.swift
//  Routes
//
//  Created by Mark Jackson on 3/22/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//

import UIKit

struct RouteTableViewCellConst {
    static let IndicatorRectXOffset : CGFloat = 0.05
    static let TrafficIndicatorOffsetPercentage : CGFloat = 0.75
    static let IndicatorBaseWidthPercentage : CGFloat = 0.4
    static let IndicatorBaseHeight : CGFloat = 30
}

class RouteTableViewCell: UITableViewCell {
    @IBOutlet weak var startToEndLocation : UILabel!
    @IBOutlet weak var viaRouteDescription : UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var totalDistance : String!
    var totalTravelTime : String!
    
    var trafficColor : UIColor!
    
    override func drawRect(rect: CGRect) {
        //Drawing code
        let ref  = UIGraphicsGetCurrentContext()
//        println("drawRect")
//        println("drawRect")
        //Draw Line across cell
        let lineWidth :CGFloat = 1
        let indicatorYPosition : CGFloat = self.frame.height * RouteTableViewCellConst.TrafficIndicatorOffsetPercentage
        self.drawWidthLine(ref, lineWidth: lineWidth, yPosition: indicatorYPosition)
        
        //Draw rounded rectangle
        let indicatorCornerRadius : CGFloat = 70
        let indicatorXPosition : CGFloat = self.frame.width * RouteTableViewCellConst.IndicatorRectXOffset
        let baseWidth : CGFloat = self.frame.width * RouteTableViewCellConst.IndicatorBaseWidthPercentage
        let indicatorRect = CGRectMake(indicatorXPosition, indicatorYPosition -  RouteTableViewCellConst.IndicatorBaseHeight / 2, baseWidth, RouteTableViewCellConst.IndicatorBaseHeight)
        self.drawTrafficIndicatorBase(indicatorRect, cornerRadius: indicatorCornerRadius)
        
        //Fill rounded rectangle
        //TODO: Logic for setting colors
        let colorLight : CGColorRef = Colors.TrafficColors.GreenLight
        let colorDark : CGColorRef = Colors.TrafficColors.GreenDark
        let percentageFill : CGFloat = 0.7
        let fillWidth : CGFloat = baseWidth * percentageFill
        let fillRect : CGRect = CGRectMake(indicatorXPosition, indicatorYPosition -  RouteTableViewCellConst.IndicatorBaseHeight / 2, fillWidth, RouteTableViewCellConst.IndicatorBaseHeight)
        self.fillTrafficIndicatorBase(ref, rect: fillRect, cornerRadius: indicatorCornerRadius, colorLight: colorLight, colorDark: colorDark, fillWidth: fillWidth)
    }
    
    func fillTrafficIndicatorBase(ref : CGContextRef, rect : CGRect, cornerRadius : CGFloat, colorLight : CGColorRef, colorDark: CGColorRef, fillWidth : CGFloat){
        CGContextSaveGState(ref)
        let gradient : CGGradientRef = CGGradientCreateWithColors(Colors.genericRGBSpace(), [colorLight, colorDark], nil)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.fill()
        path.addClip()
        CGContextDrawLinearGradient(ref, gradient, CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)), CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)), 0)
        CGContextRestoreGState(ref)
    }
    
    func drawTrafficIndicatorBase(rect : CGRect, cornerRadius : CGFloat){
        let color : UIColor = UIColor(CGColor: Colors.IndicatorBackground)
        color.setFill()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.fill()
    }
    
    func drawWidthLine(ref : CGContextRef, lineWidth : CGFloat, yPosition : CGFloat){
        CGContextSaveGState(ref)
        CGContextSetLineWidth(ref, lineWidth)
        CGContextSetStrokeColorWithColor(ref, Colors.IndicatorBackground)
        CGContextMoveToPoint(ref, 0, yPosition)
        CGContextAddLineToPoint(ref, self.frame.width, yPosition)
        CGContextStrokePath(ref)
        CGContextRestoreGState(ref)
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
