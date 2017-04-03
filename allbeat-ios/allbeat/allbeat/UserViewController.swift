//
//  UserViewController.swift
//  allbeat
//
//  Created by Ari on 9/24/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet var email: UITextField?
    @IBOutlet var password: UITextField?
    @IBOutlet var username: UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.email?.layer.cornerRadius = 20.0
        self.email?.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0 , 0)
        self.username?.layer.cornerRadius = 20.0
        self.username?.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0 , 0)
        self.password?.layer.cornerRadius = 20.0
        self.password?.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0 , 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func signIn(_ sender: AnyObject) {
        
        Allbeat.loginUserEmail(useremail: self.email!.text!, userpassword: self.password!.text!) { (isSuccessful: Bool) in
            //called after database fetch has completed
            if (isSuccessful != true){
                let alertController = UIAlertController(title: "Uh oh!", message:
                    "Something went wrong. Please make sure your password and email match.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                self.performSegue(withIdentifier: "in", sender: self)
            }
        }
    }
    @IBAction func go(_ sender: AnyObject) {
      
    
            Allbeat.createUserEmail(useremail: self.email!.text!, userpassword: self.password!.text!, username: (self.username?.text!)!) { (isSuccessful: Bool) in
                //called after database fetch has completed
                print(isSuccessful)
                if (isSuccessful != true){
                let alertController = UIAlertController(title: "Uh oh!", message:
                    "Something went wrong. Please make sure your internet connection is working and that you have entered in an unique email and strong password.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                }
                else{
                    self.performSegue(withIdentifier: "in", sender: self)
                }
            }
        
    }

}
