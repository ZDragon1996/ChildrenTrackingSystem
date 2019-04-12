//
//  ChildDetailView.swift
//  ChildrenTrackingSystem
//
//  Created by Jialong Zhang on 12/3/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//

import UIKit
import Firebase


extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        
    
        inputAccessoryView = doneToolbar
    }
}

class ChildDetailView: UITableViewController, UITextFieldDelegate {

    var childInfo: Child?
    var parentInfo: Parent?
    var addressInfo: Address?
    
    @IBOutlet weak var childNameTextField: UITextField!
    @IBOutlet weak var childEmailTextField: UITextField!
    @IBOutlet weak var parentNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var parentEmailTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var childNameEditButton: UIButton!
    @IBOutlet weak var parentNameEditButton: UIButton!
    @IBOutlet weak var phoneNumberEditButton: UIButton!
    @IBOutlet weak var streetEditButton: UIButton!
    @IBOutlet weak var cityEditButton: UIButton!
    @IBOutlet weak var stateEditButton: UIButton!
    @IBOutlet weak var zipCodeEditButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childNameTextField.delegate = self
        parentNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        streetTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipCodeTextField.delegate = self
        
        
        configureView()
        
        
        
        //fetchData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func configureView(){
        childNameTextField.text = childInfo?.name
        childEmailTextField.text = childInfo?.email
        parentNameTextField.text = parentInfo?.name
        parentEmailTextField.text = parentInfo?.email
        phoneNumberTextField.text = parentInfo?.phoneNumber
        streetTextField.text = addressInfo?.street
        cityTextField.text = addressInfo?.city
        stateTextField.text = addressInfo?.state
        zipCodeTextField.text = addressInfo?.zipCode
        
    }
    
    
    func detectDataChanged() -> Bool{
        
        return  parentNameTextField.text != parentInfo?.name
            || parentEmailTextField.text != parentInfo?.email
            || phoneNumberTextField.text != parentInfo?.phoneNumber
            || childNameTextField.text != childInfo?.name
            || childEmailTextField.text != childInfo?.email
            || streetTextField.text != addressInfo?.street
            || cityTextField.text != addressInfo?.city
            || stateTextField.text != addressInfo?.state
            || zipCodeTextField.text != addressInfo?.zipCode
  
        // return true if data has been changed
        
    }//end detectDataChange()
    
    @IBAction func saveButtonAction() {
        if detectDataChanged(){
            saveAlertConfirmAction()
        }else{
            utility.alert("Notice!", "Nothing has been changed")
            self.present(utility.alert, animated: false, completion: nil)
        }
        
    }
    
    
    
    func saveAlertConfirmAction(){
        let refreshAlert = UIAlertController(title: "Warning!", message: "Data has been changed.\nAre you sure you want to change the data?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.saveData()
           
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func saveData(){
        let ref = Database.database().reference().child("Users").child((parentInfo?.uid)!).child("Parent")
        
        guard
            let newParentName = self.parentNameTextField.text,
            let newPhoneNumber = self.phoneNumberTextField.text,
            let newChildName = self.childNameTextField.text,
            let newStreet = self.streetTextField.text,
            let newCity = self.cityTextField.text,
            let newState = self.stateTextField.text,
            let newZipCode = self.zipCodeTextField.text
        
            else{return}
        
        //make sure detail view also updated the data.
        parentInfo?.name = newParentName
        parentInfo?.phoneNumber = newPhoneNumber
        childInfo?.name = newChildName
        addressInfo?.street = newStreet
        addressInfo?.city = newCity
        addressInfo?.state = newState
        addressInfo?.zipCode = newZipCode
        
        //update parent info
        ref.child("Parent Info").updateChildValues(["Name": newParentName])
        ref.child("Parent Info").updateChildValues(["Phone Number": newPhoneNumber])
        
        //update child info
        ref.child("Child").child((childInfo?.uid)!).child("Child Info").updateChildValues(["Name": newChildName])
        
        //update address info
        ref.child("Address").updateChildValues(["Street": newStreet])
        ref.child("Address").updateChildValues(["City": newCity])
        ref.child("Address").updateChildValues(["State": newState])
        ref.child("Address").updateChildValues(["Zip Code": newZipCode])
        
        
        // back to master view, reload the table view
        self.performSegue(withIdentifier: "relordDataView", sender: self)
        
        
        
    }
    
    
    
    
    @IBAction func childNameEditButtonAction() {
         childNameTextField.isEnabled = true
         childNameTextField.becomeFirstResponder()
         childNameTextField.textColor = UIColor.black
         childNameEditButton.isEnabled = false

    }
    
    @IBAction func parentNameEditButtonAction() {
        parentNameTextField.isEnabled = true
        parentNameTextField.becomeFirstResponder()
        parentNameTextField.textColor = UIColor.black
        parentNameEditButton.isEnabled = false
    }
    
  
    
    @IBAction func phoneNumberEditButtonAction() {
        phoneNumberTextField.addDoneButtonToKeyboard(myAction:  #selector(phoneNumberTextField.resignFirstResponder))
        
        phoneNumberTextField.isEnabled = true
        phoneNumberTextField.becomeFirstResponder()
        phoneNumberTextField.textColor = UIColor.black
        phoneNumberEditButton.isEnabled = false
       
        
    }
    
    @IBAction func streetEditButtonAction() {
        streetTextField.isEnabled = true
        streetTextField.becomeFirstResponder()
        streetTextField.textColor = UIColor.black
        streetEditButton.isEnabled = false
    }
    
    @IBAction func cityEditButtonAction() {
        cityTextField.isEnabled = true
        cityTextField.becomeFirstResponder()
        cityTextField.textColor = UIColor.black
        cityEditButton.isEnabled = false
    }
    
    @IBAction func stateEditButtonAction() {
        stateTextField.isEnabled = true
        stateTextField.becomeFirstResponder()
        stateTextField.textColor = UIColor.black
        stateEditButton.isEnabled = false
    }
    
    @IBAction func zipCodeEditButtonAction() {
        zipCodeTextField.isEnabled = true
        zipCodeTextField.becomeFirstResponder()
        zipCodeTextField.textColor = UIColor.black
        zipCodeEditButton.isEnabled = false
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        childNameTextField.resignFirstResponder()
        parentNameTextField.resignFirstResponder()
        streetTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
        zipCodeTextField.resignFirstResponder()
        
        childNameEditButton.isEnabled = true
        parentNameEditButton.isEnabled = true
        streetEditButton.isEnabled = true
        cityEditButton.isEnabled = true
        stateEditButton.isEnabled = true
        zipCodeEditButton.isEnabled = true
        
        return true
    }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = UIColor.lightGray
        textField.isEnabled = false
        phoneNumberEditButton.isEnabled = true
 
    }
    
   
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 3
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 3
//    }

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
