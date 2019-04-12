//
//  StudentListController.swift
//  ChildrenTrackingSystem
//
//  Created by Bubble on 11/28/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ChildListController: UITableViewController,UISplitViewControllerDelegate, UISearchBarDelegate {
   
    
    @IBOutlet weak var logOutBarButton: UIBarButtonItem!
   
   
    var childArray = [Child]()
    var parentArray = [Parent]()
    var addressArray = [Address]()
    var GPSArray = [GPS]()
    
    
 
  
    
   let currentUserUID  = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewController?.delegate = self//  requires to display master view before detail view
 
        if !admin.isLogOut && currentUserUID == admin.adminUID{
             fetchData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print("inside the fetchData")
           
           
            
        }else{
            self.navigationItem.rightBarButtonItem = nil
            fetchParentData()
            
            print("inside the parentFetchData")
           
        }
        
      
        
    }//end viewDidLoad()
   
  
    @IBAction func logOutBarButtonAction(_ sender: UIBarButtonItem) {
        if admin.adminUID == currentUserUID{
            admin.isLogOut = true
            print("Log out success")
            print("Log out status: \(admin.isLogOut)")
        }
    
  
      
        do{
            
            try Auth.auth().signOut()
            
            
            print("Log out success")
        }catch{
            print("Log out error")
        }
          performSegue(withIdentifier: "logOut", sender: self)
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }//master view display before detail view
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }//height for each cell

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return childArray.count // return number of person
    }
    

    
    
    //Marks: Firebase read data
    func fetchParentData(){
           let ref = Database.database().reference().child("Users").child(currentUserUID!).child("Parent")//path
        
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
             //snapshot path at Parent right now
                
            let parent = Parent() //create parent
            let address = Address() //create address
                
            let value = snapshot.childSnapshot(forPath: "Parent Info").value as? NSDictionary// get value under parent info
            
            parent.name = value?["Name"] as? String //get parent name from Parent Info and save in parent
            parent.email = value?["Email"] as? String //get parent email
            parent.phoneNumber = value?["Phone Number"] as? String //get parent phone number  and save
            parent.uid = self.currentUserUID// save uid in parent
            self.parentArray.append(parent) // add parent to parentArray
                
            
                
            let addressValue = snapshot.childSnapshot(forPath: "Address").value as? NSDictionary // get value under Address
            address.street = addressValue?["Street"] as? String // get address from Address and save in address
            address.city = addressValue?["City"] as? String // get city and save
            address.state = addressValue?["State"] as? String // get state and save
            address.zipCode = addressValue?["Zip Code"] as? String // get zip Code and save
            self.addressArray.append(address) // add address to addressArray
        
            snapshot.ref.child("Child").observe(DataEventType.childAdded , with: { (snapshot2) in
            //snapshot2.key is equal to child uid
                if let childDictionary =  snapshot2.childSnapshot(forPath: "Child Info").value as? [String: AnyObject]{
                    let child = Child()//create child
                    child.name = childDictionary["Name"] as? String // get child name and save
                    child.email = childDictionary["Email"] as? String // get child email and save
                    child.uid = snapshot2.key // get child uid and save
                    child.parentUID = parent.uid
                    self.childArray.append(child)
                    
                  //  self.filteredChildArray.append(child)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }//!!important reloadData()
                    
                }//end if let childDictionary
          
        })// end snapshot2
                
       
        })// end snapshot1
        {(error) in
            print(error.localizedDescription)
        }
        
    }//end parentFetchData()
    
    
    // MARK: - FeachData()
    func fetchData(){
        let ref = Database.database().reference()

        ref.child("Users").observe(DataEventType.childAdded, with: { (snapshot) in
            print("Snapshot\(snapshot)")
            //snapshot = parent uid
            
            if let parentDictionary = snapshot.childSnapshot(forPath: "Parent").childSnapshot(forPath: "Parent Info").value as? [String: AnyObject]{
                let parent = Parent() //create parent
                
                // get parent info from database
                parent.name = parentDictionary["Name"] as? String
                parent.email = parentDictionary["Email"] as? String
                parent.phoneNumber = parentDictionary["Phone Number"] as? String
                parent.uid = snapshot.key
                self.parentArray.append(parent) //append to parentArray for static cell
            }
    
            if let addressDictionary = snapshot.childSnapshot(forPath: "Parent").childSnapshot(forPath: "Address").value as? [String: AnyObject]{
                let address = Address()// create address
                
                //get address info from database
                address.street = addressDictionary["Street"] as? String
                address.city = addressDictionary["City"] as? String
                address.state = addressDictionary["State"] as? String
                address.zipCode = addressDictionary["Zip Code"] as? String
                self.addressArray.append(address) //append to childArray for static cell
                
                
            }
            
           snapshot.ref.child("Parent").child("Child").observe(DataEventType.childAdded , with: { (snapshot2) in
            //snapshot2 = child uid
           
            if let childDictionary =  snapshot2.childSnapshot(forPath: "Child Info").value as? [String: AnyObject]{
                let child = Child()// create child
                
                //get child info from database
                child.name = childDictionary["Name"] as? String
                child.email = childDictionary["Email"] as? String
                child.uid = snapshot2.key
                child.parentUID = snapshot.key
                self.childArray.append(child)
                // self.filteredChildArray.append(child)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }//!!!importnat to reloardData or whole table will display nothing

            }//end if let childDictionary
            
         
        }, withCancel: nil) // end snapshot1
            
              }, withCancel: nil)//end snapshot2
 
        
    }//end fetchData()
    
 
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChildListCell", for: indexPath) as? ChildListCell else{
             fatalError()
        }// create reuseable cells, error checking
        
            let child = childArray[indexPath.row] 
    
            cell.profileChildName.text = child.name
            cell.profileChildEmail.text = child.email
        
        return cell
   }
    
  
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let childInfo = childArray[indexPath.row] //get each children
                let parentInfo = parentArray[indexPath.row] //get each parents
                let addressInfo = addressArray[indexPath.row] //get each addresses
                
                guard let navigationController = segue.destination as? UINavigationController, let childDetailView = navigationController.topViewController as? ChildDetailView else{return}
                // show correct data when selecting different cells
                childDetailView.childInfo = childInfo
                childDetailView.parentInfo = parentInfo
                childDetailView.addressInfo = addressInfo 
                
            }
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
