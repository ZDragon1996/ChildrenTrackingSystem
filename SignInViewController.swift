//
//  SignInViewController.swift
//  ChildrenTrackingSystem
//
//  Created by Jialong Zhang on 11/27/18.
//  Copyright © 2018 Jialong Zhang. All rights reserved.
//

import UIKit
import FirebaseAuthUI
import Firebase

//var databaseRef = Database.database().reference()

//add protocol UITextFieldDelegate to dismiss keyboard


class SignInViewController: UIViewController, UITextFieldDelegate {
  
   
    let utility = Utility()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTextFieldPlaceHolder()
        emailTextField.delegate = self //inherit UITextFieldDelegate protocol
        passwordTextField.delegate = self
        
        
    }
    
    
    func determineUserView(){
        let ref = Database.database().reference()//database reference
        let user = Auth.auth().currentUser//get current user uid
        
        ref.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if user?.uid == admin.adminUID{
                admin.isLogOut = false
                 self.performSegue(withIdentifier: "displayInfo", sender: self)
            }
            else if snapshot.hasChild("Parent"){
                self.performSegue(withIdentifier: "displayInfo", sender: self)
            }else{
                self.performSegue(withIdentifier: "childView", sender: self)
            }
            
        })
        {(error) in
            print(error.localizedDescription)
        }
        
    }
    
    
   
    
    
    @IBAction func signIn() {
        if let email = emailTextField.text, let password = passwordTextField.text{
            //condition of email and password must be true
            Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
               //sign in with email and password
                if(email == "" || password == ""){
                    self.utility.alert("Fail!", "Empty email address or password")
                    self.present(self.utility.alert, animated: true, completion: nil)
                }// check if email and password are empty
                
                if user != nil{
                    // user is not nil, user found in database
                    let alert = UIAlertController(title: "Congratulation!", message: "Sign in succeeded", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction)in
                                self.determineUserView()
                        //determine View by checking the role
                        }))
                        self.present(alert, animated: false, completion: nil)
                    
                }else{
                    // incorrect email or password. Or user is not found in database
                    
                    if error != nil {
                        //error handing with account
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            switch errCode {
                            case .userDisabled:
                                self.utility.alert("Failed","Your account has been disabled")
                                self.present(self.utility.alert, animated: true, completion: nil)
                            case .invalidEmail:
                                self.utility.alert("Failed","Please enter valid email address")
                                self.present(self.utility.alert, animated: true, completion: nil)
                            case .wrongPassword:
                                self.utility.alert("Failed","Wrong Password")
                                self.present(self.utility.alert, animated: true, completion: nil)
                            case .tooManyRequests:
                                self.utility.alert("Failed","Too many unsuccessful login request, Please wait.")
                                self.present(self.utility.alert, animated: true, completion: nil)
                            default:
                                self.utility.alert("Failed","Unknown Error(Error not defined).")
                                self.present(self.utility.alert, animated: true, completion: nil)
                            }//end switch errCode
                        }// end if let errCode
                    }// end error != nil
                }
                
            })//end  signIn
            
            
            
        }// end if let
        
        
        
        
    }//end signIn()
    
    //MARKS: keyboard next and done button
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
        emailTextField.resignFirstResponder()//remove focus from emailTextField from keyboard
        if !textField.isEditing{
            passwordTextField.becomeFirstResponder() // jump to next passwordField
        }
        else{
            passwordTextField.resignFirstResponder()// remove focus from keyboard
            signIn()// after done was pressed, trigger sign in function
        }
        return true
    }
    
   
   

 
    
    func editTextFieldPlaceHolder(){
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            .foregroundColor: UIColor.lightText,
            .font: UIFont.boldSystemFont(ofSize: 17.0)
            ])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            .foregroundColor: UIColor.lightText,
            .font: UIFont.boldSystemFont(ofSize: 17.0)
            ])
        
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
