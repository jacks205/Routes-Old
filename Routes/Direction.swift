//
//  Direction.swift
//  Routes
//
//  Created by Mark Jackson on 3/22/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//
import CoreLocation

class Direction {
    var startingLocation : String?
    var endingLocation : String?
    var viaDirections : [String]?

    var address : String?
    var city : String?
    var zipcode : String?
    var state : String?
    
    var distance : Int?
    var baseTime : Int?
    var trafficTime : Int?
    var travelTime : Int?
    
    var latitude : Float?
    var longitude : Float?
    
    init(startingLocation : String, endingLocation : String, viaDirections : [String], address : String, city: String, state : String, zipcode : String){
        self.startingLocation = startingLocation
        self.endingLocation = endingLocation
        self.viaDirections = viaDirections
        self.address = address;
        self.city = city;
        self.state = state;
        self.zipcode = zipcode;
    }
    
    func buildUrl(currentLocation : CLLocationCoordinate2D) -> NSURL?{
        let stringUrl = "\(Constants.URL_1)app_id=\(Constants.APP_ID)&app_code=\(Constants.APP_CODE)&waypoint0=geo!\(currentLocation.latitude),\(currentLocation.longitude)&waypoint1=geo!\(self.latitude),\(self.longitude)&\(Constants.URL_2)"
        return NSURL(string: stringUrl)
    }
    
}