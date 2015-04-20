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
    var maneuvars : [Maneuver]?
    
    var distance : Int?
    var baseTime : Int?
    var trafficTime : Int?
    
    init(startingLocation : Location, endingLocation : Location,  viaDirections : [String]?){
        self.startingLocation = startingLocation
        self.endingLocation = endingLocation
        self.viaDirections = viaDirections
    }
    
    func buildUrl() -> NSURL?{
        var stringUrl : String = "\(Constants.HERE.URL.DOMAIN)app_id=\(Constants.HERE.APP_ID)&app_code=\(Constants.HERE.APP_CODE)"
        println("Creating URL")
        if let startLocation = self.startingLocation{
            if let coordinate = startLocation.location?.coordinate{
                stringUrl += "&waypoint0=geo!\(coordinate.latitude),\(coordinate.longitude)"
            }
        }else{
            return nil
        }
        if let endLocation = self.endingLocation{
            if let coordinate = endLocation.location?.coordinate{
                stringUrl += "&waypoint1=geo!\(coordinate.latitude),\(coordinate.longitude)"
            }
        }else{
            return nil
        }
        stringUrl += "&\(Constants.HERE.URL.SETTINGS)"
        println("Created URL")
        return NSURL(string: stringUrl)
    }
    
}

struct Maneuver {
    var location : CLLocationCoordinate2D?
    var instruction : String?
    var length : Float?
    var travelTime : Float?
    
    init(location :CLLocationCoordinate2D?, instruction : String?, length : Float?, travelTime : Float?){
        self.location = location
        self.instruction = instruction
        self.length = length
        self.travelTime = travelTime
    }
    
    init(){
        
    }
    
}