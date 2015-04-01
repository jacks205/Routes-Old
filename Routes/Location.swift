//
//  Location.swift
//  Routes
//
//  Created by Mark Jackson on 3/31/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//
import CoreLocation

class Location {
    
    let streetNumber : String!
    let streetAddress : String!
    let city : String!
    let state : String!
    let county : String!
    let postalCode : String!
    let country : String!

    let location : CLLocation!
    
    let areaOfInterest : String!
    
    init(areaOfInterest : String, streetNumber : String, streetAddress : String, city : String, state : String, county : String, postalCode : String, country : String){
        self.areaOfInterest = areaOfInterest
        self.streetNumber = streetNumber
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.county = county
        self.postalCode = postalCode
        self.country = country
    }
    
    init(addressString : String, place : CLPlacemark){
        self.streetNumber = place.subThoroughfare
        self.streetAddress = place.thoroughfare
        self.city = place.locality
        self.state = place.administrativeArea
        self.county = place.subAdministrativeArea
        self.postalCode = place.postalCode
        self.country = place.country
        self.location = place.location
        if let areaOfInt = getEstablishmentName(addressString){
            self.areaOfInterest = areaOfInt
        }else{
            if let areaOfInt = place.areasOfInterest{
                self.areaOfInterest = areaOfInt[0] as String
            }else{
                self.areaOfInterest = place.name
            }
        }
    }
    
    private func getEstablishmentName(addressString : String) -> String?{
        let range : Range<String.Index>? = addressString.rangeOfString(",")
        if let rangeToComma = range{
           return addressString.substringToIndex(rangeToComma.startIndex)
        }
        return nil
    }
    
    
}
