//
//  AddInfoView.swift
//  ChildrenTrackingSystem
//
//  Created by Jialong Zhang on 11/28/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MessageUI//send mail


let utility = Utility()
let locationTracking = LocationTracking()
let coordinate = Coordinate()
let time = Formatter()
var admin = Admin()


class AddInfoView: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var parentNameTextField: UITextField!
    @IBOutlet weak var parentPhoneNumberTextField: UITextField!
    @IBOutlet weak var parentEmailTextField: UITextField!
    @IBOutlet weak var childNameTextField: UITextField!
    @IBOutlet weak var childEmailTextField: UITextField!
    
 
    private var tableView: UITableView?
 
    @IBOutlet weak var SaveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parentNameTextField.delegate = self
        parentPhoneNumberTextField.delegate = self
        parentEmailTextField.delegate = self
        childNameTextField.delegate = self
        childEmailTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func configureEmail() -> MFMailComposeViewController{
    
        let mail = MFMailComposeViewController()
        
     
        mail.mailComposeDelegate = self
        mail.setToRecipients(["z841063918@gmail.com"])
        mail.setSubject("Hello")
        
        
        
        mail.setMessageBody("Parent Email: \(parentEmailTextField.text!) Parent Password: \(parentPhoneNumberTextField.text!)\nChild Email: \(childEmailTextField.text!) Child Password: \(childEmailTextField.text!)", isHTML: false)
        return mail
    }
    
    func mailError(){
        let mailErrorAlert = UIAlertController(title: "Failed", message: "Could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
            mailErrorAlert.addAction(dismiss)
          self.present(mailErrorAlert, animated: true, completion: nil)
        
    
        
    }
    
    func sentEmail(){
        let mailC = configureEmail()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailC, animated: true, completion: nil)
            
        }else{
            mailError()
        }
    }


    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func displayPlaceHolderTextInRed(_ textField: UITextField, _ FieldNameText: String){
        textField.attributedPlaceholder = NSAttributedString(string: "Incorrect " + FieldNameText, attributes: [
            .foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 17.0)
            ])
    }
    
    
    //MARK: accountCheck()
    
    func isNotValidData() -> Bool{
        let leastPhoneNumberLength = 10
        
        guard let phoneNumberLength = parentPhoneNumberTextField.text?.count, let  parentEmailContainAt = parentEmailTextField.text?.contains("@"), let childEmailContainAt = childEmailTextField.text?.contains("@"), let parentEmailContainCom = parentEmailTextField.text?.contains(".com"), let childEmailContainCom = childEmailTextField.text?.contains(".com") else{
            print("Error, problem with length of phone number or format of email address")
            return true
        }// Error checking~firebase require at least 6 characters for the password, email requires @ symbol
        
        let str = parentPhoneNumberTextField.text
        
        if parentNameTextField.text == "" || parentPhoneNumberTextField.text == "" || parentEmailTextField.text == "" || childNameTextField.text == "" || childEmailTextField.text == "" || phoneNumberLength < leastPhoneNumberLength || !parentEmailContainAt || !childEmailContainAt || !parentEmailContainCom || !childEmailContainCom{
            if parentNameTextField.text == ""{
                displayPlaceHolderTextInRed(parentNameTextField, "parent name ")
            }
            
            if parentPhoneNumberTextField.text == "" || phoneNumberLength < leastPhoneNumberLength{
                parentPhoneNumberTextField.text = ""
                 displayPlaceHolderTextInRed(parentPhoneNumberTextField, "(length of 10) ")
                if (!(parentPhoneNumberTextField.text?.containOnlyNumbers)!){
                     displayPlaceHolderTextInRed(parentPhoneNumberTextField, "(must contain number only) ")
                }
               
            }// leastPhoneNumberLength = 6, at least 6 characters
            
            if parentEmailTextField.text == "" || !parentEmailContainAt{
                parentEmailTextField.text = ""
                displayPlaceHolderTextInRed(parentEmailTextField, "parent email ")
            }
            if childNameTextField.text == ""{
                displayPlaceHolderTextInRed(childNameTextField, "child name ")
            }
            
            if childEmailTextField.text == "" || !childEmailContainAt{
                childEmailTextField.text = ""
                displayPlaceHolderTextInRed(childEmailTextField, "child email ")
            }
            if childEmailTextField.text == parentEmailTextField.text{
                childEmailTextField.text = ""
                childEmailTextField.attributedPlaceholder = NSAttributedString(string: "Child Email cannot be same as parent email", attributes: [
                    .foregroundColor: UIColor.red,
                    .font: UIFont.boldSystemFont(ofSize: 17.0)
                    ])
            }
            
             return true
        }
            return false
       
    }//end isNotValidData()
    
    
    
    
    
    
    @IBAction func saveButtonAction() {
  
        if isNotValidData(){ //return true if data is not valid
            utility.alert("Failed", "Please provide correct data.") // show alert
            self.present(utility.alert, animated: true, completion: nil)
        }else{
            // all fields are not empty
            
            let alert = UIAlertController(title: "Saved", message: "Data successfully saved.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction)in
//                self.sentEmail()// send email with app email app
                self.performSegue(withIdentifier: "backToList", sender: self) // change view to Master View
                
                // list controller
            }))
            self.present(alert, animated: true, completion: nil) // perform alert animation
            
            guard
                let parentEmail = parentEmailTextField.text,
                let parentPassword = parentPhoneNumberTextField.text,
                let childEmail = childEmailTextField.text,
                let childPassword = childEmailTextField.text,
                let phoneNumber = parentPhoneNumberTextField.text
                else{return} // error checking to preventing crash. To make sure textField exist.
            
            
            let formmattedPhoneNumber = utility.formatPhoneNumber(phoneNumber) // format phone number
            Auth.auth().createUser(withEmail: parentEmail, password: parentPassword){(authResult,error) in
                //create parent account
                let parent = Auth.auth().currentUser //account is now created, get parent uid.
                let ref = Database.database().reference().child("Users").child((parent?.uid)!).child("Parent")//referent path to format your data
                
                
                ref.child("Address").setValue(["Street":"", "City": "", "State":"", "Zip Code":""]) // add empty address
                
                ref.child("Parent Info").setValue(["Name" :self.parentNameTextField.text,"Phone Number" : formmattedPhoneNumber, "Email": self.parentEmailTextField.text, "Role": admin.parentRole]) // Create Parent Info under Parent, and contain Name,Email, and Phone Number
                
                
                Auth.auth().createUser(withEmail: childEmail, password: childPassword){(authResult,error) in
                    //create child account
                    
                    let child = Auth.auth().currentUser
                    ref.child("Child").child((child?.uid)!).child("Child Info").setValue(["Name" : self.childNameTextField.text,"Email" : self.childEmailTextField.text, "Role": admin.childRole])
                   
                    
                    
                }
             
                
                
            }//end creat parent account
            
            
        }// end saveButtonAction()
        
        
        
        
        
        
        
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


