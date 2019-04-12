//
//  LocationTracking.swift
//  ChildrenTrackingSystem
//
//  Created by Jialong Zhang on 10/26/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//


/*CLLocationManagerDelegate~~
 This methods use to receive events from an associated locationvarnager object.
 
 Add new pair in info.plist:
 
 ~WheninUse - Privacy - Location when in use usage description
 ~Always - Privacy - Location always usage description
 
 ========================================================================================================
 3 main types of location updates in ios:
 1.Significant Location Change - low power, notified only when the user make a large location change.
 2.Standard Location Services - get a user's location and to track the location change.
 3.Region Monitoring - When user cross the boundary of a geographic region or a bluetooth region.
 ========================================================================================================
 2 types of location authorization in ios:
 1.WhenInUse - when the application is in the foreground and in use.
 2.Always - requests location both in the foreground and background. (significant location change and region monitoring require this)
 ========================================================================================================
 */


import Foundation
import CoreLocation //location framework in swift


protocol AccessCoordinate: class {
    func displayCoordinate()
}

protocol LocationTrackingDelegate: class {
    func getCoordinates(_ coordinate: String) -> String
   
}



class LocationTracking: NSObject, CLLocationManagerDelegate{

    private let locationTracking = CLLocationManager()
    let timeFormat = Formatter()
   
    var getUserTimeZone:String{
        return TimeZone.current.abbreviation()  ?? ""
    }
    
    override init() {
        super.init()
        locationTracking.delegate = self
        
   
    }// override init method because we are inheriting from NSObject class
 
    func requestLocationAuthorization() throws {
        let authStatus = CLLocationManager.authorizationStatus() // return enum value
        
        if authStatus == .restricted || authStatus == .denied{
            throw LocationError.disallowedByUser // throw error when disallowed by user
        }
        else if authStatus == .notDetermined{
            locationTracking.requestAlwaysAuthorization()
        }
        else{
            return
        }
    }//end requestLocationAuthorization()
    
    
    func requestLocation(){
        locationTracking.requestLocation()
        
    }//end requestLocation()
   
    


    func  locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationTracking.requestWhenInUseAuthorization()
        }
        else if status == .authorizedAlways{
            locationTracking.requestAlwaysAuthorization()
        }

    } //end locationManager - didChangeAuthorization
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(LocationError.unknownError)
    }//end locationManager - didFailWithError
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{
             print(LocationError.unableToFindLocation)
            return
        }
        
      
        Coordinate.latitude = location.coordinate.latitude //store latitude
        Coordinate.longitude = location.coordinate.longitude // store longitude
        Coordinate.location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        Formatter.timeStamp = location.timestamp // store timeStamp

       let currentTime = timeFormat.formatTime(timestamp: location.timestamp, timeZone: getUserTimeZone)
        //get userTimeZone, formatTime
        Coordinate.description = "Location:\nDate and Time: \(currentTime)\nlatitude: \(location.coordinate.latitude) \nlongitude: \(location.coordinate.longitude)"
        
        //display Date, time, latitude, and longitude
        print(Coordinate.description)
       
   
    }//end locationManager - didUpdateLocation
    
    
}//end LocationTracking class
