//
//  ErrorHandling.swift
//  ChildrenTrackingSystem
//
//  Created by Jialong Zhang on 10/26/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//

import Foundation


enum LocationError: Error{
    case disallowedByUser
    case unknownError
    case unableToFindLocation
    case loginUnknownError
}
