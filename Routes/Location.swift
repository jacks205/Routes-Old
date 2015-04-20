//
//  Location.swift
//  Routes
//
//  Created by Mark Jackson on 3/31/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//
import MapKit

class Location {
    
    let streetNumber : String?
    let streetAddress : String?
    let city : String?
    let state : String?
    let county : String?
    let postalCode : String?
    let country : String?

    let location : CLLocation?
    
    let areaOfInterest : String?
    var shortName : String?
    
    let mapItem : MKMapItem?
    
    init(areaOfInterest : String, streetNumber : String, streetAddress : String, city : String, state : String, county : String, postalCode : String, country : String){
        self.areaOfInterest = areaOfInterest
        self.streetNumber = streetNumber
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.county = county
        self.postalCode = postalCode
        self.country = country
        
        self.location = nil
        self.mapItem = nil
    }
    
    init(addressString : String, mapItem : MKMapItem){
        self.mapItem = mapItem
        self.streetNumber = mapItem.placemark.subThoroughfare
        self.streetAddress = mapItem.placemark.thoroughfare
        self.city = mapItem.placemark.locality
        self.state = mapItem.placemark.administrativeArea
        self.county = mapItem.placemark.subAdministrativeArea
        self.postalCode = mapItem.placemark.postalCode
        self.country = mapItem.placemark.country
        self.location = mapItem.placemark.location
        self.areaOfInterest = addressString
//        if let areaOfInt = getEstablishmentName(addressString){
//            self.areaOfInterest = areaOfInt
//        }else{
//            if let areaOfInt = place.areasOfInterest{
//                self.areaOfInterest = areaOfInt[0] as String
//            }else{
//                self.areaOfInterest = place.name
//            }
//        }
    }
    
    func buildAddressString() -> String?{
        var address : String = ""
        if let streetNumber = self.streetNumber{
            address += streetNumber + " "
        }
        if let streetAddress = self.streetAddress{
            address += streetAddress + " "
        }
        address += "\n"
        if let city = self.city{
            address += city + ", "
        }
        if let state = self.state{
            address += state + " "
        }
        if let postalCode = self.postalCode{
            address += postalCode
        }
        return address
    }
    
    func print(){
        println(self.areaOfInterest)
        println(self.streetNumber)
        println(self.streetAddress)
        println(self.city)
        println(self.state)
        println(self.county)
        println(self.postalCode)
        println(self.country)
        println(self.location)
    }
    
    private func getEstablishmentName(addressString : String) -> String?{
        let range : Range<String.Index>? = addressString.rangeOfString(",")
        if let rangeToComma = range{
           return addressString.substringToIndex(rangeToComma.startIndex)
        }
        return nil
    }
    
    
}
