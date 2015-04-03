//
//  Direction.swift
//  Routes
//
//  Created by Mark Jackson on 3/22/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//
import CoreLocation

class Direction {
    var startingLocation : Location?
    var endingLocation : Location?
    var viaDirections : [String]?
    
    var distance : Int?
    var baseTime : Int?
    var trafficTime : Int?
    
    init(startingLocation : Location, endingLocation : Location,  viaDirections : [String]){
        self.startingLocation = startingLocation
        self.endingLocation = endingLocation
        self.viaDirections = viaDirections
    }
    
    func buildUrl() -> NSURL?{
        var stringUrl : String = "\(Constants.URL_1)app_id=\(Constants.APP_ID)&app_code=\(Constants.APP_CODE)"
        println("Creating URL")
        if let startLocation = self.startingLocation{
            stringUrl += "&waypoint0=geo!\(startLocation.location.coordinate.latitude),\(startLocation.location.coordinate.longitude)"
        }else{
            return nil
        }
        if let endLocation = self.endingLocation{
            stringUrl += "&waypoint1=geo!\(endLocation.location.coordinate.latitude),\(endLocation.location.coordinate.longitude)"
        }else{
            return nil
        }
        stringUrl += "&\(Constants.URL_2)"
        println("Created URL")
        return NSURL(string: stringUrl)
    }
    
}