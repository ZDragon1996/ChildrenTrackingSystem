//
//  Coordinate.swift
//  ChildrenTrackingSystem
//
//  Created by Jialong Zhang on 10/26/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate{
    static var latitude: Double = 0.0
    static var longitude: Double = 0.0
    static var description: String = "location is not updated yet, please wait."
    static var location : CLLocation = CLLocation(latitude: 0, longitude: 0)
    static var gotLocation: Bool = false
    
}

//extension Coordinate: CustomStringConvertible{
//    var description: String{
//        return "\(latitude),\(longitude)"
//    }
//}
