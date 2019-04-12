//
//  Profile.swift
//  ChildrenTrackingSystem
//
//  Created by Jialong Zhang on 11/28/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//

import Foundation
import UIKit

//struct Profile {
//    let chidName: String
//    let childEmail: String
//
//}
//
//extension Profile{
//    struct Key{
//        static let name = "Name"
//        static let email = "Email"
//        static let phoneNumber = "Phone Number"
//    }
//    init?(dictionary: [String: String]){
//        guard let nameString = dictionary[Key.name],
//        let emailString = dictionary[Key.email] else{return nil}
//        self.chidName = nameString
//        self.childEmail = emailString
//    }
//}


class Child: NSObject{
    var name: String?
    var email: String?
    var role: String?
    var uid: String?
    var parentUID: String?
}


class Parent: NSObject{
    var name: String?
    var email: String?
    var phoneNumber: String?
    var uid: String?
}

class Address: NSObject{
    var street: String?
    var city: String?
    var state: String?
    var zipCode: String?
}

struct GPS{
    var dateAndTime: String?
    var latitude = Coordinate.location.coordinate.latitude
    var longitude = Coordinate.location.coordinate.longitude
}

extension Child{
    static func ==(lhs: Child, rhs: Child) -> Bool{
        return lhs.name == rhs.name && lhs.email == rhs.email && lhs.uid == rhs.uid
    }
    
  
    
}

enum selectedScope: Int{
    case name = 0
    case email = 1
}
