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
    
    func buildUrl(currentLocation : CLLocationCoordinate2D) -> NSURL?{
        let stringUrl = "\(Constants.URL_1)app_id=\(Constants.APP_ID)&app_code=\(Constants.APP_CODE)&waypoint0=geo!\(startingLocation?.location.coordinate.latitude),\(startingLocation?.location.coordinate.longitude)&waypoint1=geo!\(endingLocation?.location.coordinate.latitude),\(endingLocation?.location.coordinate.longitude)&\(Constants.URL_2)"
        return NSURL(string: stringUrl)
    }
    
}