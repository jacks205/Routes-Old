//
//  Location.swift
//  Routes
//
//  Created by Mark Jackson on 3/31/15.
//  Copyright (c) 2015 Mark Jackson. All rights reserved.
//
import MapKit

class Location {
    
    var streetNumber : String?{
        get {
            return self.mapItem?.placemark.subThoroughfare
        }
    }
    var streetAddress : String?{
        get {
            return self.mapItem?.placemark.thoroughfare
        }
    }
    var city : String?{
        get {
            return self.mapItem?.placemark.locality
        }
    }
    var state : String?{
        get {
            return self.mapItem?.placemark.administrativeArea
        }
    }
    var county : String?{
        get {
            return self.mapItem?.placemark.subAdministrativeArea
        }
    }
    var postalCode : String?{
        get {
            return self.mapItem?.placemark.postalCode
        }
    }
    var country : String?{
        get {
            return self.mapItem?.placemark.country
        }
    }

    var location : CLLocation?{
        get {
            return self.mapItem?.placemark.location
        }
    }
    
    let areaOfInterest : String?
    var shortName : String?
    
    let mapItem : MKMapItem?
    
    init(areaOfInterest : String, mapItem : MKMapItem){
        self.mapItem = mapItem
        self.areaOfInterest = areaOfInterest
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
