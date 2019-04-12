//
//  Utility.swift
//  ChildrenTrackingSystem
//
//  Created by Jialong Zhang on 11/28/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//

import Foundation
import UIKit

protocol AdminAction{
    
}

protocol ParentAction{
    
}

protocol ChildAction{
    func disableTextField() //disable child being able to edit the text inside of a text field
}


extension String{
    var containOnlyNumbers: Bool{
        guard self.count > 0 else{return false} //teturn false if less than 0
        let numbers: Set<Character> = ["0","1","2","3","4","5","6","7","8","9"] // 0-9 in the set
        return Set(self).isSubset(of: numbers)// return if string contain only numbers
    }
}







class Utility{
    
    var alert = UIAlertController()
    func alert(_ title:String, _ message: String){
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
    }))

}//end alert

    
    func formatPhoneNumber(_ phoneNumber: String) -> String?{
        //format phone number
        //example:  1234567890
        //result:  (123)-456-7890

        let symbol = "-"
        let firstThreeNumberAddParenthese = "(\(phoneNumber.prefix(3)))" // first three digtis, add parentheses around it
        let start = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
        let end = phoneNumber.index(phoneNumber.startIndex, offsetBy: 6)
        let range = start..<end // from index 3 to index 5, not include 6
        
        let middleThreeNumber =  phoneNumber[range] // 3 digits phone number at middle
        
        let endingPhoneNumber = phoneNumber.suffix(4) // last four digits of phone number
        
        let formattedPhoneNumber = firstThreeNumberAddParenthese + symbol + middleThreeNumber + symbol + endingPhoneNumber // add all formated digits
        
        return formattedPhoneNumber
    }//end formatPhoneNumber(_) -> String?



}//end Utility class
