//
//  DateFormat.swift
//  ChildrenTrackingSystem
//
//  Created by Jialong Zhang on 10/28/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//

import Foundation




class Formatter{
 
    static var timeStamp = Date(timeIntervalSince1970: 0)
    let dateFormatter = DateFormatter()

    
    func formatTime(timestamp: Date, timeZone: String) -> String{
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeString = dateFormatter.string(from: timestamp)
        return timeString
    }
    
    func updateTime(requestLocationTime: Date){
        Formatter.timeStamp = requestLocationTime
    }
    
    
}
