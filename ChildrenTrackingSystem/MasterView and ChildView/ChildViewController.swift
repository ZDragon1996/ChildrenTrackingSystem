//
//  ChildViewController.swift
//  ChildrenTrackingSystem
//
//  Created by Bubble on 12/7/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//

import UIKit
import Firebase


class ChildViewController: UIViewController {

  
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var DemoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

       // showImage()
        // Do any additional setup after loading the view.
        
        self.requestLastLoction()
        
       
    }
    
    @IBAction func logOutButtonAction(_ sender: UIBarButtonItem) {
        
        self.requestLastLoction()
        performSegue(withIdentifier: "childLogOut"
            , sender:  self)
        
        do{
            try Auth.auth().signOut()
            print("Log out success")
        }catch{
            print("Log out error")
        }
        
      
    }
    
    
    
    
    
    
    
    func requestLastLoction(){
        let currentUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("GPS").child((currentUser?.uid)!).childByAutoId()
        locationTracking.requestLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5 ){
            ref.updateChildValues(["Date and Time": time.formatTime(timestamp: Formatter.timeStamp, timeZone: locationTracking.getUserTimeZone), "Latitude": Coordinate.latitude, "Longitude": Coordinate.longitude])
        }
        
    }
    
    
    
 
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
