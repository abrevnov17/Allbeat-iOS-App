//
//  SignUpViewController.swift
//  allbeat
//
//  Created by Anatoly Brevnov on 2/25/17.
//  Copyright © 2017 allbeat, LLC. All rights reserved.
//

import Foundation
import UIKit


class SignUpViewController: UIViewController {
    
    var username:String?
    var email:String?
    var password:String?
    
    @IBOutlet weak var usernameField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var passwordField : UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username = ""
        email = ""
        password = ""
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_sender : AnyObject){
        
        username = usernameField.text
        email = emailField.text
        password = passwordField.text
        
        Allbeat.createUserEmail(useremail: email!, userpassword: password!, username: username!) { (success: Bool) in
            //called after database fetch has completed
            if (success == false){
                let alert = UIAlertController(title: "There was a problem!", message: "Try a different email and make sure your password is strong enough.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else {
                Allbeat.loginUserEmail(useremail: self.email!, userpassword: self.password!) { (success: Bool) in
                    //called after database fetch has completed
                    self.performSegue(withIdentifier: "in", sender: self)

                }
                
                
            }
        }
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
